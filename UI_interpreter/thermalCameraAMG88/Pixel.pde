public class Pixel
{
   private int x;
   private int d;
   private int y;
   private float temp;
   //private int size;
   
   public Pixel(int x, int y, int d, float temp )
 {
   this.x = x;
   this.d = d;
   this.y = y;
   this.temp = temp;
   
   
 }
   public void display(float temp) 
   {
     this.temp = temp ;
     //float colorIndex = map((float)Math.log(temp), (float)Math.log(MINTEMP), (float)Math.log(MAXTEMP), 270, 0);
     float colorIndex = map(temp, MINTEMP, MAXTEMP, 236, 0);
     colorIndex = constrain(colorIndex, 0, 236);
       
     colorMode(HSB,360,100,100);
     fill(colorIndex,86,97);
     rect(x,y,d,d); 
     
   }
   
   public void setd(int d) 
   {
     this.d = d; 
   }
   
   
   public int getd()
   {
     return d;
   }
   
   
   public int getx()
   {
     return x;
   }
   
   public int gety()
   {
     return y;
   }
 
}
