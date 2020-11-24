/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

synchronized public void conf_draw(PApplet appc, GWinData data) { //_CODE_:configwin:619524:
  appc.background(230);
} //_CODE_:configwin:619524:

public void openbtn_click(GButton source, GEvent event) { //_CODE_:openbtn:765289:
  selectInput("Select a file to process:", "fileSelectedtoopen");
  } //_CODE_:openbtn:765289:

public void saveasbtn_click(GButton source, GEvent event) { //_CODE_:saveasbtn:763760:
  //println("saveasbtn - GButton >> GEvent." + event + " @ " + millis());
    
   selectOutput("Name of the svg file:", "fileSelectedtosave");
   saveaspdf = 2; 
    
} //_CODE_:saveasbtn:763760:

public void compgraph_clicked(GOption source, GEvent event) { //_CODE_:compgraph:267923:

  //drawhull = false;
  //drawcontour = false;
  //hg = new HyperGraph();
  //hg = inputhg;
  //completegraph_config();
  
} //_CODE_:compgraph:267923:

public void circgraph_click(GOption source, GEvent event) { //_CODE_:circgraph:720602:

  //drawhull = false;
  //drawcontour = false;
  //hg = new HyperGraph();
  //hg = inputhg;
  //circulargraph_config();
  
} //_CODE_:circgraph:720602:

public void spgraph_click(GOption source, GEvent event) { //_CODE_:spgraph:860650:

  //drawhull = false;
  //drawcontour = false;
  //hg = new HyperGraph();
  //hg = inputhg;
  //spokegraph_config();
} //_CODE_:spgraph:860650:

public void wheelgraph_click(GOption source, GEvent event) { //_CODE_:wheelgraph:574825:

  //drawhull = false;
  //drawcontour = false;
  //hg = new HyperGraph();
  //hg = inputhg;
  // wheelgraph_config();
} //_CODE_:wheelgraph:574825:

public void drawhg_click(GButton source, GEvent event) { //_CODE_:drawhg:212630:
 // if(drawcontour) return; // do not draw an already drawn hyperedge 
  println("assigning colors");
  //while(true){
  //  if(hg.computeconvexhulls() == false) // there are bad hulls
  //  {
  //      println("bad hulls");
  //      graph_layout.sethypergraph(hg);
  //      graph_layout.setgraph();
  //      graph_layout.iteration = 0;
  //      graph_layout.maxiter = 100;
  //      graph_layout.g.init();
  //      graph_layout.iterateonce();
  //      time = millis();
  //      drawhull = false;
  //      drawcontour = false;
  //      STATE = DRAW; 
        
  //  }
  //  else
  //    break;
  //}
  hg.computeconvexhulls();
  hg.findcontour();
  hg.assignedgecolors();
  drawhull = true;
  drawcontour = true;
  edgebasedhg = false;
  //hg.draw(drawcontour);
} //_CODE_:drawhg:212630:

public void drawgraphrep_click(GButton source, GEvent event) { //_CODE_:drawgraphrep:682259:
  //hg = new HyperGraph(inputhg); // use copy constructor coz circular graph layout may change the ordering of the vertices in the hyperedges;
  REPR = 1;
  globalconf.setProperty("algorithm","FR");
   hg = inputhg;
  if(compgraph.isSelected())
    globalconf.setProperty("transform","complete");
  else if(spgraph.isSelected())
    globalconf.setProperty("transform","star");
  else if(wheelgraph.isSelected())
    globalconf.setProperty("transform","wheel");
  else if(circgraph.isSelected())
    globalconf.setProperty("transform","circle");
  //println("hi"+hg.associated_graph.vertices.get(0).pos.x);
  graph_config();
  drawhull = false;
  drawcontour = false;
  STATE = DRAW;
} //_CODE_:drawgraphrep:682259:

public void saveaspdfbtn_click(GButton source, GEvent event) { //_CODE_:saveaspdfbtn:973486:
  
  selectOutput("Name your pdf file:", "fileSelectedtosave");
  saveaspdf = 1;
} //_CODE_:saveaspdfbtn:973486:

public void vertexlbl_clicked(GCheckbox source, GEvent event) { //_CODE_:vertexlbl:511894:
  vertex_label = !vertex_label;
} //_CODE_:vertexlbl:511894:

public void Eades_click(GButton source, GEvent event) { //_CODE_:Eades:281487:
  REPR = 2;
  globalconf.setProperty("algorithm","Eades");
  hg = inputhg;
   if(compgraph.isSelected())
    globalconf.setProperty("transform","complete");
  else if(spgraph.isSelected())
    globalconf.setProperty("transform","star");
  else if(wheelgraph.isSelected())
    globalconf.setProperty("transform","wheel");
  else if(circgraph.isSelected())
    globalconf.setProperty("transform","circle");
    
    graph_config();
  drawhull = false;
  drawcontour = false;
  STATE = DRAW;
} //_CODE_:Eades:281487:

