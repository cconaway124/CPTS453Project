public class Point {
 public float x;
 public float y;
 
 public Point(float x, float y) {
   this.x = x;
   this.y = y;
 }

 public int quadrant() {
  if (x >= 0 && y >= 0)
    return 1;
  else if (x <= 0 && y >= 0)
    return 2;
  else if (x <= 0 && y <= 0)
    return 3;
  else 
    return 4;
 }
}
