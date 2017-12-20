int aud = 2; // wire AUD to A2  
 
void setup() 
{ 
  Serial.begin(9600); // initial serial
  pinMode(aud, INPUT); // set aud to input
}   
 
void loop()
{ 
  Serial.print("Wert: "); 
  Serial.println(analogRead(aud)); // read pin and print value
  delay(50); 
}
