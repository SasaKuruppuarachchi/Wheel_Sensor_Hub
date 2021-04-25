public class CCInterpolator
{
  private float a00, a01, a02, a03;
  private float a10, a11, a12, a13;
  private float a20, a21, a22, a23;
  private float a30, a31, a32, a33;
  private float[][][][] subMatrix = new float [8][8][4][4];
  private float[][] Matrix = new float [8*interpolationScale][8*interpolationScale];

  public void updateCoefficients (float[][] p) {
    a00 = p[1][1];
    a01 = -0.5*p[1][0] + 0.5*p[1][2];
    a02 = p[1][0] - 2.5*p[1][1] + 2*p[1][2] - 0.5*p[1][3];
    a03 = -0.5*p[1][0] + 1.5*p[1][1] - 1.5*p[1][2] + 0.5*p[1][3];
    a10 = -0.5*p[0][1] + 0.5*p[2][1];
    a11 = 0.25*p[0][0] - 0.25*p[0][2] - 0.25*p[2][0] + 0.25*p[2][2];
    a12 = -0.5*p[0][0] + 1.25*p[0][1] - p[0][2] + 0.25*p[0][3] + 0.5*p[2][0] - 1.25*p[2][1] + p[2][2] - 0.25*p[2][3];
    a13 = 0.25*p[0][0] - 0.75*p[0][1] + 0.75*p[0][2] - 0.25*p[0][3] - 0.25*p[2][0] + 0.75*p[2][1] - 0.75*p[2][2] + 0.25*p[2][3];
    a20 = p[0][1] - 2.5*p[1][1] + 2*p[2][1] - 0.5*p[3][1];
    a21 = -0.5*p[0][0] + 0.5*p[0][2] + 1.25*p[1][0] - 1.25*p[1][2] - p[2][0] + p[2][2] + 0.25*p[3][0] - 0.25*p[3][2];
    a22 = p[0][0] - 2.5*p[0][1] + 2*p[0][2] - 0.5*p[0][3] - 2.5*p[1][0] + 6.25*p[1][1] - 5*p[1][2] + 1.25*p[1][3] + 2*p[2][0] - 5*p[2][1] + 4*p[2][2] - p[2][3] - 0.5*p[3][0] + 1.25*p[3][1] - p[3][2] + .25*p[3][3];
    a23 = -.5*p[0][0] + 1.5*p[0][1] - 1.5*p[0][2] + .5*p[0][3] + 1.25*p[1][0] - 3.75*p[1][1] + 3.75*p[1][2] - 1.25*p[1][3] - p[2][0] + 3*p[2][1] - 3*p[2][2] + p[2][3] + .25*p[3][0] - .75*p[3][1] + .75*p[3][2] - .25*p[3][3];
    a30 = -.5*p[0][1] + 1.5*p[1][1] - 1.5*p[2][1] + .5*p[3][1];
    a31 = .25*p[0][0] - .25*p[0][2] - .75*p[1][0] + .75*p[1][2] + .75*p[2][0] - .75*p[2][2] - .25*p[3][0] + .25*p[3][2];
    a32 = -.5*p[0][0] + 1.25*p[0][1] - p[0][2] + .25*p[0][3] + 1.5*p[1][0] - 3.75*p[1][1] + 3*p[1][2] - .75*p[1][3] - 1.5*p[2][0] + 3.75*p[2][1] - 3*p[2][2] + .75*p[2][3] + .5*p[3][0] - 1.25*p[3][1] + p[3][2] - .25*p[3][3];
    a33 = .25*p[0][0] - .75*p[0][1] + .75*p[0][2] - .25*p[0][3] - .75*p[1][0] + 2.25*p[1][1] - 2.25*p[1][2] + .75*p[1][3] + .75*p[2][0] - 2.25*p[2][1] + 2.25*p[2][2] - .75*p[2][3] - .25*p[3][0] + .75*p[3][1] - .75*p[3][2] + .25*p[3][3];
  }

  public float getValue (float x, float y) {
    float x2 = x * x;
    float x3 = x2 * x;
    float y2 = y * y;
    float y3 = y2 * y;

    return (a00 + a01 * y + a02 * y2 + a03 * y3) +
           (a10 + a11 * y + a12 * y2 + a13 * y3) * x +
           (a20 + a21 * y + a22 * y2 + a23 * y3) * x2 +
           (a30 + a31 * y + a32 * y2 + a33 * y3) * x3;
  }
  
  public float[][] cubicInterpolate (float[][] data)
  {
    float frac = 1/float(interpolationScale);
    for (int j = 0; j < 8; j++)
    {
      for (int i = 0; i < 8; i++)
      {
        for (int y = 0; y < 4; y++)
        {
          for (int x = 0; x < 4; x++)
          {
            if (x+i-1<0 && y+j-1<0) subMatrix[i][j][x][y] = data[0][0];//
            else if (x+i-1<0 && y+j-1>7) subMatrix[i][j][x][y] = data[7][0];
            else if (x+i-1>7 && y+j-1<0) subMatrix[i][j][x][y] = data[0][7];
            else if (x+i-1>7 && y+j-1>7) subMatrix[i][j][x][y] = data[7][7];
            else if (x+i-1<0) subMatrix[i][j][x][y] = data[0][y+j-1];//
            else if (y+j-1<0) subMatrix[i][j][x][y] = data[x+i-1][0];//
            else if (x+i-1>7) subMatrix[i][j][x][y] = data[7][y+j-1];
            else if (y+j-1>7) subMatrix[i][j][x][y] = data[x+i-1][7];
            else subMatrix[i][j][x][y] = data[x+i-1][y+j-1];
          }  
        }
        //SubMatrix created
        updateCoefficients (subMatrix[i][j]);
        //import values to the final matrix
        for (int n = 0; n < interpolationScale; n++)
        {  
          for (int m = 0; m < interpolationScale; m++)
          {  
          
          Matrix[i*interpolationScale+m][j*interpolationScale+n] = getValue(frac *m, frac *n);
          }
        }
      }
    }
    return Matrix;
  }
  
  
  
 
}
