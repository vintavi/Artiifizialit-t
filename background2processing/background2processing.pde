import processing.serial.*;

Serial myPort;
int serialValue =0;
float b =0;


void setup() {
  size(300, 300);
  printArray(myPort.list());
  String portName =myPort.list()[7];
  myPort =new Serial(this, portName, 9600);
}

void draw () {
  if (myPort.available()>1) {
    
    serialValue =myPort.read();
    println(serialValue);
    //input inMin, inMax,OutMin, outMax
  //int b = map(serialValue, 0, 1023, 0, 255);
  background(serialValue);
}
}