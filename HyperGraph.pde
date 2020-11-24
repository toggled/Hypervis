import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.Collections;
import java.util.TreeMap;

class HyperEdge{
  List<Integer> vertices = new ArrayList<Integer>();
  color col;
  ConvexHull hull;
  ArrayList <PVector> hullpoints;
  ArrayList<ArrayList<PVector>> tangents = null;
  ArrayList <PVector> boundarypoints = null;
  float Areaoccupied = 0; // area occupied by the drawing of this hyperedge 
  boolean isBadhull = false;
  

  Set<Integer> getsetrep(){
    Set<Integer> associatedvertexset = new LinkedHashSet<Integer>();
    for(Integer i:vertices)
      associatedvertexset.add(i);
      
    return associatedvertexset;
  }
  
  void setcolor(color c){
    col = c;
  }
  
  //PVector 
  ArrayList<PVector> getouttangent(PVector c1,PVector c2,boolean twovertexcase){
  // Given center of two circles with radius equal to vertex_radius, draw the outtangent
  // If only two vertex return both the out tangents 
    //println("hi"+c1+" "+c2);
    float angle_centr = atan((c2.y - c1.y)/(c2.x - c1.x));
    ArrayList <PVector> line = new ArrayList <PVector> ();
    PVector from = new PVector();
    PVector to = new PVector();
    
    if(c2.x>c1.x){
      from.x = c1.x + vertex_radius*cos(PI/2 - angle_centr);
      from.y = c1.y - vertex_radius*sin(PI/2 - angle_centr);
      to.x = c2.x + vertex_radius*cos(PI/2 - angle_centr);
      to.y = c2.y - vertex_radius*sin(PI/2 - angle_centr);
      
    }
    else{
      from.x = c1.x - vertex_radius*cos(PI/2 - angle_centr);
      from.y = c1.y + vertex_radius*sin(PI/2 - angle_centr);
      to.x = c2.x - vertex_radius*cos(PI/2 - angle_centr);
      to.y = c2.y + vertex_radius*sin(PI/2 - angle_centr);
      
    }
    line.add(from);
    line.add(to);
    boundarypoints.add(from);
    boundarypoints.add(to);
    if(twovertexcase){
      PVector from2 = new PVector();
      PVector to2 = new PVector();
      if(c2.x>c1.x){

            from2.x = c1.x - vertex_radius*cos(PI/2 - angle_centr);
            from2.y = c1.y + vertex_radius*sin(PI/2 - angle_centr);
            to2.x = c2.x - vertex_radius*cos(PI/2 - angle_centr);
            to2.y = c2.y + vertex_radius*sin(PI/2 - angle_centr);
      }
      else{
            from.x = c1.x + vertex_radius*cos(PI/2 - angle_centr);
            from.y = c1.y - vertex_radius*sin(PI/2 - angle_centr);
            to.x = c2.x + vertex_radius*cos(PI/2 - angle_centr);
            to.y = c2.y - vertex_radius*sin(PI/2 - angle_centr);
      }
      line.add(from2);
      line.add(to2);
      boundarypoints.add(from2);
      boundarypoints.add(to2);
    }
    return line;
  }
  
  void find_allpairtangents(){
    // Find all pair tangents between the consecutive circles(vertex) surrounding the hullpoints.
    if(size()<2) return;
    tangents = new ArrayList<ArrayList<PVector>>();
    boundarypoints = new ArrayList <PVector>();
    //Collections.sort(hullpoints, new LexicalComparison());
    if(hullpoints.size() > 2){ // has at least 3 points , thus not a polygon 
      for(int i=0;i<hullpoints.size()-1;i++){
        ArrayList <PVector> temp = getouttangent(hullpoints.get(i),hullpoints.get(i+1),false);
        //println(temp);
        tangents.add(temp);
      }
    }
    else{
      ArrayList <PVector> temp = getouttangent(hullpoints.get(0),hullpoints.get(1),true);
        //println(temp);
        tangents.add(temp); //creating list of tangents marking the boundary, Also creating list of points for drawing closed curve along the boundary.
    }
    //println("before refinement: "+boundarypoints.size());
    refine_boundarypoints();
    correct_collinear_boundarypoints();
  }
  
  // Refine the boundary points i.e compute pairwise intersection between tangents and draw the curve closed by only the intersection points (better look)
  void refine_boundarypoints(){
    ArrayList <PVector> refinedboundary = new ArrayList <PVector> ();
    //refinedboundary.add(boundarypoints.get(0));
    //refinedboundary.add(boundarypoints.get(0));
   // refinedboundary.add(boundarypoints.get(1));
    
    int sizeofbpoints = boundarypoints.size();
    for(int i=1; i<sizeofbpoints ;i+=2){
      // find intersection
      PVector p1_from = boundarypoints.get(i-1);
      PVector p1_to = boundarypoints.get(i);
      PVector p2_from = boundarypoints.get((i+1)%sizeofbpoints);
      PVector p2_to = boundarypoints.get((i+2)%sizeofbpoints);
      PVector intersection = getIntersection(p1_from,p1_to,p2_from,p2_to);
      
      if(intersection == null){
          refinedboundary.add(p1_from);
          refinedboundary.add(p1_to);
          refinedboundary.add(p2_to);
          refinedboundary.add(p2_from);
          return;
      }
      //else
      //  refinedboundary.add(intersection);
      float dist = min(PVector.dist(p1_to, intersection),PVector.dist(p2_from, intersection));
      float diam = max(PVector.dist(p1_from, p1_to), PVector.dist(p1_to, p2_from), PVector.dist(p2_from, p2_to));
      float diam2 = max(PVector.dist(p2_to, p1_from), PVector.dist(p1_from, p2_from),PVector.dist(p1_to, p2_to));
      
      if(dist>1.2*max(diam,diam2)){
        
        println("issue-----");
        //refinedboundary.add(p1_from);
        //refinedboundary.add(p1_to);
        //refinedboundary.add(p2_to);
        //refinedboundary.add(p2_from);
        do{
          intersection = new PVector((p1_to.x + p2_to.x + intersection.x)/3,(p1_to.y + p2_to.y + intersection.y)/3);
          dist = min(PVector.dist(p1_to, intersection),PVector.dist(p2_from, intersection));
           diam = max(PVector.dist(p1_from, p1_to), PVector.dist(p1_to, p2_from), PVector.dist(p2_from, p2_to));
           diam2 = max(PVector.dist(p2_to, p1_from), PVector.dist(p1_from, p2_from),PVector.dist(p1_to, p2_to));
        }while(dist>1.2*max(diam,diam2));
        
        refinedboundary.add(intersection);
      }
      else{
        refinedboundary.add(intersection);
      }
        
      ////refinedboundary.add(p2_from);
      ////refinedboundary.add(p2_to);
    }
//    
    boundarypoints = refinedboundary;
    //println("b"+boundarypoints.size());
  }
  void correct_collinear_boundarypoints(){
    
  }
  
