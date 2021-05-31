
import augmenta.*;
import oscP5.*;

// Visualize data from Augmenta single spatializer through a Syphon/Spout output

OscP5 myosc;

boolean mode3D = false;


float value;
float x, y, r, g, b;
float h1, h2, h3, h4, h5, exe, h6, h7, h8;
float v1, v2, v3, v4, v5, v6, v7, v8;
float exp1, exp2, exp3, exp4, exp5, exp6, exp7, exp8;
float alpha1, alpha2, alpha3, alpha4, alpha5, alpha6, alpha7, alpha8;
int active1, active2, active3, active4, active5, active6, active7, active8;

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

  // Draw point
  //_mycanvas.fill(r*255, g*255, b*255, a*320);  //   with color
  _mycanvas.fill(255); // white point
  _mycanvas.ellipse(x*w, y*h, 50, 50);

  //node 1
  if (active1 == 1)
  {

    _mycanvas.fill(0.384*255, 0.996*255, 0.384*255, alpha1*320);  //   Set fill to gray
    _mycanvas.noStroke();
    _mycanvas.ellipse(v1*w, h1*h, exp1*2*w, exp1*2*h);
  }

  // node 2
  if (active2 == 1)
  {
    _mycanvas.fill(0.998*255, 0, 0, alpha2*320);
    _mycanvas.noStroke();
    _mycanvas.ellipse(v2*w, h2*h, exp2*2*w, exp2*2*h);
  }

  // node 3
  if (active3 == 1)
  {
    _mycanvas.fill(0.427*255, 0.843*255, 255, alpha3*320);
    _mycanvas.noStroke();
    _mycanvas.ellipse(v3*w, h3*h, exp3*2*w, exp3*2*h);
  }

  // node 4
  if (active4 == 1)
  {
    _mycanvas.fill(0.439*255, 0.624*255, 0.075*255, alpha4*320);
    _mycanvas.noStroke();
    _mycanvas.ellipse(v4*w, h4*h, exp4*2*w, exp4*2*h);
  }

  // node 5
  if (active5 == 1)
  {
    _mycanvas.fill(0.969*255, 0.686*255, 0.184*255, alpha5*255);
    _mycanvas.noStroke();
    _mycanvas.ellipse(v5*w, h5*h, exp5*2*w, exp5*2*h);
  }

  // node 6
  if (active6 == 1)
  {
    _mycanvas.fill(0.733*255, 0.035*255, 0.788*255, alpha6*255);
    _mycanvas.noStroke();
    _mycanvas.ellipse(v6*w, h6*h, exp6*2*w, exp6*2*h);
  }

  // node 7
  if (active7 == 1)
  {
    _mycanvas.fill(0.882*255, 0.243*255, 0.149*255, alpha7*255);
    _mycanvas.noStroke();
    _mycanvas.ellipse(v7*w, h7*h, exp7*2*w, exp7*2*h);
  }

  // node 8
  if (active8 == 1)
  {
    _mycanvas.fill(0.027*255, 0.451*255, 0.506*255, alpha8*255);
    _mycanvas.noStroke();
    _mycanvas.ellipse(v8*w, h8*h, exp8*2*w, exp8*2*h);
  }
}

