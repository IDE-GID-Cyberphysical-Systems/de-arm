/*
   arduino-osc-blink

   Listens for serial messages and controls the
   the on-board LED according to the message.

   To be used with the Processing sketch
   processing_osc_to_arduino.pde

   Written by Becky Stewart 2022
*/


// variable used for LED blink pattern
int blinkCode = -1;

void setup() {
  Serial.begin(9600);  // initialise the serial communication


  // initialize digital pin LED_BUILTIN as an output.
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // wait for a message to arrive
  if (Serial.available()) {
    // save the message when it arrives
    blinkCode = Serial.read();
  }

  // create two variables to control the blink patter
  int onDelay;
  int offDelay;

  switch (blinkCode) {
    case 1:
      // on one second, off a quarter second
      onDelay = 1000;
      offDelay = 250;
      break;
    case 2:
      // on a half second, off one second
      onDelay = 500;
      offDelay = 1000;
      break;
    case 3:
      // on one and a half seconds, off 50 ms
      onDelay = 1500;
      offDelay = 50;
      break;
    default:
      // default to on one second, off one second
      onDelay = 1000;
      offDelay = 1000;
      break;
  }

  digitalWrite(LED_BUILTIN, HIGH);  // turn the LED on (HIGH is the voltage level)
  delay(onDelay);                   // wait for the delayed time
  digitalWrite(LED_BUILTIN, LOW);   // turn the LED off by making the voltage LOW
  delay(offDelay);                  // wait for the delayed time
}