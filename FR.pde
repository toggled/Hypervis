class Fruch_Rein{
  HyperGraph h;
  Graph g;
  int frame_width,frame_height;
  float temp = 50;
  private float k;
  int iteration;
  int maxiter = 40;
  boolean barycenter = false;
  float C; // Experimentally determined constant in FR algorithm 
  float c1 = 0.001;
  float c2= 1000;
  float c3 = 1000000;
 ArrayList <Vertex> listofpseudov = new ArrayList();
 ArrayList <Edge> pseudo_edgelist = new ArrayList();
 int del = 10; // offset for drawing window
 float gravity = 3;
 boolean hasgravity = false; // default is no gravity
 boolean circularcanvas = false; // default is rectangular 
 
  Fruch_Rein(int W,int H){
    frame_width = W;
    frame_height = H;
    C = 1;
    iteration = 0;
  }
  
  void sethypergraph(HyperGraph h){ 
    this.h = h; 
  }
  void setgraph(){
    this.g = this.h.associated_graph;
    k = C*sqrt(PI*drawing_rad*drawing_rad/g.vertices.size());
  }

  float get_attractive_force_bery(float distance){
    return pow(distance,1.5)/k;
  }
  
  float get_attractive_force(float distance){
    if(REPR == 1)
      return pow(distance,2)/k; // FR algorithm
    if(REPR == 2)
      return c1*log(distance/c2); // Eades
      
    return pow(distance,2)/k; // default is FR
  }
  
  float get_repulsive_force(float distance){
    if(REPR == 1)
      return pow(k,1.7)/distance; // FR algorithm
    if(REPR == 2)
      return c3/pow(distance,2); //Eades
      
    return pow(k,1.7)/distance; // default is FR
  }
  
  float get_gravitational_force(float distance,int deg){
    return 0.001*gravity*distance*(deg+1); // 0.01 = magic number
    //return 0.01*gravity*distance; // 0.01 = magic number
  }
  
  void iterateonce(){
    if(iteration > maxiter) {
      return;
    }

    // adjust position of vertices based on replacement due to repulsive forces by others
    for(Vertex v: g.vertices){
      v.displace = new PVector(0,0);
      for(Vertex u:g.vertices){
        if(u.id != v.id){
          PVector delta = g.getdifference_vector(v,u);
         // println("delta: "+delta.x+" "+delta.y+" "+delta.mag());
         if(delta.mag()>0)
           v.displace.add(PVector.mult(delta,get_repulsive_force(delta.mag())/delta.mag()));
        }
      }
    }
  
    //Edge adjustment
    for(int i =0; i< g.vertices.size(); i++ ){
      Vertex vertex_u = g.vertices.get(i);
      ArrayList <Integer> adjacent_u = g.adjlist.get(g.vindex_verlist(vertex_u.id));
      if(adjacent_u.isEmpty()) {
        //println("you empty ");
        continue;
      }
      else{
        for(Integer vertex_indx: adjacent_u){
            Vertex vertex_v = g.vertices.get(vertex_indx);
                //line(vertex_u.pos.x,vertex_u.pos.y,vertex_v.pos.x,vertex_v.pos.y); 
                PVector delta = g.getdifference_vector(vertex_v,vertex_u);
                if(delta.mag()> 0){
                  vertex_v.displace.sub(PVector.mult(delta,get_attractive_force(delta.mag())/delta.mag()));
                  vertex_u.displace.add(PVector.mult(delta,get_attractive_force(delta.mag())/delta.mag()));
                }
        }
      }
    }
     
     //Barycenter based circular force based algorithm
     // Attractive Force along the pseudoedge u,barycenter , for every vertex u
     if(barycenter){
       listofpseudov.clear();
       pseudo_edgelist.clear();
       for(HyperEdge hyperedge:this.h.hyperedges){
         if(hyperedge.size()<2) continue; // barycenter of singleton hyperedge is undefined.
         //Computing barycenter and making it a pseudovertex
         Vertex pseudovertex = new Vertex(-1);
         PVector pos = new PVector(0,0);
         int size_hypedge = hyperedge.size();
          for(int i = 0; i<size_hypedge; i++){
            PVector vertex_u = h.getposition(hyperedge.get(i));
            //println(vertex_u.pos.x+" "+vertex_u.pos.y);
            pos.add(vertex_u);
          }
          pseudovertex.setposition(pos.x/size_hypedge,pos.y/size_hypedge);
          listofpseudov.add(pseudovertex);
     //    // println(pos.x/size_hypedge + " " + pos.y/size_hypedge+"iteration "+iteration);
          
          // Computing attractive force between each vertex in the hyperedge
          for(int i = 0; i<size_hypedge; i++){
              Vertex vertex_u = g.vertices.get(g.vmap.get(hyperedge.get(i)));
              pseudo_edgelist.add(new Edge(vertex_u,pseudovertex));
              PVector delta = g.getdifference_vector(pseudovertex,vertex_u);
              if(delta.mag() >0)
                vertex_u.displace.add(PVector.mult(delta,get_attractive_force_bery(delta.mag())/delta.mag()));
          }
        }
     }
     
          //Vertex placement after one iteration
     for(Vertex v:g.vertices){
       //println("id: ",v.id);
       PVector posv = new PVector(v.pos.x,v.pos.y);
       //println("displace mag"+v.displace.x+" "+v.displace.y);
       PVector totaldisp = PVector.mult(v.displace,min(v.displace.mag(),temp)/v.displace.mag());
       
      if(hasgravity){
        // Common Improvement: Adding Gravity force towards center of the drawing proportional to distance from center
        PVector newpos = PVector.add(posv,totaldisp); // new position after node-node repulsion and along-edge attraction
        PVector delta = PVector.sub(drawing_center,newpos); // force vector towards center
        if(delta.mag()>0){
          println("gravity: "+get_gravitational_force(delta.mag(),v.deg)/delta.mag());
          totaldisp.add(PVector.mult(delta,get_gravitational_force(delta.mag(),v.deg)/delta.mag())); // (delta/|delta|)*gravityforce(|delta|)
        }
      }
      
      if(circularcanvas){
         //Adjust x and y coordinate so that they don't go outside frame
         if(PVector.dist(PVector.add(posv,totaldisp),drawing_center)<drawing_rad-vertex_radius){
           posv.add(totaldisp);
           if (!v.fixed)
             v.setposition(posv.x,posv.y); 
         }
      }
      else{
          posv.add(totaldisp);
      
         //Adjust x and y coordinate so that they don't go outside frame
         if(posv.x<= topleftcorner.x)
           posv.x = topleftcorner.x + 2*vertex_radius + del;
         if(posv.x >= frame_width)
           posv.x = frame_width - 2*vertex_radius - del;
         
         if(posv.y<=topleftcorner.y)
           posv.y = topleftcorner.y + 2*vertex_radius + del;
         if(posv.y >= frame_height)
           posv.y = frame_height - 2*vertex_radius - del;
         if (!v.fixed) 
           v.setposition(posv.x,posv.y); 
          
      }
       //v.setposition(posv.x,posv.y); 
       
     }
     
     iteration++;
     temp = gettemp(); //cool temp
  }
  

  float gettemp(){
    // cooling function to limit the max displacement
    //return temp*exp(-iteration);
    return temp*.9;
  }
  
  Graph getgraph(){
    assert g !=null;
      return g;
  }
  
}