public void initial_placement_click(GCheckbox source, GEvent event) { //_CODE_:initial_placement:589367:
  GOODINITPLACEMENT = GOODINITPLACEMENT == 2?1:2;
  globalconf.setProperty("initialplacement",GOODINITPLACEMENT==1?"circular":"random");
 
} //_CODE_:initial_placement:589367:

public void drawingcanvas_clicked(GCheckbox source, GEvent event) { //_CODE_:drawingcanvas:803163:
  CIRCULARCANVAS = CIRCULARCANVAS == 2?1:2; 
  globalconf.setProperty("canvas",CIRCULARCANVAS==1?"circular":"rectangular");
 
} //_CODE_:drawingcanvas:803163:

public void GravityForce_clicked(GCheckbox source, GEvent event) { //_CODE_:GravityForce:231870:
  GRAVITY = !GRAVITY;
  globalconf.setProperty("gravity",String.valueOf(GRAVITY));
} //_CODE_:GravityForce:231870:

//public void dropList_click(GDropList source, GEvent event) { //_CODE_:modedrdownlst:440705:
//  println("modedrdownlst - GDropList >> GEvent." + event + " @ " + millis());
//  rendering_mode = source.getSelectedIndex ();
//  globalconf.setProperty("mode",rendering_mode==0?"2D":"3D");
//} //_CODE_:modedrdownlst:440705:

//public void genrandhg_click(GButton source, GEvent event) { //_CODE_:Genrandhg:278933:
//  probab = probtxtfield.getText();
//  randomhg = new RandomHypergraph((int)numvslider.getValueF(),Float.valueOf(probab));
//  randomhg.generate();
//  graphtype = 0;
//} //_CODE_:Genrandhg:278933:

public void numvslider_change(GSlider source, GEvent event) { //_CODE_:numvslider:550830:
  vertex_radius = (int)vradslider.getValueF();
} //_CODE_:numvslider:550830:

//public void probtxtfield_changed(GTextField source, GEvent event) { //_CODE_:probtxtfield:420286:
  
//  hype_txtfield.setText(String.valueOf( (Math.pow(2,(int)numvslider.getValueF())-1)*Double.valueOf(source.getText())));
//} //_CODE_:probtxtfield:420286:

//public void hype_txtfield_changed(GTextField source, GEvent event) { //_CODE_:hype_txtfield:609727:
//  //println("hype_txtfield - GTextField >> GEvent." + event + " @ " + millis());
//  println("possible edges: ",Math.pow(2,(int)numvslider.getValueF())-1);
//  println( (Math.pow(2,(int)numvslider.getValueF()) - 1)*Double.valueOf(probtxtfield.getText()));
//} //_CODE_:hype_txtfield:609727:

//public void randasc_clicked(GButton source, GEvent event) { //_CODE_:randasc:822481:
//  probab = probtxtfield.getText();
//  randomasc = new RandomASC((int)numvslider.getValueF(),Float.valueOf(probab));
//  randomasc.generaterandomasc_test();
//  graphtype = 2;
//} //_CODE_:randasc:822481:

//public void btn_hgdrawedge(GButton source, GEvent event) { //_CODE_:hgdraw_edge:746527:
//  globalconf.setProperty("transform","complete");
//  globalconf.setProperty("algorithm","FR");
//  REPR = 1;
//  //REPR = 2;
//  //globalconf.setProperty("algorithm","Eades");
//  hg = graphtype == 1?inputhg:randomhg;
//  if(graphtype == 1)
//    hg = inputhg;
//  else if(graphtype == 0)
//    hg = randomhg;
//  else
//    hg = randomasc;
//  globalconf.setProperty("initialplacement","circular");
//  graph_config();
//  STATE = DRAW;
//  drawcontour = false;
//} //_CODE_:hgdraw_edge:746527:

public void edscheme1_click(GButton source, GEvent event) { //_CODE_:edscheme1:250781:
  drawhull = true;
  SHOWHULLS = false;
  edgebasedhg = true;
  edscheme = 1;
  hg.assignedgecolors();
} //_CODE_:edscheme1:250781:

public void edscheme2_click(GButton source, GEvent event) { //_CODE_:edschem2:825895:
  drawhull = true;
  SHOWHULLS = false;
  edgebasedhg = true;
  edscheme = 2;
  hg.assignedgecolors();
  
} //_CODE_:edschem2:825895:

