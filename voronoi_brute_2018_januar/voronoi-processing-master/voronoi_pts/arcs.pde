
/* Any class extending this one can be used to perform insertion, 
 * deletion, and query operations with a beachline. Arcs are always
 * parabolas, and queries are just points. */
abstract class arc_key implements Comparable<arc_key> {
    
    /* Get position of left breakpoint. This breakpoint defines the 
     * leftmost position of the arc which is part of the beachline. */
    abstract point get_left();
    
    /* Get position of right breakpoint. This breakpoint defines the
     * rightmost position of the arc which is part of the beacline. */
    abstract point get_right();
    
    @Override
    int compareTo(arc_key that) {
        point mylf = this.get_left();
        point myrt = this.get_right();
        point urlf = that.get_left();
        point urrt = that.get_right();
        
        /* Given a query and and arc, the arc is "above" the query
         * if the query falls between the arc's current left and 
         * right points on the beachline. */
        if(((that.getClass() == arc_query.class) || (this.getClass() == arc_query.class)) && 
                ((mylf.x <= urlf.x && myrt.x >= urrt.x) || (urlf.x <= mylf.x && urrt.x >= myrt.x))) {
            return 0;
        }
        
        /* Two arcs are equal if they have the same left and right points.
         * Used when finding left and right arcs when processing circle events.
         * WILL NOT PROCESS QUERIES! */
        if(mylf.x == urlf.x && myrt.x == urrt.x) {
            return 0;
            
        /* If left of this is to the right of that, this goes after that. 
         * Used both for arcs and for queries. */
        }else if(mylf.x >= urrt.x) {
            return 1;
            
        /* If right of this is to the left of that, this goes before that. 
         * Ised both for arcs and for queries. */
        }else if(myrt.x <= urlf.x) {
            return -1;
        }
        
        /* When ordering arcs on the beacline, sort them by the midpoint 
         * of their current left and right points, i.e. order by 
         * center of mass. This avoids some problems introduced by floating
         * point precision. WILL NOT PROCESS QUERIES! */
        return mylf.midpt(myrt).compareTo(urlf.midpt(urrt));
    }
}

/* Used to communicate what type of arc 
class arc_type {
    
}

/* A simple arc implementation. Defined by two breakpoints 
 * and a focus site. */
class arc extends arc_key {
    
    fortune      f;  /* used to get current directrix */
    breakpt lf, rt;  /* left and right break points */
    point        s;  /* focus site of arc */
    
    /* Creates an arc with the given left and right breakpoints. */
    arc(breakpt lf, breakpt rt, fortune f) {
        if(lf == null && rt == null) {
            throw new RuntimeException("cannot make arc with null breakpoints!");
        }
        this.f = f;
        this.lf = lf;
        this.rt = rt;
        this.s = (lf != null) ? lf.srt : rt.slf;
    }
    
    /* Create arc without left or right breakpoints. This is necessary only
     * to create the first arc. */
    arc(point s, fortune f) {
        this.f = f;
        this.lf = null;
        this.rt = null;
        this.s = s;
    }
    
    @Override
    point get_right() {
        if(this.rt == null) {  /* if no right breakpoint, return point at +infinity */
            return new point(Float.POSITIVE_INFINITY, Float.POSITIVE_INFINITY);
        }
        return this.rt.get_position_when(f.directrix);
    }
    
    @Override
    point get_left() {
        if(this.lf == null) {  /* if no left breakpoint, return point at -infinity */
            return new point(Float.NEGATIVE_INFINITY, Float.NEGATIVE_INFINITY);
        }
        return this.lf.get_position_when(f.directrix);
    }
    
    circle check_circle() {
        if(this.lf == null || this.rt == null) {
            return null;
        }else if(ccw(this.lf.slf, this.s, this.rt.srt) != -1) {
            return null;
        }else{
            circle c = new circle(this.lf.slf, this.s, this.rt.srt);
            return c;
        }
    }
    
    void draw(float directrix, float min, float max) {
        point lf = get_left();
        point rt = get_right();
        parabola p = new parabola(this.s, directrix);
        min = (lf.x == Float.NEGATIVE_INFINITY) ? min : lf.x;
        max = (rt.x == Float.POSITIVE_INFINITY) ? max : rt.x;
        p.draw(min, max);
    }
    
    @Override
    String toString() {
        return "arc(" + "site=" + this.s + ", " +
                    "lf=" + (this.lf == null ? null : this.lf.slf) + ", " +
                    "rt=" + (this.rt == null ? null : this.rt.srt) + ")";
    }
}

/* Used to query the beachline to find the arc "above"
 * a given point. */
class arc_query extends arc_key {
    
    point p;  /* query point, i.e. point "below" arc to find. */
    
    arc_query(point p) {
        this.p = p;
    }
    
    @Override
    point get_left() {
        return this.p;
    }
    
    @Override
    point get_right() {
        return this.get_left();
    }
}

/* A breakpoint separates two arcs on the beachline. */
class breakpt {
    
    point slf, srt;  /* left and right sites forming this breakpoint */
    edge         e;  /* edge traced out by this breakpoint */
    
    point begin;  /* for drawing */
    
    breakpt(point slf, point srt, edge e, float directrix) {
        this.slf = slf;
        this.srt = srt;
        this.e = e;
        this.begin = this.get_position_when(directrix);
    }
    
    /* Caps one end of this edge with the given point. This point is
     * ALWAYS the center vertex of some circle event and this method
     * is called only when a relevant circle event is handled. */
    void cap(point p) {
        if(this.e.p1 == null) {
            this.e.p1 = p;
        }else{
            this.e.p2 = p;
        }
    }
    
    /* Any breakpoint left on the beachline at the end of the algorithm
     * will trace out an edge to a point at infinity. By calling this
     * function, this point at infinity is contracted to some minimum
     * position. */
    void finish(float min) {
        point p = this.get_position_when(min);
        if(this.e.p1 == null) {
            this.e.p1 = p;
        }else{
            this.e.p2 = p;
        }
    }
    
    /* The position of this breakpoint when the scan line is at
     * the specified height. */
    point get_position_when(float directrix) {
        float x, y;
        
        /* Directly compute position when edge is a vertical line.
         * This is done to avoid problems of floating point precision. */
        if(slf.y == srt.y) {
            x = (slf.x + srt.x) / 2;
            y = (pow(x - slf.x, 2) + pow(slf.y, 2) - pow(directrix, 2)) / (2f * (slf.y - directrix));
            return new point(x, y);
            
        /* In general case, intersect neighboring parabolas. */
        }else{
            parabola p1 = new parabola(this.slf, directrix);
            parabola p2 = new parabola(this.srt, directrix);
            return p1.intersect(p2);
        }
    }
    
    void draw(float directrix) {
        point b = this.get_position_when(directrix);
        stroke(color(0, 255, 0));
        b.draw();
        stroke(color(0, 255, 0));
        line(begin.x, begin.y, b.x, b.y);
        if(e.p2 != null) {
            line(begin.x, begin.y, e.p2.x, e.p2.y);
        }
        if(e.p1 != null) {
            line(begin.x, begin.y, e.p1.x, e.p1.y);
        }
    }
}