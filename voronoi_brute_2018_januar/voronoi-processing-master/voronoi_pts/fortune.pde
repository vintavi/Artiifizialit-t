import java.util.*;

class fortune {
    
    ArrayList<point> sites;  /* sites of diagram */
    ArrayList<edge>  edges;  /* edges of Voronoi diagram */
    beachline          bln;  /* beachline of ordered breakpoints */
    equeue              eq;  /* event queue */
    
    float      directrix;  /* current position of the directrix */
    float mindim, maxdim;  /* min and max of the bounding box of the diagram */
    
    fortune(ArrayList<point> sites, float mindim, float maxdim) {
        this.sites = sites;
        this.mindim = mindim;
        this.maxdim = maxdim;
        this.edges = new ArrayList<edge>(sites.size());
        this.eq = create_equeue();
        this.bln = create_beachline();
        
        /* Add all site events (just endpoints) to event queue */
        for(point site : this.sites) {
            eq.insert(new sevent(site));
        }
        
        /* Directrix starts at the bottom. */
        this.directrix = maxdim;
    }
    
    boolean step() {
        if(eq.events_remaining() > 0) {
            /* Process next event. */
            sevent e = eq.next_event();
            this.directrix = e.s.y;
            System.out.println(this.directrix);
            if(e.getClass() == sevent.class) {
                handle_site_event(e);
            }else{
                cevent ce = (cevent) e;
                handle_cevent(ce);
            }
            
            /* Cut infinite edges after all steps */
            if(eq.events_remaining() == 0) {
                /* Pin floating edges to bounding box */
                this.directrix = mindim;  /* directrix ends at the top */
                for(breakpt bp : bln.breakpoints()) {
                    bp.finish(this.directrix);
                }
            }
            return false;
        }else{
            return true;
        }
    }
    
    void handle_site_event(sevent e) {
        
        /* If no arcs exist on the beachline, insert first arc and return. */
        if(bln.num_arcs() == 0) {
            bln.insert_arc(new arc(e.s, this), NO_CEVENT);
            return;
        }
        
        /* Find arc above new site */
        arc arc_above = bln.get_arc_above(e.s);
        
        /* Get two breakpoints bounding arc to be split */
        breakpt brklf = arc_above.lf;
        breakpt brkrt = arc_above.rt;
        
        /* Create bisector between new site and site "above" it.
         * This edge will be traced out by both new breakpoints. */
        edge newedge = new edge(arc_above.s, e.s);
        edges.add(newedge);
        
        /* Create new breakpoints between the old arc and the new 
         * arc, add them to the beachline. */
        breakpt newbrklf = new breakpt(arc_above.s, e.s, newedge, this.directrix);
        breakpt newbrkrt = new breakpt(e.s, arc_above.s, newedge, this.directrix);
        bln.insert_breakpt(newbrklf);
        bln.insert_breakpt(newbrkrt);
        
        /* Construct three new arcs to replace old one. */
        arc arclf = new arc(brklf, newbrklf, this);
        arc center = new arc(newbrklf, newbrkrt, this);
        arc arcrt = new arc(newbrkrt, brkrt, this);
        
        /* Replace old arc (and false circle event, if any) with three new arcs */
        cevent falsece = bln.delete_arc(arc_above);
        if(falsece != NO_CEVENT) {
            eq.delete(falsece);
        }
        bln.insert_arc(arclf, NO_CEVENT);
        bln.insert_arc(center, NO_CEVENT);
        bln.insert_arc(arcrt, NO_CEVENT);
        
        /* Check if new circle events should be added to queue */
        discover_circle_event(arclf);
        discover_circle_event(arcrt);
    }
    
