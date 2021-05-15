float arrowWidth = 100.0,
      arrowHeight = 100.0,
      arrW = 100,
      arrH = 100,
      bottom = 570,
      bottomLeft = 25,
      SPEED = 6.3;

class arrow{
  boolean live = false;
  String type = "blank";
  float x = 0,
        y = bottom;
  
  arrow(int i, int j, boolean t){
    if(t){
      switch(j){
        case 0:
          type = "l";
          x = bottomLeft;
          break;
        case 1:
          type = "d";
          x = bottomLeft + arrW + 50;
          break;
        case 2:
          type = "u";
          x = bottomLeft + 2 * arrW + 2 * 50;
          break;
        case 3:
          type = "r";
          x = bottomLeft + 3 * arrW + 3 * 50;
          break;
      }
    }
    y -= 50 * (i + 1);
  }
  
  void display(){
    if(live){
      switch(type){
        case "l":
          image(left, x, y, arrW, arrH);
          break;
        case "r":
          image(right, x, y, arrW, arrH);
          break;
        case "u":
          image(up, x, y, arrW, arrH);
          break;
        case "d":
          image(down, x, y, arrW, arrH);
          break;
      }
    }
  }
  
  void move(){
    if(live){
      y += SPEED;
      if(y > 650){
        live = false;
        count--;
        combo = 0;
      }
    }
    if(!live && y < -50 && type != "blank"){
      y += SPEED;
      if(y >= -50)
        live = true;
    }
  }
};