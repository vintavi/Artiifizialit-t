/** 
 * Teilweise übernommen: https://www.openprocessing.org/sketch/337514
 * waving lines 
 * @author aa_debdeb 
 * @date 2016/03/27 
 */

float noiseW = random(100); 
float noiseH = random(100); 
float noiseT = random(100);

int maxWaveSize = 255;
int waveCount = maxWaveSize; 
int waveStep = 10;

float speed = 0.0015;

int potiValue = maxWaveSize;

void drawWave() { 
  background(255); 
  
    stroke(102, 149, 245, 100); 
  strokeWeight(height); 

  // fill(0,100, 120, 100); 
  noFill();

  float t = frameCount * speed;

  for (float h = -1000; h < height + 1000; h += waveCount) { 
    beginShape(); 
    curveVertex(0, h + getNoise(0, h, t)); 

    for (float w = 0; w <= width; w += 10) { 
      curveVertex(w, h + getNoise(w, h, t));
    } 

    curveVertex(width, h + getNoise(width, h, t)); 
    endShape();
  }

  checkWaveNo();
} 

void waveInput(boolean dir){
  
    if (dir) {
      if (potiValue <= 255)
        potiValue++;
    }
    if (!dir) {
      if (potiValue >= 50)
        potiValue--;
    }
    
   waveCount = potiValue;
  //waveCount+=waveStep;
  
}

void checkWaveNo() {
  if (waveCount <= 50 || waveCount >= maxWaveSize) {
    waveStep *= (-1);
  }
  println(waveCount);
}


float getNoise(float w, float h, float t) { 
  return map(noise(noiseW + w * 0.001, noiseH + h * 0.001, noiseT + t), 0, 1, -100, 1000);
}