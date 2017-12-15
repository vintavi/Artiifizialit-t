const int potiPin = A0;
const int buttonPin = 4;

int serialValue = 0;
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

  String value1 = "";
  String value2 = (String)serialValue;
  
  //BUTTON VALUE
  if (buttonState == HIGH) {
    value1 = "0";
  } else {
    value1 = "1";
  }

  /*
  //POTI VALUE
  Serial.write((byte)serialValue); */

  String out = "";
  out = value1 + "A" + value2;
  Serial.println(out);

  /*
  Serial.write(value1));
  Serial.write(value2);
  Serial.write((byte)'\n');
  Serial.write("hello world");
  */
  
  delay(20);


}
