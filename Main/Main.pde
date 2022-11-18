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
boolean bridgeOn;
boolean graphPressed;
boolean submitPressed;
boolean badInt = false;

int bridgeExecution = 0;
int graphNum = -1;
int hasBeenPressed = 0;

ArrayList<Vertex> vertices = new ArrayList<Vertex>();
ArrayList<Edge> edges = new ArrayList<Edge>();
ArrayList<Vertex> currEdge = new ArrayList<Vertex>();

public color currColor;

public int components = 0;

public final static int NO_DRAW_Y_BOUND = 200;
public final static int NO_DRAW_X_BOUND = 200;
public final static int RADIUS = 30;

// functionality buttons
Button vertexBtn;
Button edgeBtn;
Button deleteBtn;
Button emptyScreen;
Button vertexLabelBtn;
Button edgeLabelBtn;
Button vertexDegreeBtn;
Button totalDegreeBtn;
Button directedBtn;
Button bridges;
Button importCommonGraphBtn;
Button submitGraphBtn;

Slider r;
Slider g;
Slider b;

Textfield n_input;
int nInputValue = -1;
int p = -1;
int q = -1;

DropdownList commonGraphs;

void setup() {
   size(1500, 1500);
   surface.setResizable(true);
   background(colors.RED());
   
   cp5 = new ControlP5(this);
   
   vertexOn = false;
   edgeOn = false;
   deleteOn = false;
   
   // create a new button with name 'buttonA'
   vertexBtn = addButton("vertex", 0, 50, 40, 100, 50, true);
   edgeBtn = addButton("edge", 0, 160, 40, 100, 50, true);
   deleteBtn = addButton("delete", 0, 270, 40, 100, 50, true);
   emptyScreen = addButton("reset", 0, 380, 40, 100, 50, true);
   vertexLabelBtn = addButton("vlabels", 0, 50, 100, 100, 50, true);
   edgeLabelBtn = addButton("elabels", 0, 50, 160, 100, 50, true);
   vertexDegreeBtn = addButton("vDegree", 0, 160, 100, 100, 50, true);
   totalDegreeBtn = addButton("totalDegree", 0, 270, 100, 100, 50, true);
   directedBtn = addButton("directed", 0, 270, 100, 100, 50, true);
   bridges = addButton("bridges", 0, 380, 100, 100, 50, true);
   importCommonGraphBtn = addButton("graph", 0, 490, 40, 100, 50, false).setOff();
   submitGraphBtn = addButton("submit", 0, 550, 525, 100, 50, false).setOff().hide();
   
   r = cp5.addSlider("r").setPosition(20,300).setRange(0,255).setWidth(20).setHeight(255).setValue(255);
   g = cp5.addSlider("g").setPosition(80,300).setRange(0,255).setWidth(20).setHeight(255).setValue(255);
   b = cp5.addSlider("b").setPosition(140,300).setRange(0,255).setWidth(20).setHeight(255).setValue(255);
   
   n_input = cp5.addTextfield("input").setPosition(580, 450).setSize(200, 40).setFocus(true).setFont(createFont("arial",20)).setColor(colors.GRAY()).hide(); 
   
   commonGraphs = cp5.addDropdownList("Common Graphs", 420, 450, 150, 400).setBackgroundColor(colors.WHITE()).setItemHeight(25).setBarHeight(20).setBarVisible(false).close();
   commonGraphs.addItem("P_n", 0);
   commonGraphs.addItem("C_n", 1);
   commonGraphs.addItem("K_n", 2);
   commonGraphs.addItem("K_(p,q)", 3);
   commonGraphs.addItem("Q_n", 4);
   
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
      components = getComponents(vertices, edges);
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

public void bridges(boolean isOn) {
  if (isOn) {
    bridgeOn = true;
  } else {
    bridgeOn = false;
    bridgeExecution = 0;
  }
}

public void graph() {
  if (commonGraphs != null) {   
   graphPressed = true;
  }
}

public void submit() {
  if (commonGraphs != null) {  
    n_input.submit();
   submitPressed = true;
   switch (graphNum) {
      case 0:
        makeP_n(nInputValue);
        break;
      case 1:
        makeC_n(nInputValue);
        break;
      case 2:
        makeK_n(nInputValue);
        break;
      case 3:
        if (p != -1 && q != -1)
          makeK_pq(p, q);
        break;
      case 4:
        break;
      default:
        println("Something went wrong lmao - from switch in submit");
        break;
   }
  }
}

public void input(String text) {
  try {
    nInputValue = Integer.parseInt(text);
  } catch (NumberFormatException e) { 
    try {
      String[] pq = text.split(",");
      p = Integer.parseInt(pq[0]);
      q = Integer.parseInt(pq[1]);
    } catch (NumberFormatException e2) {
      badInt = true;
    }
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
   push();
   fill(currColor);
   rect(50, 575, 75, 75);
   pop();
   
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
   
   // execute if bridge is on
   if (bridgeOn && bridgeExecution <= 4) {
    ArrayList<Edge> currBridges = getBridges();
    for (Edge edge : currBridges) {
        if (bridgeExecution % 2 == 0) {
          println("0");
          edge.setColor(colors.complementaryColor(currColor));
        } else
          edge.setColor(currColor);
      }
      int start = millis();
      while (millis() - start <= 100){}
      bridgeExecution++;
   }
   
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
   
   if (graphPressed && !submitPressed) {
     rect(400, 400, 400, 220);
    if(badInt) {
       push();
       textSize(20);
       fill(colors.BLACK());
       text("Not an int", 700, 510);
       pop();
     }
     
     push();
     fill(colors.BLACK());
     textSize(20);
     text("Choose your graph:", 420, 430);
     pop();
    
     submitGraphBtn.show();
     commonGraphs.setBarVisible(true);
     n_input.show();
   } else if (graphPressed && submitPressed) {
     submitGraphBtn.hide();
     commonGraphs.setBarVisible(false);
     n_input.hide();
     graphPressed = false;
     submitPressed = false;
     badInt = false;
   }
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
      components = getComponents(vertices, edges);
   }
}

public void mouseDragged() {
  if (mouseY >= NO_DRAW_Y_BOUND && mouseX >= NO_DRAW_X_BOUND) {
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

public int getComponents(ArrayList<Vertex> vertices, ArrayList<Edge> edges) {
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
  
  PVector wing1 = PVector.mult(PVector.fromAngle(angleBetween + radians(150)), 20);
  PVector wing2 = PVector.mult(PVector.fromAngle(angleBetween + radians(210)), 20);
  
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

public ArrayList<Edge> getBridges() {
  ArrayList<Edge> bridges = new ArrayList<>();
  int currentComponents = getComponents(vertices, edges);
  for (Edge edge : edges) {
    ArrayList<Edge> tempEdgeSet = new ArrayList<>(edges);
    tempEdgeSet.remove(edge);
    int changedComponents = getComponents(vertices, tempEdgeSet);
    
    if (changedComponents - currentComponents == 1) {
      bridges.add(edge);
    } else if (changedComponents - currentComponents == -1) {
     println("ruh roh raggy"); 
    } else {
      println("Ectra ruh roh raggy");
    }
  }
  
  return bridges; 
}

public void makeP_n(int n) {
  Vertex last_vertex = new Vertex();
  for (int i = 0; i < n; i++) {
    Vertex curr = new Vertex(250 + i * 150, 300);
    vertices.add(curr);
    if (last_vertex.posX != null) {
      edges.add(new Edge(last_vertex, curr));
    }
    last_vertex = curr;
  }
}

public void makeC_n(int n) {
  PVector center = new PVector(600, 500);
  int radius = 200;
  float angleBetweenPoints = TAU / n;
  Vertex last_vertex = new Vertex();
  Vertex first_vertex = new Vertex();
  for (int i = 0; i < n; i++) {
    PVector newVert = (PVector.fromAngle(i * angleBetweenPoints).mult(radius)).add(center);
    Vertex curr = new Vertex(int(newVert.x), int(newVert.y));
    vertices.add(curr);
    first_vertex = (i == 0) ? curr : first_vertex;
    if (last_vertex.posX != null) {
     edges.add(new Edge(last_vertex, curr)); 
    }
    
    if (i == n - 1)
      edges.add(new Edge(curr, first_vertex));
    last_vertex = curr;
  }
}

public void makeK_n(int n) {
  PVector center = new PVector(600, 500);
  int radius = 200;
  float angleBetweenPoints = TAU / n;
  ArrayList<Vertex> allVerts = new ArrayList<Vertex>();
  for (int i = 0; i < n; i++) {
    PVector newVert = (PVector.fromAngle(i * angleBetweenPoints).mult(radius)).add(center);
    Vertex curr = new Vertex(int(newVert.x), int(newVert.y));
    vertices.add(curr);
    allVerts.add(curr);
    for (Vertex vert : allVerts) {
     edges.add(new Edge(vert, curr)); 
    }
  }
}

public void makeK_pq(int p, int q) {
  ArrayList<Vertex> set1 = new ArrayList<Vertex>();
  ArrayList<Vertex> set2 = new ArrayList<Vertex>();
  for (int i = 0; i < p; i++) {
    Vertex curr = new Vertex(300 + i * 75, 300);
    set1.add(curr);
    vertices.add(curr);
  }
  
  for (int i = 0; i < q; i++) {
    Vertex curr = new Vertex(300 + i * 75, 500);
    set2.add(curr);
    vertices.add(curr);
  }
  
  for (int i = 0; i < set1.size(); i++) {
     for (int j = 0; j < set2.size(); j++) {
       edges.add(new Edge(set1.get(i), set2.get(j)));
     }
  }
}

void controlEvent(ControlEvent theEvent) {
  // if the event is from a group, which is the case with the dropdownlist
  //println(theEvent.getGroup());
  if (theEvent.isGroup()) {
    // if the name of the event is equal to ImageSelect (aka the name of our dropdownlist)
  } else if(theEvent.isController()) {
    // not used in this sketch, but has to be included
    if (theEvent.getController().getName().equals("Common Graphs")) {
      // then do stuff, in this case: set the variable selectedImage to the value associated
      // with the item from the dropdownlist (which in this case is either 0 or 1)
      graphNum = int(theEvent.getController().getValue());
      }
    }
  }
