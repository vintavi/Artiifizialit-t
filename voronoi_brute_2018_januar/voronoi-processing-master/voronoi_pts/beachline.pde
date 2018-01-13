
/* This interface provides the API for the beachline
 * used to implement Fortune's algorithm. The beachline
 * here is only used to store the breakpoints separating
 * arcs on the beachline, not the arcs themselves. */
interface beachline {
    
    /* Breakpoint add/removal operations */
    void insert_breakpt(breakpt b);
    void delete_breakpt(breakpt b);
    
    /* Breakpoint query operations */
    Iterable<breakpt> breakpoints();
    
    /* Arc add/removal operations */
    void   insert_arc(arc a, cevent ce);
    cevent delete_arc(arc a);
    
    /* Arc query operations */
    arc  get_arc_above(point p);
    arc  get_left_arc(arc a);
    arc  get_right_arc(arc a);
    Iterable<arc_key> arcs();
    int num_arcs();
}

/* Provides an instance of a beachline. */
beachline create_beachline() {
    return new beachline_hs();
}



/*****************************
 * Beachline implementations *
 *****************************/
 
 class beachline_hs implements beachline {
     
     HashSet<breakpt>       brkpts;
     TreeMap<arc_key, cevent> arcs;
     
     PrintWriter out;
     
     beachline_hs() {
         if(DEBUG_ENABLED) {
             out = createWriter("beachline.txt");
         }
         this.brkpts = new HashSet<breakpt>();
         this.arcs = new TreeMap<arc_key, cevent>();
     }
     
     @Override
     Iterable<arc_key> arcs() {
         return this.arcs.keySet();
     }
     
     @Override
     void insert_breakpt(breakpt b) {
         brkpts.add(b);
     }
     
     @Override
     void delete_breakpt(breakpt b) {
         brkpts.remove(b);
     }
     
     @Override
     Iterable<breakpt> breakpoints() {
         return this.brkpts;
     }
     
     @Override
     void insert_arc(arc a, cevent ce) {
         cevent old = this.arcs.put(a, ce);
         if(DEBUG_ENABLED) {
             out.println("insert: " + a + ", replaced " + old + " with " + ce + " (ref: " + NO_CEVENT + ")");
             out.flush();
         }
     }
     
     @Override
     cevent delete_arc(arc a) {
         cevent ce = this.arcs.remove(a);
         if(DEBUG_ENABLED) {
             out.println("delete: " + a + ", " + ce);
             out.flush();
         }
         return ce;
     }
     
     @Override
     arc get_arc_above(point p) {
        arc_query aq = new arc_query(p);
        return (arc) arcs.floorKey(aq);
     }
     
     @Override
     arc get_right_arc(arc a) {
         return (arc) arcs.higherKey(a);
     }
     
     @Override
     arc get_left_arc(arc a) {
         return (arc) arcs.lowerKey(a);
     }
     
     @Override
     int num_arcs() {
         return this.arcs.size();
     }
 }