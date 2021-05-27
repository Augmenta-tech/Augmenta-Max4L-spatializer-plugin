import codeanticode.syphon.*; // Syphon (osx)
import spout.*; // Spout (win)
import java.util.List; // Needed for controlP5
import controlP5.*; // GUI

SyphonServer syphon_server;
Spout spout_server;
PGraphics canvas; // Syphon/Spout texture output

// GUI
boolean guiIsVisible = true;
boolean uiIsLoaded = false;
// ControlP5
ControlP5 cp5;
Toggle autoSceneSize;
Textlabel autoSizeLabel;
Textfield sceneX;
Textfield sceneY;
Textlabel sceneSizeInfo;
Textfield portInput;
Textlabel portInputLabel;

// Manual scene size info
int manualSceneX = 640; // default
int manualSceneY = 480; // default

// Used to set the interactive area
// click and drag to set a custom area, right click to set it to default (full scene)
float originX;
float originY;

AugmentaP5 auReceiver;
int oscPort = 12000;  // OSC default reception port
boolean drawDebugData = false;

void settings() {
  if (mode3D) {
    size(manualSceneX, manualSceneY, P3D);
  } else {
    size(manualSceneX, manualSceneY, P2D);
  }

  PJOGL.profile=1; // Force OpenGL2 mode for Syphon compatibility
}

void setupAugmenta() {

  // Create the Augmenta receiver
  auReceiver= new AugmentaP5(this, oscPort);
  auReceiver.setTimeOut(30); // TODO : comment needed here !
  auReceiver.setGraphicsTarget(canvas);
  // You can set the interactive area (can be set with the mouse in this example)
  //auReceiver.interactiveArea.set(0.25f, 0.25f, 0.5f, 0.5f);

  // Create the canvas that will be sent by Syphon/Spout

  if (mode3D) {
    canvas = createGraphics(width, height, P3D);
  } else {
    canvas = createGraphics(width, height, P2D);
  }
}

void setupSyphonSpout() {

  // Create a Syphon server to send frames out
  if (platform == MACOSX) {
    syphon_server = new SyphonServer(this, "Processing Syphon");
  } else if (platform == WINDOWS) {
    spout_server = new Spout(this);
    spout_server.createSender("Processing Spout", width, height);
  }
}

void setupGUI() {

  // Create GUI
  cp5 = new ControlP5(this);
  setUI();

  // Load the settings
  loadSettings("settings");
}

void showGUI(boolean val) {
  // Show or hide the GUI (always after the Syphon output)
  autoSceneSize.setVisible(val);
  autoSizeLabel.setVisible(val);
  if (autoSceneSize.getBooleanValue()) {
    sceneSizeInfo.setVisible(val);
  } else {
    sceneX.setVisible(val);
    sceneY.setVisible(val);
  }

  portInput.setVisible(val);
  portInputLabel.setVisible(val);
}

boolean changeSize(int a_width, int a_height) {
  System.out.println("Changing size");
  boolean hasChanged = false;
  int minSize = 200;
  int maxSize = 16000;

  // Check that size is correct
  if ( (canvas.width!=a_width || canvas.height!=a_height) && a_width>=minSize && a_height>=minSize && a_width<=maxSize && a_height <=maxSize ) {
    // Create the output canvas with the correct size
    if (mode3D) {
      canvas = createGraphics(a_width, a_height, P3D);
    } else {
      canvas = createGraphics(a_width, a_height, P2D);
      // Update/create SquareCanvas
      if(a_width <= a_height)
      {
        canvasSquare = createGraphics(a_width, a_width, P2D);
      } else 
      {
        canvasSquare = createGraphics(a_height, a_height, P2D);
      }

  }



    //      // Change window size if needed
    //      float ratio = (float)a_width/(float)a_height;
    //      if (a_width >= displayWidth*0.9f || a_height >= displayHeight*0.9f) {
    //        // Resize the window to fit in the screen with the correct ratio
    //        if ( ratio > displayWidth/displayHeight ) {
    //          a_width = (int)(displayWidth*0.8f);
    //          a_height = (int)(a_width/ratio);
    //        } else {
    //          a_height = (int)(displayHeight*0.8f);
    //          a_width = (int)(a_height*ratio);
    //        }
    //      }

    surface.setSize(a_width, a_height);
    //auReceiver.setGraphicsTarget(canvas);

    hasChanged = true;
    System.out.println("Size changed");
  } else if (a_width < minSize || a_height < minSize || a_width > maxSize || a_height > maxSize) {
    println("ERROR : Cannot set a window size of :" + a_width + "x" + a_height + " : smaller than " +  minSize + " or greater than " + maxSize);
  }

  return hasChanged;
}

