obj getNearestObj(ArrayList<obj> objs, float x, float y) {
    float mindist = objs.get(0).getDist(x,y);
    int minindex = 0;
    for(int i = 1; i < objs.size(); i++) {
        float dist = objs.get(i).getDist(x, y);
        if(dist < mindist) {
            minindex = i;
            mindist = dist;
        }
    }
    return objs.get(minindex);
}

interface obj {
    float getDist(float x, float y);
    color getColor();
    void render();
}

class pointobj implements obj {
    
    final int PT_SZ = 10;
    
    float ptx, pty;
    color pc, rc;
    
    pointobj(float ptx, float pty, color rc) {
        this.ptx = ptx;
        this.pty = pty;
        this.rc = rc;
        this.pc = color(red(rc) * 0.75, green(rc) * 0.75, blue(rc) * 0.75);
    }
    
    pointobj(float ptx, float pty) {
        this(ptx, pty, 0);
    }
    
    float getDist(float x, float y) {
        return pow(ptx - x, 2f) + pow(pty - y, 2f);
    }
    
    void render() {
        ellipseMode(CENTER);
        noStroke();
        fill(pc);
        ellipse(x(), y(), PT_SZ, PT_SZ);
    }
    
    float x() {
        return ptx;
    }
    
    float y() {
        return pty;
    }
    
    color getColor() {
        return rc;
    }
}

class lineobj implements obj {
    
    final int STROKE_SZ = 10;
    
    pointobj a, b;
    color rc, lc;
    
    lineobj(pointobj a, pointobj b, color rc) {
        this.a = a;
        this.b = b;
        this.rc = rc;
        this.lc = color(red(rc) * 0.6, green(rc) * 0.6, blue(rc) * 0.6);
    }
    
    void render() {
        stroke(lc);
        strokeWeight(STROKE_SZ);
        line(a.x(), a.y(), b.x(), b.y());
    }
    
    /* ehem, we stole this function. will document later. */
    /* stolen from: https://stackoverflow.com/a/6853926 */
    float getDist(float x, float y) {
        float A = x - a.x();
        float B = y - a.y();
        float C = b.x() - a.x();
        float D = b.y() - a.y();
        
        float dot = A * C + B * D;
        float len_sq = C * C + D * D;
        float param = -1;
        if(len_sq != 0) //in case of 0 length line
            param = dot / len_sq;
        
        float xx, yy;
        
        if(param < 0) {
            xx = a.x();
            yy = a.y();
        }else if (param > 1) {
            xx = b.x();
            yy = b.y();
        }else {
            xx = a.x() + param * C;
            yy = a.y() + param * D;
        }
        
        float dx = x - xx;
        float dy = y - yy;
        return dx * dx + dy * dy;
    }
    
    color getColor() {
        return rc;
    }
}