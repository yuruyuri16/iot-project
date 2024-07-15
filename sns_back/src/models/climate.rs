use bson::DateTime;

use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct Climate {
    temperature: f32,
    humidity: f32,
    // #[serde(with = "bson::serde_helpers::chrono_datetime_as_bson_datetime")]
    #[serde(with = "bson::serde_helpers::bson_datetime_as_rfc3339_string")]
    timestamp: DateTime,
}

impl Climate {
    pub fn new(temperature: f32, humidity: f32) -> Self {
        Self {
            temperature,
            humidity,
            timestamp: DateTime::now(),
        }
    }
}
