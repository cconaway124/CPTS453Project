public class Vertex {
 public Integer posX;
 public Integer posY;
 public int index;
 
 public Vertex(int posX, int posY) {
   this(posX, posY, 0);
 }

 public Vertex (int posX, int posY, int index) {
    this.posX = posX;
    this.posY = posY;
    this.index = index;
 }
  @Override
  public String toString() {
    return "v" + this.index;
  }
 
}