void oscEvent(OscMessage theOscMessage) {

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
      println("xy : "+x + y);
    }
  }
  

  //node 1
  if (theOscMessage.checkAddrPattern("/m4l/node1")==true)
  {
    if (theOscMessage.checkTypetag("fffi"))
    {
      v1 = theOscMessage.get(0).floatValue();
      h1 = theOscMessage.get(1).floatValue();
      exp1 = theOscMessage.get(2).floatValue();
      active1 = theOscMessage.get(3).intValue();
    }
  }
  if (theOscMessage.checkAddrPattern("/m4l/knob1")==true)
  {
    if (theOscMessage.checkTypetag("f"))
    {
      alpha1 = theOscMessage.get(0).floatValue();
    }
  }

  //node 2

  if (theOscMessage.checkAddrPattern("/m4l/node2")==true) {
    if (theOscMessage.checkTypetag("fffi")) {
      v2 = theOscMessage.get(0).floatValue(); 
      h2 = theOscMessage.get(1).floatValue();
      exp2 = theOscMessage.get(2).floatValue();
      active2 = theOscMessage.get(3).intValue();
    }
  }
  if (theOscMessage.checkAddrPattern("/m4l/knob2")==true) {
    if (theOscMessage.checkTypetag("f")) {
      alpha2 = theOscMessage.get(0).floatValue();
    }
  }

  //node 3

  if (theOscMessage.checkAddrPattern("/m4l/node3")==true) {
    if (theOscMessage.checkTypetag("fffi")) {
      v3 = theOscMessage.get(0).floatValue(); 
      h3 = theOscMessage.get(1).floatValue();
      exp3 = theOscMessage.get(2).floatValue();
      active3 = theOscMessage.get(3).intValue();
    }
  }
  if (theOscMessage.checkAddrPattern("/m4l/knob3")==true) {
    if (theOscMessage.checkTypetag("f")) {
      alpha3 = theOscMessage.get(0).floatValue();
    }
  }

  //node 4

  if (theOscMessage.checkAddrPattern("/m4l/node4")==true) {
    if (theOscMessage.checkTypetag("fffi")) {
      v4 = theOscMessage.get(0).floatValue(); 
      h4 = theOscMessage.get(1).floatValue();
      exp4 = theOscMessage.get(2).floatValue();
      active4 = theOscMessage.get(3).intValue();
    }
  }
  if (theOscMessage.checkAddrPattern("/m4l/knob4")==true) {
    if (theOscMessage.checkTypetag("f")) {
      alpha4 = theOscMessage.get(0).floatValue();
    }
  }

  //node 5

  if (theOscMessage.checkAddrPattern("/m4l/node5")==true) {
    if (theOscMessage.checkTypetag("fffi")) {
      v5 = theOscMessage.get(0).floatValue(); 
      h5 = theOscMessage.get(1).floatValue();
      exp5 = theOscMessage.get(2).floatValue();
      active5 = theOscMessage.get(3).intValue();
    }
  }
  if (theOscMessage.checkAddrPattern("/m4l/knob5")==true) {
    if (theOscMessage.checkTypetag("f")) {
      alpha5 = theOscMessage.get(0).floatValue();
    }
  }

  //node 6

  if (theOscMessage.checkAddrPattern("/m4l/node6")==true) {
    if (theOscMessage.checkTypetag("fffi")) {
      v6 = theOscMessage.get(0).floatValue(); 
      h6 = theOscMessage.get(1).floatValue();
      exp6 = theOscMessage.get(2).floatValue();
      active6 = theOscMessage.get(3).intValue();
    }
  }
  if (theOscMessage.checkAddrPattern("/m4l/knob6")==true) {
    if (theOscMessage.checkTypetag("f")) {
      alpha6 = theOscMessage.get(0).floatValue();
    }
  }

  //node 7

  if (theOscMessage.checkAddrPattern("/m4l/node7")==true) {
    if (theOscMessage.checkTypetag("fffi")) {
      v7 = theOscMessage.get(0).floatValue(); 
      h7 = theOscMessage.get(1).floatValue();
      exp7 = theOscMessage.get(2).floatValue();
      active7 = theOscMessage.get(3).intValue();
    }
  }
  if (theOscMessage.checkAddrPattern("/m4l/knob7")==true) {
    if (theOscMessage.checkTypetag("f")) {
      alpha7 = theOscMessage.get(0).floatValue();
    }
  }

  //node 8

  if (theOscMessage.checkAddrPattern("/m4l/node8")==true) {
    if (theOscMessage.checkTypetag("fffi")) {
      v8 = theOscMessage.get(0).floatValue(); 
      h8 = theOscMessage.get(1).floatValue();
      exp8 = theOscMessage.get(2).floatValue();
      active8 = theOscMessage.get(3).intValue();
    }
  }
  if (theOscMessage.checkAddrPattern("/m4l/knob8")==true) {
    if (theOscMessage.checkTypetag("f")) {
      alpha8 = theOscMessage.get(0).floatValue();
    }
  }
}
