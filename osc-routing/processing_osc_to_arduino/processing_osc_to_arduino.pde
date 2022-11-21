/*
  processing_osc_to_arduino
 
 Listens for OSC messages and sends a Serial message
 to the Arduino.
 
 To be used with the Arduino sketch
 arduino-osc-blink.ino
 
 Expects one output from Wekinator with a classifier 
 of up to 3 classes. More than 3 classes will result
 only in the default blinking.
 
 Written by Becky Stewart 2022
 */

import oscP5.*;
import netP5.*;
import processing.serial.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

Serial port;

int arduinoMessage = -1;

void setup() {
  size(256, 150);
  println("Available serial ports:");
  // print the list of available ports
  printArray(Serial.list());

  // Uses the printed list of ports to choose which number your board is connected to.
  // Change the below line Serial.list()[X] to your selected port, replacind X with
  // your number.
  // The last parameter (e.g. 9600) is the speed of the communication. It has to
  // correspond to the value passed to Serial.begin() in your Arduino sketch.
  port = new Serial(this, Serial.list()[1], 9600);

  // If you know the name of the port used by the Arduino board, you can specify
  // it directly like this.
  //port = new Serial(this, "COM1", 9600);

  // Start oscP5 and listen for incoming messages at port 12000
  oscP5 = new OscP5(this, 12000);
}


void draw() {
  // draw a gradient from black to white
  // it doesn't do anything, just to fill the window
  for (int i = 0; i < 256; i++) {
    stroke(i);
    line(i, 0, i, 150);
  }

  // write the current X-position of the mouse to the serial port 
  // useful for debugging, may want to comment out when listening
  // for osc messages
  //int mouseMessage = (int)map(mouseX, 0, 256, 0, 4);
  //updateArduino(mouseMessage);
  
}


void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */

  if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
    /* check if the typetag is the right one. */
    if (theOscMessage.checkTypetag("f")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      float firstValue = theOscMessage.get(0).floatValue();
      print("### received an osc message /test with typetag f.");
      println(" values: "+firstValue);

      updateArduino((int)firstValue);
      return;
    }
  }
  println("### received an osc message. with address pattern "+theOscMessage.addrPattern());
}

// send a new message to the Arduino
void updateArduino(int newMessage) {
  // check that the message is different from the last one sent
  if ( newMessage != arduinoMessage ) {
    // if so then update the message
    arduinoMessage = newMessage;
    // print for debugging convenience
    println(arduinoMessage);
    // send the message to the Arduino
    port.write(arduinoMessage);
  }
}
