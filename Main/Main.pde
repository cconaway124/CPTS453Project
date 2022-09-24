import controlP5.*;
import java.time.*;

ControlP5 cp5;

myColor colors = new myColor();

boolean vertexOn;
boolean edgeOn;
boolean deleteOn;

int currX, currY;

ArrayList<Vertex> vertices = new ArrayList<Vertex>();
ArrayList<Edge> edges = new ArrayList<Edge>();
Edge currentEdge = new Edge();

int numPointsInEdge = 0;

public final static int NO_DRAW_Y_BOUND = 200;
public final static int RADIUS = 50;

Button vertexBtn;
Button edgeBtn;
Button deleteBtn;
Button emptyScreen;

void setup() {
  size(1500, 1500);
  background(colors.RED());
  
  cp5 = new ControlP5(this);
  
  vertexOn = false;
  edgeOn = false;
  deleteOn = false;
  
  currX = mouseX;
  currY = mouseY;
  
  // create a new button with name 'buttonA'
  vertexBtn = addButton("vertex", 0, 50, 50, 100, 50, true);
  edgeBtn = addButton("edge", 0, 160, 50, 100, 50, true);
  deleteBtn = addButton("delete", 0, 270, 50, 100, 50, true);
  emptyScreen = addButton("reset", 0, 380, 50, 100, 50, true);
}

public void vertex(boolean isOn) {
  if (isOn) {
    vertexOn = true;
    edgeBtn.setOff();
    deleteBtn.setOff();
  } else
    vertexOn = false;
}

public void edge(boolean isOn) {
  //fill(colors.GREEN());
  if (isOn) {
    edgeOn = true;
    vertexBtn.setOff();
    deleteBtn.setOff();
  } else
    edgeOn = false;
}

public void delete(boolean isOn) {
 if (isOn) {
   deleteOn = true;
   vertexBtn.setOff();
   edgeBtn.setOff();
 } else
   deleteOn = false;
}

public void reset(boolean isOn) {
  if (isOn) {
    vertices = new ArrayList<Vertex>();
    edges = new ArrayList<Edge>();
    emptyScreen.setOff();
    vertexBtn.setOff();
    edgeBtn.setOff();
    deleteBtn.setOff();
  }
}

void draw() {
  background(colors.BLACK());
  
  //arc(centerX, centerY, diameterX, diameterY, startAngle, endAngle)
  push();
  for (Edge curr : edges) {
    int x1 = curr.startX;
    int y1 = curr.startY;
    int x2 = curr.endX;
    int y2 = curr.endY;
    
    float[] circle = findCircle(x1, y1, ((float)x1 + x2) / 2 - 10, ((float)y1 + y2) / 2 + 10, x2, y2);
    
    float centerX = circle[0];
    float centerY = circle[1];
    float r = circle[2];
    float startAngle = PI;
    float endAngle = TAU;
    noFill();
    stroke(colors.WHITE());
    line(x1, y1, centerX, centerY);
    line(x2, y2, centerX, centerY);
    float x_dist = abs(x1 - x2);
    int index1 = vertexIndex(x1, y1);
    int index2 = vertexIndex(x2, y2);
    
    arc(500, 500, 100, 100, 3 * HALF_PI, TAU + HALF_PI);
    arc(500, 500, 100, 100, HALF_PI, 3 * HALF_PI);
    
      
    println(degrees(startAngle), degrees(endAngle));
    
    PShape arc = createShape(ARC, centerX, centerY, r * 2, r * 2, startAngle, endAngle);
    arc.setStroke(colors.WHITE());
    shape(arc);
    //line(curr.startX, curr.startY, curr.endX, curr.endY);  
  }
  pop();
  for (int i = 0; i < vertices.size(); i++) {
    PShape ellipse = createShape(ELLIPSE, vertices.get(i).posX, vertices.get(i).posY, RADIUS * 2, RADIUS * 2);
    ellipse.setFill(colors.BLUE());
    ellipse.setStroke(0);
    shape(ellipse);
  }
}

public Button addButton(String name, int initValue, int posX, int posY, int len, 
                      int wid, boolean swit) {
      return cp5.addButton(name).setValue(initValue).setPosition(posX,posY).setSize(len, wid).setSwitch(swit)
          .setColorActive(colors.GREEN()).setColorBackground(colors.RED());

}

public void mousePressed() {
  if (vertexOn && mouseY >= NO_DRAW_Y_BOUND) {
    vertices.add(new Vertex(mouseX, mouseY));
  }
  
  if (edgeOn && mouseY >= NO_DRAW_Y_BOUND) {
    inVertex(mouseX, mouseY, false);
    if (currentEdge.noNull()) {
       edges.add(currentEdge);
    }
  } else {
      numPointsInEdge = 0;
      currentEdge = new Edge();
  }
  
  if (deleteOn && mouseY >= NO_DRAW_Y_BOUND) {
    Vertex vertToDel = inVertex(mouseX, mouseY, true);
    if (vertToDel != null) {
      vertices.remove(vertices.indexOf(vertToDel));
      removeEdges(vertToDel);
    }
  }
}

public void removeEdges(Vertex vertToDel) {
  for (int i = 0; i < edges.size(); i++) {
         boolean startToCent = edges.get(i).startX == vertToDel.posX && edges.get(i).startY == vertToDel.posY;
         boolean endToCent = edges.get(i).endX == vertToDel.posX && edges.get(i).endY == vertToDel.posY;
         if (startToCent || endToCent) {
           edges.remove(edges.get(i));
           i--;
         }
      }
}

public Vertex inVertex(int posX, int posY, boolean delete) {
  for (Vertex curr : vertices) {
     float distFromCenter = distance(posX, posY, curr.posX, curr.posY);
     if (distFromCenter <= RADIUS) {
       if (delete)
         return curr;
        else
          addVerticesToEdge(curr);
     } 
  }
  return null;
}

public void addVerticesToEdge(Vertex curr) {
 if (numPointsInEdge != 1) {
   currentEdge = new Edge(); 
   numPointsInEdge = 1;
   currentEdge.setStartPoint(curr.posX, curr.posY);
  } else {
      currentEdge.setEndPoint(curr.posX, curr.posY);
      numPointsInEdge++;
  } 
}

public float distance(float x1, float y1, float x2, float y2) {
  return sqrt((float)(pow((float)x1 - x2, 2.0) +  pow(((float)y1 - y2), 2.0)));
}

public Point getMidPoint(float x1, float y1, float x2, float y2) {
  return new Point((x1 + x2) / 2, (y1 + y2) / 2);
}

// gets the angle of the line from horizontal, requires trig
// x1, y1 is the first point and x2 y2 is the second but we can get a vector from them
public float[] findCircle(float x1, float y1, float x2, float y2, float x3, float y3) {
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
    float centerX = -g;
    float centerY = -f;
    float sqr_of_r = centerX * centerX + centerY * centerY - c;
 
    // r is the radius
    float r = sqrt(sqr_of_r);
    return new float[] {centerX, centerY, r};
}

public int vertexIndex(int x, int y) {
  int count = 0;
  for (Vertex curr : vertices) {
    if (x == curr.posX && y == curr.posY)
      return count;
    count++;
  }
   return -1;
}
