String msg;

#define SLOW 160
#define FAST 255


String get_message() {
  String res = Serial1.readStringUntil('\n');
  res.trim();
  return res;
}

void setup()
{
  Serial.begin(9600);
  Serial1.begin(9600);

  pinMode(11, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(9, OUTPUT);

  digitalWrite(10, LOW);
  digitalWrite(11, LOW);
}

void loop()
{
  if (Serial1.available()) {
    msg = get_message();

    Serial.println(msg);

    if (msg == "Parado") {
      digitalWrite(11, LOW);
      digitalWrite(10, LOW);
    } else if (msg == "Rápido horario") {
      analogWrite(9, FAST);
      digitalWrite(11, LOW);
      digitalWrite(10, HIGH);
    } else if (msg == "Rápido antihorario") {
      analogWrite(9, FAST);
      digitalWrite(11, HIGH);
      digitalWrite(10, LOW);
    } else if (msg == "Lento horario") {
      analogWrite(9, SLOW);
      digitalWrite(11, LOW);
      digitalWrite(10, HIGH);
    } else if (msg == "Lento antihorario") {
      analogWrite(9, SLOW);
      digitalWrite(11, HIGH);
      digitalWrite(10, LOW);
    } else {
      digitalWrite(11, LOW);
      digitalWrite(10, LOW);
    }
  } else {
    // Serial.println("No serial 1 available");
  }
}