import processing.serial.*;
Serial port;
float brightness = 0;

int interpolationScale = 16;

//low range of the sensor (this will be blue on the screen)
int MINTEMP = 28;

//high range of the sensor (this will be red on the screen)
int MAXTEMP = 34;



float avgTemp = 0;

float avgTempP;

int outputMetrixSize = 7*interpolationScale +1 ;

int pixelNo = outputMetrixSize;

int pixelsize = 500/outputMetrixSize;

String fulldata = "";
String partdata = "";
float[][] data = new float [8][8];
float[][] Matrix = new float [outputMetrixSize][outputMetrixSize];
PFont font;
int index = 0;


Pixel[][] pixels = new Pixel[outputMetrixSize][outputMetrixSize];
MovingAverage [][] MOfilter = new MovingAverage[8][8];

float[][] datatest = new float[][]{
  { 1, 2, 3, 4, 1, 2, 3, 4 },
  { 2, 5, 6, 8, 1, 2, 3, 4 },
  { 5, 10, 8, 7, 1, 2, 3, 4},
  { 7, 6, 4, 8, 1, 2, 3, 4},
  { 1, 2, 3, 4, 1, 2, 3, 4},
  { 2, 5, 6, 8, 1, 2, 3, 4},
  { 5, 10, 8, 7, 1, 2, 3, 4},
  { 7, 6, 4, 8, 1, 2, 3, 4}
};

CCInterpolator cci = new  CCInterpolator();



void settings() {  // can't call settings() after setup()
  size( 400+outputMetrixSize*pixelsize , outputMetrixSize*pixelsize );
}

void setup()
{
  //size(800,outputMetrixSize*pixelsize);
  port = new Serial(this, "COM3" , 115200);
  port.bufferUntil('N');
  font = loadFont("EuroStyleNormal-48.vlw");
  textFont(font,50);
  
  for (int y = 0; y < pixelNo; y++)
  {
     for (int x = 0; x < pixelNo; x++)
     {
       pixels[x][y] = new Pixel(x*pixelsize,y*pixelsize,pixelsize,50);
     }
  }
  
  for (int y = 0; y < 8; y++)
  {
     for (int x = 0; x < 8; x++)
     {
       MOfilter[x][y] = new MovingAverage(3);
     }
  }
  
  //cci.updateCoefficients (datatest);
  
  //print(cci.getValue(0.5,0.5));
  Matrix =cci.cubicInterpolate(datatest);
  for (int x = 0; x < 8*interpolationScale; x++)
  {
     for (int y = 0; y < 8*interpolationScale; y++)
     {
       cci.updateCoefficients(datatest);
       print(Matrix[x][y]);print(" , ");
     }
     print('\n');
  }
  
  
}

void draw()
{
  
  background(map(int(avgTempP), 25, MAXTEMP, 236, 0),86,97);
  for (int y = 0; y < pixelNo; y++)
  {
     for (int x = 0; x < pixelNo; x++)
     {
       pixels[x][y].display(Matrix[x][y]);
       
       //*******************************************************Show temp - uncomment************************************************
       /*fill(0,0,0);
       textFont(font,20/float(interpolationScale));
       text(int(Matrix[x][y]),x*pixelsize+10/float(interpolationScale),y*pixelsize+20/float(interpolationScale));*/
     }
  }
  fill(0,0,100);
  textFont(font,80);
  text("Avg.Temp: ",50+outputMetrixSize*pixelsize,100);
  textFont(font,100);
  text(int(avgTempP),50+outputMetrixSize*pixelsize,200);text(" C",150+outputMetrixSize*pixelsize,200);
  
  fill(0,0,0);
  textFont(font,30);
  text("Interpolation   Scale            x",50+outputMetrixSize*pixelsize,300);text(interpolationScale ,290+outputMetrixSize*pixelsize,300);
  text("MaxTemp  ",50+outputMetrixSize*pixelsize,360);text(MAXTEMP ,290+outputMetrixSize*pixelsize,360);
  text("MinTemp  ",50+outputMetrixSize*pixelsize,400);text(MINTEMP ,290+outputMetrixSize*pixelsize,400);
  //println('\n');
} 

void serialEvent( Serial port)
{
  fulldata = port.readStringUntil('N');
  fulldata = fulldata.substring(0, fulldata.length()-1); //fetch data array
  avgTemp = 0;
  for (int y = 0; y < 8; y++)
  {
     for (int x = 0; x < 8; x++)
     {
         //fetch each temp data
         index = fulldata.indexOf(',');
         partdata = fulldata.substring(0,index);
         data[x][y] = float(partdata);
         
         //data[x][y] = MOfilter[x][y].next(int(data[x][y]*1000))/1000.00;
         /*MAXTEMP = 35;
         MINTEMP = 26;
         if (data[x][y]>MAXTEMP)MAXTEMP = int(data[x][y]);
         else if (data[x][y]<MINTEMP)MINTEMP = int(data[x][y]);*/
         fulldata = fulldata.substring(index+1, fulldata.length());
         avgTemp += data[x][y];
     }
  }
  Matrix =cci.cubicInterpolate(data);
  avgTempP = avgTemp/64;
  
  
  /*for (int y = 0; y < 16; y++)
  {
     for (int x = 0; x < 16; x++)
     {
       //cci.updateCoefficients(datatest);
       print(Matrix[x][y]);print(" , ");
     }
     print('\n');
  }*/
}
