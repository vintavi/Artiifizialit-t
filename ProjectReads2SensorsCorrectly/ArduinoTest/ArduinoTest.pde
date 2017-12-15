import processing.serial.*;

Serial myPort;
int serialValue = 0;
float b =0;

int[] values = new int[2];
int index = 0;

void setup() {
  size(300, 300);
  printArray(myPort.list());
  String portName = myPort.list()[1];
  myPort =new Serial(this, portName, 9600);

}

void draw () {

  //println("button: " + values[0] + "poti: " + values[1]); 

}

void serialEvent(Serial myPort) {
  //while (myPort.available() > 0) {

    String value = myPort.readStringUntil('\n');
    
    if (value != null)
      println(value);

    //println(value);

    //int inByte = myPort.read();
    //println(inByte);
  //}
  //println(myPort.read());
}