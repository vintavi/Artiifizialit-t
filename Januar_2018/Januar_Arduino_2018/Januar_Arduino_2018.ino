/*
 * 1. Find the Song for the Speakers
 * 2. Put the 2 codes in this example 
 * 
 */

#include "pitches.h"

const int potiPin = A0;
const int buttonPin = 4;
const int potiPin2 = A1;
const int knockSensor =A2;
byte val =0;
int statePin = LOW;
int THRESHOLD =1; //LOW TO 100 TO 1



int melody[] = {
  NOTE_C4, NOTE_G3, NOTE_G3, NOTE_A3, NOTE_G3, 0, NOTE_B3, NOTE_C4
};
int noteDurations[] = {
  4, 8, 8, 4, 4, 4, 4, 4
};
int serialValue = 0;
int buttonState = 0;
int serialValue2 = 0;

void setup() {
  pinMode(potiPin, INPUT);
  pinMode(buttonPin, INPUT);
  pinMode(potiPin2, INPUT);

  Serial.begin(9600);

for (int thisNote = 0; thisNote < 8; thisNote++) {

    // to calculate the note duration, take one second divided by the note type.
    //e.g. quarter note = 1000 / 4, eighth note = 1000/8, etc.
    int noteDuration = 1000 / noteDurations[thisNote];
    tone(8, melody[thisNote], noteDuration);

    // to distinguish the notes, set a minimum time between them.
    // the note's duration + 30% seems to work well:
    int pauseBetweenNotes = noteDuration * 1.30;
    delay(pauseBetweenNotes);
    // stop the tone playing:
    noTone(8);
  }
}

void loop() {
  readWord();
  
  serialValue = analogRead(potiPin);
  serialValue = map(serialValue, 0, 1023, 0, 255);

  serialValue2 = analogRead(potiPin2);
  serialValue2 = map(serialValue2, 0, 1023, 0, 255);

  //BUTTON INFO
  buttonState = digitalRead(buttonPin);

  String value1 = "";
  String value2 = (String)serialValue;
  String value3 = (String)serialValue2;

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
  out = value1 + "A" + value2 + "B" + value3;
  Serial.println(out);

  /*
    Serial.write(value1));
    Serial.write(value2);
    Serial.write((byte)'\n');
    Serial.write("hello world");
  */

 
}

void readWord(){
for (int i = 0; i < 6; i++) {
    val = analogRead(knockSensor);
    if (val >= THRESHOLD) {
      Serial.print("1");
    }
    else {
      Serial.print ("0");
    }
    delay(4);
  }
  Serial.println();
 delay(20);

}


