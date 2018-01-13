
/* Is a->b->c a ccw turn? */
int ccw(point a, point b, point c) {
    double det = (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);
    if(det < 0) {
        return -1;
    }else if(det > 0) {
        return 1;
    }
    return 0;
}

class point implements Comparable<point> {
    
    final int PT_SZ = 5;
    final float x, y;
    line parent;
    
    point(float x, float y, line parent) {
        this(x, y);
        this.parent = parent;
    }
    
    point(float x,float y) {
        this.x = x;
        this.y = y;
        this.parent = null;
    }
    
    float dot(point that) {
        return this.x*that.x + this.y*that.y;
    }
    
    @Override
    int compareTo(point that) {
        if(this.x == that.x) {
            if(this.y == that.y) {
                return 0;
            }
            return (this.y < that.y) ? -1 : 1;
        }
        return (this.x < that.x) ? -1 : 1;
    }
    
    point midpt(point that) {
        return new point((this.x + that.x) / 2f, (this.y + that.y) / 2f);
    }
    
    float dist(point that) {
        float dx = this.x - that.x;
        float dy = this.y - that.y;
        return sqrt(dx*dx + dy*dy);
    }
    
    int minYOrderedCompareTo(point that) {
        if(this.y < that.y) {
            return 1;
        }else if(this.y > that.y) {
            return -1;
        }else if(this.x == that.x) {
            return 0;
        }else{
            return (this.x < that.x) ? -1 : 1;
        }
    }
    
    point minus(point that) {
        return new point(this.x - that.x, this.y - that.y);
    }
    
    void draw() {
        pushStyle();
        ellipseMode(CENTER);
        noStroke();
        ellipse(x, y, PT_SZ, PT_SZ);
        popStyle();
    }
    
    @Override
    String toString() {
        return "(" + x + "," + y + ")";
    }
    
    @Override
    boolean equals(Object othat) {
        if(othat.getClass() != point.class) {
            return false;
        }
        point that = (point)othat;
        return that.x == this.x && that.y == this.y;
    }
}

class line {
    
    point a, b;  /* endpoints of line, a <= b */
    
    line(float x1, float y1, float x2, float y2) {
        /* Create endpoints. */
        point a = new point(x1, y1, this);
        point b = new point(x2, y2, this);
        
        /* Swap to ensure a <= b. */
        if(a.compareTo(b) < 0) {
            point temp = a;
            a = b;
            b = temp;
        }
        this.a = a;
        this.b = b;
    }
    
    /* Find point of intersection of a horizontal line 
     * at y = directrix with this line segment, if any. */
    point intersect(float directrix) {
        /* If y does not intersect this line segment,
         * return null. */
        if(directrix < a.y || directrix > b.y) {
            return null;
        }
        
        /* If line segment is horizontal, return midpoint. */
        if(a.y == b.y) {
            return a.midpt(b);
            
        /* Otherwise, compute point of intersection in general. */
        }else{
            float t = (directrix - a.y) / (b.y - a.y);
            return new point((b.x-a.x) * t + a.x, directrix);
        }
    }
    
    /* Find point of intersection of this line 
     * with the given parabola. */
    point intersect(parabola p) {
        throw new UnsupportedOperationException("not yet implemented!");
    }
    
    private boolean onseg(point p, point q, point r) {
        return q.x <= max(p.x, r.x) && q.x >= min(p.x, r.x) &&
                q.y <= max(p.y, r.y) && q.y >= min(p.y, r.y);
    }
    
    /* Finds point of intersection between this line segment 
     * and that line segment, null if none. */
    point intersect(line that) {
        int o1 = ccw(this.a, this.b, that.a);
        int o2 = ccw(this.a, this.b, that.b);
        int o3 = ccw(that.a, that.b, this.a);
        int o4 = ccw(that.a, that.b, this.b);
        
        if(o1 != o2 && o3 != o4) {
            float x1 = this.a.x, y1 = this.a.y;
            float x2 = that.a.x, y2 = that.a.y;
            float x3 = this.b.x, y3 = this.b.y;
            float x4 = that.b.x, y4 = that.b.y;
            float den = (y4-y3)*(x2-x1)-(y2-y1)*(x4-x2);
            float x = ((x2-x1)*(x3*y4-x4*y3)-(x4-x3)*(x1*y2-x2*y1)) / den;
            float y = ((y2-y1)*(x3*y4-x4*y3)-(y4-y3)*(x1*y2-x2*y1)) / den;
            return new point(x, y);
        }
        
        /* that.a falls on line this.a,that.a */
        if(o1 == 0 && onseg(this.a, that.a, this.b)) {
            return that.a;
        }
        if(o2 == 0 && onseg(this.a, that.b, this.b)) {
            return that.b;
        }
        if(o3 == 0 && onseg(that.a, this.a, that.b)) {
            return this.a;
        }
        if(o4 == 0 && onseg(that.a, this.b, that.b)) {
            return that.a;
        }
        return null;
    }
    
