//https://forum.processing.org/two/discussion/2712/volume-control-of-a-song-with-arduino-and-ultrasonic-sensor

import processing.serial.*;
import ddf.minim.*;
 
Serial myPort;
String comPortString;
AudioPlayer player;
Minim minim;
int volume = 0;
int distance;      // Data received from the serial port
 
void setup()
{
  size(400, 400);
  myPort = new Serial(this, Serial.list()[0], 9600); //put the desired serial port
  myPort.bufferUntil('\n'); // Trigger a SerialEvent on new line
  distance = 0;
  minim = new Minim(this);
  distance = constrain(distance, 1 , 200);
  // load a file
  player = minim.loadFile("myfile.mp3", 2048);
  // play the file
  player.play();
  player.loop();
  player.unmute();
}
 
void draw()
{
  background(distance);
  delay(200);
 
}
 
void stop()
{
  // always close Minim audio classes when you are done with them
  player.close();
  minim.stop();
  super.stop();
}
 
void serialEvent(Serial cPort){
comPortString = (new String(cPort.readBytesUntil('\n')));
if(comPortString != null) {
comPortString=trim(comPortString);
  distance = constrain(distance, 1 , 200);
  float volume = int(map(Integer.parseInt(comPortString),0,100,-50,50));
  player.setGain(volume); 
  println(volume);
 
if(distance<0){
distance = 0;
}
}
}
