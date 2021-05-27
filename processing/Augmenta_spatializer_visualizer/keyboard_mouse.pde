// Keyboard and mouse event functions

boolean cmdKey = false;

void keyPressed(){
  
  if (keyCode == 157 || key == CONTROL){
    cmdKey = true;
  } else if (key == 'h' || key == 'H') {
    
    // Show/Hide Gui
    guiIsVisible=!guiIsVisible;
    showGUI(guiIsVisible);
  } else if (key == 'd' || key == 'D') {

    // Show/hide the debug info
    drawDebugData=!drawDebugData;
  } else if (keyCode == TAB) {
    
    // Go to next textfield when typing in sceneX
    if (sceneX.isFocus()){
       sceneX.setFocus(false);
       sceneY.setFocus(true);
    }
  } else if(key == 's' || key == 'S') {
     if(cmdKey) {
       saveSettings("settings");
     }
  } else if(key == 'l' || key == 'L') {
      if(cmdKey) {
        loadSettings("settings");
      }
  }
}

void mousePressed() {
  
  if (drawDebugData) {
    if (mouseButton == LEFT) {
      originX = (float)mouseX/(float)width;
      originY = (float)mouseY/(float)height;
    } else {
      auReceiver.interactiveArea.set(0f, 0f, 1f, 1f);
    }
  }
}

void mouseDragged() {

  if (drawDebugData && !mode3D) {
    if (mouseButton == LEFT) {
      float w = (float)mouseX/(float)width-originX;
      float h = (float)mouseY/(float)height-originY;
      if (w > 0 && h > 0) {
        auReceiver.interactiveArea.set(originX, originY, w, h); 
      } else if (w < 0 && h > 0) {
        auReceiver.interactiveArea.set((float)mouseX/(float)width, originY, -w, h);
      } else if (h < 0 && w > 0) {
        auReceiver.interactiveArea.set(originX, (float)mouseY/(float)height, w, -h);
      } else {
        auReceiver.interactiveArea.set((float)mouseX/(float)width, (float)mouseY/(float)height, -w, -h);
        //println("Rect : "+(float)mouseX/(float)width+" "+ (float)mouseY/(float)height+" "+ -w+" "+ -h);
      }
    }
  }
}