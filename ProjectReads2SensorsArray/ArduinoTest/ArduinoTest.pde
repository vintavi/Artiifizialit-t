import processing.serial.*;

Serial myPort;
int serialValue = 0;

int noOfSensors = 2;
int[] values = new int[noOfSensors];

void setup() {
  size(300, 300);
  printArray(myPort.list());
  String portName = myPort.list()[1];
  myPort =new Serial(this, portName, 9600);
}

void draw () {

  //println("button: " + values[0] + "poti: " + values[1]);
  printArray(values);
}

void serialEvent(Serial myPort) {
  //while (myPort.available() > 0) {

  String value = myPort.readStringUntil('\n');
    
  if (value != null) {      

    String[] list = split(value, 'A');
    list[noOfSensors-1] = list[noOfSensors-1].substring(0, list[noOfSensors-1].length()-1);
    
    /*
    for (int i = 0; i < list.length; i++){
      values[i] = parseInt(list[i]);
    }*/
    
    int a = int(list[0]);
    int b = int(list[1].trim());
    
    values[0] = a;
    values[1] = b;
    
    //printArray(list);  
  }

  
  

  //println(value);

  //int inByte = myPort.read();
  //println(inByte);
  //}
  //println(myPort.read());
}