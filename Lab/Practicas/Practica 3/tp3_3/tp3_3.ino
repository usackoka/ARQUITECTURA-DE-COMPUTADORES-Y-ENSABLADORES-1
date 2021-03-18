//LIBRERIAS
#include <Servo.h>
#include <LiquidCrystal.h>
#include <Stepper.h>

#define STEPS 64 //Número de pasos que necesita para dar una vuelta 64
#define pin1 22
#define pin2 24
#define pin3 26
#define pin4 28
#define delayStepper 1
#define CantidadProductos 10

LiquidCrystal lcd(7, 8, 9, 10, 11, 12);
int PROD = CantidadProductos; //cantidad total de productos
int PA = 0; //pedidos automaticos
int PM = 0; //pedidos manuales
int Dato; //almacena valor
char Tipo; //almacena valor char recibido serialmente
int buz = 4; //pin del buzzer
int AUTO[] = {730, 630, 830}; //tonos  solicitudes automaticas
int MANU[] = {930, 515, 430,930, 515, 430}; //tonos  solicitudes manuales
String hora = "00:00";
int minutos = 0;
int t1=0;
int duracion = 250;
int fMin = 2000;
int fMax =4000;

byte admiracion[8] =
{
  0b00000000,
  0b00000100,
  0b00000000,
  0b00000100,
  0b00000100,
  0b00000100,
  0b00000100,
  0b00000000
};

byte grado[8] =
{
  0b00001100,     // Los definimos como binarios 0bxxxxxxx
  0b00010010,
  0b00010010,
  0b00001100,
  0b00000000,
  0b00000000,
  0b00000000,
  0b00000000
};


Stepper stepper(STEPS, pin1, pin3, pin2, pin4);

void setup() {
  Serial.begin(9600); //inicializa comunicacion serial
  lcd.begin(16, 2); //inicializa lcd 16x2
  pinMode(pin1, OUTPUT);
  pinMode(pin2, OUTPUT);
  pinMode(pin3, OUTPUT);
  pinMode(pin4, OUTPUT);
  lcd.createChar(1,admiracion);
  //lcd.createChar(1, grado);
  stepper.setSpeed(300);
  ActualizarLCD();
}

void Despachar() { //ejecuta el movimiento del servo para desplegar 1 producto
  stepper.step(2048);
  delay(delayStepper);
}
//METODO PARA EJECUTAR ALERTAS SONORAS
void Tonos(char s) {  //ejecuta los tonos correspondientes a cada solicitud a=automatica , m= manula y p= producto
  switch (s) {
    case 'a':
        for(int i=fMin; i<=fMax; i++){
          tone(buz,i,duracion);
        }
        for(int i=fMax; i>=fMin; i--){
          tone(buz,i,duracion);
        }
        noTone(buz);
        for(int i=fMin; i<=fMax; i++){
          tone(buz,i,duracion);
        }
        for(int i=fMax; i>=fMin; i--){
          tone(buz,i,duracion);
        }
      noTone(buz);
      break;
    case'm':
      for (int i = 0; i < 6; i++) {
        tone(buz, MANU[i]);
        delay(100);
      }
      noTone(buz);
      break;
    case'p':
      tone(buz, 1700);
      delay(100);
      tone(buz, 1700);
      delay(100);
      tone(buz, 1700);
      delay(100);
      noTone(buz);
      break;
  }
}

//METODO PARA DISPENSAR PRODUCTOS
void Dispensar(int v) 
{
  for (int i = 0; i < v; i++) 
  {
    Despachar();
    Tonos('p');
    PROD--;
    ActualizarLCD();
  }
}

void ActualizarLCD() 
{
  lcd.display();
  String l1 = "GRUPO 8 A! P" + String(PROD);
  String l2 = "H" + hora + " SM" + String(PM) + " SA" + String(PA);
  lcd.setCursor(0, 0);
  lcd.write(1);
  lcd.print(l1);
  lcd.setCursor(0, 1);
  lcd.print(l2);
}

void loop() {
  ActualizarLCD();
  Tipo = 'B';
  while(Tipo=='B'){Tipo = Serial.read();}
  
  if (Tipo == 'm')
  {
    Tonos('m');
    int cantidad = 0;
    while (cantidad == 0)
    {
      cantidad = Serial.parseInt();
      if (cantidad != 0)
      {
        PM++;
        Dispensar(cantidad);
        //Serial.println("OKM");
      }
    }
  } else if (Tipo == 'a') {
    Tonos('a');
    int cantidad = 0;
    while (cantidad == 0)
    {
      cantidad = Serial.parseInt();
      if (cantidad != 0) 
      {
        PA++;
        Dispensar(cantidad);
        //Serial.println("OKA");
      }
    }
  }
  else if (Tipo == 'h') {
    hora = "";
    while (hora == "")
    {
      hora = Serial.readString();
      if (hora != "") 
      {
        ActualizarLCD();
      }
    }
  }
}
