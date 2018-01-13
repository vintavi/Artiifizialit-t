
final cevent NO_CEVENT = new cevent(null, null, null);

class sevent implements Comparable<sevent> {
    
    final point s;
    
    sevent(point s) {
        this.s = s;
    }
    
    @Override
    int compareTo(sevent that) {
        return this.s.minYOrderedCompareTo(that.s);
    }
}

class cevent extends sevent {
    
    final arc      a;  /* arc to delete with this circle event */
    final circle   c;  /* cirlce */
    
    cevent(arc a, point circpt, circle c) {
        super(circpt);
        this.a = a;
        this.c = c;
    }
}