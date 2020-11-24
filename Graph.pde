import java.util.ArrayList;
import java.util.Hashtable;
import org.la4j.vector.DenseVector;


class position{
  float x,y;
  Vector posvector;
  position(){};
  PVector getpvector(){return new PVector(x,y);}
  Vector getVector(){
   return posvector;
  }
  void project(int i, int j){
    x = (float)posvector.get(i);
    y = (float)posvector.get(j);
  }
}
class Vertex{
  String label;
  int id;
  position pos ;
  PVector displace;
  Vector displacement;
  boolean centroid = false;
  int deg = 0;
  int degree_hypergraph = 0;
  boolean fixed = false;
  
  // create a vertex with an id in R^dim // for generalized FR
  Vertex(int id, int dim){ 
    this.id = id;
    pos = new position();
    pos.posvector = DenseVector.zero(dim);
  }
  
  Vertex(int id){
    this.id = id;
    pos = new position();
  }
  //Vertex(int id,int x,int y){
  //  this.id = id;
  //  this.pos.x = x;
  //  this.pos.y = y;
  //displace = new PVector(0,0);
  //}
  void setposition(float x, float y){
    this.pos.x = x;
    this.pos.y = y;
    displace = new PVector(0,0);
  }
  void setposition(double x[]){ // for generalized FR
    pos.posvector = DenseVector.fromArray(x);
    displacement = DenseVector.zero(x.length);
  }
  void setposition(Vector v){
    pos.posvector = v;
    displacement = DenseVector.zero(v.length());
  }
  
  PVector getposition(){
    return pos.getpvector();
  }
}
class Edge{
  Vertex u,v;
  //Edge(int uid,int vid){
  //  u = new Vertex(uid);
  //  v = new Vertex(vid);
  //}
  Edge (Vertex u, Vertex v){
    this.u = u;
    this.v = v;
  }
}
class Graph {
  ArrayList <Vertex> vertices = new ArrayList <Vertex> ();
  ArrayList <ArrayList <Integer>> adjlist = new ArrayList <ArrayList <Integer>>(); // Adjlist with i -> (j,k,l) where i is the index of vertex lets say a in this.vertices

  Hashtable <Integer,Integer> vmap = new Hashtable<Integer,Integer> (); // Which vertexid in which index of vertices 
  Graph(){
  }
  void addvertex(Vertex v){
    vmap.put(v.id,this.vertices.size());
    this.vertices.add(v); // The order in which the vertices are added to this.vertices is the same as 
    adjlist.add(new ArrayList<Integer>());     // in adjlist.add()
  }
  void printgraph(){
    for(ArrayList <Integer> edge:adjlist){
      println(edge);
    }
  }
  Vertex addvertex(int vertex_id){
    Vertex v = new Vertex(vertex_id);
    this.addvertex(v);  
    return v;
  }
  
  void addedge(Vertex u, Vertex v){
    // We assume the id of the vertices are integers not necessarily consecutive. Thus the id's are ordered.
    
    if(!vertexexists(u.id)){
      addvertex(u);
    }
    if(!vertexexists(v.id)){
      addvertex(v);
    }
    if(u.id<v.id)
      this.adjlist.get(vindex_verlist(u.id)).add(vindex_verlist(v.id));
    else
      this.adjlist.get(vindex_verlist(v.id)).add(vindex_verlist(u.id));
      
    //this.adjlist.get(v.id).add(u); //We dont need to add edge with repetition
    u.deg++;
    v.deg++;
  }
  
  void addedge(int u_id, int v_id){
    Vertex u, v;
    int u_indx,v_indx;
    if(!vertexexists(u_id)){
      u = addvertex(u_id);
    }
    u_indx = this.vmap.get(u_id);
      
    if(!vertexexists(v_id)){
      v = addvertex(v_id);
    }
    v_indx = this.vmap.get(v_id);
      
    if(u_id<v_id)
      if(!this.adjlist.get(u_indx).contains(v_indx))
        this.adjlist.get(u_indx).add(v_indx);
      else{
       // println("Nada");
      }
    else
      if(!this.adjlist.get(v_indx).contains(u_indx))
        this.adjlist.get(v_indx).add(u_indx);
      else{
        //println("dada");
      }
     this.vertices.get(u_indx).deg++;
     this.vertices.get(v_indx).deg++;
  }
  
