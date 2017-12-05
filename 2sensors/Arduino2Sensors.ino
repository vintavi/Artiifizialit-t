const int potiPin = 7;
const int buttonPin = 4;

int serialValue = A0;
int buttonState = 0;

void setup() {
  pinMode(potiPin, INPUT);
  pinMode(buttonPin, INPUT);
  
  Serial.begin(9600);


}

void loop() {
  serialValue = analogRead(potiPin);
  serialValue = map(serialValue, 0, 1023, 0, 255);

  buttonState = digitalRead(buttonPin);
   
  if (buttonState == HIGH) {
    Serial.println("Button HIGH");
  } else {
    Serial.println("Button LOW");
  }

  Serial.println(serialValue);
  
  Serial.write((byte)serialValue);
  //Serial.print("Hallo");
  delay(20);


}
