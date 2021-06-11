
import augmenta.*;
import oscP5.*;

// Visualize data from Augmenta single spatializer through a Syphon/Spout output

OscP5 myosc;

boolean mode3D = false;

float value;
float x, y, r, g, b;

public static class Node {
  float h = 1.0, v = 1.0, exp = 1.0;
  boolean isActive = false;
}

public static class Knob {
  float alpha = 1.0;
}

//Node node1, node2, node3, node4, node5, node6, node7, node8;
//Knob knob1, knob2, knob3, knob4, knob5, knob6, knob7, knob8;

Node node1 = new Node();
Node node2 = new Node();
Node node3 = new Node();
Node node4 = new Node();
Node node5 = new Node();
Node node6 = new Node();
Node node7 = new Node();
Node node8 = new Node();
  
Knob knob1 = new Knob();
Knob knob2 = new Knob();
Knob knob3 = new Knob();
Knob knob4 = new Knob();
Knob knob5 = new Knob();
Knob knob6 = new Knob();
Knob knob7 = new Knob();
Knob knob8 = new Knob();

Node[] nodes = {node1, node2, node3, node4, node5, node6, node7, node8};
Knob[] knobs = {knob1, knob2, knob3, knob4, knob5, knob6, knob7, knob8};
color[] palette = {
  color(0.384*255, 0.996*255, 0.384*255),
  color(0.998*255, 0, 0),
  color(0.427*255, 0.843*255, 255),
  color(0.439*255, 0.624*255, 0.075*255),
  color(0.969*255, 0.686*255, 0.184*255),
  color(0.733*255, 0.035*255, 0.788*255),
  color(0.882*255, 0.243*255, 0.149*255),
  color(0.027*255, 0.451*255, 0.506*255)
};

color pointColor;

int[] g_sceneSize = {400, 400};

PGraphics canvasSquare; // Syphon/Spout texture output

void setup() {

  background(0);
  // /!\ Keep this setup order !
  setupSyphonSpout();

  // The messages coming from Max4Live are sent on the port 9000 by default
  myosc = new OscP5(this, 9000);

  //setupAugmenta();
  if (mode3D) {
    canvas = createGraphics(width, height, P3D);
  } else {
    canvas = createGraphics(width, height, P2D);
  }
  setupGUI();
  // enable the resizable window
  surface.setResizable(true); 
  
  pointColor = color(255,255,255,255);
}

void draw() {

  adjustSceneSize();
  background(0);

  canvasSquare.beginDraw();
  canvasSquare.background(0);
  drawSpatializerDisks(canvasSquare);
  canvasSquare.endDraw();

  // All visuals to send must be drawn in this canvas
  // Prefix your drawing functions with "canvas." as below
  canvas.beginDraw();
  
  canvas.background(0);
  canvas.image(canvasSquare, 0, 0, canvas.width, canvas.height);
  //println("size : "+ g_sceneSize[0] + " " + g_sceneSize[1]);
  
  canvas.endDraw();

  // Draw canvas in the window
  //image(canvas, 0, 0, width, height);
  image(canvas, 0, 0);

  // Display instructions
  if (drawDebugData) {
    textSize(10);
    fill(255);
    text("Drag mouse to set the interactive area. Right click to reset.", 10, height - 10);
  }

  // Syphon/Spout output
  sendFrames();
}

void drawSpatializerDisks(PGraphics _mycanvas) {

  // Setup
  int w = _mycanvas.width;
  int h = _mycanvas.height;
  _mycanvas.background(0);
  //rect(0,height/2,value*width,20);
  _mycanvas.ellipseMode(CENTER);  // Set ellipseMode to CENTER

 
  // Draw the nodes 
  for(int i = 0; i < nodes.length; i++){
//    System.out.println("Drawing elipse: " + i);
    if(nodes[i].isActive){
      _mycanvas.fill(palette[i],knobs[i].alpha * 255);
      _mycanvas.noStroke();
      _mycanvas.ellipse(nodes[i].v*w, nodes[i].h*h,nodes[i].exp*2*w, nodes[i].exp*2*h);
    }
  }
  
  // Draw point
  //_mycanvas.fill(r*255, g*255, b*255, a*320);  //   with color
  _mycanvas.fill(pointColor); // white point
  _mycanvas.ellipse(x*w, y*h, 50, 50);
}

