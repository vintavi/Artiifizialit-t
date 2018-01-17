
/* Representation of a point defined by its x- and y-coordinates */
class point {
    
    private float x, y;
    
    point(float x, float y) {
        this.x = x;
        this.y = y;
    }
    
    float x() {
        return x;
    }
    
    float y() {
        return y;
    }
}