// Knock In 
// by David Cuartielles <http://www.0j0.org>
// based on Analog In by Josh Nimoy <http://itp.jtnimoy.com>

// Reads a value from the serial port and makes the background 
// color toggle when there is a knock on a piezo used as a knock
// sensor. 
// Running this example requires you have an Arduino board
// as peripheral hardware sending values and adding an EOLN + CR 
// in the end. More information can be found on the Arduino 
// pages: http://www.arduino.cc

// Created 23 November 2005
// Updated 23 November 2005

import processing.serial.*;

String buff = "";
int val = 0;
int NEWLINE = 10;

Serial port;

void setup()
{
  size(200, 200);
printArray(Serial.list());
  // Open your serial port
  port = new Serial(this, "/dev/cu.usbmodem1421", 115200);  // <-- SUBSTITUTE COMXX with your serial port name!!
}

void draw()
{
  // Process each one of the serial port events
  while (port.available() > 0) {
    serialEvent(port.read()); 
  }
  background(val);
}

void serialEvent(int serial) 
{ 
  if(serial != NEWLINE) { 
    buff += char(serial);
  } else {
    buff = buff.substring(1, buff.length()-1);
    // Capture the string and print it to the commandline
    // we have to take from position 1 because 
    // the Arduino sketch sends EOLN (10) and CR (13)
    if (val == 0) {
      val = 255;
    } else {
      val = 0;
    }
    println(buff);
    // Clear the value of "buff"
    buff = "";
   }
}