// Called each frame, adjust the scene size depending on various parameters
boolean adjustSceneSize() {

  boolean hasChanged = false;
  int newWidth = 0;
  int newHeight = 0;

  // Auto size
  if (autoSceneSize.getBooleanValue()) {

    int[] sceneSize = g_sceneSize;
    newWidth = sceneSize[0];
    newHeight = sceneSize[1];

    if (newWidth == canvas.width && newHeight == canvas.height) {

      // If we were in Auto with default size we need to update
      if (sceneSizeInfo.get().getText() == "0 x 0")
      {
        sceneSizeInfo.setText(newWidth + " x " + newHeight);
      }
      // Same size than current size, do nothing
      hasChanged = false;
    } else if (newWidth == 0 && newHeight == 0) {

      // No data received, display 0x0 and keep current size
      sceneSizeInfo.setText("0 x 0");
      hasChanged = false;
    } else if (newWidth != canvas.width || newHeight != canvas.height) {

      // New size or same size newly received from Augmenta
      hasChanged = changeSize(newWidth, newHeight);
      // Update text only if it did change (prevent displaying wrong values)
      if (hasChanged) {
        sceneSizeInfo.setText(newWidth + " x " + newHeight);
      }
    }
  }

  return hasChanged;
}

// --------------------------------------
// Set the GUI
// --------------------------------------
void setUI() {

  //Auto scene size + manual scene size
  autoSceneSize = cp5.addToggle("changeAutoSceneSize")
    .setPosition(14, 35)
    .setSize(15, 15)
    .setLabel("")
    .setValue(false)
    ;
  autoSizeLabel = cp5.addTextlabel("labelAutoSceneSize")
    .setText("Auto size")
    .setPosition(30, 41)
    ;
  sceneX = cp5.addTextfield("changeSceneWidth")
    .setPosition(100, 35)
    .setSize(30, 20)
    .setAutoClear(false)
    .setCaptionLabel("")
    .setInputFilter(ControlP5.INTEGER);
  ;

  sceneX.setText(""+width);
  sceneY = cp5.addTextfield("changeSceneHeight")
    .setPosition(130, 35)
    .setSize(30, 20)
    .setAutoClear(false)
    .setCaptionLabel("")
    .setInputFilter(ControlP5.INTEGER);
  ;
  sceneY.setText(""+height);
  sceneSizeInfo = cp5.addTextlabel ("label")
    .setText(width+" x "+height)
    .setPosition(96, 41)
    ;
  sceneSizeInfo.setVisible(false);

  // Port input OSC
  portInput = cp5.addTextfield("changeInputPort")
    .setPosition(100, 10)
    .setSize(40, 20)
    .setAutoClear(false)
    .setCaptionLabel("")
    .setInputFilter(ControlP5.INTEGER);
  ;
  portInput.setText(""+oscPort);
  portInputLabel = cp5.addTextlabel("labeloscport")
    .setText("OSC input port")
    .setPosition(10, 16)
    ;
}
// --------------------------------------


// --------------------------------------
// GUI change handlers
// --------------------------------------
void changeSceneWidth(String s) {
  updateManualSize();
}
void changeSceneHeight(String s) {
  updateManualSize();
}
void updateManualSize() {
  try {
    manualSceneX = Integer.parseInt(sceneX.getText());
    manualSceneY = Integer.parseInt(sceneY.getText());
  } 
  catch(Exception e) {
    return;
  }

  // If new size requested, change it
  if (manualSceneX != canvas.width || manualSceneY != canvas.height) {
    changeSize(manualSceneX, manualSceneY);
  }
}
void changeAutoSceneSize(boolean b) {
  if (sceneSizeInfo != null && sceneX != null && sceneY != null) {
    if (b) {
      sceneSizeInfo.setVisible(true);
      sceneX.setVisible(false);
      sceneY.setVisible(false);
    } else {
      sceneSizeInfo.setVisible(false);
      sceneX.setVisible(true);
      sceneY.setVisible(true);
    }
  }
}
public void changeInputPort(String s) {
  try {
    oscPort = Integer.parseInt(s);
  } 
  catch(Exception e) {
    return;
  }
  reconnectReceiver();
}

public void reconnectReceiver() {
  if (portInput != null && auReceiver != null) { // Sanity check
    auReceiver.reconnect(oscPort);
  }
}
// --------------------------------------


// --------------------------------------
// Save / Load
// --------------------------------------
void saveSettings(String file) {
  println("Saving to : "+file);
  cp5.saveProperties(file);
}

void loadSettings(String file) {
  println("Loading from : "+file);
  cp5.loadProperties(file);
  // After load force the textfields callbacks
  List<Textfield> list = cp5.getAll(Textfield.class);
  for (Textfield b : list) {
    b.submit();
  }
}
// --------------------------------------

void drawAugmenta() {

  // Draw debug data on top with [d] key
  if (drawDebugData) {
    AugmentaObject[] objects = auReceiver.getObjectsArray();
    for (int i=0; i<objects.length; i++) {
      System.out.println("Debug draw");
      objects[i].draw();
    }
  }

  // Draw interactive area
  if (drawDebugData) {
    //String s = auReceiver.interactiveArea.area.x + "," + auReceiver.interactiveArea.area.y + "," + auReceiver.interactiveArea.area.width + "," + auReceiver.interactiveArea.area.height;
    //System.out.println(s);
    //auReceiver.interactiveArea.draw();
  }
}

// --------------------------------------
// Exit function (This way of handling the exit of the app works everywhere except in the editor)
// --------------------------------------
void exit() {
  // Save the settings on exit
  saveSettings("settings");

  // Add custom code here
  // ...

  // Finish by forwarding the exit call
  super.exit();
}
// --------------------------------------

void sendFrames() { 
  if (platform == MACOSX) {
    syphon_server.sendImage(canvas);
  } else if (platform == WINDOWS) {
    spout_server.sendTexture(canvas);
  }
}
