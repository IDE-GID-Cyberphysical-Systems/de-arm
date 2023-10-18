/**
 * REALLY simple processing sketch for using webcam input
 * This sends 100 input values to port 6448 using message /wek/inputs.
 * Modified from Rebecca Fiebrink's example on wekinator.org
 * Sends only 100 pixels sampled from across the camera input over OSC.
 **/

import processing.video.*;
import oscP5.*;
import netP5.*;

int numPixelsOrig;
int numPixels;

int boxWidth = 64;
int boxHeight = 48;

int numHoriz = 640/boxWidth;
int numVert = 480/boxHeight;

color[] downPix = new color[numHoriz * numVert];


Capture video;

OscP5 oscP5;
NetAddress dest;

void setup() {
  size(640, 480);

  // This the default video input
  video = new Capture(this, width, height);

  // Start capturing the images from the camera
  video.start();


  numPixelsOrig = video.width * video.height;
  noStroke();

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 9000);
  dest = new NetAddress("127.0.0.1", 6448);
}

void draw() {

  if (video.available() == true) {
    video.read();
    video.loadPixels(); // Make the pixels of video available

    // the box number
    int boxNum = 0;

    // go through each row of boxes
    for (int x = 0; x < width; x += boxWidth) {
      float red = 0, green = 0, blue = 0;
      // go through each column of boxes
      for (int y = 0; y < height; y += boxHeight) {
        // sample the middle pixel
        int index = (x + boxWidth/2) + (y + boxHeight/2) * 640;
        red = red(video.pixels[index]);
        green = green(video.pixels[index]);
        blue = blue(video.pixels[index]);
        // save the value to send over OSC later
        downPix[boxNum] =  color(red, green, blue);

        // set the colour
        fill(downPix[boxNum]);

        // draw the box
        rect(x, y, boxWidth, boxHeight);
        boxNum++;
      }
    }

    // limit how frequently the OSC message is sent
    if (frameCount % 10 == 0)
      sendOsc(downPix);
  }
  // uncomment if you want to see the full camera input instead
  //image(video, 0, 0, width, height);
  fill(255);
  text("Sending 100 inputs to port 6448 using message /wek/inputs", 10, 10);
}


void sendOsc(int[] px) {
  // start a new OSC message
  OscMessage msg = new OscMessage("/wek/inputs");
  // add each pixel value to the OSC message
  for (int i = 0; i < px.length; i++) {
    msg.add(float(px[i]));
  }
  // send the OSC message
  oscP5.send(msg, dest);
}
