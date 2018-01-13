
/* List of objects */
ArrayList<obj> objs;

void setup() {
    size(800, 600);
    background(color(255));
    init();
    updateDraw();
}

void init() {
    objs = new ArrayList<obj>();
    for(int i = 0; i < 1; i++)
         objs.add(new pointobj(random(width), random(height), createColor()));
}

void updateDraw() {
    for(int x = 0; x < width; x++)
        for(int y = 0; y < height; y++)
            set(x, y, getNearestObj(objs, x, y).getColor());
    for(int i = 0; i < objs.size(); i++)
        objs.get(i).render();
    fill(0);
    text("Left click to add points", 10, 20);
    text("Left click, drag, and release to add lines", 10, 40);
}

void draw() {
}

pointobj start, end;
void mouseReleased() {
    end = new pointobj(mouseX, mouseY, createColor());
    if(start.x() == end.x() && start.y() == end.y()) {
           objs.add(end);
    }else{
        lineobj ln = new lineobj(start, end, createColor());
        objs.add(ln);
    }
    updateDraw();
}

void mousePressed() {
    start = new pointobj(mouseX, mouseY);
}