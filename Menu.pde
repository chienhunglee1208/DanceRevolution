/**
 * Global Variables in this file.
 */
int alphaValue = 510;
int songID = 1, 
    leftID = 0, 
    rightID = 0, 
    maxSongs = 3,
    minSongs = 1,
    coverWidth = 400, 
    coverHeight = 400;
    
int[] TEXT_COLOR = {255, 1, 255};
    
boolean clipPlayed = false;

AudioPlayer clip;

/**
 * Main page for the game.
 * Wait for any key pressed to continue.
 */
void startPage() {
  if (startingPage) {
    soundTrack.play();
    
    PImage startPageBG;
    startPageBG = loadImage("images/startPage.jpg");
    image(startPageBG, -500, 0);

    // Game Title
    noStroke();
    fill(255, 0, 255, 200);
    rect(25, HEIGHT - 400, 850, 125);

    textSize(80);
    fill(255, 255, 255);
    text("DANCE REVOLUTION", WIDTH / 15, HEIGHT - 365, 900, 700);

    // Press Any Key Message
    textSize(50);
    fill(255, 255, 255, alphaValue);
    text("Pressed Down To Start", WIDTH / 6, HEIGHT - 150);
    alphaValue -= 255;

    if (DEBUG) println("alphaValue = " + alphaValue);

    if (alphaValue <= -510) alphaValue = 510;
  }
}

/**
 * The page for player to select a song.
 */
void selectSongs() {
  if (selectingSongs) {
    background(255);

    tint(255, 50);
    PImage startPageBG;
    startPageBG = loadImage("images/startPage.jpg");
    image(startPageBG, -500, 0);

    if (DEBUG) println("Selected songID = " + songID);
    
    /**
     * @TODO
     * Play selected song's preview clip music. (loop)
     */

    leftID = songID - 1;
    rightID = songID + 1;
    if (songID - 1 < minSongs) leftID = maxSongs;
    if (songID + 1 > maxSongs) rightID = 1;
    
    PImage album;
    // Left song
    tint(255, 120);
    album = loadImage("images/cover/" + leftID + ".jpg");
    image(album, WIDTH / 2 - coverWidth, HEIGHT / 2 - coverHeight / 2 + 25, coverWidth - 50, coverHeight - 50);

    // Right song
    tint(255, 120);
    album = loadImage("images/cover/" + rightID + ".jpg");
    image(album, WIDTH / 2 + coverWidth / 6, HEIGHT / 2 - coverHeight / 2 + 25, coverWidth - 50, coverHeight - 50);

    // Selected song
    tint(255, 255);
    album = loadImage("images/cover/" + songID + ".jpg");
    image(album, WIDTH / 2 - coverWidth / 2, HEIGHT / 2 - coverHeight / 2, coverWidth, coverHeight);
    
    // Left & right arrow
    PImage selectArrow;
    selectArrow = loadImage("images/selectArrowLeft.png");
    image(selectArrow, -10, HEIGHT / 2 - 50, 100, 100);
    selectArrow = loadImage("images/selectArrowRight.png");
    image(selectArrow, WIDTH - 90, HEIGHT / 2 - 50, 100, 100);
    
    textSize(50);
    fill(1, 1, 1, alphaValue);
    text("Press Up to select a song.", WIDTH / 7, HEIGHT - 50);
    alphaValue -= 255;

    if (alphaValue <= -510) alphaValue = 510;
    
    // Play the preview music clip
    if(!clipPlayed){
      clip = minim.loadFile("songs/clips/" + songID + ".mp3");
      clip.rewind();
      clip.play();
      clipPlayed = true;
    }
  }
}

/**
 * Alert player Arduino is not connected.
 * 
 */
void showAlertPage(){
  if(alertPage){
    background(255);
    
    /**
     * @TODO
     * Design the alert page.
     */
  }
}

void keyPressed() {
  if(KEYBOARD_MODE){
    if(keyCode == ESC) exit();
  
    /**
     * Press any key except ENTER to continue from the main page.
     *
     * keycode:
     *   - Anykey(except ENTER)
     *
     * Go to the page to select a song.
     */
    if (startingPage && keyCode != ENTER) {
      minim.stop();
      selectingSongs = true;
      startingPage = false;
    }
  
    /**
     * Press LEFT or RIGHT to select the song
     * and press ENTER to confired selete a song.
     *
     * keyCode:
     *   - LEFT
     *   - RIGHT
     *   - ENTER
     *
     * Go to the page to start the game.
     */
    if (selectingSongs) {
      if (keyCode == LEFT) {
        minim.stop();
        clipPlayed = false;
        songID--;
        if (songID < minSongs) songID = maxSongs;
      }
      if (keyCode == RIGHT) {
        minim.stop();
        clipPlayed = false;
        songID++;
        if (songID > maxSongs) songID = minSongs;
      }
      if(keyCode == ENTER){
        minim.stop();
        clipPlayed = false;
        selectingSongs = false;
        playingGame = true;
      }
    }
    
    /**
     * Gaming control.
     *
     * keyCode:
     *   - LEFT
     *   - RIGHT
     *   - UP
     *   - DOWN
     */
    if(playingGame){
       if(DEBUG) println("Start playing game.");
       if(keyCode == UP) detect("up");
       if(keyCode == DOWN) detect("down");
       if(keyCode == LEFT) detect("left");
       if(keyCode == RIGHT) detect("right");
     }
     
     if(endingGame){
       if(keyCode == UP) backToMenu();
       if(keyCode == DOWN) exit();
     }
  } 
}

/**
 * Arduino signal detect.
 *
 * 1 = LEFT
 * 2 = DOWN
 * 3 = UP
 * 4 = RIGHT
 */
void arduinoSignal(int signal){
  if(!PROCESSING_ONLY){
    if (startingPage && signal == 2) {
      minim.stop();
      selectingSongs = true;
      startingPage = false;
    }
    
    if (selectingSongs) {
      if (signal == 1) {
        println("LEFT");
        minim.stop();
        clipPlayed = false;
        songID--;
        if (songID < minSongs) songID = maxSongs;
      }
      if (signal == 4) {
        minim.stop();
        clipPlayed = false;
        songID++;
        if (songID > maxSongs) songID = minSongs;
      }
      if(signal == 3){
        minim.stop();
        clipPlayed = false;
        selectingSongs = false;
        playingGame = true;
      }
    }
    
    if(playingGame){
       if(DEBUG) println("Start playing game.");
       if(signal == 3) detect("up");
       if(signal == 2) detect("down");
       if(signal == 1) detect("left");
       if(signal == 4) detect("right"); 
     }
     
     if(endingGame){
       if(signal == 3) backToMenu();
       if(signal == 2) exit();
     }
  }
}