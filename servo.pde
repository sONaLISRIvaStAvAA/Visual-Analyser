import processing.serial.*; // Imports library for serial communication //<>//
import java.awt.event.KeyEvent; // Imports library for reading key events (not used in this code)
import java.io.IOException; // Imports library for handling input/output exceptions (not used in this code)
Serial myPort; // Defines an object for Serial communication
String angle=""; // Stores the angle received from Arduino
String distance=""; // Stores the distance received from Arduino
String data=""; // Stores raw data received from Arduino
String noObject; // Stores whether an object is in range or not
float pixsDistance; // Converts distance (cm) to pixels for visualization
int iAngle, iDistance; // Integer versions of angle and distance
int index1=0; // Stores position of ',' in received data
int index2=0; // Not used
PFont orcFont; // Font (not used in the current code)
void setup() {
  size (2000, 1000); // Sets window size to 1200x700 pixels
  smooth(); // Enables anti-aliasing for smoother graphics
  myPort = new Serial(this, "COM6", 9600); // Initializes Serial communication on COM7 at 9600 baud
  myPort.bufferUntil('.'); // Reads serial data until '.' is received
}
void draw() {
  fill(98, 245, 31); // Sets color to green

  // Simulates motion blur and slow fade effect
  noStroke(); 
  fill(0, 4);  
  rect(0, 0, width, height-height*0.065); 

  fill(98, 245, 31); // Green color
  drawRadar(); // Draws the radar structure
  drawLine();  // Draws the scanning line
  drawObject(); // Draws detected objects
  drawText(); // Displays angle, distance, and labels
}
void serialEvent (Serial myPort) {
  data = myPort.readStringUntil('.'); // Reads serial data until '.'
  data = data.substring(0, data.length()-1); // Removes the last character (.)

  index1 = data.indexOf(","); // Finds position of ','
  angle = data.substring(0, index1); // Extracts angle value
  distance = data.substring(index1+1, data.length()); // Extracts distance value

  iAngle = int(angle); // Converts angle to integer
  iDistance = int(distance); // Converts distance to integer
}
void drawRadar() {
  pushMatrix();
  translate(width/2, height-height*0.074); // Moves origin to radar center
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31); // Green lines

  // Draws concentric arcs representing distance markers
  arc(0, 0, (width-width*0.0625), (width-width*0.0625), PI, TWO_PI);
  arc(0, 0, (width-width*0.27), (width-width*0.27), PI, TWO_PI);
  arc(0, 0, (width-width*0.479), (width-width*0.479), PI, TWO_PI);
  arc(0, 0, (width-width*0.687), (width-width*0.687), PI, TWO_PI);

  // Draws angle lines
  line(-width/2, 0, width/2, 0);
  line(0, 0, (-width/2)*cos(radians(30)), (-width/2)*sin(radians(30)));
  line(0, 0, (-width/2)*cos(radians(60)), (-width/2)*sin(radians(60)));
  line(0, 0, (-width/2)*cos(radians(90)), (-width/2)*sin(radians(90)));
  line(0, 0, (-width/2)*cos(radians(120)), (-width/2)*sin(radians(120)));
  line(0, 0, (-width/2)*cos(radians(150)), (-width/2)*sin(radians(150)));
  
  popMatrix();
}
void drawObject() {
  pushMatrix();
  translate(width/2, height-height*0.074); 
  strokeWeight(9);
  stroke(255, 10, 10); // Red color

  pixsDistance = iDistance * ((height-height*0.1666) * 0.025); // Converts cm to pixels

  if (iDistance < 300) { // Draw object only if within range
    line(pixsDistance*cos(radians(iAngle)), -pixsDistance*sin(radians(iAngle)), 
        (width-width*0.505)*cos(radians(iAngle)), -(width-width*0.505)*sin(radians(iAngle)));
  }
  popMatrix();
}
void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30, 250, 60);
  translate(width/2, height-height*0.074);
  line(0, 0, (height-height*0.12)*cos(radians(iAngle)), -(height-height*0.12)*sin(radians(iAngle)));
  popMatrix();
}
void drawText() {
  pushMatrix();
  if (iDistance > 300) {
    noObject = "Out of Range";
  } else {
    noObject = "In Range";
  }

  fill(0, 0, 0);
  noStroke();
  rect(0, height-height*0.0648, width, height); // Black background for text
  fill(98, 245, 31);
  textSize(25);

  text("10cm", width-width*0.3854, height-height*0.0833);
  text("20cm", width-width*0.281, height-height*0.0833);
  text("30cm", width-width*0.177, height-height*0.0833);
  text("40cm", width-width*0.0729, height-height*0.0833);
  textSize(40);
  text("Angle: " + iAngle, width-width*0.48, height-height*0.0277);
  text("Distance: " + (iDistance < 300 ? iDistance + " cm" : ""), width-width*0.26, height-height*0.0277);
  popMatrix();
}
