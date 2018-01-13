
/* This interface provides the API for the event queue
 * used to implement Fortune's algorithm. */
interface equeue {
    
    /* Querying operations */
    sevent    next_event();
    int events_remaining();
    Iterable<sevent> events();
    
    
    /* Modification operations */
    boolean insert(sevent e);
    void    delete(sevent e);  /* used to remove false circle events */
}

/* Provides an instance of an event queue. */
equeue create_equeue() {
    return new equeue_ts();
}



/*******************************
 * Event Queue implementations *
 *******************************/

/* Using Java's TreeSet. */
class equeue_ts extends TreeSet<sevent> implements equeue {
    
    PrintWriter out;
    
    equeue_ts() {
        super();
        if(DEBUG_ENABLED) {
            out = createWriter("equeue.txt");
        }
    }
    
    @Override
    sevent next_event() {
        return super.pollFirst();
    }
    
    @Override
    Iterable<sevent> events() {
        return this;
    }
    
    @Override
    boolean insert(sevent e) {
        if(DEBUG_ENABLED) {
             out.println("insert: " + e);
             out.flush();
        }
        return super.add(e);
    }
    
    @Override
    void delete(sevent e) {
        if(DEBUG_ENABLED) {
             out.println("delete: " + e);
             out.flush();
        }
        super.remove(e);
    }
    
    @Override
    int events_remaining() {
        return super.size();
    }
}