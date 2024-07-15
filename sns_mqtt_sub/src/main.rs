use dotenvy_macro::dotenv;
use log::info;
use paho_mqtt as mqtt;
use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize)]
struct SensorData {
    temperature: f32,
    humidity: f32,
}

#[derive(Debug, Serialize)]
struct NewSensorData {
    temperature: f32,
    humidity: f32,
    #[serde(with = "bson::serde_helpers::bson_datetime_as_rfc3339_string")]
    timestamp: bson::DateTime,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    dotenvy::dotenv().ok();
    env_logger::init();

    let http_client = reqwest::Client::new();
    let mqtt_client = mqtt::Client::new(dotenv!("MQTT_BROKER_URL")).unwrap();

    mqtt_client.connect(None).unwrap();

    let receiver = mqtt_client.start_consuming();

    mqtt_client.subscribe(dotenv!("MQTT_TOPIC"), 0).unwrap();

    for msg in receiver.iter() {
        if let Some(msg) = msg {
            info!("Received message: {:?}", msg.payload_str());

            let data = match serde_json::from_str::<SensorData>(&msg.payload_str()) {
                Ok(data) => data,
                Err(_) => continue,
            };

            let new_data = NewSensorData {
                temperature: data.temperature,
                humidity: data.humidity,
                timestamp: bson::DateTime::now(),
            };
            let payload = match serde_json::to_string_pretty(&new_data) {
                Ok(payload) => payload,
                Err(_) => continue,
            };
            let msg = mqtt::Message::new_retained("sensor_clean", payload, mqtt::QOS_1);
            match mqtt_client.publish(msg) {
                Ok(_) => (),
                Err(_) => continue,
            }

            info!("Sending data to the SNS endpoint...");

            match http_client
                .post(dotenv!("SNS_ENDPOINT"))
                .json(&new_data)
                .send()
                .await
            {
                Ok(_) => info!("Data sent to the SNS endpoint"),
                Err(err) => info!("Error sending data to the SNS endpoint: {:?}", err),
            }

            info!("Data sent to the SNS endpoint");
        }
    }

    if mqtt_client.is_connected() {
        info!("Disconnecting...");
        mqtt_client.disconnect(None).unwrap();
    }
    info!("Disconnected");

    Ok(())
}