    void handle_cevent(cevent ce) {
        
        /* Get arcs to the left and right of the arc to be deleted. */
        arc arcrt = bln.get_right_arc(ce.a);
        arc arclf = bln.get_left_arc(ce.a);
        
        /* If the right arc has a circle event, it is a false alarm.
         * Delete it from the event queue and continue. */
        if(arcrt != null) {
            cevent falsece = bln.delete_arc(arcrt);
            if(falsece != NO_CEVENT) {
                eq.delete(falsece);
            }
            bln.insert_arc(arcrt, NO_CEVENT);
        }
        
        /* If the left arc has a circle event, it is a false alarm.
         * Delete it from the event queue and continue. */
        if(arclf != null) {
            cevent falsece = bln.delete_arc(arclf);
            if(falsece != NO_CEVENT) {
                eq.delete(falsece);
            }
            bln.insert_arc(arclf, NO_CEVENT);
        }
        
        /* Remove the arc deleted by this circle event. The circle 
         * event has already been removed from the event queue, so 
         * don't remove it again! */
        cevent c = bln.delete_arc(ce.a);
        if(c == null) {
            throw new RuntimeException("no circle event on arc: " + ce.a + ", " + ce);
        }
        
        /* Cap edges being traced out by the breakpoints bounding 
         * this arc. */
        ce.a.lf.cap(ce.c.center());
        ce.a.rt.cap(ce.c.center());
        
        /* Remove left and right breakpoints bounding this arc 
         * from the beachline. */
        bln.delete_breakpt(ce.a.lf);
        bln.delete_breakpt(ce.a.rt);
        
        /* Create new edge to be traced out by the breakpoint 
         * between the left and right arcs. */
        edge e = new edge(ce.a.lf.slf, ce.a.rt.srt);
        edges.add(e);
        e.p1 = ce.c.center();
        
        /* Create and add the single breakpoint replacing the deleted arc. */
        breakpt newbp = new breakpt(ce.a.lf.slf, ce.a.rt.srt, e, this.directrix);
        bln.insert_breakpt(newbp);
        
        /* Update breakpoint references of left and right arcs. */
        arcrt.lf = newbp;
        arclf.rt = newbp;
        
        /* Check if new circle events should be added to queue */
        discover_circle_event(arclf);
        discover_circle_event(arcrt);
    }
    
    void discover_circle_event(arc a) {
        circle c = a.check_circle();
        if(c != null) {
            float radius = a.s.dist(c.center());
            point cept = new point(c.center().x, c.center().y - radius);
            cevent ce = new cevent(a, cept, c);
            eq.insert(ce);
            bln.insert_arc(a, ce);
        }
    }
    
    void animate() {
        fill(color(255));
        rect(0, 0, width, height);
        
        /* Draw sites. */
        stroke(color(255, 0, 0));
        fill(color(255, 0, 0));
        for(point site : sites) {
            site.draw();
        }
        
        /* Draw breakpoints and in-progress arcs. */
        fill(color(0, 255, 0));
        for(breakpt b : this.bln.breakpoints()) {
            b.draw(this.directrix);
        }
        for(arc_key a : this.bln.arcs()) {
            ((arc) a).draw(directrix, mindim, maxdim);
        }
        
        /* Draw completed edges. */
        stroke(0, 0, 255);
        for(edge e : edges) {
            if(e.p1 != null && e.p2 != null) {
                float topy = (e.p1.y == Float.POSITIVE_INFINITY) ? maxdim : e.p1.y;
                line(e.p1.x, topy, e.p2.x, e.p2.y);
            }
        }
        
        /* Draw circle events. */
        stroke(0, 255, 255);
        noFill();
        for(sevent e : eq.events()) {
            if(e instanceof cevent) {
                cevent ce = (cevent) e;
                ce.c.draw();
            }
        }
        
        /* Draw scan line. */
        stroke(color(255, 0, 255));
        line(mindim, this.directrix, maxdim, this.directrix);
    }
    
    void staticdraw() {
        fill(color(255));
        rect(0, 0, width, height);
        
        /* Draw sites. */
       	stroke(color(255, 0, 0));
        fill(color(255, 0, 0));
        for(point site : sites) {
            site.draw();
        }
        
        /* Draw edges. */
        stroke(0, 0, 255);
        for(edge e : edges) {
            float topy = (e.p1.y == Float.POSITIVE_INFINITY) ? maxdim : e.p1.y;
            line(e.p1.x, topy, e.p2.x, e.p2.y);
        }
    }
}