  PVector getIntersection(PVector line1_from,PVector line1_to, PVector line2_from, PVector line2_to){
    // get general equation of line1 and line2
    float line1_A = line1_to.y-line1_from.y;
    float line1_B = line1_from.x - line1_to.x;
    float line1_C = line1_B*line1_from.y + line1_A*line1_from.x;
    
    float line2_A = line2_to.y-line2_from.y;
    float line2_B = line2_from.x - line2_to.x;
    float line2_C = line2_B*line2_from.y + line2_A*line2_from.x;
    
    float Det = line1_A*line2_B - line2_A*line1_B; 
    if(Det == 0) return null; // parallel line
    // compute the x,y coordinate of the intersection
    PVector res = new PVector ( (line2_B*line1_C - line1_B*line2_C)/Det, (line1_A*line2_C - line2_A*line1_C)/Det);
    return res;
  }
  
  void add(int vertexid){
    vertices.add(vertexid);
  }
  int size(){
    return vertices.size();
  }
  int get(int i){
    return vertices.get(i);
  }
  
  void set(int index,int id){
    vertices.set(index,id);
  }
  void markBadhull(){
    if (hullpoints.size()<=2) return;
    for(int i =0 ;i < hullpoints.size()-2;i++){
        PVector p1 = hullpoints.get(i);
        PVector p2 = hullpoints.get(i+1);
        PVector p3 = hullpoints.get(i+2);
        float angle = PVector.angleBetween(PVector.sub(p1,p2),PVector.sub(p3,p2));
        if (abs(degrees(angle))< 10 || abs(degrees(angle)) > 170){
          isBadhull = true;
        }
    }
  }
  void computehull(ArrayList <Vertex> v){
    hull = new ConvexHull(v);
    hullpoints = hull.gethullvectors();
    isBadhull = false;
    markBadhull();
  }

  void drawhulls(){
    if(hullpoints == null) return;
    stroke(col);
    for(int i=1;i<hullpoints.size();i++){
      PVector p1 = hullpoints.get(i);
      PVector p2 = hullpoints.get(i-1);
      line(p1.x, p1.y, p2.x, p2.y);
    }
  }
}
  
class HyperGraph{

  ArrayList <Vertex> vertices ;
  ArrayList <HyperEdge> hyperedges;
  Hashtable <Integer,Integer> vmap ; // Which vertexid in which index of vertices
  //Hashtable<Vertex,HyperEdge> vtohmap; //vertex to hyperedge map, which vertex is in which hypedge
  IntDict labeltoidmap ; // which vertex label has what id 
  
  //int counter;
  Graph associated_graph;
  int numvertices;
  int numhyperedges;
  int totaladdedhypedges ; // how many hyperedges are added so far
  int totaladdednodes ; // total nodes added while creating the hg
  color from;  // hyperedge color to interpolate from
  color to ;// hyperedge color to interpolate to
  int singletonedges;
  boolean circularinitialplacement = true; // good initial placement is true by default
  
  HyperGraph(){
      associated_graph = null;
      vertices = new ArrayList <Vertex> ();
      hyperedges = new ArrayList<HyperEdge>();
      vmap = new Hashtable<Integer,Integer> (); // Which vertexid in which index of vertices
      //vtohmap = new Hashtable<Vertex,HyperEdge>();
      labeltoidmap = new IntDict(); //
      
      //counter = 0;
      totaladdedhypedges = 0; // how many hyperedges are added so far
      totaladdednodes = 0; // total nodes added while creating the hg
      singletonedges = 0;

  }
  HyperGraph(HyperGraph hg){ // COPY CONSTRUCTOR
      associated_graph = hg.associated_graph;
      vertices = hg.vertices;
      hyperedges = hg.hyperedges;
      vmap = hg.vmap;
      labeltoidmap = hg.labeltoidmap;
      totaladdedhypedges = hg.totaladdedhypedges;
      totaladdednodes = hg.totaladdednodes;
      singletonedges = hg.singletonedges; 
      circularinitialplacement = hg.circularinitialplacement;
  }
  
  HyperGraph(int numberofvertices,int numberofhyperedges){
    associated_graph = null;
    numvertices = numberofvertices;
    numhyperedges = numberofhyperedges;    
          vertices = new ArrayList <Vertex> ();
      hyperedges = new ArrayList<HyperEdge>();
      vmap = new Hashtable<Integer,Integer> (); // Which vertexid in which index of vertices
      //vtohmap = new Hashtable<Vertex,HyperEdge>();
      labeltoidmap = new IntDict(); //
      
     // counter = 0;
      totaladdedhypedges = 0; // how many hyperedges are added so far
      totaladdednodes = 0; // total nodes added while creating the hg
      singletonedges = 0;
  }
  
  String getHyperEdgerepr(HyperEdge h){
    String s= "";
    for(int i = 0; i<h.vertices.size()-1; i++){
      s+= vertices.get(vmap.get(h.vertices.get(i))).label+",";
    }
    s+=vertices.get(vmap.get(h.vertices.get(h.vertices.size()-1))).label;
    //s+='\n';
    return s;
  }
  
  int getdim(){
    int maxd = 0;
    for(HyperEdge he:this.hyperedges){
      if(he.size()>maxd)  maxd = he.size();
    }
    return maxd;
  }
  
