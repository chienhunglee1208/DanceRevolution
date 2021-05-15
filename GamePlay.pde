int MAXLINE = 0,
    count = 0,
    bonus = 1,
    combo = 0,
    DRUG_MODE = 0;

boolean loadComplete = false;
boolean newHighScore = false;

Movie mv;
AudioPlayer drum;
    
arrow[][] data = new arrow[100000][4];

void play(){
  if(DEBUG) println("Player selected songID is " + songID);
    
  loadGameData();
  drawPlayScreen();
  mv.play();
  
  if(count == 0){
    playingGame = false;
    endingGame = true;
  }else{
    for(int i = 0 ; i < MAXLINE ; i++){
      for(int j = 0 ; j < 4 ; j++){
         data[i][j].display();
         data[i][j].move();
      }
    }
  }
}

void loadGameData(){
  if(!loadComplete){
    // Load highscore
    String s[] = loadStrings("songs/highscore/" + songID + ".txt");
    highscore = Integer.valueOf(s[0]).intValue();
    
    // Load Song data
    String line[] = loadStrings("songs/" + songID + ".txt");
    
    DRUG_MODE = 0;
    count = 0;
    
    MAXLINE = line.length;
    for(int i = 0 ; i < line.length ; i++){
      if(DEBUG) println(line[i]);
      
      for(int j = 0 ; j < 4 ; j++){
        if(line[i].charAt(j) == '1'){
          data[i][j] = new arrow(i, j, true);
          DRUG_MODE++;
          count++;
        }else
          data[i][j] = new arrow(i, j, false);
      }
    }
    
    if(DEBUG) println("DRUG_MODE = " + DRUG_MODE);
    if(DEBUG) println("count = " + count);
    
    mv = new Movie(this, "videos/" + songID + ".mov");
    mv.speed(1.0);
    mv.frameRate(30);
    
    loadComplete = true;
  }
}

void drawPlayScreen(){
  // drug mode
  if(combo >= DRUG_MODE / 8) tint(255, 20);
  else if(combo >= DRUG_MODE / 16) tint(255, 50);
  else tint(255, 255);
    
  image(mv, -180, 0);
 
  tint(255, 255); 
  fill(1);
  stroke(1);
  
  tint(255, 255);
  
  stroke(1);
  strokeWeight(10);
  fill(TEXT_COLOR[songID - 1]);
  textSize(25);
  text("Highest", 790, 30);
  textSize(50);
  text("Score", 745, 120);
  if(score >= highscore){
    newHighScore = true;
    fill(255, 0, 0);
    highscore = score;
  }
    
  textSize(25);
  text(nf(highscore, 9), 745, 60);
  textSize(50);
  text(nf(score, 9), 610, 170);
    
  fill(TEXT_COLOR[songID - 1]);
  text("Combo", 725, 620);
  text(nf(combo, 3), 790, 680);
  
  // play screen arrow
  image(left, bottomLeft, bottom, arrW, arrH);
  image(down, bottomLeft + arrW + 50, bottom, arrW, arrH);
  image(up, bottomLeft + 2 * arrW + 2 * 50, bottom, arrW, arrH);
  image(right, bottomLeft + 3 * arrW + 3 * 50, bottom, arrW, arrH);
  
}

void drawEndScreen(){
  // Update Highscore
  if(newHighScore){
    newHighScore = false;
    PrintWriter output;
    output = createWriter("data/songs/highscore/" + songID + ".txt");
    output.println(highscore);
    output.flush();
    output.close();
  }
  
  mv.stop();
  drawPlayScreen();
  fill(0, 0, 0, 200);
  rect(0, 0, 900, 700);
  fill(255);
  textSize(20);
  text("Purchase Full Version For USD 0.99", 250, 550);
}

void backToMenu(){
  endingGame = false;
  
  alphaValue = 510;
  songID = 1;
  leftID = 0;
  rightID = 0;
  
  loadComplete = false;
  
  count = 0;
  combo = 0;
  DRUG_MODE = 0;
  
  selectingSongs = true;
}

void calScore(int range, arrow p){
  switch(range){
    case -1:
      score += 10 * bonus;
      combo++;
      break;
    case 0:
      score += 50 * bonus;
      combo++;
      break;
    case 1:
      score += 5 * bonus;
      combo++;
      break;
    case -10:
      combo = 0;
      break;
  }
  
  if(combo > DRUG_MODE / 16) bonus = 4;
  else if(combo > DRUG_MODE / 8) bonus = 8;
  else if(combo > DRUG_MODE / 4) bonus = 16;
  else bonus = 1;
  
  if(p.live){
    p.live = false;
    count--;
  }
}

void detect(String keyin){
  drum = minim.loadFile("songs/drum.mp3");
  drum.play();
  
    for(int i = 0 ; i < MAXLINE ; i++){
      switch(keyin){
        case "up":
          if(data[i][2].live){
            if(data[i][2].y > bottom - 40 && data[i][2].y < bottom){ // good
              calScore(-1, data[i][2]);
            }else if(data[i][2].y >= bottom && data[i][2].y <= bottom + 10){ // perfect
              calScore(0, data[i][2]);
            }else if(data[i][2].y > bottom + 10 && data[i][2].y < bottom + 40){ // normal
              calScore(1, data[i][2]);
            }
          }
          break;
        case "down":
          if(data[i][1].live){
            if(data[i][1].y > bottom - 40 && data[i][1].y < bottom){ // good
              calScore(-1, data[i][1]);
            }else if(data[i][1].y >= bottom && data[i][1].y <= bottom + 10){ // perfect
              calScore(0, data[i][1]);
            }else if(data[i][1].y > bottom + 10 && data[i][1].y < bottom + 40){ // normal
              calScore(1, data[i][1]);
            }
          }
          break;
        case "right":
          if(data[i][3].live){
            if(data[i][3].y > bottom - 40 && data[i][3].y < bottom){ // good
              calScore(-1, data[i][3]);
            }else if(data[i][3].y >= bottom && data[i][3].y <= bottom + 10){ // perfect
              calScore(0, data[i][3]);
            }else if(data[i][3].y > bottom + 10 && data[i][3].y < bottom + 40){ // normal
              calScore(1, data[i][3]);
            }
          }
          break;
        case "left":
          if(data[i][0].live){
            if(data[i][0].y > bottom - 50 && data[i][0].y < bottom){ // good
              calScore(-1, data[i][0]);
            }else if(data[i][0].y >= bottom && data[i][0].y <= bottom + 10){ // perfect
              calScore(0, data[i][0]);
            }else if(data[i][0].y > bottom + 10 && data[i][0].y < bottom + 50){ // normal
              calScore(1, data[i][0]);
            }
          }
          break;
      }
    }
}

void movieEvent(Movie m) {
  m.read();
}