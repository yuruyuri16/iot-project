#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include "DHT.h"
#include <ArduinoJson.h>
#include <SoftwareSerial.h>


const char* ssid = "NETWORK_NAME";
const char* password = "NETWORK_PASSWORD";
const char* mqtt_server = "IP ADDRESS";

boolean mqtt_will_retain = true;

#define DHTPIN D4
#define DHTTYPE DHT11

DHT dht(DHTPIN, DHTTYPE);
SoftwareSerial espSerial(D2, D3);  // (D2 = 4) RX, (D3 = 0) TX pins for ESP8266 (you can use any available pins)


WiFiClient espClient;
PubSubClient client(espClient);
unsigned long lastMsg = 0;
#define MSG_BUFFER_SIZE	(50)
char msg[MSG_BUFFER_SIZE];

void setup_wifi() {
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  randomSeed(micros());

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Create a random client ID
    String clientId = "ESP8266Client-";
    clientId += String(random(0xffff), HEX);
    // Attempt to connect
    if (client.connect(clientId.c_str())) {
      Serial.println("connected");
      // Once connected, publish an announcement...
      client.publish("outTopic", "hello world");
      // ... and resubscribe
      // client.subscribe("inTopic");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void setup() {
  Serial.begin(9600);
  espSerial.begin(9600);  // Initialize the ESP8266 serial port
  setup_wifi();
  client.setServer(mqtt_server, 1883);
  dht.begin();
}

double round2(double value) {
   return (int)(value * 100 + 0.5) / 100.0;
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  unsigned long now = millis();
  if (now - lastMsg > 10000) {
    float temperature = dht.readTemperature();
    float humidity = dht.readHumidity();

    if (isnan(temperature) || isnan(humidity)) {
      lastMsg = now;
      Serial.println("WHOOPS");
      return;
    }
    
    Serial.print("Temperature: ");
    Serial.println(temperature);
    Serial.print("Humidity: ");
    Serial.println(humidity);

    if ((18 <= temperature && temperature <= 24) && (60 <= humidity && humidity <= 80)) {
      espSerial.println("Parado");
    } else if (temperature > 28 || humidity > 90) {
      espSerial.println("Rápido horario");
    } else if (temperature < 16 && humidity > 85) {
      espSerial.println("Rápido antihorario");
    } else if (temperature > 25) {
      espSerial.println("Lento horario");
    } else if (temperature < 18) {
      espSerial.println("Lento antihorario");
    } else {
      if (humidity < 80) {
        espSerial.println("Lento horario");
      } else {
        espSerial.println("Lento antihorario");
      }
    }

    lastMsg = now;
    JsonDocument doc;
    char buffer[256];
    doc["temperature"] = round2(temperature);
    doc["humidity"] = humidity;
    size_t n = serializeJsonPretty(doc, buffer);

    Serial.print("Publish message: ");
    Serial.println(buffer);

    client.publish("sensor", buffer, mqtt_will_retain);
  }
}
