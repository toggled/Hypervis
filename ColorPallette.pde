import java.util.Iterator;

class RandomColorGenerator{
  
  class Color{
    int R,G,B;
    int initR,initG,initB;
    PVector displacement;
    int id; // id to differentiate colors even if they result in same because of the simulation of forces
    int alpha = 128;
    Color(int R,int G,int B){this.R = R; this.G = G; this.B = B;
      initR = R;initG = G;initB = B;
    }
    Color(float R,float G,float B){this.R = int(R); this.G = int(G); this.B = int(B);
      initR = int(R);initG = int(G);initB = int(B);
    }
    color getvalue(){
      return color(R,G,B,alpha);
    }
    PVector getvector(){
      return new PVector(R,G,B);
    }
    void update(){
      
      this.R = (this.R + (int)displacement.x)>255?255:(this.R + (int)displacement.x);
      this.R = this.R<0?0:this.R;
      this.G = (this.G + (int)displacement.y)>255?255:(this.G + (int)displacement.y);
      this.G = this.G<0?0:this.G;
      this.B = (this.B + (int)displacement.z)>255?255:(this.B + (int)displacement.z);
      this.B = this.B<0?0:this.B;
    }

  }
  
  ArrayList <Color> colorlist = new ArrayList<Color>();
  Iterator <Color> it;// iterator of colorlist
  int TOTAL;
  int iteration_param;
  
  RandomColorGenerator(int howmany){
    TOTAL = howmany;
    //initialize colors randomly
    for(int i = 0; i< TOTAL; i++){
       Color randomcolor;
       int r = int(random(255));
       int g = int(random(255));
       int b = int(random(255));
       randomcolor = new Color(r,g,b);
       randomcolor.id = i;
       colorlist.add(randomcolor);
    }
    if(TOTAL<200)
      iteration_param = TOTAL*15;
    else
      iteration_param = 200*10; // if so many colors are required (more than available in color space) there is no point in iterating more
      
    it = colorlist.iterator(); 
  }
  
  float distance(Color a, Color b){
    return abs(a.R-b.R)+abs(a.G-b.G)+abs(a.B-b.B);
  }
  
  PVector difference(Color a, Color b){
    // return a-b
    return PVector.sub(a.getvector(),b.getvector());
  }

  void forcebasedcolor(){  
    int constantK = 2;
    for(int iteration = 0; iteration < iteration_param; iteration++){
        for(Color a:colorlist){
          PVector displacement = new PVector(0,0,0);
          for(Color b:colorlist){
           // println("pow: "+pow(distance(a,b),3));
            float repulsiveforcex = (constantK*difference(a,b).x) / pow(distance(a,b),1);
            float repulsiveforcey = (constantK*difference(a,b).y) / pow(distance(a,b),1);
            float repulsiveforcez = (constantK*difference(a,b).z) / pow(distance(a,b),1);
            displacement.add(new PVector(repulsiveforcex,repulsiveforcey,repulsiveforcez));
          }
          a.displacement = displacement;
          //println("before: "+a.R+" "+a.G+" "+a.B);
          //println(displacement);
          a.update();
          //println("after: "+a.R+" "+a.G+" "+a.B);
        }
    }
  }
  color nextcolor(){
    Color toreturn = it.next();
    Color white = new Color(255,255,255);
    if(distance(toreturn,white) == 0){ // we dont want white coz of white background
      int red = int(random(TOTAL));
      int green = int(random(TOTAL));
      int blue = int(random(TOTAL));
      
      toreturn = new Color( red(colorlist.get(red).getvalue()), green(colorlist.get(green).getvalue()),blue(colorlist.get(blue).getvalue())); 
    }
    return toreturn.getvalue();
  }
}