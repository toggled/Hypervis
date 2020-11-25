import processing.pdf.*;
import java.util.Properties;
import processing.svg.*;
import g4p_controls.*;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.Files;
import java.nio.charset.Charset;
import java.net.URL;
import org.la4j.vector.DenseVector;
import peasy.*;

PeasyCam cam;

HyperGraph hg;
HyperGraph inputhg; 
ReadHyperGraph hgreader;
int i=0,j=1;
boolean drawhull = false;
boolean drawcontour = false;

int edscheme = 1; // 1 is filledcurve, 2 is just curve
int saveaspdf = 0; // 1 means pdf, 2 means svg
int window_width;
int window_height;
final PVector topleftcorner = new PVector(10,10);
Vector GFR_topleftcorner;

int drawing_rad;
PVector drawing_center;
Vector GFR_drawing_center;

int text_font = 15;
int stroke_intensity = 3;
int vertex_radius = 5;
color background_color = color(255,255,255);
color vertex_color = color(100,100,100);
color edge_color = color(128);
color vertexlabel_color = color(0,0,255);
boolean vertex_fill = true;
boolean vertex_label = false;
Fruch_Rein graph_layout;
 
int time;
PVector poi = new PVector(0,0); // point of interest of my rendering window 
float zoom = 1;

boolean mdsbasedhg = false;
boolean edgebasedhg = false;
String pdffilename;
String inputgraphfilename; //
String probab;
private static final int SAVEAS = 2;
private static final int DRAW = 1;
private static final int BLANK = 0;
int STATE = BLANK;

int REPR = 1; // 1 = Fruchterman-Reingold, 2 = EADES 

int CIRCULARCANVAS = 2; // 1 = circular, 2 = rectangular
int GOODINITPLACEMENT = 2; // 1 = circularly, 2 = random placement
boolean GRAVITY = false; 
boolean SHOWHULLS = false;

Properties globalconf = new Properties();
Properties hypergraphconf = new Properties();
//class vertexconfigs{
//  color vertex_color = color(128,128,128);
//  color vertexlabel_color = color(255,0,0);
//  boolean vertex_fill = true;
//  boolean vertex_label = true;
//  int vertex_radius = 20;
//}

//class edgeconfigs{
//  color edge_color = color(0,0,0);
//  int edgestroke;
//}

void globalconfig(){
  //randomSeed(0);
  //hg = new GenerateHyperGraph().DemoHyperGraph();
  hg = new GenerateHyperGraph().RandomK_HyperGraph(500,50,3);
}

void graph_config(){
  if(globalconf.getProperty("initialplacement").equals("circular"))
     hg.circularinitialplacement = true;
   else
     hg.circularinitialplacement = false;
    
  hg.build_graph();
  graph_layout = new Fruch_Rein(window_width,window_height);
  
  if(globalconf.getProperty("canvas").equals("circular"))
    graph_layout.circularcanvas = true;
  else
    graph_layout.circularcanvas = false;
  
  String transform = globalconf.getProperty("transform");
  if(transform.equals("complete")){
    graph_layout.barycenter = false;
    if(graph_layout.circularcanvas) 
      hg.build_associatedgraph();
    else
      hg.build_associatedgraph(window_width,window_height);
  }
  if(transform.equals("star")){
    graph_layout.barycenter = true;
    if(graph_layout.circularcanvas) 
      hg.build_associatedspokegraph_bery();
    else
      hg.build_associatedspokegraph_bery(window_width,window_height);
  }
  if(transform.equals("circle")){
    graph_layout.barycenter = false;
    if(graph_layout.circularcanvas) 
      hg.build_associatedcirculargraph();
    else
      hg.build_associatedcirculargraph(window_width,window_height);
  }
  if(transform.equals("wheel")){
    graph_layout.barycenter = true;
    if(graph_layout.circularcanvas) 
       hg.build_associatedcirculargraph();
    else
      hg.build_associatedcirculargraph(window_width,window_height);
  }
  if(graph_layout.barycenter) globalconf.setProperty("barycenter","True");
  else globalconf.setProperty("barycenter","False");
  
  if(globalconf.getProperty("gravity").equals("true"))
    graph_layout.hasgravity = true;
  else
    graph_layout.hasgravity = false;
    
  graph_layout.sethypergraph(hg);
  graph_layout.setgraph();

}

void initial_config(){
   globalconf.setProperty("initialplacement",GOODINITPLACEMENT==1?"circular":"random");
   globalconf.setProperty("canvas",CIRCULARCANVAS==1?"circular":"rectangular");
   globalconf.setProperty("gravity",String.valueOf(GRAVITY));
}

void settings(){
  size(displayWidth-400, 640);
  randomSeed(0);
  window_width = displayWidth-400;
  window_height = 640;
  drawing_rad = min(window_height, window_width)/2;
  drawing_center = new PVector(window_width/2,window_height/2);
}

void setup() {
  cam = new PeasyCam(this, window_width/2,window_height/2,window_width/2,50);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(800);
  
 // hint(ENABLE_STROKE_PERSPECTIVE) ;
  
  surface.setLocation(400,0);
  colorMode(RGB);
  createGUI();
  initial_config();
  smooth(4);
  time = millis();
}


void mouseClicked() {
}

