import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

//Serial myPort;
int serialValue = 0;
int potiPin = A0;

int buttonPin = 4;
int buttonState = Arduino.HIGH;
float b =0;


void setup() {
  size(300, 300);
  printArray(Arduino.list());

  arduino = new Arduino(this, Arduino.list()[1], 9600);
  arduino.pinMode(buttonPin, Arduino.INPUT);
  
}

void draw () {
  
  buttonState = arduino.digitalRead(buttonPin);
  
  if(arduino.digitalRead(buttonPin) == Arduino.HIGH){
   println("button high"); 
  } else {
    println("button low");
  }
  
  serialValue = arduino.analogRead(potiPin);
  println(serialValue);
  
}