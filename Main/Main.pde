import controlP5.*;

ControlP5 cp5;

myColor colors = new myColor();

boolean vertexOn;
boolean edgeOn;

int currX, currY;

ArrayList<Vertex> vertices = new ArrayList<Vertex>();
ArrayList<Edge> edges = new ArrayList<Edge>();
Edge currentEdge = new Edge();

int numPointsInEdge = 0;

public final static int NO_DRAW_Y_BOUND = 200;
public final static int RADIUS = 50;

void setup() {
  size(1000, 1000);
  background(colors.RED());
  noStroke();
  cp5 = new ControlP5(this);
  vertexOn = false;
  edgeOn = false;
  currX = mouseX;
  currY = mouseY;
  
  // create a new button with name 'buttonA'
  addButton("vertex", 0, 50, 50, 100, 50, true);
  addButton("edge", 0, 160, 50, 100, 50, true);

}

public void vertex(boolean isOn) {
  fill(colors.BLUE());
  if (isOn)
    vertexOn = true;
 else
    vertexOn = false;
}

public void edge(boolean isOn) {
  //fill(colors.GREEN());
  if (isOn) {
    edgeOn = true;
  } else
    edgeOn = false;
}

void draw() {
  background(colors.BLACK());
  
  for (int i = 0; i < vertices.size(); i++) {
    ellipse(vertices.get(i).posX, vertices.get(i).posY, RADIUS * 2, RADIUS * 2);
  }
  
  for (Edge curr : edges) {
    noFill();
    bezier((float)curr.startX, (float)curr.startY, ((float)curr.startX + curr.endX), ((float)curr.startY + curr.endY), ((float)curr.startX + curr.endX) / 2, ((float)curr.startY + curr.endY) / 2, (float)curr.endX, (float)curr.endY);
    stroke(colors.WHITE());
    //line(curr.startX, curr.startY, curr.endX, curr.endY);  
}
}

public void addButton(String name, int initValue, int posX, int posY, int len, 
                      int wid, boolean swit) {
      cp5.addButton(name).setValue(initValue).setPosition(posX,posY).setSize(len, wid).setSwitch(swit)
          .setColorActive(colors.GREEN()).setColorBackground(colors.RED());

}

public void mousePressed() {
  if (vertexOn && mouseY >= NO_DRAW_Y_BOUND) {
    vertices.add(new Vertex(mouseX, mouseY));
    ellipse(mouseX, mouseY, 100, 100);
  }
  
  if (edgeOn && mouseY >= NO_DRAW_Y_BOUND) {
    inVertex(mouseX, mouseY);
    if (currentEdge.noNull()) {
        println("yes?");
       edges.add(currentEdge);
    }
  }
}

public void inVertex(int posX, int posY) {
  for (Vertex curr : vertices) {
     double distFromCenter = Math.sqrt(Math.pow((double)posX - curr.posX, 2.0) + Math.pow(((double)posY - curr.posY), 2.0));
     if (distFromCenter <= RADIUS) {
       println("in circle");
       println(curr.posX);
       println(curr.posY);
        if (numPointsInEdge != 1) {
         currentEdge = new Edge(); 
         numPointsInEdge = 1;
         currentEdge.setStartPoint(curr.posX, curr.posY);
        } else {
            currentEdge.setEndPoint(curr.posX, curr.posY);
            numPointsInEdge++;
        }
     } 
  }
}