  void addvertex(Vertex v){
    //vmap.put(v.id,v.id);
    //vmap.put(v.id,v.id);
   // vmap.put(v.id,this.counter++);
   vmap.put(v.id,this.vertices.size());
    this.vertices.add(v); // The order in which the vertices are added to this.vertices is the same as  
    totaladdednodes++;
  }
  
  boolean addvertex(int vertex_id){
    if(vertexexists(vertex_id)){
      this.vertices.get(this.vmap.get(vertex_id)).degree_hypergraph++;
      return false;
    }
    Vertex v = new Vertex(vertex_id);
    v.label = String.valueOf(vertex_id);
    this.addvertex(v); 
    return true;
  }
  
  boolean removevertex(int vid){
    if(!vertexexists(vid)) {
      //println("trying to remove non-existent vertex");
      return false;
    }
    try{
      this.vertices.remove(this.vmap.get(vid));
      //this.vmap.remove(vid);
      this.totaladdednodes--;
      return true;
    }catch(Exception e){
      e.printStackTrace();
      return false;
    }
  }
  void addvertex(String label){ 
    // Add a vertex from the label. 
    // This function assigns a new id (internal representation) (based on how many nodes already added) and creates a vertex with the given label
    if(labeltoidmap.get(label,-1)==-1){
      labeltoidmap.set(label, totaladdednodes);
      Vertex v = new Vertex(totaladdednodes);
      v.label = label;
      addvertex(v);
    }
    else{
      this.vertices.get(this.vmap.get(labeltoidmap.get(label))).degree_hypergraph++;
    }
      
  }
  void addhyperedge(Integer [] ids){
    HyperEdge hype = new HyperEdge();
    for(Integer id:ids){
      addvertex(id);
     hype.add(id);
      //vertices_in_hyperedge.add(vmap.get(id));
    }
    this.hyperedges.add(hype);
    totaladdedhypedges++;
    if(ids.length == 1) singletonedges++;
  }
  
  void removehyperedge(int index){
    HyperEdge hy = this.hyperedges.get(index);
    if(hy.size() == 1) this.singletonedges--;
    
    for(int vertexid: hy.vertices){
      int deg = this.vertices.get(vertexid).degree_hypergraph - 1;
      if((deg) < 0){ 
        //singletone before
        this.removevertex(vertexid);
      }
      //else if(deg == 0){ // one of the vertices of a 2-hyperedge
      //  // singleton now. 
      //   if(this.removevertex(vertexid))
      //     continue;
      //   else{
      //     println("Failed to remove vertex. Exiting!! ");
      //     System.exit(100);
      //   }
      //}
      else{
          this.vertices.get(vertexid).degree_hypergraph--;
        }
    }
    this.hyperedges.remove(index);
    this.totaladdedhypedges--;
  }
  
  void addhyperedge(String [] labels){
    HyperEdge hype = new HyperEdge();
    
    for(String lbl:labels){
      this.addvertex(lbl);
      hype.add(labeltoidmap.get(lbl));
    }
    
    this.hyperedges.add(hype);
    totaladdedhypedges++;
    if(labels.length == 1) singletonedges++;
  }
  
  // return position vector of the vertex in hypergraph drawn from associated graph
  PVector getposition(int vertex_id){
    return this.associated_graph.vertices.get(this.associated_graph.vmap.get(vertex_id)).pos.getpvector();
  }
  
  // GFR
  Vector GFR_getposition(int vertex_id){
    return this.associated_graph.vertices.get(this.associated_graph.vmap.get(vertex_id)).pos.getVector();
  }
  
  boolean vertexexists(int id){
    return vmap.get(id) != null;
  }
 
 void build_graph(){
   associated_graph = new Graph();
 }
 
 void GFR_build_associatedgraph(Vector topleftcorner,int frame_width,int frame_height){
    associated_graph = new Graph();
    for(Vertex v: this.vertices)
      associated_graph.addvertex(v);
    associated_graph.initGFR(topleftcorner, frame_width, frame_height,this.getdim());
    
    for(HyperEdge hyperedge:this.hyperedges){
        for(int i = 0; i<hyperedge.size()-1; i++){
          Integer u = hyperedge.get(i);
          for(int j = i; j<hyperedge.size();j++){
            Integer v = hyperedge.get(j);
              if(u!=v){
                 associated_graph.addedge(u,v);
              }
          }
        }
    }
  }
  
  void build_associatedgraph(){
    for(Vertex v: this.vertices)
      associated_graph.addvertex(v);
    associated_graph.init();
    
    for(HyperEdge hyperedge:this.hyperedges){
        for(int i = 0; i<hyperedge.size()-1; i++){
          Integer u = hyperedge.get(i);
          for(int j = i; j<hyperedge.size();j++){
            Integer v = hyperedge.get(j);
              if(u!=v){
                 associated_graph.addedge(u,v);
              }
          }
        }
    }
  }
  
    void build_associatedgraph(int frame_width,int frame_height){
    for(Vertex v: this.vertices)
      associated_graph.addvertex(v);
    associated_graph.init(frame_width, frame_height);
    
    for(HyperEdge hyperedge:this.hyperedges){
        for(int i = 0; i<hyperedge.size()-1; i++){
          Integer u = hyperedge.get(i);
          for(int j = i; j<hyperedge.size();j++){
            Integer v = hyperedge.get(j);
              if(u!=v){
                 associated_graph.addedge(u,v);
              }
          }
        }
    }
  }