  boolean vertexexists(int id){
    if(id == -1) // centroid
      return true;
    return vmap.get(id) != null;
  }
  int vindex_verlist(int id){
    // get index in vertices list from vertex id 
    return vmap.get(id);
  }
  PVector getdifference_vector(Vertex v, Vertex u){
    // return v-u
    return PVector.sub(new PVector(v.pos.x,v.pos.y),new PVector(u.pos.x,u.pos.y));
  }
  
  Vector GFR_getdifference_vector(Vertex v,Vertex u){ // GFR
    return v.pos.getVector().subtract(u.pos.getVector());
  }
  
 void initGFR(Vector thresh,int frame_width, int frame_height, int dim){
   assert frame_width == frame_height;
   for(Vertex v:this.vertices){
     double x[] = new double[dim];
     Random rn = new Random();
     Vector randomv = DenseVector.random(dim,rn);
     thresh = thresh.add(randomv.multiply(frame_width));
     v.setposition(thresh);
   }
 }
 void init(int frame_width, int frame_height){
    for(Vertex v:this.vertices){
      if (!v.fixed){
        int x = int(random(frame_width));
        int y = int(random(frame_height));
        v.setposition(x,y); // displacement vector initialized to 0
      }
    }
 }
 
 void init(){ // Initializing vertices in the circular drawing canvus
   for(Vertex v:this.vertices){
     if (!v.fixed){
       float x = random(drawing_center.x-drawing_rad,drawing_center.x+drawing_rad);
       float y_from = -sqrt(drawing_rad*drawing_rad - pow((x-drawing_center.x),2)) +  drawing_center.y;
       float y_to = sqrt(drawing_rad*drawing_rad - pow((x-drawing_center.x),2)) +  drawing_center.y;
       float y = random(min(y_from , y_to),max(y_from , y_to));
       v.setposition(x,y);
     }
   }
 }
 
 void project(int i,int j){
   for(Vertex v:this.vertices){
     v.pos.project(i,j);
   }
 }
 
   void drawgraph(){
    
      background(background_color);
      strokeWeight(stroke_intensity);
      for(Vertex v:this.vertices){
        
        if(vertex_fill)
          noFill();
        ellipse(v.pos.x,v.pos.y,vertex_radius,vertex_radius);
        if(vertex_label){
          fill(vertexlabel_color);
          textSize(text_font);
          text(v.label, v.pos.x+vertex_radius,v.pos.y+vertex_radius);
        }
      // println(v.pos.x+" "+v.pos.y);
      }
    //if(graph_layout.barycenter){
      if(Boolean.valueOf(globalconf.getProperty("barycenter"))){
        for(Vertex v:graph_layout.listofpseudov){
          if(vertex_fill)
            fill(vertex_color+color(50,50,50));
          ellipse(v.pos.x,v.pos.y,vertex_radius,vertex_radius);
        }
      }
    
    fill(edge_color);
    stroke(0,0,0);
      for(int i =0; i< this.vertices.size(); i++ ){
        int u_id = i;
        Vertex vertex_u = this.vertices.get(i);
        ArrayList <Integer> adjacent_u = this.adjlist.get(u_id);
        for(Integer vertex_indx: adjacent_u){
            Vertex vertex_v = this.vertices.get(vertex_indx);
                line(vertex_u.pos.x,vertex_u.pos.y,vertex_v.pos.x,vertex_v.pos.y);   
        }
      }
    
    //drawing centroid connected edges
    //if(graph_layout.barycenter){
      if(Boolean.valueOf(globalconf.getProperty("barycenter"))){
        fill(color(0,0,250));
        for(Edge e:graph_layout.pseudo_edgelist){
          line(e.u.pos.x,e.u.pos.y,e.v.pos.x,e.v.pos.y);
        }
      }
  }

}

class GenerateGraph{
  Graph RandomGraph(int numvertices, int numedges){
  Graph g = new Graph();
  int total_edges = 0;
  //for(int i = 0; i < numvertices; i++){
  //  g.addvertex(new Vertex(i));
  //}
  
  for(int i = 0; i < numvertices-1 && total_edges<numedges; i++){
    for(int j = i+1; j< numvertices && total_edges<numedges; j++){
      float prob = random(0,1);
      if( prob > 0.5){
        println(str(i)+" "+str(j));
        g.addedge(i,j);
        total_edges++;
      }
    }
  }
  return g;
  }
}
