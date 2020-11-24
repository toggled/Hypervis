import java.util.Collections;
import java.awt.Polygon;
import java.awt.geom.Area;
import java.awt.geom.Line2D;
import java.awt.geom.Point2D;

//Grahams Scan algorithm for convex hull
class ConvexHull{
  Graph g; // The end result is a graph. 
  ArrayList<PVector> points;
  ArrayList<PVector> hull;
  PVector h1;
  PVector h2;
  PVector h3;
  int currentPoint = 2;
  int direction = 1;
  PVector starting_point;
  Polygon associatedpolygon = null;
  float hullarea = 0;
  
  ConvexHull(ArrayList <Vertex> vertices){
      points = new ArrayList();
      hull = new ArrayList();
      h1 = new PVector();
      h2 = new PVector();
      h3 = new PVector();
      for(Vertex v:vertices)
        points.add(v.pos.getpvector());
        // sort the points "lexically", i.e.
    // by x from left to right and
    // by y if they have the same x
    // see the LexicalComparison class
    // for the implementation of the sort.
    Collections.sort(points, new LexicalComparison());
  
    starting_point = points.get(0);
    // add the first two points to the hull
    hull.add(points.get(0));
    hull.add(points.get(1));
  }
  void addPoint() {

    // add the next point
    hull.add(points.get(currentPoint));
  
    // look at the turn direction in the last three points
    // (we have to work with copies of the points because Java)
    h1 = copyOf(hull.get(hull.size() - 3));
    h2 = copyOf(hull.get(hull.size() - 2));
    h3 = copyOf(hull.get(hull.size() - 1));
  
    // while there are more than two points in the hull
    // and the last three points do not make a right turn
    while (!isRightTurn (h1, h2, h3) && hull.size() > 2) {
      // remove the middle of the last three points
      hull.remove(hull.size() - 2);
      
      // refresh our copies because Java
      if (hull.size() >= 3) {
        h1 = copyOf(hull.get(hull.size() - 3));
      }
      h2 = copyOf(hull.get(hull.size() - 2));
      h3 = copyOf(hull.get(hull.size() - 1));
    } 
  
    //println("currentPoint: " + currentPoint + " numPoints: " + points.size() + " hullSize: " + hull.size() + " direction " + direction);
    
    // going through left-to-right calculates the top hull
    // when we get to the end, we reverse direction
    // and go back again right-to-left to calculate the bottom hull
    if (currentPoint == points.size() -1 || currentPoint == 0) {
      direction = direction * -1;
    }
  
    currentPoint+= direction;
  }
  
  PVector copyOf(PVector p){
    return new PVector(p.x, p.y);
  }
  // use the cross product to determin if we have a right turn
  boolean isRightTurn(PVector a, PVector b, PVector c) {
    return ((b.x - a.x)*(c.y - a.y) - (b.y - a.y)*(c.x - a.x)) >= 0;
  }
  ArrayList<PVector> gethullvectors(){
    if(points.size()==2) return hull;
    while(points.get(currentPoint) != starting_point){
      addPoint();
    }
    addPoint();
    //println("hull: "+hull);
    //println(isConvex());
    return hull;
  }
  boolean isConvex(){
    boolean convex = true;
    if(points.size() <= 2) return true;
    //boolean negative = PVector.dot(PVector.sub(hull.get(1),hull.get(0)) , PVector.sub(hull.get(2),hull.get(1)) )<0;
    
    for(int i =0 ;i <hull.size()-2;i++){
        PVector p1 = hull.get(i);
        PVector p2 = hull.get(i+1);
        PVector p3 = hull.get(i+2);
        float angle = PVector.angleBetween(PVector.sub(p1,p2),PVector.sub(p3,p2));
        if (abs(degrees(angle))< 10 || abs(degrees(angle)) > 170){
          println("bad hull");
        }
        if(sin(angle)<0){ 
          convex = false;
          break;
        }
        
    }
    return convex;
  }
  float getAverageArea(){ 
    // returns area occupied by each vertex in the hyperedge in the layout
    hullarea = 0;
    if(hull.size() == 2) {
      float dist = PVector.dist(hull.get(0),hull.get(1));
      hullarea = dist*vertex_radius*2 ; // area of the rectangle with side dist(center(nodea),center(nodeb)) and diameter of 2r (r= radius of the drawing of the nodes)
      return hullarea/2; // average
    }
    else{
      int n = hull.size();
      for(int i =0; i<n;i++){
        PVector x1 = hull.get(i);
        PVector x2 = hull.get((i+1)%n);
        hullarea+= 0.5*(x1.x*x2.y - x2.x*x1.y);
      }
      return hullarea/n;
    }
  }
  Polygon getawtPolygon(){
    int nshape = hull.size();
    int xpoly[] = new int[nshape];
    int ypoly[] = new int[nshape];
    for(int i=0;i<nshape;i++){
      xpoly[i] = (int)hull.get(i).x;
      ypoly[i] = (int)hull.get(i).y;
    }
    if(associatedpolygon == null)
       associatedpolygon = new Polygon(xpoly,ypoly,nshape);
    
    return associatedpolygon;
  }
  
  boolean collides(ConvexHull h2){
    // if either or both of the hulls are 2 vertex set 
    if(this.points.size() ==2 || h2.points.size() == 2){
      Line2D.Double line = new Line2D.Double(); // points of the line
      ArrayList<Point2D> polyPoints = new ArrayList<Point2D>(); //points of the polygon
      boolean intersect = false;
      
      if(this.points.size() == 2 && h2.points.size()>2){
        line = new Line2D.Double(hull.get(0).x,hull.get(0).y,hull.get(1).x,hull.get(1).y);
        for(PVector p:h2.hull){
          Point2D.Double point = new Point2D.Double(p.x,p.y);
          polyPoints.add(point);
        }
      }
      else if(this.points.size() > 2 && h2.points.size()==2){
        line = new Line2D.Double(h2.hull.get(0).x,h2.hull.get(0).y,h2.hull.get(1).x,h2.hull.get(1).y);
        for(PVector p:hull){
          Point2D.Double point = new Point2D.Double(p.x,p.y);
          polyPoints.add(point);
        }
      }
      else{
        // line line intersection
        Line2D.Double line1 = new Line2D.Double(hull.get(0).x,hull.get(0).y,hull.get(1).x,hull.get(1).y); // points of the line
        Line2D.Double line2 = new Line2D.Double(h2.hull.get(0).x,h2.hull.get(0).y,h2.hull.get(1).x,h2.hull.get(1).y); // points of the line
        return line1.intersectsLine(line2);
      }
      
      // handle point , polygon or polygon,point intersection
      
      for (int i = 0; i < polyPoints.size() - 1; i++) {
         intersect = line.intersectsLine(polyPoints.get(i).getX(), polyPoints.get(i).getY(), polyPoints.get(i+1).getX(), polyPoints.get(i+1).getY());
         if (intersect) {
            break;
         }
      }
      return intersect;
    }
    else{
       Area thisarea =  new Area(getawtPolygon());
       Area h2area = new Area(h2.getawtPolygon());
       thisarea.intersect(h2area);
       return !thisarea.isEmpty();
    }
  }
}