    float dist(line that) {
        throw new UnsupportedOperationException("not implemented yet!");
    }
    
    /* Squared length of line segment. */
    float len2() {
        return pow(a.x-b.x,2) + pow(a.y-b.y,2);
    }
    
    /* Actual length of line segment. */
    float len() {
        return sqrt(this.len2());
    }
    
    void draw() {
        line(a.x, a.y, b.x, b.y);
        a.draw();
        b.draw();
    }
}

/* An edge in the final diagram. */
class edge {
    
    point s1, s2;  /* sites this edge cuts between */
    point p1, p2;  /* edge line endpoints */
    
    edge(point s1, point s2) {
        this.s1 = s1;
        this.s2 = s2;
    }
}

/* Used to find the circumcenter of three points */
class circle {
    
    point center;  /* center of this circle */
    float radius;  /* radius of this circle */
    
    circle(point a, point b, point c) {
        float den = 2 * (a.x * (b.y-c.y) + b.x * (c.y-a.y) + c.x * (a.y-b.y));
        if(den != 0) {
            float x = (a.dot(a)*(b.y-c.y) + b.dot(b)*(c.y-a.y) + c.dot(c)*(a.y-b.y)) / den;
            float y = (a.dot(a)*(c.x-b.x) + b.dot(b)*(a.x-c.x) + c.dot(c)*(b.x-a.x)) / den;
            this.center = new point(x,y);
            this.radius = this.center.dist(a);
        }else{
            throw new RuntimeException("Three points colinear!");
        }
    }
    
    circle(point center, float radius) {
        this.center = center;
        this.radius = radius;
    }
    
    point center() {
        return this.center;
    }
    
    float radius() {
        return this.radius;
    }
    
    void draw() {
        ellipseMode(RADIUS);
        ellipse(this.center.x, this.center.y, this.radius, this.radius);
    }
}

/* An implementation of a parabola created using
 * a focus point and a horizontal directrix. */
class parabola {
    
    point focus;
    float a, b, c;
    
    parabola(point focus, float directrix) {
        this.focus = focus;
        float D = 2f * (focus.y - directrix);
        if(D != 0) {
            this.a = 1f / D;
            this.b = (-2f * focus.x) / D;
            this.c = (pow(focus.x,2) + pow(focus.y,2) - pow(directrix,2)) / D;
        }
    }
    
    void draw(float min, float max) {
        stroke(color(0));
        fill(color(0));
        /* drawing nice parabolas is intensive... do it with points instead*/
        //float lasty = -1;
        for(float x = min; x < max; x += 1) {
            float y = this.evaluate(x);
            //if(lasty != -1) {
            //    line(x,y,x-1,lasty);
            //}
            //lasty = y;
            point(x,y);
        }
    }
    
    @Override
    String toString() {
        return "y = " + a + "x^2 + " + b + "x + " + c;
    }
    
    /* Evaluates this parabola at the given point. */
    float evaluate(float x) {
        return a*x*x + b*x + c;
    }
    
    /* A degenerate parabola is one without 
     * a quadratic term. */
    boolean is_degenerate() {
        return this.a == 0;
    }
    
    point intersect(parabola that) {
        
        float x, y;
        
        /* When this parabola is degenerate, the point of
         * intersection is the point on the parabola */
        if(this.is_degenerate()) {
            x = this.focus.x;
            y = that.evaluate(x);
            return new point(x, y);
        }
        
        /* If that parabola is degenerate, then it's
         * intersection with this parabola occurs at */
        if(that.is_degenerate()) {
            x = that.focus.x;
            y = this.evaluate(x);
            return new point(x, y);
        }
        
        /* If neither parabola is degenerate, find equation
         * of parabola whose roots have x-coordinates equal
         * to the intersection points of this and that. */
        float aa = this.a - that.a;
        float bb = this.b - that.b;
        float cc = this.c - that.c;
        float d2 = pow(bb,2) - 4f * aa * cc;
        if(d2 > 0) {  /* precision is good, return right intersection point. */
            float d = sqrt(d2);
            x = (-bb + d) / (2f * aa);
        }else{  /* only occurs due to lossy precision, det is actually zero. */
            x = -bb / (2f * aa);
        }
        y = this.evaluate(x);
        return new point(x, y);
    }
}