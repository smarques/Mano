import de.voidplus.leapmotion.*;
import oscP5.*;
import netP5.*;
import controlP5.*;

LeapMotion leap;
int num=0;
OscP5 oscP5;
NetAddress dest;
PFont font, fontSmall;
int   fontSize = 30, fontSizeSmall = 12;
ControlP5 cp5;
boolean isRecording = true; //mode
boolean isRecordingNow = true;
int currentClass = 1;
int alpha = 0;
String[] messageNames = {"/output_1", "/output_2", "/output_3", "/output_4", "/output_5", "/output_6", "/output_7", "/output_8", "/output_9" }; //message names for each DTW gesture type
int receivedClass = 1;
Toggle workingMode;
int wekinatorReceivePort = 6448;
int processingReceivePort = 12000;
WekinatorProxy wp;

void setup() {
  size(800, 500);
  background(255); //black background
  //talk to our wekinator friend
  oscP5 = new OscP5(this, 12000);
  wp = new WekinatorProxy(oscP5);
  dest = new NetAddress("127.0.0.1", wekinatorReceivePort);
  //set up a font for printing online
  font = createFont("NexaLight-16.vlw", fontSize, true);
  fontSmall = createFont("NexaLight-16.vlw", fontSizeSmall, true);
  textFont(font, fontSize);
  //init leap
  leap = new LeapMotion(this);
  //set up var names
  sendInputNames();
  createControls();
  toggleRecording();
}

void createControls() {
  cp5 = new ControlP5(this);
  workingMode = cp5.addToggle("isRecording")
    .setPosition(700, 20)
    .setSize(75, 20)
    .setValue(true)
    .setCaptionLabel("record/run")
    .setMode(ControlP5.SWITCH)
    ;
}

void toggleRecording() {
  isRecording = !isRecording;
  workingMode.setValue(isRecording);
  if (isRecording) {
    wp.startRunning();
    wp.startRecording();
    sendCurrentClass();
  } else {
    wp.stopRecording();
    wp.startRunning();
  }
}

void sendCurrentClass(){
  //wp.setClass(currentClass);
}

void keyPressed() {
  print(keyCode); 
  if (key >= '1' && key <= '9') {
    currentClass = key - '1' + 1;
    sendCurrentClass();
  } else if (key == ' ') {
    toggleRecording();
  }
}

void draw() {
  background(0);
  stroke(255);
  drawText();
  sendInputs();
}

void sendInputs() {
  // ========= HANDS =========
  if (leap.countHands() == 2) //we can only send data when Leap sees both hands
  {

    ArrayList<Hand> hands = leap.getHands();
    Hand firstHand = hands.get(0);
    Hand secondHand = hands.get(1);
    OscMessage msg = new OscMessage("/wek/inputs");
    String currentPars = "";
    println("SENDING FEATURES");
    for (int i = 0; i < 5; i++) {
      Finger firstFinger = firstHand.getFinger(i);
      Finger secondFinger = secondHand.getFinger(i);
      float dist = firstFinger.getPositionOfJointTip().dist(secondFinger.getPositionOfJointTip());
      print(dist + ",");  
      if (i>0) {
        currentPars +=",";
      }
      currentPars += "dist";
      msg.add(dist);
      //draw histogram
      fill(220);
      rect(100*i+20, 20, 20, dist);
      //draw value
      fill(250);
      text(""+Math.round(dist), 100*i+20, 400, 100, 150);
    }

    oscP5.send(msg, dest);
  }
}


void drawText() {
  fill(255);
  textFont(fontSmall);
  String msg;
  if (isRecording) {
    msg = "Run Wekinator with 5 inputs (distance between thumbs, index fingers, ring fingers etc), 1 DTW output";
    msg += "Place your hands in Leap Motions's sight to record\n";
    msg += "Space bar toggles working mode";
  } else {
    msg = "Do your hand dance baby";
  } 
  text(msg, 580, 80, 200, 300);

  if (!isRecording) {
    //Draw received value
    textFont(font, 140);
    fill(0, 255, 0, alpha);
    text(receivedClass, 600, 350);
    alpha -= 10;
  }
}

void sendInputNames() {
  OscMessage msg = new OscMessage("/wekinator/control/setInputNames");
  String[] fingerNames = {"thumb", "index", "middle", "ring", "pinky"};
  for (int i = 0; i < fingerNames.length; i++) {
    msg.add(fingerNames[i] + "_delta");
  }
  oscP5.send(msg, dest); 
  println("Sent finger distances names");
}

void oscEvent(OscMessage theOscMessage) {
  for (int i = 0; i < 9; i++) {
    if (theOscMessage.checkAddrPattern(messageNames[i]) == true) {
      showMessage(i);
    }
  }
}
void showMessage(int i) {
  alpha = 255;
  receivedClass = i+1;
}