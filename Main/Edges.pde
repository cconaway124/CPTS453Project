public class Edge {
 
  public Vertex start;
  public Vertex end;
  public Vertex midpoint;
  public float centerX;
  public float centerY;
  public float radius;
  public color edgeColor = colors.WHITE();;
  
  public Edge() {}
  
  public Edge (Vertex start, Vertex end) {
     this.start = start;
     this.end = end;
     setMidpoint();
  }
  
  public void setColor(color edgeColor) {
    this.edgeColor = edgeColor;
  }

  public void setStartPoint(Vertex start) {
    this.start = start;
  }
  
  public void setEndPoint(Vertex end) {
     this.end = end;
  }

  public void setMidpoint() {
   Point mid = getMidPoint(start.posX, start.posY, end.posX, end.posY);
   float x3dir = -(end.posY - start.posY);
   float y3dir = mid.x;
   float magnitude = sqrt(x3dir * x3dir + y3dir * y3dir);
   x3dir /= magnitude;
   y3dir /= magnitude;
   
   float midpointDist = distance(start.posX, start.posY, end.posX, end.posY) / 10;
   x3dir *= midpointDist;
   y3dir *= midpointDist;
   this.midpoint = new Vertex((int)(mid.x + x3dir), (int)(mid.y + y3dir));
   if (noNull()) {
     if (!this.isLoop())
      findCircle(start.posX, start.posY, midpoint.posX, midpoint.posY, end.posX, end.posY);
     else
       findCircle(start.posX + 100, start.posY, midpoint.posX, midpoint.posY, end.posX, end.posY);
   }
  }
  
public void setMidpoint(int x, int y) {   
   this.midpoint = new Vertex((int)(x), (int)(y));
   if (noNull()) {
      if (!this.isLoop())
      findCircle(start.posX, start.posY, midpoint.posX, midpoint.posY, end.posX, end.posY);
     else
       findCircle(start.posX + 100, start.posY, midpoint.posX, midpoint.posY, end.posX, end.posY);
   }
  }
  
  public boolean noNull() {
    return !(start == null|| end == null); 
  }
  
  public void setCircle(float centerX, float centerY, float radius) {
    this.centerX = centerX;
    this.centerY = centerY;
    this.radius = radius;
  }
  
  public boolean contains(Vertex target) {
     return start.equals(target) || end.equals(target); 
  }

  public Vertex getOtherVertex(Vertex target) {
    if (start.equals(target)) {
      return end;
    } else if (end.equals(target)) {
      return start;
    } else {
      return null;
    }
  }
  
  // gets the angle of the line from horizontal, requires trig
// x1, y1 is the first point and x2 y2 is the second but we can get a vector from them
public void findCircle(float x1, float y1, float x2, float y2, float x3, float y3) {
   float x12 = x1 - x2;
   float x13 = x1 - x3;
   
   float y12 = y1 - y2;
   float y13 = y1 - y3;
   
   float y31 = y3 - y1;
   float y21 = y2 - y1;
   
   float x31 = x3 - x1;
   float x21 = x2 - x1;
   
   // x1^2 - x3^2
   float sx13 = (float)(pow(x1, 2) -
   pow(x3, 2));
   
   // y1^2 - y3^2
   float sy13 = (float)(pow(y1, 2) -
   pow(y3, 2));
   
   float sx21 = (float)(pow(x2, 2) -
   pow(x1, 2));
   
   float sy21 = (float)(pow(y2, 2) -
   pow(y1, 2));
   
   float f = ((sx13) * (x12)
   + (sy13) * (x12)
   + (sx21) * (x13)
   + (sy21) * (x13))
   / (2 * ((y31) * (x12) - (y21) * (x13)));
   float g = ((sx13) * (y12)
   + (sy13) * (y12)
   + (sx21) * (y13)
   + (sy21) * (y13))
   / (2 * ((x31) * (y12) - (x21) * (y13)));
   
   float c = -(float)pow(x1, 2) - (float)pow(y1, 2) -
   2 * g * x1 - 2 * f * y1;
   
   // eqn of circle be x^2 + y^2 + 2*g*x + 2*f*y + c = 0
   // where centre is (h = -g, k = -f) and radius r
   // as r^2 = h^2 + k^2 - c
   centerX = -g;
   centerY = -f;
   float sqr_of_r = centerX * centerX + centerY * centerY - c;
   
   // r is the radius
   radius = sqrt(sqr_of_r);
}
  
  public boolean isLoop() {
     return start.equals(end); 
  }
  
  public void updateCircle() {
    if (noNull()) {
      if (!this.isLoop())
      findCircle(start.posX, start.posY, midpoint.posX, midpoint.posY, end.posX, end.posY);
     else
       findCircle(start.posX + 100, start.posY, midpoint.posX, midpoint.posY, end.posX, end.posY);
   }
  }
}
