const int p1 = 10;
const int p2 = 11;
const int p3 = 12;
const int p4 = 13;

int p1s = 0;
int p2s = 0;
int p3s = 0;
int p4s = 0;

void setup() {
  Serial.begin(9600); 
  
  pinMode(p1, INPUT);
  pinMode(p2, INPUT);
  pinMode(p3, INPUT);
  pinMode(p4, INPUT);
}

void loop() {
  p1s = digitalRead(p1);
  p2s = digitalRead(p2);
  p3s = digitalRead(p3);
  p4s = digitalRead(p4);


  if(p1s == HIGH) Serial.println("bt1 is ON");
  else Serial.println("bt1 is OFF");

  if(p2s == HIGH) Serial.println("bt2 is ON");
  else Serial.println("bt2 is OFF");

  if(p3s == HIGH) Serial.println("bt3 is ON");
  else Serial.println("bt3 is OFF");

  if(p4s == HIGH) Serial.println("bt4 is ON");
  else Serial.println("bt4 is OFF");

  Serial.println("");
  delay(1000);
}
