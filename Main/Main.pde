import controlP5.*;
import java.time.*;
import java.util.*;

ControlP5 cp5;

myColor colors = new myColor();

boolean vertexOn;
boolean edgeOn;
boolean deleteOn;
boolean vertexLabelOn;
boolean edgeLabelOn;
boolean vertexDegreeOn;
boolean totalDegreeOn;
boolean directedOn;

ArrayList<Vertex> vertices = new ArrayList<Vertex>();
ArrayList<Edge> edges = new ArrayList<Edge>();
ArrayList<Vertex> currEdge = new ArrayList<Vertex>();

public color currColor;

public int components = 0;

public final static int NO_DRAW_Y_BOUND = 200;
public final static int NO_DRAW_X_BOUND = 200;
public final static int RADIUS = 30;

Button vertexBtn;
Button edgeBtn;
Button deleteBtn;
Button emptyScreen;
Button vertexLabelBtn;
Button edgeLabelBtn;
Button vertexDegreeBtn;
Button totalDegreeBtn;
Button directedBtn;

Slider r;
Slider g;
Slider b;

void setup() {
   size(1500, 1500);
   surface.setResizable(true);
   background(colors.RED());
   
   cp5 = new ControlP5(this);
   
   vertexOn = false;
   edgeOn = false;
   deleteOn = false;
   
   // create a new button with name 'buttonA'
   vertexBtn = addButton("vertex", 0, 50, 50, 100, 50, true);
   edgeBtn = addButton("edge", 0, 160, 50, 100, 50, true);
   deleteBtn = addButton("delete", 0, 270, 50, 100, 50, true);
   emptyScreen = addButton("reset", 0, 380, 50, 100, 50, true);
   vertexLabelBtn = addButton("vlabels", 0, 50, 110, 100, 50, true);
   edgeLabelBtn = addButton("elabels", 0, 50, 170, 100, 50, true);
   vertexDegreeBtn = addButton("vDegree", 0, 160, 110, 100, 50, true);
   totalDegreeBtn = addButton("totalDegree", 0, 270, 110, 100, 50, true);
   directedBtn = addButton("directed", 0, 270, 110, 100, 50, true);
   
   r = cp5.addSlider("r").setPosition(20,300).setRange(0,255).setWidth(20).setHeight(255).setValue(255);
   g = cp5.addSlider("g").setPosition(80,300).setRange(0,255).setWidth(20).setHeight(255).setValue(255);
   b = cp5.addSlider("b").setPosition(140,300).setRange(0,255).setWidth(20).setHeight(255).setValue(255);
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

public void vlabels(boolean isOn) {
  if (isOn) {
   vertexLabelOn = true;
  } else {
    vertexLabelOn = false;
  }
}

public void elabels(boolean isOn) {
  if (isOn) {
    edgeLabelOn = true;
  } else {
    edgeLabelOn = false;
  }
}

public void vDegree(boolean isOn) {
  if (isOn) {
    vertexDegreeOn = true;
  } else {
    vertexDegreeOn = false;
  }
}

public void totalDegree(boolean isOn) {
  if (isOn) {
    totalDegreeOn = true;
  } else {
    totalDegreeOn = false;
  }
}

public void directed(boolean isOn) {
  if (isOn) {
    directedOn = true;
  } else {
    directedOn = false;
  }
}

public void r(float r) {
  currColor = color(r, green(currColor), blue(currColor));
}

public void g(float g) {
  currColor = color(red(currColor), g, blue(currColor));
}

public void b(float b) {
  currColor = color(red(currColor), green(currColor), b);
}

void draw() {
   background(colors.BLACK());
   //shape(arrowHead(new PVector(400, 400), new PVector(500, 400)), 400, 400);
   push();
   stroke(colors.WHITE());   
   line(NO_DRAW_X_BOUND, NO_DRAW_Y_BOUND, width, NO_DRAW_Y_BOUND);
   line(NO_DRAW_X_BOUND, NO_DRAW_Y_BOUND, NO_DRAW_X_BOUND, height);
   textSize(48);
   text(String.format("n = %d, m = %d, k = %d", vertices.size(), edges.size(), components), 750, 100);
   if (totalDegreeOn) {
     text(String.format("n = %d, m = %d, k = %d, Total degree = %d", vertices.size(), edges.size(), components, edges.size() * 2), 750, 100);
   } else {
    text(String.format("n = %d, m = %d, k = %d", vertices.size(), edges.size(), components), 750, 100); 
   }
   pop();
   
   push();
   for (Edge curr : edges) {
      PShape arc = getEdgeAngle(curr);
      arc.setStroke(curr.edgeColor);
      fill(curr.edgeColor);
      shape(arc);
      if (directedOn) {
        float midpointX = curr.midpoint.posX;
        float midpointY = curr.midpoint.posY;
        PVector parallelVect = PVector.mult(new PVector(curr.end.posX - curr.start.posX, curr.end.posY - curr.start.posY).normalize(), 10);
        PVector midpointVect = new PVector(midpointX, midpointY);
        PVector vectSub = new PVector(midpointVect.x - parallelVect.x, midpointVect.y - parallelVect.y);
        PVector vectAdd = new PVector(midpointVect.x + parallelVect.x, midpointVect.y + parallelVect.y);
        println(midpointVect.x - parallelVect.x, midpointVect.x + parallelVect.x, parallelVect.x, midpointVect.x);
        PShape arrow = arrowHead(vectSub, vectAdd);
        arrow.fill(curr.edgeColor);
        shape(arrow, midpointX, midpointY);
      } else 
        ellipse(curr.midpoint.posX, curr.midpoint.posY, 10, 10);
      if (edgeLabelOn) {
        textSize(32);
        text(String.format("E%d", edges.indexOf(curr)), curr.midpoint.posX - RADIUS / 2, curr.midpoint.posY + RADIUS);
      }
   }
   pop();
   
   push();
   for (Vertex vert : vertices) {
      PShape ellipse = createShape(ELLIPSE, vert.posX, vert.posY - 10, RADIUS * 2, RADIUS * 2);
      ellipse.setFill(vert.vertColor);
      ellipse.setStroke(vert.vertColor);
      shape(ellipse);
      if (vertexLabelOn) {
        push();
        fill(colors.complementaryColor(vert.vertColor));
        textSize(32);
        text(String.format("V%d", vertices.indexOf(vert)), vert.posX - RADIUS / 2, vert.posY);
        pop();
      }
      
      if (vertexDegreeOn) {
        text(String.format("%d", getDegreeOfVertex(vert)), vert.posX - 50, vert.posY - 50);
      }
   }
   pop();
}

public int getDegreeOfVertex(Vertex vert) {
  int count = 0;
  for (Edge edge : edges) {
     if (edge.contains(vert))
       count++;
  }
  return count;
}

public Button addButton(String name, int initValue, int posX, int posY, int len,
int wid, boolean swit) {
   return cp5.addButton(name).setValue(initValue).setPosition(posX,posY).setSize(len, wid).setSwitch(swit)
   .setColorActive(colors.GREEN()).setColorBackground(colors.RED());
   
}

public void mousePressed() {
   if (mouseY >= NO_DRAW_Y_BOUND && mouseX >= NO_DRAW_X_BOUND) {
      if (vertexOn) {
         Vertex onVert = findVertex(mouseX, mouseY);
         if (onVert != null) {
           onVert.setPosition(mouseX, mouseY);
           onVert.setColor(currColor);
         } else {
           Vertex vert = new Vertex(mouseX, mouseY);
           vert.setColor(currColor);
           vertices.add(vert);
         }
      }
      
      if (edgeOn) {
         Vertex vert = findVertex(mouseX, mouseY);
         if (vert != null) {
           currEdge.add(vert);
           if (currEdge.size() == 2) {
             Edge loop;
             if (currEdge.get(0).equals(currEdge.get(1))) {
               loop = new Edge(currEdge.get(0), currEdge.get(1));
               loop.setMidpoint(currEdge.get(0).posX + 100, currEdge.get(0).posY + 100);
             } else {
               loop = new Edge(currEdge.get(0), currEdge.get(1));
             }
             loop.setColor(currColor);
             edges.add(loop);  
             currEdge = new ArrayList<Vertex>();
            }
         }
         Edge currEdge = findEdge(mouseX, mouseY);
         if (currEdge != null) {
          currEdge.setColor(currColor); 
         }
      } else {
         currEdge = new ArrayList<Vertex>();
      }
      
      if (deleteOn) {
         Vertex vertToDel = findVertex(mouseX, mouseY);
         if (vertToDel != null) {
            vertices.remove(vertices.indexOf(vertToDel));
            removeEdges(vertToDel);
         }
         
         deleteEdge(mouseX, mouseY);
      }
      components = getComponents();
   }
}

public void mouseDragged() {
  if (vertexOn) {
     Vertex onVert = findVertex(mouseX, mouseY);
     if (onVert != null && mousePressed) {
         onVert.setPosition(mouseX, mouseY);
         for (Edge edge : edges) {
            if (edge.contains(onVert))
              edge.updateCircle();
              edge.setMidpoint();
         }
     }
  }
  
  if (edgeOn) {
    Edge onEdge = findEdgeMidpoint(mouseX, mouseY);
    if (onEdge != null) {
      if (!onEdge.isLoop()) {
        Point mid = getMidPoint(onEdge.start.posX, onEdge.start.posY, onEdge.end.posX, onEdge.end.posY);
        float radius = distance(onEdge.start.posX, onEdge.start.posY, onEdge.end.posX, onEdge.end.posY) / 2;
        boolean betweenPoints = (abs(mid.x - mouseX) < radius) && (abs(mid.y - mouseY) < radius);
        if (betweenPoints)
         onEdge.setMidpoint(mouseX, mouseY); 
      } else {
         boolean withinR = distance(onEdge.start.posX, onEdge.start.posY, mouseX, mouseY) < 200;
         if (withinR)
           onEdge.setMidpoint(mouseX, mouseY); 
      }
    }
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

public Vertex findVertex(int posX, int posY) {
   for (Vertex curr : vertices) {
      float distFromCenter = distance(posX, posY, curr.posX, curr.posY);
      if (distFromCenter <= RADIUS) {
        return curr;
      }
   }
   return null;
}

public float distance(float x1, float y1, float x2, float y2) {
   return sqrt((float)(pow((float)x1 - x2, 2.0) +  pow(((float)y1 - y2), 2.0)));
}

public Point getMidPoint(float x1, float y1, float x2, float y2) {
   return new Point((x1 + x2) / 2, (y1 + y2) / 2);
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

public Edge findEdge(int x, int y) {
   for (int i = 0; i < edges.size(); i++) {
      Edge curr = edges.get(i);
      if (abs(curr.radius - distance(x, y, curr.centerX, curr.centerY)) < 25) {
         return curr;
      }
   }
   return null;
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

   while (!unvisited.isEmpty()) {
    if (nextToVisit.isEmpty()) {
      components += 1;
      for (Vertex next : unvisited) {
        nextToVisit.add(vertices.indexOf(next));
        break;
      }
    }
    Vertex curr = vertices.get(nextToVisit.pop());
    unvisited.remove(curr);
    List<Vertex> connectedVertices = adjacentVertices.get(vertices.indexOf(curr));
    for (Vertex conn : connectedVertices) {
       if (unvisited.contains(conn)) {
         nextToVisit.add(vertices.indexOf(conn));
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

public PShape getEdgeAngle(Edge curr) {
   stroke(colors.WHITE());
   noFill();
   float centerX = curr.centerX;
   float centerY = curr.centerY;
   float r = curr.radius;
   
   if (curr.isLoop()) {
     return createShape(ARC, centerX, centerY, r * 2, r * 2, 0, TAU);
   }
   
   float adjX1 = curr.start.posX - centerX;
   float adjY1 = curr.start.posY - centerY;
   float adjX2 = curr.end.posX - centerX;
   float adjY2 = curr.end.posY - centerY;
   
   float startAngle = angleFrom0(adjX1, adjY1);
   float midpointAngle = angleFrom0(curr.midpoint.posX - centerX, curr.midpoint.posY - centerY);
   float endAngle = angleFrom0(adjX2, adjY2);
   
   float relMid = (midpointAngle - startAngle + TAU) % TAU;
   float relEnd = (endAngle - startAngle + TAU) % TAU;
   
   if (relMid < relEnd) {  
     return createShape(ARC, centerX, centerY, r * 2, r * 2, (startAngle), (startAngle + relEnd));
    }
    else {
      while (abs(((-(2 * TAU - endAngle)) % TAU) - startAngle) > TAU) {
       endAngle += TAU; 
      }
      return createShape(ARC, centerX, centerY, r * 2, r * 2, (-(2 * TAU - endAngle)) % TAU, (startAngle));
    }
    
    

}

public float angleFrom0(float x, float y) {
   return atan2(y, x);
}

public Edge findEdgeMidpoint(int posX, int posY) {
  for (Edge edge : edges) {
     if (distance(posX, posY, edge.midpoint.posX, edge.midpoint.posY) < 15) {
         return edge;
     }
  }
  return null;
}

//The first point is the "back" of the arrow, and the second point is the "front"
public PShape arrowHead(PVector vect1, PVector vect2) {
  PVector middleArrow = vect2.sub(vect1);;
  
  float angleBetween = middleArrow.heading();
  println("zero: " + angleBetween);  
  
  PVector wing1 = PVector.mult(PVector.fromAngle(angleBetween + radians(150)), 20);
  PVector wing2 = PVector.mult(PVector.fromAngle(angleBetween + radians(210)), 20);
  
  //wing1 = wing1.add(vect1);
  //wing2 = wing2.add(vect1);
  /*
     line(400, 400, 500, 400);
   line(400, 400, 350, 350);
   line(350, 350, 500, 400);
   line(400, 400, 350, 450);
   line(350, 450, 500, 400);
  */
  
  PShape arrow = createShape();
  arrow.beginShape();
  
  arrow.noStroke();
  
  arrow.vertex(wing1.x, wing1.y);
  arrow.vertex(vect2.x, vect2.y);
  arrow.vertex(wing2.x, wing2.y);
  arrow.vertex(0, 0);
  arrow.vertex(wing1.x, wing1.y);  
  
  arrow.endShape(CLOSE);
  
  return arrow; 
}
