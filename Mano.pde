import de.voidplus.leapmotion.*;
import oscP5.*;
import netP5.*;

LeapMotion leap;
int num=0;
OscP5 oscP5;
NetAddress dest;
PFont font;
int   fontSize = 30;


void setup() {
  size(800, 500);
  background(255); //black background
  //talk to our wekinator friend
  oscP5 = new OscP5(this, 9000);
  dest = new NetAddress("127.0.0.1", 6448);
  //set up a font for printing online
  font = createFont("NexaLight-16.vlw", fontSize, true);
  textFont(font, fontSize);
  //init leap
  leap = new LeapMotion(this);
  //set up var names
  sendInputNames();
}

void draw() {
  background(0);stroke(255);
  // ========= HANDS =========
  if (leap.countHands() == 2) //we can only send data when Leap sees both hands
  {
    ArrayList<Hand> hands = leap.getHands();
    Hand firstHand = hands.get(0);
    Hand secondHand = hands.get(1);
    OscMessage msg = new OscMessage("/wek/inputs");
    String currentPars = "";
    println("");
    println("SENDING FEATURES");
    for (int i = 0; i < 5; i++) {
      Finger firstFinger = firstHand.getFinger(i);
      Finger secondFinger = secondHand.getFinger(i);
      float dist = firstFinger.getPositionOfJointTip().dist(secondFinger.getPositionOfJointTip());
      print(dist + ",");  
      if(i>0){
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


void sendInputNames() {
  OscMessage msg = new OscMessage("/wekinator/control/setInputNames");
  String[] fingerNames = {"thumb", "index", "middle", "ring", "pinky"};
  for (int i = 0; i < fingerNames.length; i++) {
    msg.add(fingerNames[i] + "_delta");
  }
  oscP5.send(msg, dest); 
  println("Sent finger distances names");
}