  // Good/Bad placement for circular canvas
  void build_associatedcirculargraph(){
    //better initial positioning
    if(circularinitialplacement){ // good placement 
      for(HyperEdge hyperedge:this.hyperedges){
        int radius = 5*hyperedge.size(); // radius of the circle on which the vertices will be placed
          float x = random(drawing_center.x-drawing_rad,drawing_center.x+drawing_rad);
         float y_from = -sqrt(drawing_rad*drawing_rad - pow((x-drawing_center.x),2)) +  drawing_center.y;
         float y_to = sqrt(drawing_rad*drawing_rad - pow((x-drawing_center.x),2)) +  drawing_center.y;
         float y = random(min(y_from , y_to),max(y_from , y_to));
         
          PVector center = new PVector(x,y);
          
          for(int i = 0; i<hyperedge.size(); i++){
            Integer u = hyperedge.get(i);
            Vertex vertex_u = vertices.get(vmap.get(u)); 
            float newposition_x = random(center.x-radius,center.x+radius);
            float newposition_y = sqrt(radius*radius - pow((newposition_x-center.x),2)) + center.y;
           // println(newposition_x+" "+newposition_y);
            if(!associated_graph.vertexexists(u)){
                vertex_u.pos.x = newposition_x;
                vertex_u.pos.y  = newposition_y;
                associated_graph.addvertex(vertex_u);
            }
            else{ //vertex already added. We just need to modify its position to the middle of current position and already assigned position
            vertex_u = associated_graph.vertices.get(associated_graph.vmap.get(u));
              vertex_u.pos.x = (vertex_u.pos.x + newposition_x)/2;
              vertex_u.pos.y = (vertex_u.pos.y + newposition_y)/2;
              
            }
        }
      }
    }
    else{ // bad initial placement
       for(Vertex v: this.vertices)
          associated_graph.addvertex(v);

       associated_graph.init();
    }
    // ordering the vertices in the hyperedge by position and then add edge consecutively
      for(HyperEdge hyperedge:this.hyperedges){
        // sorting
        if(hyperedge.size()<2) continue; // ignore singletons
        for(int i = 0; i<hyperedge.size()-1; i++){
          PVector min = getposition(hyperedge.get(i));
          int minidx=i;
          //println(min);
          
            for(int j = i+1; j<hyperedge.size(); j++){
              PVector next = getposition(hyperedge.get(j));
              if(next.x<min.x){
                min = next;
                minidx = j;
              }
            }
          Integer temp = hyperedge.get(i);
          hyperedge.set(i,hyperedge.get(minidx));
          hyperedge.set(minidx,temp);
       }
       
       for(int i = 0; i<hyperedge.size()-1; i++){
            Integer u = hyperedge.get(i);
            Integer v = hyperedge.get(i+1);
            //println(u+":"+getposition(u).x+" "+v+":"+getposition(v).x);
            associated_graph.addedge(u,v);
       }
       associated_graph.addedge(hyperedge.get(0),hyperedge.get(hyperedge.size()-1));
       //println();
      //for(HyperEdge hyperedge:this.hyperedges){
        //for(int i = 0; i<hyperedge.size(); i++){
        //     Integer u = hyperedge.get(i);
        //     print("after Label: "+associated_graph.vertices.get(associated_graph.vmap.get(u)).label+" ");
        // }
        // println();
      //}
      }
    
  }

  // good/bad initial placement for squared drawing canvus
  void build_associatedcirculargraph(int frame_width, int frame_height){
    
    if(circularinitialplacement){ // good placement 
      for(HyperEdge hyperedge:this.hyperedges){
        int radius = 5*hyperedge.size(); // radius of the circle on which the vertices will be placed
          float x = random(drawing_center.x-drawing_rad,drawing_center.x+drawing_rad);
         float y_from = -sqrt(drawing_rad*drawing_rad - pow((x-drawing_center.x),2)) +  drawing_center.y;
         float y_to = sqrt(drawing_rad*drawing_rad - pow((x-drawing_center.x),2)) +  drawing_center.y;
         float y = random(min(y_from , y_to),max(y_from , y_to));
         
          PVector center = new PVector(x,y);
          
          for(int i = 0; i<hyperedge.size(); i++){
            Integer u = hyperedge.get(i);
            Vertex vertex_u = vertices.get(vmap.get(u)); 
            float newposition_x = random(center.x-radius,center.x+radius);
            float newposition_y = sqrt(radius*radius - pow((newposition_x-center.x),2)) + center.y;
           // println(newposition_x+" "+newposition_y);
            if(!associated_graph.vertexexists(u)){
                vertex_u.pos.x = newposition_x;
                vertex_u.pos.y  = newposition_y;
                associated_graph.addvertex(vertex_u);
            }
            else{ //vertex already added. We just need to modify its position to the middle of current position and already assigned position
            vertex_u = associated_graph.vertices.get(associated_graph.vmap.get(u));
              vertex_u.pos.x = (vertex_u.pos.x + newposition_x)/2;
              vertex_u.pos.y = (vertex_u.pos.y + newposition_y)/2;
              
            }
        }
      }
    }
    else{
      for(Vertex v: this.vertices)
        associated_graph.addvertex(v);
  
      associated_graph.init(frame_width, frame_height);
    }
      // ordering the vertices in the hyperedge by position and then add edge consecutively
      for(HyperEdge hyperedge:this.hyperedges){
        // sorting
        if(hyperedge.size()<2) continue; // ignore singletons
        for(int i = 0; i<hyperedge.size()-1; i++){
          PVector min = getposition(hyperedge.get(i));
          int minidx=i;
          //println(min);
          
            for(int j = i+1; j<hyperedge.size(); j++){
              PVector next = getposition(hyperedge.get(j));
              if(next.x<min.x){
                min = next;
                minidx = j;
              }
            }
          Integer temp = hyperedge.get(i);
          hyperedge.set(i,hyperedge.get(minidx));
          hyperedge.set(minidx,temp);
       }
       
       for(int i = 0; i<hyperedge.size()-1; i++){
            Integer u = hyperedge.get(i);
            Integer v = hyperedge.get(i+1);
            //println(u+":"+getposition(u).x+" "+v+":"+getposition(v).x);
            associated_graph.addedge(u,v);
       }
       associated_graph.addedge(hyperedge.get(0),hyperedge.get(hyperedge.size()-1));
       //println();
      }
    
  }
  
