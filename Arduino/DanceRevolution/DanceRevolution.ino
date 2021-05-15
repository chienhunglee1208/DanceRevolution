const int leftBtnPin = 10,
          downBtnPin = 11,
          upBtnPin = 12,
          rightBtnPin = 13;

int leftBtnStatus = 0,
    downBtnStatus = 0,
    upBtnStatus = 0,
    rightBtnStatus = 0,
    lastLeftBtnStatus = 0,
    lastDownBtnStatus = 0,
    lastUpBtnStatus = 0,
    lastRightBtnStatus = 0;
    
bool DEBUG = false;

void setup() {
  pinMode(leftBtnPin, INPUT);
  pinMode(downBtnPin, INPUT);
  pinMode(upBtnPin, INPUT);
  pinMode(rightBtnPin, INPUT);

  Serial.begin(9600);
}

void loop() {
  leftBtnStatus = digitalRead(leftBtnPin);
  upBtnStatus = digitalRead(upBtnPin);
  downBtnStatus = digitalRead(downBtnPin);
  rightBtnStatus = digitalRead(rightBtnPin);

  int L = 0, D = 0, U = 0, R = 0, output = 0;

  if(leftBtnStatus != lastLeftBtnStatus){
    if(leftBtnStatus == HIGH) L = 1;
    else L = 0;
  }

  if(rightBtnStatus != lastRightBtnStatus){
    if(rightBtnStatus == HIGH) R = 1;
    else R = 0;
  }

  if(upBtnStatus != lastUpBtnStatus){
    if(upBtnStatus == HIGH) U = 1;
    else U = 0;
  }

  if(downBtnStatus != lastDownBtnStatus){
    if(downBtnStatus == HIGH) D = 1;
    else D = 0;
  }

  if(L == 1 && D == 0 && U == 0 && R == 0) output = 1;
  if(L == 0 && D == 1 && U == 0 && R == 0) output = 2;
  if(L == 0 && D == 0 && U == 1 && R == 0) output = 3;
  if(L == 0 && D == 0 && U == 0 && R == 1) output = 4;

  if(leftBtnStatus != lastLeftBtnStatus ||
     rightBtnStatus != lastRightBtnStatus ||
     upBtnStatus != lastUpBtnStatus ||
     downBtnStatus != lastDownBtnStatus){
    if(DEBUG) Serial.println(output);
    else Serial.write(output);
  }

  lastLeftBtnStatus = leftBtnStatus;
  lastRightBtnStatus = rightBtnStatus;
  lastUpBtnStatus = upBtnStatus;
  lastDownBtnStatus = downBtnStatus;

  delay(25);
}
