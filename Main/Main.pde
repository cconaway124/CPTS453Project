import controlP5.*;
import java.time.*;
import java.util.*;

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
public int components = 0;

public final static int NO_DRAW_Y_BOUND = 200;
public final static int NO_DRAW_X_BOUND = 200;
public final static int RADIUS = 25;

Button vertexBtn;
Button edgeBtn;
Button deleteBtn;
Button emptyScreen;

void setup() {
   size(1500, 1500);
   surface.setResizable(true);
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
      components = getComponents();
   }
}

void draw() {
   background(colors.BLACK());
   push();
   stroke(colors.WHITE());
   line(NO_DRAW_X_BOUND, NO_DRAW_Y_BOUND, width, NO_DRAW_Y_BOUND);
   line(NO_DRAW_X_BOUND, NO_DRAW_Y_BOUND, NO_DRAW_X_BOUND, height);
   textSize(48);
   text(String.format("n = %d, m = %d, k = %d", vertices.size(), edges.size(), components), 750, 100);
   pop();
   
   push();
   for (Edge curr : edges) {
      int x1 = curr.start.posX;
      int y1 = curr.start.posY;
      int x2 = curr.end.posX;
      int y2 = curr.end.posY;
      
      PShape arc = getEdgeAngle(x1, y1, x2, y2, curr);
      shape(arc);
      fill(colors.WHITE());
      ellipse(curr.midpoint.posX, curr.midpoint.posY, 15, 15);
      
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
   if (mouseY >= NO_DRAW_Y_BOUND && mouseX >= NO_DRAW_X_BOUND) {
      if (vertexOn) {
         Vertex vert = new Vertex(mouseX, mouseY, vertices.size());
         vertices.add(vert);
      }
      
      if (edgeOn) {
         inVertex(mouseX, mouseY, false);
         if (currentEdge.noNull()) {
            edges.add(currentEdge);
         }
      } else {
         numPointsInEdge = 0;
         currentEdge = new Edge();
      }
      
      if (deleteOn) {
         Vertex vertToDel = inVertex(mouseX, mouseY, true);
         if (vertToDel != null) {
            vertices.remove(vertices.indexOf(vertToDel));
            removeEdges(vertToDel);
         }
         
         deleteEdge(mouseX, mouseY);
      }
      components = getComponents();
   }
}

public void removeEdges(Vertex vertToDel) {
   for (int i = 0; i < edges.size(); i++) {
      boolean startToCent = edges.get(i).start.posX == vertToDel.posX && edges.get(i).start.posY == vertToDel.posY;
      boolean endToCent = edges.get(i).end.posX == vertToDel.posX && edges.get(i).end.posY == vertToDel.posY;
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
      currentEdge.setStartPoint(curr);
   } else {
      currentEdge.setEndPoint(curr);
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

public void deleteEdge(int x, int y) {
   for (int i = 0; i < edges.size(); i++) {
      Edge curr = edges.get(i);
      if (abs(curr.radius - distance(x, y, curr.centerX, curr.centerY)) < 25) {
         edges.remove(i);
         break;
      }
   }
}

public int getComponents() {
  if (vertices.isEmpty())
    return 0;
    
   ArrayList<ArrayList<Vertex>> adjacentVertices = new ArrayList<>(vertices.size());
   for (int i = 0; i < vertices.size(); i++) {
      ArrayList<Vertex> currVerts = new ArrayList<>();
      for (Edge edge : edges) {
        Vertex connVert = edge.getOtherVertex(vertices.get(i));
        if (connVert != null) {
          currVerts.add(connVert);
        }
      }
      adjacentVertices.add(currVerts);
   }

   HashSet<Vertex> unvisited = new HashSet<Vertex>();
   LinkedList<Integer> nextToVisit = new LinkedList<Integer>();
   nextToVisit.add(0);
   
   for (Vertex vertex : vertices) {
    unvisited.add(vertex);
   }
  
   int components = 1;
   println("b4 while");
   println(adjacentVertices.toString());

   while (!unvisited.isEmpty()) {
    println("father help");
    if (nextToVisit.isEmpty()) {
      components += 1;
      for (Vertex next : unvisited) {
        nextToVisit.add(next.index);
        break;
      }
    }
    Vertex curr = vertices.get(nextToVisit.pop());
    unvisited.remove(curr);

    List<Vertex> connectedVertices = adjacentVertices.get(curr.index);
    for (Vertex conn : connectedVertices) {
       if (unvisited.contains(conn)) {
         nextToVisit.add(conn.index);
       }
    }
    

   }

   return components;
}

public ArrayList<ArrayList<Integer>> getMatrixGraph() {
   ArrayList<ArrayList<Integer>> matrix = new ArrayList<>(vertices.size());
   for (int i = 0; i < vertices.size(); i++) {
      ArrayList<Integer> row = new ArrayList<>(vertices.size());
      for (int j = 0; j < vertices.size(); j++) {
         int edgeCount = edgeWithVerticesCount(vertices.get(j), vertices.get(i));
         row.set(j, edgeCount);
      }
      matrix.add(row);
   }
   
   return matrix;
}

public int edgeWithVerticesCount(Vertex target1, Vertex target2) {
   int count = 0;
   for (Edge edge : edges) {
      if (edge.contains(target1) && edge.contains(target2)){
         count += 1;
      }
   }
   return count;
}

public PShape getEdgeAngle(int x1, int y1, int x2, int y2, Edge curr) {
   Point mid = getMidPoint(x1, y1, x2, y2);
   stroke(colors.WHITE());
   noFill();
   boolean point1Below = (y1 - mid.y) > 0;
   
   float x3dir = -(y2 - y1);
   float y3dir = mid.x;
   float magnitude = sqrt(x3dir * x3dir + y3dir * y3dir);
   x3dir /= magnitude;
   y3dir /= magnitude;
   
   float midpointDist = distance(x1, y1, x2, y2) / 10;
   x3dir *= midpointDist;
   y3dir *= midpointDist;
   
   curr.setMidpoint(new Vertex((int)(mid.x + x3dir), (int)(mid.y + y3dir)));
   float[] circle = findCircle(x1, y1, mid.x + x3dir, mid.y + y3dir, x2, y2);
   
   float centerX = circle[0];
   float centerY = circle[1];
   float r = circle[2];
   
   float adjX1 = x1 - centerX;
   float adjY1 = y1 - centerY;
   float adjX2 = x2 - centerX;
   float adjY2 = y2 - centerY;
   
   Point point1 = new Point(adjX1, adjY1);
   Point point2 = new Point(adjX2, adjY2);
   int point1Quad = point1.quadrant();
   int point2Quad = point2.quadrant();
   
   float startAngle = angleFrom0(point1, r);
   float endAngle = angleFrom0(point2, r);
   
   if (startAngle > endAngle) {
      float temp = startAngle;
      startAngle = endAngle;
      endAngle = temp;
   }
   
   return createShape(ARC, centerX, centerY, r * 2, r * 2, startAngle, endAngle);
}

public float angleFrom0(Point point, float r) {
   switch (point.quadrant()) {
      case 1:
      return acos(point.x / r);
      case 2:
      return acos(point.x / r);
      case 3:
      float diff = PI - acos(point.x / r);
      return 2 * diff + acos(point.x / r);
      case 4:
      return TAU - acos(point.x / r);
      default:
      return -375.0;
   }
}