//public void mds_draw_btn_clk(GButton source, GEvent event) { //_CODE_:mds_draw_btn:789740:
//  println("mds_draw_btn - GButton >> GEvent." + event + " @ " + millis());
//} //_CODE_:mds_draw_btn:789740:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setCursor(ARROW);
  surface.setTitle("Sketch Window");
  configwin = GWindow.getWindow(this, "Configuration Panel", 0, 0, 400, 640, JAVA2D);
  configwin.noLoop();
  configwin.setActionOnClose(G4P.EXIT_APP);
  configwin.addDrawHandler(this, "conf_draw");
  openbtn = new GButton(configwin, 11, 10, 100, 30);
  openbtn.setText("Load dataset");
  openbtn.setTextBold();
  openbtn.addEventHandler(this, "openbtn_click");
  saveasbtn = new GButton(configwin, 170, 10, 80, 30);
  saveasbtn.setText("Save as svg");
  saveasbtn.setTextBold();
  saveasbtn.addEventHandler(this, "saveasbtn_click");
  saveaspdfbtn = new GButton(configwin, 289, 10, 80, 30);
  saveaspdfbtn.setText("Save as pdf");
  saveaspdfbtn.setTextBold();
  saveaspdfbtn.addEventHandler(this, "saveaspdfbtn_click");
  togGroup1 = new GToggleGroup();
  compgraph = new GOption(configwin, 3, 165+50, 228, 35);
  compgraph.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  compgraph.setText("Complete Graph");
  compgraph.setTextBold();
  compgraph.setOpaque(false);
  compgraph.addEventHandler(this, "compgraph_clicked");
  circgraph = new GOption(configwin, 3, 240+50, 223, 27);
  circgraph.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  circgraph.setText("Circular Graph");
  circgraph.setTextBold();
  circgraph.setOpaque(false);
  circgraph.addEventHandler(this, "circgraph_click");
  spgraph = new GOption(configwin, 3, 206+50, 226, 29);
  spgraph.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  spgraph.setText("Spoke Graph");
  spgraph.setTextBold();
  spgraph.setOpaque(false);
  spgraph.addEventHandler(this, "spgraph_click");
  wheelgraph = new GOption(configwin, 2, 270+50, 226, 29);
  wheelgraph.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  wheelgraph.setText("Wheel Graph");
  wheelgraph.setTextBold();
  wheelgraph.setOpaque(false);
  wheelgraph.addEventHandler(this, "wheelgraph_click");
  togGroup1.addControl(compgraph);
  compgraph.setSelected(true);
  togGroup1.addControl(circgraph);
  togGroup1.addControl(spgraph);
  togGroup1.addControl(wheelgraph);
  drawgraphrep = new GButton(configwin, 40, 395+50, 130, 30);
  drawgraphrep.setText("Fruchterman-Reingold");
  drawgraphrep.setTextBold();
  drawgraphrep.addEventHandler(this, "drawgraphrep_click");
  vertexlbl = new GCheckbox(configwin, 7, 19+50, 120, 20);
  vertexlbl.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  vertexlbl.setText("Vertex Label");
  vertexlbl.setTextBold();
  vertexlbl.setOpaque(false);
  vertexlbl.addEventHandler(this, "vertexlbl_clicked");
  Eades = new GButton(configwin, 190, 395+50, 114, 30);
  Eades.setText("Eades algorithm");
  Eades.setTextBold();
  Eades.addEventHandler(this, "Eades_click");
  initial_placement = new GCheckbox(configwin, 8, 49+50, 198, 25);
  initial_placement.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  initial_placement.setText("Circular hyperedge placement");
  initial_placement.setTextBold();
  initial_placement.setOpaque(false);
  initial_placement.addEventHandler(this, "initial_placement_click");
  drawingcanvas = new GCheckbox(configwin, 7, 85+50, 200, 22);
  drawingcanvas.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  drawingcanvas.setText("Circular Drawing Canvas");
  drawingcanvas.setTextBold();
  drawingcanvas.setOpaque(false);
  drawingcanvas.addEventHandler(this, "drawingcanvas_clicked");
  GravityForce = new GCheckbox(configwin, 6, 118+50, 200, 24);
  GravityForce.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  GravityForce.setText("Extra Gravity Force");
  GravityForce.setTextBold();
  GravityForce.setOpaque(false);
  GravityForce.addEventHandler(this, "GravityForce_clicked");
  //modedrdownlst = new GDropList(configwin, 220, 17, 90, 60, 2);
  //modedrdownlst.setItems(loadStrings("list_440705"), 0);
  //modedrdownlst.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  //modedrdownlst.addEventHandler(this, "dropList_click");
  //Genrandhg = new GButton(configwin, 38, 493, 157, 50);
  //Genrandhg.setText("Generate Random Hypergraph");
  //Genrandhg.addEventHandler(this, "genrandhg_click");
  label1 = new GLabel(configwin, 100, 5+50, 179, 23);
  label1.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label1.setText("1. Set drawing parameters");
  label1.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  label1.setOpaque(false);
  label2 = new GLabel(configwin, 85, 370+50, 215, 23);
  label2.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label2.setText("2. Draw Associated Graph ");
  label2.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  label2.setOpaque(false);
  //prob = new GLabel(configwin, 28, 371, 106, 26);
  //prob.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  //prob.setText("Probability:");
  //prob.setOpaque(false);
  //numv = new GLabel(configwin, 23, 417, 106, 23);
  //numv.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  //numv.setText("Number of Vertices");
  //numv.setOpaque(false);
  label5 = new GLabel(configwin, 10, 328+50, 100, 26);
  label5.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label5.setText("Vertex Radius: ");
  label5.setOpaque(false);
  vradslider = new GSlider(configwin, 140, 320+50, 240, 41, 10.0);
  vradslider.setShowValue(true);
  vradslider.setShowLimits(true);
  vradslider.setLimits(vertex_radius, 5, 20);
  vradslider.setNumberFormat(G4P.INTEGER, 0);
  //vradslider.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  vradslider.setOpaque(false);
  vradslider.addEventHandler(this, "numvslider_change");
  label3 = new GLabel(configwin, 100, 455+50, 206, 26);
  label3.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label3.setText("3. Draw Hypergraph");
  label3.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  label3.setOpaque(false);
  //label4 = new GLabel(configwin, 80, 560, 206, 26);
  //label4.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  //label4.setText("Load/Save");
  //label4.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  //label4.setOpaque(false);
  //probtxtfield = new GTextField(configwin, 151, 370, 160, 30, G4P.SCROLLBARS_NONE);
  //probtxtfield.setText("0.01");
  //probtxtfield.setOpaque(true);
  //probtxtfield.addEventHandler(this, "probtxtfield_changed");
  //hype_txtfield = new GTextField(configwin, 150, 458, 160, 30, G4P.SCROLLBARS_NONE);
  //hype_txtfield.setOpaque(true);
  //hype_txtfield.addEventHandler(this, "hype_txtfield_changed");
  //randasc = new GButton(configwin, 212, 495, 143, 26);
  //randasc.setText("Gen. Rand. ASC");
  //randasc.addEventHandler(this, "randasc_clicked");
  //hgdraw_edge = new GButton(configwin, 258, 190, 140, 30);
  //hgdraw_edge.setText("EdgeBasedDraw-Stage1");
  //hgdraw_edge.setTextBold();
  //hgdraw_edge.addEventHandler(this, "btn_hgdrawedge");
  drawhg = new GButton(configwin, 5, 485+50, 100, 30);
  drawhg.setText("Subset-based");
  drawhg.setTextBold();
  drawhg.setLocalColorScheme(GCScheme.RED_SCHEME);
  drawhg.addEventHandler(this, "drawhg_click");
  edscheme1 = new GButton(configwin, 120, 485+50, 130, 32);
  edscheme1.setText("Zykov");
  edscheme1.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  edscheme1.addEventHandler(this, "edscheme1_click");
  edschem2 = new GButton(configwin, 265, 485+50, 134, 32);
  edschem2.setText("Edge-based");
  edschem2.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  edschem2.addEventHandler(this, "edscheme2_click");
  //mds_draw_btn = new GButton(configwin, 308, 325, 80, 35);
  //mds_draw_btn.setText("MDS Draw");
  //mds_draw_btn.setTextBold();
  //mds_draw_btn.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  //mds_draw_btn.addEventHandler(this, "mds_draw_btn_clk");
  configwin.loop();
}

// Variable declarations 
// autogenerated do not edit
GWindow configwin;
GButton openbtn; 
GButton saveasbtn; 
GToggleGroup togGroup1; 
GOption compgraph; 
GOption circgraph; 
GOption spgraph; 
GOption wheelgraph; 
GButton drawhg; 
GButton drawgraphrep; 
GButton saveaspdfbtn; 
GCheckbox vertexlbl; 
GButton Eades; 
GCheckbox initial_placement; 
GCheckbox drawingcanvas; 
GCheckbox GravityForce; 
//GDropList modedrdownlst; 
//GButton Genrandhg; 
GLabel label1; 
GLabel label2; 
//GLabel prob; 
//GLabel numv; 
GSlider vradslider; 
GLabel label3; 
//GLabel label4; 
GLabel label5; 
//GTextField probtxtfield; 
//GTextField hype_txtfield; 
//GButton randasc; 
//GButton hgdraw_edge; 
GButton edscheme1; 
GButton edschem2; 
//GButton mds_draw_btn; 
