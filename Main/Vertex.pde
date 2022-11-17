public class Vertex {
 public Integer posX;
 public Integer posY;
 public color vertColor = colors.WHITE();

 public Vertex() { }
 public Vertex (int posX, int posY) {
    this.posX = posX;
    this.posY = posY;
 }
  
  public void setPosition(int posX, int posY) {
    this.posX = posX;
    this.posY = posY;
  }
  
  public void setColor(color vertColor) {
     this.vertColor = vertColor; 
  }
 
}