  // Good/Bad placement for circular canvas
  void build_associatedspokegraph_bery(){
    if(circularinitialplacement){
      for(HyperEdge hyperedge:this.hyperedges){
        // good initialization of the vertices in the hyperedge
        int radius = 5*hyperedge.size(); // radius of the circle on which the vertices will be placed
          
         float x = random(drawing_center.x-drawing_rad,drawing_center.x+drawing_rad);
         float y_from = -sqrt(drawing_rad*drawing_rad - pow((x-drawing_center.x),2)) +  drawing_center.y;
         float y_to = sqrt(drawing_rad*drawing_rad - pow((x-drawing_center.x),2)) +  drawing_center.y;
         float y = random(min(y_from , y_to),max(y_from , y_to));
       
          PVector center = new PVector(x,y);
       for(int i = 0; i<hyperedge.size(); i++){
            Integer u = hyperedge.get(i);
            Vertex vertex_u = vertices.get(vmap.get(u)); 
            float newposition_x = random(center.x-radius,center.x+radius);
            float newposition_y = sqrt(radius*radius - pow((newposition_x-center.x),2)) + center.y;
            //println(newposition_x+" "+newposition_y);
            if(!associated_graph.vertexexists(u)){
                vertex_u.pos.x = newposition_x;
                vertex_u.pos.y  = newposition_y;
                associated_graph.addvertex(vertex_u);
            }
            else{ //vertex already added. We just need to modify its position to the middle of current position and already assigned position 
              vertex_u.pos.x = (vertex_u.pos.x + newposition_x)/2;
              vertex_u.pos.y = (vertex_u.pos.y + newposition_y)/2;
            }
       }
    // println("haga");
      }
    }
    else{
      for(Vertex v: this.vertices)
        associated_graph.addvertex(v);
      for(HyperEdge hyperedge:this.hyperedges){
        for(int i = 0; i<hyperedge.size(); i++){
            Integer u = hyperedge.get(i);
            if(!associated_graph.vertexexists(u))
                associated_graph.addvertex(u);
        }
      }
      associated_graph.init();
    }
  }
  
    // good/bad initial placement for squared drawing canvus
    void build_associatedspokegraph_bery(int frame_width, int frame_height){
      
    if(circularinitialplacement){
      for(HyperEdge hyperedge:this.hyperedges){
        // good initialization of the vertices in the hyperedge
        int radius = 5*hyperedge.size(); // radius of the circle on which the vertices will be placed
          
         float x = random(drawing_center.x-drawing_rad,drawing_center.x+drawing_rad);
         float y_from = -sqrt(drawing_rad*drawing_rad - pow((x-drawing_center.x),2)) +  drawing_center.y;
         float y_to = sqrt(drawing_rad*drawing_rad - pow((x-drawing_center.x),2)) +  drawing_center.y;
         float y = random(min(y_from , y_to),max(y_from , y_to));
       
          PVector center = new PVector(x,y);
       for(int i = 0; i<hyperedge.size(); i++){
            Integer u = hyperedge.get(i);
            Vertex vertex_u = vertices.get(vmap.get(u)); 
            float newposition_x = random(center.x-radius,center.x+radius);
            float newposition_y = sqrt(radius*radius - pow((newposition_x-center.x),2)) + center.y;
            //println(newposition_x+" "+newposition_y);
            if(!associated_graph.vertexexists(u)){
                vertex_u.pos.x = newposition_x;
                vertex_u.pos.y  = newposition_y;
                associated_graph.addvertex(vertex_u);
            }
            else{ //vertex already added. We just need to modify its position to the middle of current position and already assigned position 
              vertex_u.pos.x = (vertex_u.pos.x + newposition_x)/2;
              vertex_u.pos.y = (vertex_u.pos.y + newposition_y)/2;
            }
       }
    // println("haga");
      }
    }
    else{
      for(Vertex v: this.vertices)
        associated_graph.addvertex(v);
      for(HyperEdge hyperedge:this.hyperedges){
       for(int i = 0; i<hyperedge.size(); i++){
            Integer u = hyperedge.get(i);
            if(!associated_graph.vertexexists(u))
                associated_graph.addvertex(u);
       }
      }
      associated_graph.init(frame_width, frame_height);
    }
  }
  
  boolean computeconvexhulls(){
    boolean allgoodhulls = true;
    // Compute convex hulls of all the hyperedges
    for(HyperEdge hypedge:this.hyperedges){
      if(hypedge.size()<2) // ignore 1 point hyper edges
        continue;
      ArrayList<Vertex> vv = new ArrayList<Vertex>();
      for(int i = 0; i<hypedge.size(); i++){
        int id = hypedge.get(i);
         vv.add(associated_graph.vertices.get(associated_graph.vmap.get(id))); // get the vertices in the associated graph from the vertices in the hyperedge
        //println(hg.associated_graph.vertices.get(i).id);
      }
      
      hypedge.computehull(vv);
      //if (hypedge.isBadhull){
      //  // do nothing. will be handled in subsequent iteration
      //  allgoodhulls = false;
      //  //for(int i = 0; i<hypedge.size(); i++){
      //  //    int id = hypedge.get(i);
      //  //    Vertex updatedV = associated_graph.vertices.get(associated_graph.vmap.get(id));
      //  //    updatedV.fixed = true;
      //  //    associated_graph.vertices.set(associated_graph.vmap.get(id), updatedV);
      //  //  }
      //  println(hypedge.vertices);
      //}
      //else
      //  {// make the vertices of the good hulls unmovable.
      //    for(int i = 0; i<hypedge.size(); i++){
      //      int id = hypedge.get(i);
      //      Vertex updatedV = associated_graph.vertices.get(associated_graph.vmap.get(id));
      //      updatedV.fixed = true;
      //      associated_graph.vertices.set(associated_graph.vmap.get(id), updatedV);
      //    }
      //  }
      
    }
    return allgoodhulls;
  }
  
  void findcontour(){
    // Find the all pair tangents, their intersections and thus the boundary of all the hyperedges.
    for(HyperEdge hypedge:this.hyperedges){
      if(hypedge.size()>1)
        hypedge.find_allpairtangents();
      //println("b points: "+hypedge.boundarypoints.size());
    }
  }
  
