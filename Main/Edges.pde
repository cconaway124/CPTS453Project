public class Edge {
 
  public Integer startX;
  public Integer startY;
  public Integer endX;
  public Integer endY;

  public void setStartPoint(int startX, int startY) {
    this.startX = startX;
    this.startY = startY;
  }
  
  public void setEndPoint(int endX, int endY) {
     this.endX = endX;
     this.endY = endY;
  }
  
  public boolean noNull() {
    return !(startX == null || startY == null || endX == null || endY == null); 
  }
  
}