void oscEvent(OscMessage theOscMessage) {
  
  //println("Got message");

  if (theOscMessage.checkAddrPattern("/fusion")==true) {
    if (theOscMessage.checkTypetag("ffffii")) {
      g_sceneSize[0] = theOscMessage.get(4).intValue();
      g_sceneSize[1] = theOscMessage.get(5).intValue();
    }
  }

  //xy
  if (theOscMessage.checkAddrPattern("/m4l/xy")==true) {
    if (theOscMessage.checkTypetag("fffff")) {
      x = theOscMessage.get(0).floatValue();
      y = theOscMessage.get(1).floatValue();
      r = theOscMessage.get(2).floatValue();
      g = theOscMessage.get(3).floatValue();
      b = theOscMessage.get(4).floatValue();
    }
  }
  
  if (theOscMessage.checkAddrPattern("/m4l/xy")==true) {
    if (theOscMessage.checkTypetag("ff")) {
      x = theOscMessage.get(0).floatValue();
      y = theOscMessage.get(1).floatValue();
      //println("xy : "+x + y);
    }
  }
  
  // point color
  if (theOscMessage.checkAddrPattern("/knobcolor")==true) {
    if (theOscMessage.checkTypetag("ffff")) {
      color tmp = color(theOscMessage.get(0).floatValue() * 255, theOscMessage.get(1).floatValue() * 255, theOscMessage.get(2).floatValue() * 255, theOscMessage.get(3).floatValue() * 255);
      pointColor = tmp;
    }
  }  

  //node 1
  if (theOscMessage.checkAddrPattern("/m4l/node1")==true)
  {
    if (theOscMessage.checkTypetag("fffi"))
    {
      node1.v = theOscMessage.get(0).floatValue();
      node1.h = theOscMessage.get(1).floatValue();
      node1.exp = theOscMessage.get(2).floatValue();
      node1.isActive = theOscMessage.get(3).intValue() == 1;
    }
  }
  if (theOscMessage.checkAddrPattern("/m4l/knob1")==true)
  {
    if (theOscMessage.checkTypetag("f"))
    {
      knob1.alpha = theOscMessage.get(0).floatValue();
    }
  }

  //node 2
  if (theOscMessage.checkAddrPattern("/m4l/node2")==true) {
    if (theOscMessage.checkTypetag("fffi")) {
      node2.v = theOscMessage.get(0).floatValue(); 
      node2.h = theOscMessage.get(1).floatValue();
      node2.exp = theOscMessage.get(2).floatValue();
      node2.isActive = theOscMessage.get(3).intValue() == 1;
    }
  }
  if (theOscMessage.checkAddrPattern("/m4l/knob2")==true) {
    if (theOscMessage.checkTypetag("f")) {
      knob2.alpha = theOscMessage.get(0).floatValue();
    }
  }

  //node 3
  if (theOscMessage.checkAddrPattern("/m4l/node3")==true) {
    if (theOscMessage.checkTypetag("fffi")) {
      node3.v = theOscMessage.get(0).floatValue(); 
      node3.h = theOscMessage.get(1).floatValue();
      node3.exp = theOscMessage.get(2).floatValue();
      node3.isActive = theOscMessage.get(3).intValue() == 1;
    }
  }
  if (theOscMessage.checkAddrPattern("/m4l/knob3")==true) {
    if (theOscMessage.checkTypetag("f")) {
      knob3.alpha = theOscMessage.get(0).floatValue();
    }
  }

  //node 4
  if (theOscMessage.checkAddrPattern("/m4l/node4")==true) {
    if (theOscMessage.checkTypetag("fffi")) {
      node4.v = theOscMessage.get(0).floatValue(); 
      node4.h = theOscMessage.get(1).floatValue();
      node4.exp = theOscMessage.get(2).floatValue();
      node4.isActive = theOscMessage.get(3).intValue() == 1;
    }
  }
  if (theOscMessage.checkAddrPattern("/m4l/knob4")==true) {
    if (theOscMessage.checkTypetag("f")) {
      knob4.alpha = theOscMessage.get(0).floatValue();
    }
  }

  //node 5
  if (theOscMessage.checkAddrPattern("/m4l/node5")==true) {
    if (theOscMessage.checkTypetag("fffi")) {
      node5.v = theOscMessage.get(0).floatValue(); 
      node5.h = theOscMessage.get(1).floatValue();
      node5.exp = theOscMessage.get(2).floatValue();
      node5.isActive = theOscMessage.get(3).intValue() == 1;
    }
  }
  if (theOscMessage.checkAddrPattern("/m4l/knob5")==true) {
    if (theOscMessage.checkTypetag("f")) {
      knob5.alpha = theOscMessage.get(0).floatValue();
    }
  }

  //node 6
  if (theOscMessage.checkAddrPattern("/m4l/node6")==true) {
    if (theOscMessage.checkTypetag("fffi")) {
      node6.v = theOscMessage.get(0).floatValue(); 
      node6.h = theOscMessage.get(1).floatValue();
      node6.exp = theOscMessage.get(2).floatValue();
      node6.isActive = theOscMessage.get(3).intValue() == 1;
    }
  }
  if (theOscMessage.checkAddrPattern("/m4l/knob6")==true) {
    if (theOscMessage.checkTypetag("f")) {
      knob6.alpha = theOscMessage.get(0).floatValue();
    }
  }

  //node 7
  if (theOscMessage.checkAddrPattern("/m4l/node7")==true) {
    if (theOscMessage.checkTypetag("fffi")) {
      node7.v = theOscMessage.get(0).floatValue(); 
      node7.h = theOscMessage.get(1).floatValue();
      node7.exp = theOscMessage.get(2).floatValue();
      node7.isActive = theOscMessage.get(3).intValue() == 1;
    }
  }
  if (theOscMessage.checkAddrPattern("/m4l/knob7")==true) {
    if (theOscMessage.checkTypetag("f")) {
      knob7.alpha = theOscMessage.get(0).floatValue();
    }
  }

  //node 8

  if (theOscMessage.checkAddrPattern("/m4l/node8")==true) {
    if (theOscMessage.checkTypetag("fffi")) {
      node8.v = theOscMessage.get(0).floatValue(); 
      node8.h = theOscMessage.get(1).floatValue();
      node8.exp = theOscMessage.get(2).floatValue();
      node8.isActive = theOscMessage.get(3).intValue() == 1;
    }
  }
  if (theOscMessage.checkAddrPattern("/m4l/knob8")==true) {
    if (theOscMessage.checkTypetag("f")) {
      knob8.alpha = theOscMessage.get(0).floatValue();
    }
  }
}