  void assignedgecolors(){
     RandomColorGenerator cg = new RandomColorGenerator(totaladdedhypedges); 
     println("singletons: "+singletonedges+" total: "+totaladdedhypedges);
     cg.forcebasedcolor(); 
     int i=0;
      for(HyperEdge hypedge:hyperedges){
        //if(hypedge.size()>=2){
           println(i++);
           color c = cg.nextcolor();
           if(c == color(255,255,255,128)){
             println("ignoring white");
             c = cg.nextcolor();
           }
           hypedge.setcolor(c);
        //}
      }
  }
  
  void drawvertices(){
    for(HyperEdge hypedge:this.hyperedges){
      //if(hypedge.size()<2) continue; // Draw the singletons
      for(int i = 0; i<hypedge.size(); i++){
        int id = hypedge.get(i);
        
        PVector pos = getposition(id);
        strokeWeight(stroke_intensity);
        if(vertex_fill){
            stroke(vertex_color);
            noFill();
          }
          ellipse(pos.x,pos.y,vertex_radius,vertex_radius);
          //labels
         if(vertex_label){
            //strokeWeight(stroke_intensity);
            stroke(vertexlabel_color);
            fill(vertexlabel_color);
            textSize(text_font);
            text(this.vertices.get(this.vmap.get(id)).label, pos.x+vertex_radius,pos.y+vertex_radius);
          }
      }
    }
  }
  void draw(boolean drawcontour){
    //draw vertices
    drawvertices();
    //println("inside draw");
    for(HyperEdge hypedge:hyperedges){
      
        //draw hulls
      //if(hypedge.size()>1)
      //  stroke(hypedge.col);
      if(drawcontour){
            //for(HyperEdge hyperedge:this.hyperedges){
            //  for(int i = 0; i<hyperedge.size(); i++){
            //       Integer u = hyperedge.get(i);
            //       print("Label: "+associated_graph.vertices.get(u).label+" ");
            //   }
            //   println();
            //   STATE = BLANK;
            //}
        //for(ArrayList<PVector> tangent:hypedge.tangents){
        //  line(tangent.get(0).x,tangent.get(0).y,tangent.get(1).x,tangent.get(1).y);
        //  if(tangent.size() == 4)
        //    line(tangent.get(2).x,tangent.get(2).y,tangent.get(3).x,tangent.get(3).y);    
        //}
        
        // draw closed curve
        if(hypedge.size()<=2){
          
          if(hypedge.size() <= 1){ // singleton hyperedge
          noFill();
          strokeWeight(stroke_intensity);
          stroke(hypedge.col);
          PVector pos = getposition(hypedge.get(i));
          ellipse(pos.x,pos.y,vertex_radius*3,vertex_radius*3 ); // Draw a larger ball.  
          
          }
          else{
            
            //println(hypedge.tangents.size());
           ArrayList<PVector>tangents = hypedge.tangents.get(0); 
          PVector tangent11 = tangents.get(0);
          PVector tangent12 = tangents.get(1);
          PVector tangent21 = tangents.get(3);
          PVector tangent22 = tangents.get(2);
            noFill();
            strokeWeight(stroke_intensity);
            stroke(hypedge.col);
            beginShape();
              curveVertex(tangent11.x,tangent11.y);
              curveVertex(tangent12.x,tangent12.y);
              curveVertex(tangent21.x,tangent21.y);
              curveVertex(tangent22.x,tangent22.y);
               curveVertex(tangent11.x,tangent11.y);
              curveVertex(tangent12.x,tangent12.y);
              curveVertex(tangent21.x,tangent21.y);
            endShape();
          }
        }
        else{
          noFill();
          // Draw the hyperedge considering the hullpoints as the control points of the spline. 
          //beginShape();
          //  for(int i=0;i<hypedge.hullpoints.size();i++){
          //    PVector p = hypedge.hullpoints.get(i);
          //    curveVertex(p.x,  p.y);
          //    //println("hi "+p.x+ " "+p.y);
          //  }
          //  //curveVertex(hypedge.hullpoints.get(0).x,hypedge.hullpoints.get(0).y);
          //  curveVertex(hypedge.hullpoints.get(1).x,hypedge.hullpoints.get(1).y);
          //  curveVertex(hypedge.hullpoints.get(2).x,hypedge.hullpoints.get(2).y);
          //  //println("hi "+hypedge.hullpoints.get(0).x+" "+hypedge.hullpoints.get(0).y);
          //endShape();
          stroke(hypedge.col);
          beginShape();
          int sz = hypedge.boundarypoints.size();
          for(int i = 0; i< sz+3; i++){
            PVector point = hypedge.boundarypoints.get(i%sz);
            curveVertex(point.x,point.y);
            ellipse(point.x,point.y,vertex_radius/2,vertex_radius/2);
            //print(point+" ");
          }
          //curveVertex(hypedge.boundarypoints.get(2).x,hypedge.boundarypoints.get(2).y);
          //println();
          endShape();
    
        }
      }
      else{
        //for(int i=1;i<hypedge.hullpoints.size();i++){
        //  PVector p1 = hypedge.hullpoints.get(i);
        //  PVector p2 = hypedge.hullpoints.get(i-1);
        //  line(p1.x, p1.y, p2.x, p2.y);
        //}
      }
    }
  }
  
  PVector getCentroid(HyperEdge hyed){
    PVector centroid = new PVector(0,0);
    for(int v:hyed.vertices)
      centroid = PVector.add(centroid,PVector.div(getposition(v),hyed.size()));
    return centroid; 
  }
  
