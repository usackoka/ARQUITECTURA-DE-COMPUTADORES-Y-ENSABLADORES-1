#include <LedControlMS.h>
#include <LiquidCrystal.h>
#include "Variables.h"
#include "Arreglos.h"
#include <Stepper.h>
#include <Servo.h>
Stepper stepper(STEPS,pin1,pin3,pin2,pin4);
Servo servo1;

void setup() {      
  
  pinMode(pin1,OUTPUT);
  pinMode(pin2,OUTPUT);
  pinMode(pin3,OUTPUT);
  pinMode(pin4,OUTPUT);
  pinMode(pinDireccion,INPUT);
  
  stepper.setSpeed(200);  
  
  Serial.begin (9600);
  lcd.begin(16, 2);
  pinMode(PinEcho, INPUT);
  pinMode(PinTrigger, OUTPUT);
  pinMode(alarma, 1);
  pinMode(interruptor,OUTPUT);

  lc.shutdown(0,false);    // Activar las matrices
  lc.setIntensity(0,8);    // Poner el brillo a un valor intermedio
  lc.clearDisplay(0);      // Y borrar todo
  }

  
void loop() {
  MostrarLCD();
  ModoReconocimiento();
}

void ModoReconocimiento()
{
  while(true)
  { 
    modo = 'R';
    MostrarLCD();
    EstadoInterruptor = digitalRead(interruptor);
    MoverStepper();
    ActualizarMatriz(stepp);
    SensorUltrasonico();
  }
}

void motorServo(int posGrados,int NoServo){
  servo1.attach(NoServo, pm, PM);
  if(posGrados <= 180){
    if(posGrados>posAnterior)
    {
        for(int i = posAnterior; i<=posGrados; i++)
        {
          servo1.write(i);
          delay(delayServo);
        }
      posAnterior = posGrados;
    }
    else if(posGrados<posAnterior)
    {
      for(int i = posAnterior; i>= posGrados; i--)
      {
        servo1.write(i);
        delay(delayServo);
      }
      posAnterior = posGrados;
    }else if(posGrados==posAnterior){
      
    }
  }
  servo1.detach();
}

void MoverStepper()
{
  if(EstadoInterruptor==1)
  {//MOVER AGUJAS DEL RELOJ
    stepper.step(-128);
    stepp-=128;
    if(stepp<=0){stepp=2048;}
  }
  else
  {//EN CONTRA DE LAS AGUJAS
     stepper.step(128);
     stepp+=128;
     if(stepp>=2048){stepp=0;}
  }
}

