
ArrayList<Line> lines = new ArrayList<Line>();

void drawLines(){
  
  for(Line line : lines){
   line.drawLine(); 
  }
} 

class Line {

  float x1, y1, x2, y2;
  float weight, r, g, b, alpha; 

  Line(float pX1, float pY1, float pX2, float pY2, float pWeight, float pr, float pg, float pb, float palpha) {
    x1 = pX1;
    y1 = pY1;
    x2 = pX2;
    y2 = pY2;    
    weight = pWeight;
    r = pr;
    g = pg;
    b = pb;
    alpha = palpha;
  }

  void drawLine() {
    stroke(r,g,b, alpha);
    strokeWeight(weight);
    line(x1, y1, x2, y2);
  }
}

void addLine() { 
  
    //LINE-------------------------------------
    lines.add(new Line(random(-width,width), random(-height, 0), random(-width,2*width), random(height, 2*height),
                       random(3,20), random(0,255), random(0,50), random(0,50), random(50,100)));
    
}