  void drawEdgebased(){
    drawvertices();
    for(HyperEdge hypedge:this.hyperedges){
      if(hypedge.size()<2) { // draw singletons
        noFill();
        stroke(hypedge.col);
        PVector pos = getposition(hypedge.get(i));
          ellipse(pos.x,pos.y,vertex_radius*3,vertex_radius*3 ); // Draw a larger ball.  
      }
      else if(hypedge.size()==2){
        noFill();
        stroke(hypedge.col);
        line(getposition(hypedge.get(0)).x, getposition(hypedge.get(0)).y, getposition(hypedge.get(1)).x, getposition(hypedge.get(1)).y);
      }
      else{
         PVector centroid = getCentroid(hypedge);
         PVector[] vt = new PVector[hypedge.size()];
         float angles[] = new float[hypedge.size()];
         
         for(int i = 0; i<hypedge.size(); i++)
           vt[i] = getposition(hypedge.get(i));
           
         // finding angles with centroids
         for(int i=0;i<hypedge.size(); i++){
           if ( (vt[i].x - centroid.x) >0)
             angles[i] = atan( (vt[i].y - centroid.y)/(vt[i].x - centroid.x) )*180/PI;
           else if(vt[i].x == centroid.x){
             if(vt[i].y < centroid.y)
               angles[i] = 90;
             else
               angles[i] = 270;
           }
           else{
             angles[i] = atan( (vt[i].y - centroid.y)/(vt[i].x - centroid.x) )*180/PI + 180;
           }
           if(angles[i] <0)  angles[i]+=360;
           
         }
         
         
         TreeMap<Float,Integer> map = new TreeMap<Float,Integer>();
         int[] sortedvt = new int[hypedge.size()];
          for( int i = 0; i<hypedge.size(); i++ ) {
              map.put( angles[i], hypedge.get(i) );
          }
          int i =0;
          for(int idx:map.values()){
            sortedvt[i++] = idx;
          }
          
          stroke(hypedge.col);
          fill(hypedge.col);
          //for(int j = 0; j<hypedge.size();j++){
          //  PVector p0 = getposition(sortedvt[j]);
          //  PVector p1 = getposition(sortedvt[(j+1)%sortedvt.length]);
          //  PVector midway0 = new PVector(0,0);
          //  PVector midway1 = new PVector(0,0);
          //  midway0 = PVector.div(PVector.add(p0,centroid),2);
          //  midway1 = PVector.div(PVector.add(p1,centroid),2);
          //  bezier(p0.x, p0.y, midway0.x, midway0.y, midway1.x, midway1.y,  p1.x, p1.y);
          //}
          
          /* Another way */
          beginShape();
          for(int j = 0; j<hypedge.size();j++){
            PVector p0 = getposition(sortedvt[j]);
            PVector p1 = getposition(sortedvt[(j+1)%sortedvt.length]);
            PVector midway0 = new PVector(0,0);
            PVector midway1 = new PVector(0,0);
            midway0 = PVector.div(PVector.add(p0,centroid),2);
            midway1 = PVector.div(PVector.add(p1,centroid),2);            
            vertex(p0.x, p0.y);
            bezierVertex(midway0.x, midway0.y, midway1.x, midway1.y,  p1.x, p1.y);    
          }
          endShape();
        }
    }
  }
  
  //void drawEdgebased_curveonly(){
  //  drawvertices();
  //  for(HyperEdge hypedge:this.hyperedges){
  //    if(hypedge.size()<2) {
  //      continue;
  //    }
  //    else if(hypedge.size()==2){
  //      stroke(hypedge.col);
  //      line(getposition(hypedge.get(0)).x, getposition(hypedge.get(0)).y, getposition(hypedge.get(1)).x, getposition(hypedge.get(1)).y);
  //    }
  //    else{
  //       PVector centroid = getCentroid(hypedge);
  //       PVector[] vt = new PVector[hypedge.size()];
  //       float angles[] = new float[hypedge.size()];
         
  //       for(int i = 0; i<hypedge.size(); i++)
  //         vt[i] = getposition(hypedge.get(i));
           
  //       // finding angles with centroids
  //       for(int i=0;i<hypedge.size(); i++){
  //         if ( (vt[i].x - centroid.x) >0)
  //           angles[i] = atan( (vt[i].y - centroid.y)/(vt[i].x - centroid.x) )*180/PI;
  //         else if(vt[i].x == centroid.x){
  //           if(vt[i].y < centroid.y)
  //             angles[i] = 90;
  //           else
  //             angles[i] = 270;
  //         }
  //         else{
  //           angles[i] = atan( (vt[i].y - centroid.y)/(vt[i].x - centroid.x) )*180/PI + 180;
  //         }
  //         if(angles[i] < 0)  angles[i]+=360;
           
  //       }
         
         
  //       TreeMap<Float,Integer> map = new TreeMap<Float,Integer>();
  //       int[] sortedvt = new int[hypedge.size()];
  //        for( int i = 0; i<hypedge.size(); i++ ) {
  //            map.put( angles[i], hypedge.get(i) );
  //        }
  //        int i =0;
  //        for(int idx:map.values()){
  //          sortedvt[i++] = idx;
  //        }
          
  //        stroke(hypedge.col);
  //        noFill();
          
  //        //first bunch goes through vt[0],centroid,vt[1]
  //        PVector p0 = getposition(sortedvt[0]);
  //        PVector p1 = getposition(sortedvt[1]);
  //        curve(p0.x, p0.y, p0.x,p0.y, centroid.x,centroid.y, p1.x, p1.y);
  //        curve(p0.x, p0.y, centroid.x,centroid.y, p1.x,p1.y, p1.x, p1.y);
          
  //        // the consequtive ones
  //        for(int j = 2; j<sortedvt.length; j++){
  //          p0 = p1;
  //          p1 = getposition(sortedvt[j]);
  //          PVector oldcentroid = centroid;
  //          centroid = PVector.div(PVector.add(PVector.add(centroid,p0),p1),3);
  //          p0 = oldcentroid;
  //          curve(p0.x, p0.y, p0.x,p0.y, centroid.x,centroid.y, p1.x, p1.y);
  //          curve(p0.x, p0.y, centroid.x,centroid.y, p1.x,p1.y, p1.x, p1.y);
  //        }
  //    }
  //  }
  //}
  
