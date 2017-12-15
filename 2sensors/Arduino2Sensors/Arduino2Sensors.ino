#include <Bounce2.h>
const int potiPin = A0;
const int buttonPin = 4;

int serialValue = A0;
int buttonState = 0;

//bouncer------------
Bounce debouncer = Bounce();
//-------------------

void setup() {
  pinMode(potiPin, INPUT);
  //pinMode(buttonPin, INPUT);
  
  //Bouncer----------
  pinMode(buttonPin,INPUT_PULLUP);
  // After setting up the button, setup the Bounce instance :
  debouncer.attach(buttonPin);
  debouncer.interval(5); // interval in ms, (5 IS THE STANDARD)
  
  Serial.begin(9600);


}

void loop() {

  //BOUNCER------
  // Update the Bounce instance :
  debouncer.update();

  // Get the updated value :
  int value = debouncer.read();

  
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
