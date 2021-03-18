void setup() {
  // put your setup code here, to run once:
  pinMode(13,OUTPUT); //declaramos el pin 13 como de salida
}

void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(13,HIGH); //encendemos el led
  delay(1000); //tiempo que el arduino va a esperar en milisegundos
  digitalWrite(13,LOW); //apagamos el LED
  delay(1000);
}