void ActualizarMatriz(int contador)
{
switch(contador){
    case 0:
      for(int i=0;i<8;i++){lc.setRow(0,i,s0[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s11[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s12[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s13[i]);}
      delay(delaytime);
    break;
    case 128:
      for(int i=0;i<8;i++){lc.setRow(0,i,s0[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s21[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s22[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s23[i]);}
      delay(delaytime);
    break;
    case 256:
       for(int i=0;i<8;i++){lc.setRow(0,i,s0[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s31[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s32[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s33[i]);}
      delay(delaytime);
    break;
    case 384:
      for(int i=0;i<8;i++){lc.setRow(0,i,s0[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s31[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s32[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s33[i]);}
      delay(delaytime);
    break;
    case 512:
      for(int i=0;i<8;i++){lc.setRow(0,i,s0[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s41[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s42[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s43[i]);}
      delay(delaytime);
    break;
    case 640:
      for(int i=0;i<8;i++){lc.setRow(0,i,s0[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s51[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s52[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s53[i]);}
      delay(delaytime);
    break;
     case 768:
      for(int i=0;i<8;i++){lc.setRow(0,i,s0[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s61[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s62[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s63[i]);}
      delay(delaytime);
    break;
    case 896:
      for(int i=0;i<8;i++){lc.setRow(0,i,s0[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s61[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s62[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s63[i]);}
      delay(delaytime);
    break;
    case 1024:
      for(int i=0;i<8;i++){lc.setRow(0,i,s0[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s71[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s72[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s73[i]);}
      delay(delaytime);
    break;
    case 1152:
      for(int i=0;i<8;i++){lc.setRow(0,i,s0[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s81[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s82[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s83[i]);}
      delay(delaytime);
    break;
    case 1280:
      for(int i=0;i<8;i++){lc.setRow(0,i,s0[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s91[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s92[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s93[i]);}
      delay(delaytime);
    break;
    case 1408:
      for(int i=0;i<8;i++){lc.setRow(0,i,s0[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s91[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s92[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s93[i]);}
      delay(delaytime);
    break;
    case 1536:
      for(int i=0;i<8;i++){lc.setRow(0,i,s0[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s101[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s102[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s103[i]);}
      delay(delaytime);
    break;
    case 1664:
      for(int i=0;i<8;i++){lc.setRow(0,i,s0[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s111[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s112[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s113[i]);}
      delay(delaytime);
    break;
    case 1792:
      for(int i=0;i<8;i++){lc.setRow(0,i,s0[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s121[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s122[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s123[i]);}
      delay(delaytime);
    break;
    case 1920:
      for(int i=0;i<8;i++){lc.setRow(0,i,s0[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s121[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s122[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s123[i]);}
      delay(delaytime);
    break;
    case 2048:
      for(int i=0;i<8;i++){lc.setRow(0,i,s0[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s11[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s12[i]);}
      delay(delaytime);
      for(int i=0;i<8;i++){lc.setRow(0,i,s13[i]);}
      delay(delaytime);
    break;
  }
}

int ObtenerAngulo(int dis)
{
  int angulo=80;
  return angulo;
}

void ModoDeteccion()
{
  modo = 'D';
  MostrarLCD();
  int angulo = ObtenerAngulo(distancia);
  motorServo(90,PinServo2);
   motorServo(0,PinServo2);
  //motorServo(90,PinServo2);
  //motorServo(0,PinServo);
  //motorServo(1,PinServo2);
  kills++;
  MostrarLCD();
  delay(800);
}

void PulsoTrigger()
{
    digitalWrite(PinTrigger, LOW);
    delayMicroseconds(2);
    digitalWrite(PinTrigger, HIGH);
    delayMicroseconds(10);
    digitalWrite(PinTrigger, LOW);
    tiempo = pulseIn(PinEcho, HIGH);
    distancia = (tiempo/2) / 29;// calcula la distancia en centimetros
    if(distancia>500){distancia = 500;}
}

void SensorUltrasonico()
{
    PulsoTrigger();
    if (distancia >= 500 || distancia <= 0)
    {  // si la distancia es mayor a 500cm o menor a 0cm 
      Serial.println("Distancia mayor a 500 cm o menor a 0 cm"); // no mide nada
    }
    else
    {
      Serial.print(distancia); // envia el valor de la distancia por el puerto serial
      Serial.println("cm"); // le coloca a la distancia los centimetros "cm"
      digitalWrite(alarma, 0); // en bajo el pin alarma
    }
    if (distancia <= 50 && distancia >= 10)
    {
      Serial.println("Alarma.......");
      ALARMA();
      ModoDeteccion();
    }
}

void ALARMA()
{
   for(int i=fMin; i<=fMax; i++){
    tone(alarma,i,duracion);
  }
  for(int i=fMax; i>=fMin; i--){
    tone(alarma,i,duracion);
  }
}

void MostrarLCD()
{
  t1=millis()/1000;
  if(t1>59){t1=t1/60;t2=minutos+t1;}
  else{t2=minutos;}
  
  lcd.setCursor(0,0);
  lcd.print(mensaje1+String(kills));
  lcd.setCursor(0,1);
  switch(modo)
  {
    case 'R':
    lcd.print("H"+String(hora)+":"+String(t2)+" "+String(modo));
    lcd.print("      ");
    lcd.display();
    break;
    case 'D':
    lcd.print("H"+String(hora)+":"+String(t2)+" "+String(modo)+" "+distancia+" cm");
    lcd.display();
    break;
  }
}