void draw() {
  if(STATE == SAVEAS){
    if(saveaspdf==1){
      beginRecord(PDF, pdffilename); 
    }
    
    if(saveaspdf==2){
      beginRecord(SVG, pdffilename); 
    }
  }
  if(STATE == DRAW || STATE == SAVEAS){
    translate(poi.x,poi.y);
    scale(zoom);
    Graph temporal_g;
     if(millis() - time >= 100){
       graph_layout.iterateonce();
       //GFR_graph_layout.iterateonce();
       time = millis();
     }
     if(mdsbasedhg){
     
     }
     else{
       if(edgebasedhg){
         if(drawhull){
           background(background_color);
           if(edscheme == 1)
             hg.drawEdgebased();
           if(edscheme == 2)
             hg.drawEdgebased_curveonly();
         }
         else{
           temporal_g = graph_layout.getgraph();
           temporal_g.drawgraph();
         }
       }
       else{
         if(drawhull){ 
              background(background_color);
             if(SHOWHULLS){ // SHow the hulls only
               hg.drawvertices();
               for(HyperEdge h:hg.hyperedges){
                 h.drawhulls();
               }
             }
             else // Show the contour drawing of the hypergraph
             {
                hg.draw(drawcontour);
             }
         }
         else{
           temporal_g = graph_layout.getgraph();
           //println(graph_layout.circularcanvas);
           //temporal_g = GFR_graph_layout.getgraph();
           //drawgraph(temporal_g);
           //temporal_g.project(i,j);
           temporal_g.drawgraph();
           
         }
       }
     }
  }
  if (STATE == SAVEAS) {
    endRecord();
    STATE = DRAW;
    saveaspdf = 0;
  }
}

void mouseDragged(){
  if (mouseX < 0 | mouseX >= width
    | mouseY < 0 | mouseY >= height)  return;
  poi.x = poi.x + (mouseX-pmouseX);
  poi.y = poi.y + (mouseY-pmouseY);
}
void mouseWheel(MouseEvent event) {
  float zoomdelta = 0.05;
  float e = event.getAmount();
  
  if(e>0)  zoom+=zoomdelta;
  if(e<0)  zoom-=zoomdelta;
}

void mouseMoved(){
 // clear();
  //text(str(mouseX)+","+str(mouseY),mouseX,mouseY);
}

void keyPressed(){
   if(key == '-')
     vertex_radius--;
  if(key == ' ')
    graph_layout.barycenter = !graph_layout.barycenter;
    
  if(key == 'r') // reset zoom
    zoom = 1;
    
  if(key == 't' || key == 'T'){
    drawcontour = true;
    hg.findcontour();
  }
  if(key == 'b' || key == 'B'){ // go back to assocated graph drawing from hypergraph drawing and vice versa
      drawhull = !drawhull;
      drawcontour = !drawcontour;
  }
   if(key == 'h' || key == 'H'){
     SHOWHULLS = !SHOWHULLS;
   }
   if(key == 'a' || key == 'A'){     
     //println("Concavity: "+a.getconcavity());
     //ai.add(a);
     
     //drawhull = false;
  //drawcontour = false;
     //hg = inputhg;
     //completegraph_config();
     int n = hg.getdim();
     if(i<n) 
       if(j<n) j = (j + 1)%n;
     println(i+" ",j);
   }
   if(key == 'c' || key == 'C'){

   }
   if(key == 'i' || key == 'I'){

     
   }
   if(key == 'e' || key == 'E'){

 
   }
   
   if(key== 'u' || key == 'U'){
      println(dataPath(""));
   }
   if(key == 'w' || key == 'W'){
    
   }
   
   if(key == 'g' || key == 'G')
     globalconfig();
   if(key == 's' || key == 'S'){
     
     REPR = 1;
      //if(compgraph.isSelected())
      //  completegraph_config();
      //else if(spgraph.isSelected())
      //  spokegraph_config();
      //else if(wheelgraph.isSelected())
      //  wheelgraph_config();
      //else if(circgraph.isSelected())
      //  circulargraph_config();
   // println("hi"+hg.associated_graph.vertices.get(0).pos.x);
    graph_config();
    drawhull = false;
    drawcontour = false;
    STATE = DRAW;
   }
   if(key == 'd' || key == 'D'){
     
     REPR = 2;
     graph_config();
    drawhull = false;
    drawcontour = false;
    STATE = DRAW;
   }
   if(key == 'q' || key == 'Q'){
    
   }
   if(key == 'm' || key == 'M'){
   }
}

void fileSelectedtoopen(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    hgreader = new ReadHyperGraph();
    inputhg = new HyperGraph();
    inputgraphfilename = selection.getAbsolutePath();
    inputhg = hgreader.readasedgelist(inputgraphfilename);
    //inputhg.assignedgecolors();
    edgebasedhg = false;
    STATE = 0;
  } 
}

void fileSelectedtosave(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    
      pdffilename = selection.getAbsolutePath();
    //}
    //else{ // create path to store the random graph in svg
    //  //String datapath = dataPath("");
    //  //String[] pathsplit = datapath.split("\\");
    //  //if(saveaspdf==2)
    //  //  pathsplit[pathsplit.length-1] = "randomhg_"+String.valueOf(randomhg.totaladdednodes)+"_"+String.valueOf(randomhg.p)+".svg";
    //  //else
    //  //  pathsplit[pathsplit.length-1] = "randomhg_"+String.valueOf(randomhg.totaladdednodes)+"_"+String.valueOf(randomhg.p)+".pdf";
    //  pdffilename = selection.getAbsolutePath();
    
    STATE = SAVEAS;
    
  } 
}
