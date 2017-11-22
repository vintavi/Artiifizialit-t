
const int potiPin = A0;
//const int photoPin =A1;
int serialValue = 0;

void setup() {
 pinMode(potiPin, INPUT);
//pinMode(photoPin,INPUT);
  Serial.begin(9600);


}

void loop() {
  serialValue = analogRead(potiPin);
  serialValue = map(serialValue, 0, 1023, 0, 255);
  Serial.write((byte)serialValue);

  delay(20);


}
