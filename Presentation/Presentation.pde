import processing.serial.*;
 Serial myPort;
int serialValue = 100;

void setup() {
  size(1000, 500);
  printArray(myPort.list());
  String portName = myPort.list()[3];
  myPort =new Serial(this, portName, 9600);
}

void draw () {
  
  if (myPort.available()>1) {
    serialValue = myPort.read();
     
    drawWave(serialValue);
   
    println(serialValue);
 
    //background(serialValue);
    
  }
}



/* TEST
void keyPressed() { 
  
  //WAVE---------------------------------------------------------------------------
  if (keyPressed) {
    if (key == 'W' || key == 'w') {
      serialValue++;
    }
    if (key == 'S' || key == 's') {
      serialValue--;        
    }
  } 
  //-------------------------------------------------------------------------------
}
*/