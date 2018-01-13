
static boolean DEBUG_ENABLED = false;  /* dump beachline and event queue operation logs to file? */
static boolean       ANIMATE = true;  /* animate algorithm? */
static int                 N =  200;  /* number of line segments to start with */

/* Local variables. */
ArrayList<point> sites;
fortune f;

void setup() {
    size(800, 800);
    background(color(255));
    frameRate(24);
    
    /* Generate N random sites. */
    sites = genpts(N);
    
    /* Create algorithm instance. */
    this.f = new fortune(sites, -height, height);
    
    /* Run algorithm to completion if animation disabled. */
    while(!ANIMATE && !this.f.step());
}

void draw() {
    /* Sweep left to right. */
    rotate(PI / 2);
    translate(0, -height);
    
    /* Draw current state of Voronoi diagram. */
    if(!this.f.step()) {
        this.f.animate();
    }else{
        this.f.staticdraw();
    }
}

void mouseReleased() {
    sites.add(new point(mouseY, width-mouseX));
    this.f = new fortune(sites, -height, height);
}