int est = 0;
void setup() {
  // put your setup code here, to run once:
  pinMode(3,OUTPUT);
  pinMode(4,INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  est = digitalRead(4);
  if(est==HIGH)
  {
    digitalWrite(3,HIGH);
  }
  else
  {
    digitalWrite(3,LOW);
  }
}