  void drawEdgebased_curveonly(){
    drawvertices();
    for(HyperEdge hypedge:this.hyperedges){
      if(hypedge.size()<2) { // Draw singletons
        noFill();
        stroke(hypedge.col);
        PVector pos = getposition(hypedge.get(i));
          ellipse(pos.x,pos.y,vertex_radius*3,vertex_radius*3 ); // Draw a larger ball.  
      }
      else if(hypedge.size()==2){
        noFill();
        stroke(hypedge.col);
        line(getposition(hypedge.get(0)).x, getposition(hypedge.get(0)).y, getposition(hypedge.get(1)).x, getposition(hypedge.get(1)).y);
      }
      else{
         PVector centroid = getCentroid(hypedge);
         PVector[] vt = new PVector[hypedge.size()];
         float angles[] = new float[hypedge.size()];
         
         for(int i = 0; i<hypedge.size(); i++)
           vt[i] = getposition(hypedge.get(i));
           
         // finding angles with centroids
         for(int i=0;i<hypedge.size(); i++){
           if ( (vt[i].x - centroid.x) >0)
             angles[i] = atan( (vt[i].y - centroid.y)/(vt[i].x - centroid.x) )*180/PI;
           else if(vt[i].x == centroid.x){
             if(vt[i].y < centroid.y)
               angles[i] = 90;
             else
               angles[i] = 270;
           }
           else{
             angles[i] = atan( (vt[i].y - centroid.y)/(vt[i].x - centroid.x) )*180/PI + 180;
           }
           if(angles[i] < 0)  angles[i]+=360;
           
         }
         
         
         TreeMap<Float,Integer> map = new TreeMap<Float,Integer>();
         int[] sortedvt = new int[hypedge.size()];
          for( int i = 0; i<hypedge.size(); i++ ) {
              map.put( angles[i], hypedge.get(i) );
          }
          int i =0;
          for(int idx:map.values()){
            sortedvt[i++] = idx;
          }
          
          stroke(hypedge.col);
          noFill();
          
          
          //first bunch goes through vt[0],centroid,vt[1]
          PVector p0 = getposition(sortedvt[0]);
          PVector p1 = getposition(sortedvt[1]);
          curve(p0.x, p0.y, p0.x,p0.y, centroid.x,centroid.y, p1.x, p1.y);
          curve(p0.x, p0.y, centroid.x,centroid.y, p1.x,p1.y, p1.x, p1.y);
          
          // the consequtive ones
          for(int j = 2; j<sortedvt.length; j++){
            // find the point which makes almost 0 angle with the conjugate of the new point
            PVector newpoint = getposition(sortedvt[j]);
            float angle_newpoint = angles[j];
            float absmax = 0;
            int indmax = j;
            for(int index_of_targetpt = j;index_of_targetpt >=0; index_of_targetpt--){
              float val = abs(angle_newpoint - angles[index_of_targetpt]);
              if(val>180) val = 360 - val;
              if(val>absmax){
                absmax = val;
                indmax = index_of_targetpt;
              }
            }
            
            PVector oppositept = getposition(sortedvt[indmax]);
            curve(oppositept.x,oppositept.y,centroid.x,centroid.y,newpoint.x,newpoint.y,newpoint.x,newpoint.y);
            //p0 = p1;
            //p1 = getposition(sortedvt[j]);
            //PVector oldcentroid = centroid;
            //centroid = PVector.div(PVector.add(PVector.add(centroid,p0),p1),3);
            //p0 = oldcentroid;
            //curve(p0.x, p0.y, p0.x,p0.y, centroid.x,centroid.y, p1.x, p1.y);
            //curve(p0.x, p0.y, centroid.x,centroid.y, p1.x,p1.y, p1.x, p1.y);
          }
      }
    }
  }
  
  void writehypergraphtofile(Path p){
    println(p.toString());
    ArrayList<String> stringtowrite = new ArrayList<String>();
    for(HyperEdge h:this.hyperedges){
      stringtowrite.add(getHyperEdgerepr(h));  
    }
    
    try{
        //for(String st:s)  
        //  println(st);
        Files.write(p, stringtowrite, Charset.forName("UTF-8"));
        println("Written to: "+p);
      }catch (IOException ex) {
        // report
        println("Write Error");
      }
  }
}


class GenerateHyperGraph{
  HyperGraph DemoHyperGraph(){
    HyperGraph hg = new HyperGraph();
    //for(int i =0 ; i<10;i++)
    //  hg.addvertex(i);
    println(hg.vertices.size());
    //Integer [] h1 = {0,1,2}; 
    //hg.addhyperedge(h1);
    //Integer [] h2 = {2,3,4}; 
    //hg.addhyperedge(h2);
    Integer [] h3 = {2,4}; 
    hg.addhyperedge(h3);
    
    println(hg.hyperedges);
    
    return hg;
  }
  HyperGraph RandomK_HyperGraph(int n_vertices,int n_hypedges,int k){
   
    HyperGraph hg = new HyperGraph(n_vertices,n_hypedges);
    
    for(int i = 0; i<n_hypedges; i++){
      
       // Ideally just create one instance globally
      // Note: use LinkedHashSet to maintain insertion order
      Set<Integer> generated = new LinkedHashSet<Integer>();
      Integer [] hypedge = new Integer[k];
      while (generated.size() < k)
      {
          Integer next = new Integer(int(random(n_vertices))); // Random number between [0-n_vertices)
          // As we're adding to a set, this will automatically do a containment check
          generated.add(next);
          println(next);
      }
      int indx = 0;
      for(Integer val:generated)
        hypedge[indx++] = val;
      Arrays.sort(hypedge); //hyperedges are sorted by id
      
      hg.addhyperedge(hypedge);
    }
    //println(hg.hyperedges);
    return hg;
  }
}

color getRandomColor(){
  float R = random(255);
  float G = random(255);
  float B = random(255);
  return color(R,G,B);
}

  class ReadHyperGraph{
    HyperGraph readasedgelist(String filepath){
      /*
      0,1
      1,2,3
      1
      means {1} is an hyperedge consisting of node 1, {0,1} is an hyperedge and so is{1,2,3}      
      */
      HyperGraph readhg = new HyperGraph();
      String lines[] = loadStrings(filepath);
        println("there are " + lines.length +" lines");
        for (int i = 0 ; i < lines.length; i++) {
          String words[] = lines[i].split(",");
          println(words[0]+" "+words.length);
          readhg.addhyperedge(words);
          }
      readhg.numvertices = readhg.totaladdednodes;
      readhg.numhyperedges = readhg.totaladdedhypedges;
         
      return readhg;
    }
  }
