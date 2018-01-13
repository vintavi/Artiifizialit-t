
/* Generates n random line segments with 
 * some preferable properties. */
ArrayList<line> genlines(int n) {
    ArrayList<line> sites = new ArrayList<line>();
    int i = 0;
    while(i != n) {
        /* Generate random line segment. */
        line ln = new line(random(width), random(height), random(width), random(height));
        
        /* If it's too long, try again. */
        if(ln.len() > width / 5) {
            continue;
        }
        
        /* If it intersects with an existing line segment, try again. */
        boolean intersects = false;
        for(line that : sites) {
            if(that.intersect(ln) != null) {
                intersects = true;
                break;
            }
        }
        if(!intersects) {
            i++;
            sites.add(ln);
        }
    }
    return sites;
}

/* Generates n random points. */
ArrayList<point> genpts(int n) {
    ArrayList<point> sites = new ArrayList<point>();
    for(int i = 0; i < n; i++) {
        point p = new point(random(width), random(height));
        sites.add(p);
    }
    return sites;
}