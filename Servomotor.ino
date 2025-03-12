#include <Servo.h>

int trigPin = 3;
int echoPin = 4;
int distance;
int duration;
Servo myservo;

int distances() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  distance = duration * 0.034 / 2;
  return distance;  // ✅ Return distance
}

void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  myservo.attach(5);
  Serial.begin(9600);
}

void loop() {
  int i;
  
  // ✅ Servo moves from 15° to 165° (forward sweep)
  for (i = 5; i <= 150; i++) {
    myservo.write(i);
    delay(10);  // Reduce delay to speed up movement
    distance = distances();  // ✅ Store the returned value

    Serial.print(i);      // Print angle
    Serial.print(",");    
    Serial.print(distance);  // Print distance
    Serial.print(".");
  }

  // ✅ Servo moves from 165° back to 15° (reverse sweep)
  for (i = 150; i >=5; i--) {
    myservo.write(i);
    delay(10);
    distance = distances();  // ✅ Store the returned value

    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
}
