import processing.video.*;
import processing.serial.*;
import ddf.minim.*;

/**
 * Global Main Variables
 */
// Main Window Size
int WIDTH = 900,
    HEIGHT = 700;

// Detect for current status.
boolean alertPage = false,
        startingPage = true,
        selectingSongs = false,
        playingGame = false,
        endingGame = false;
        
int score = 0,
    highscore = 0;
    
PImage left, right, up, down;

Minim minim;
AudioPlayer soundTrack;
    
// Arduino Object
Serial arduino;
int signal;
        
/**
 * DEBUG = true
 *   - Output debug logs in console.
 *
 * DEBUG = false
 *   - Disable
 */
boolean DEBUG = false;

/**
 * PROCESSING_ONLY = true
 *   - Only run processing's code without Arduino's function.
 *
 * PROCESSING_ONLY = false
 *   - Need Arduino connected and set correct COM port to run.
 */
boolean PROCESSING_ONLY = true;

/**
 * KEYBOARD_MODE = true
 *   - Allow control from keyboard (use to test).
 *
 * KEYBOARD_MODE = false
 *   - Disable keyPressd detect, only control by Arduino.
 */
boolean KEYBOARD_MODE = true;

void setup(){
  size(900, 700);
  background(255);
  frameRate(60);
  
  // Arduino Com port
  if(!PROCESSING_ONLY){
    if(DEBUG) println(Serial.list());
   
    // Check for COM port and update here.
    String portName = Serial.list()[1];
    arduino = new Serial(this, portName, 9600);
  }
  
  // Set custom pixel font
  PFont pixelFont;
  pixelFont = createFont("font/Pixel.otf", 50);
  textFont(pixelFont);
  
  minim = new Minim(this);
  // load starting page soundTrack
  soundTrack = minim.loadFile("songs/soundTrack.mp3");
  
  // Load gameplay arrow image
  left = loadImage("images/arrows/left.png");
  right = loadImage("images/arrows/right.png");
  up = loadImage("images/arrows/up.png");
  down = loadImage("images/arrows/down.png");
}

void draw(){
  if(!PROCESSING_ONLY){
    // Arduino not connected and alert.
    if(arduino.available() < 0){
       alertPage = true;
       startingPage = false;
    }
    
    // Arduino connected and read the output.
    if(arduino.available() > 0){
      signal = arduino.read();
      arduinoSignal(signal);
    }
  }
  
  if(alertPage) showAlertPage();
  if(startingPage) startPage();
  if(selectingSongs) selectSongs();
  if(playingGame) play();
  if(endingGame) drawEndScreen();
}