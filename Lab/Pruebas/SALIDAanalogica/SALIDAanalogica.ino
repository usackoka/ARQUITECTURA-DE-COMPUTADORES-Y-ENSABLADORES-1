const int led = 3;
int brillo;

void setup() {
  // put your setup code here, to run once:
  pinMode(led,OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  for(brillo = 0; brillo < 256; brillo ++){
    analogWrite(led,brillo); //va de 0-255 intensidad para la LED
    delay(10);
    }

    for(brillo = 255; brillo >= 0; brillo--){
    analogWrite(led,brillo); //va de 0-255 intensidad para la LED
    delay(10);
    }
}
