import java.util.BitSet;
import java.util.ArrayList;
import java.util.stream.IntStream;


class RandomHypergraph extends HyperGraph{
  float p; //probability
  int numvert;
  ArrayList <BitSet> hypedges_bitset = new ArrayList();
  RandomHypergraph(){}
  RandomHypergraph(int N,float p){
      super();
      numvert = N;
      this.p = p;
  }
  public void generate_baseline(){
    
  }
  public void generate(){
      // Create an empty hypergraph with numvert vertices
      //for(int i = 0; i<numvert; i++)
      //  this.addvertex(i);
      
      Random rand = new Random();
      BitSet Xi = new BitSet(numvert+1); // initially Xi is [0,n-1] all 0's
      BitSet one = new BitSet(numvert+1);
      one.set(0,numvert); // a bit set of n 1's i.e [0,n-1] all 1's
      BitSet Xnext = new BitSet(numvert+1);
      do{
        float u = rand.nextFloat();
        int s = 1 + ceil(log(1-u)/log(1-this.p) - 1);
        
        BitSet s_inbinary = new BitSet(numvert+1);
        //BitSet t = BitSet.valueOf(new long[]{s});
        //for(int m = 0; m<numvert; m++)
        //  if(m<t.length())
        //    s_inbinary.set(m,t.get(m));
        //  else
        //    s_inbinary.set(m,false);
        
        s_inbinary = BitSet.valueOf(new long[]{s});
        //println("geometric dist: ",s, " binray: ",BitSettoString(s_inbinary));
        Xnext = (BitSet)Xi.clone();  
        Xnext = addbitset(Xnext,s_inbinary,numvert); // next hyperedge to add
        if(compare(Xnext,one)>=0){ // if Xnext<=one
          addEdge(Xnext); // add hyperedge
          println("addition", BitSettoString(Xnext));
        }
        Xi = (BitSet)Xnext.clone();
        //V.or(Xnext); 
      }while(Xnext.cardinality()<numvert); // when Xnext<one
      println("done generating hypergraph: |V| = ",this.totaladdednodes, " |E| = ",this.totaladdedhypedges);
  }
  
  void generate_hypedge_bitset(){
      Random rand = new Random();
      BitSet Xi = new BitSet(numvert+1); // initially Xi is [0,n-1] all 0's
      BitSet one = new BitSet(numvert+1);
      one.set(0,numvert); // a bit set of n 1's i.e [0,n-1] all 1's
      BitSet Xnext = new BitSet(numvert+1);
      do{
        float u = rand.nextFloat();
        int s = 1 + ceil(log(1-u)/log(1-this.p) - 1);
        
        BitSet s_inbinary = new BitSet(numvert+1);
        //BitSet t = BitSet.valueOf(new long[]{s});
        //for(int m = 0; m<numvert; m++)
        //  if(m<t.length())
        //    s_inbinary.set(m,t.get(m));
        //  else
        //    s_inbinary.set(m,false);
        
        s_inbinary = BitSet.valueOf(new long[]{s});
        //println("geometric dist: ",s, " binray: ",BitSettoString(s_inbinary));
        Xnext = (BitSet)Xi.clone();  
        Xnext = addbitset(Xnext,s_inbinary,numvert); // next hyperedge to add
        if(compare(Xnext,one)>=0){ // if Xnext<=one
          /*
            Instead of storing hyperedges as set of labels,store them as bitset
          */
          hypedges_bitset.add(Xnext); 
          //println("addition", BitSettoString(Xnext));
        }
        Xi = (BitSet)Xnext.clone();
        //V.or(Xnext); 
      }while(compare(Xnext,one)>0); // when Xnext<one
  }
  void addEdge(BitSet X){
    int idx = 0;
    ArrayList <Integer> hyperedg = new ArrayList(); 
    for(;idx<numvert;idx++)
      if(X.get(idx) == true)
        hyperedg.add(idx);
    //println(hyperedg);
    addhyperedge(hyperedg.toArray(new Integer[hyperedg.size()]));
  }
  BitSet addbitset(BitSet a,BitSet b,int len){
        boolean lastcarry = false;
        BitSet sum = new BitSet(len+1);
        int i;
        //println("len: ",len);
        for(i = 0; i<len; i++){
            sum.set(i, lastcarry ^ a.get(i) ^ b.get(i));
            lastcarry = (a.get(i) && b.get(i)) || (lastcarry && (a.get(i) ^ b.get(i))) ; 
        }
        sum.set(i, lastcarry);
        //println(BitSettoString(a)," + ",BitSettoString(b)+" = ",BitSettoString(sum));
        return sum;
  }
  int compare(BitSet lhs, BitSet rhs) {
    // 1 if lhs<rhs, -1 if lhs>rhs, 0 if equal
    if (lhs.equals(rhs)) return 0;
    BitSet xor = (BitSet)lhs.clone();
    xor.xor(rhs);
    int firstDifferent = xor.length()-1;
    if(firstDifferent==-1)
            return 0;

    return rhs.get(firstDifferent) ? 1 : -1;
}
  String BitSettoString(BitSet B){
        StringBuilder s = new StringBuilder();
            for( int i = B.length(); i >-1;  i-- )
            {
                s.append( B.get( i ) == true ? 1: 0 );
            }
        return s.toString();
  }
}