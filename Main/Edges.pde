public class Edge {
 
  public Vertex start;
  public Vertex end;
  public Vertex midpoint;
  public float centerX;
  public float centerY;
  public float radius;
  
  
  public Edge() {}
  
  public Edge (Vertex start, Vertex end, Vertex midpoint) {
     this.start = start;
     this.end = end;
     this.midpoint = midpoint;
  }

  public void setStartPoint(Vertex start) {
    this.start = start;
  }
  
  public void setEndPoint(Vertex end) {
     this.end = end;
  }

  public void setMidpoint(Vertex midpoint) {
    this.midpoint = midpoint;
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
  
}
