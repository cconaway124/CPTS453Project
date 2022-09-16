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
  stroke(colors.RED());
  noFill();
  line(500, 700, 500, 500);
  line(250, 600, 750, 600);
  arc(500, 600, 500, 500, PI, TAU); //arc(centerX, centerY, diameterX, diameterY, startAngle, endAngle)
  for (int i = 0; i < vertices.size(); i++) {
    PShape ellipse = createShape(ELLIPSE, vertices.get(i).posX, vertices.get(i).posY, RADIUS * 2, RADIUS * 2);
    ellipse.setFill(colors.BLUE());
    ellipse.setStroke(0);
    shape(ellipse);
  }
  
  for (Edge curr : edges) {
    line((float)curr.startX, (float)curr.startY, 
          (float)curr.endX, (float)curr.endY);
    stroke(colors.WHITE());
    //line(curr.startX, curr.startY, curr.endX, curr.endY);  
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
  return sqrt((float)(pow((float)x1 - x2, 2.0) + Math.pow(((float)y1 - y2), 2.0)));
}

public Point getMidPoint(float x1, float y1, float x2, float y2) {
  return new Point((x1 + x2) / 2, (y1 + y2) / 2);
}

// gets the angle of the line from horizontal, requires trig x(
public float getAngle(float x1, float y1, float x2, float y2) {
   return 0.0; 
}
