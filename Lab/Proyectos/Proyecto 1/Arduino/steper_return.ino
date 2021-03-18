//#include <FrequencyTimer2.h>
#include <Stepper.h>
#include <Servo.h>
#include <SoftwareSerial.h> 
#include <LiquidCrystal.h>
#include <LedControlMS.h>
#include "variables.h"
#include "string.h"
#define pin1 10
#define pin2 11
#define pin3 12
#define pin4 13

//GRADOS PARA CONTROL DEL LAPIZ
#define subirLapiz 0
#define bajarLapiz 40
//PASO PARA MOVER CARRETE
#define movArriba -2048
#define movAbajo 2048

#define delaytime 1000
#define STEPS 64 //Número de pasos que necesita para dar una vuelta 64
//------------------------- MATRIZ ---------------------------
LedControl lc=LedControl(23,25,27, 1);  // Creamos una instancia de LedControl
//-------------------------MOTORES---------------------------
Stepper Carrete(STEPS,pin1,pin3,pin2,pin4);
Servo cilindro;
Servo lapiz;
//ARREGLO MATRIZ LEDS
int matriz[8][8];
//VARIABLES X,Y,Z PARA LAS COORDENADAS CARTESIANAS
int x=0;
int y=0;
int z=0;

//VARIABLES XCIL YCIL ZCIL PARA LAS COORDENADAS CILINDRICAS
double xcil;
double ycil;
double zcil;

//GRADOS PARA CONTROL DEL CILINDRO //17 grados cada paso
int posCilindro = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(pin1,OUTPUT);
  pinMode(pin2,OUTPUT);
  pinMode(pin3,OUTPUT);
  pinMode(pin4,OUTPUT);
  cilindro.attach(9);  // attaches the servo on pin 9 to the servo object 
  lapiz.attach(7);
  lapiz.write(0);
  cilindro.write(0);
  Carrete.setSpeed(460); //Velocidad del motor en RPM 
  //------- LCD ---------
  lcd.begin(16,2);
  lcd.createChar(1,grado);
  lcd.createChar(2,ohm);
    //------ MATRIZ -------
  //FrequencyTimer2::disable();
  //FrequencyTimer2::setPeriod(200);
  //FrequencyTimer2::setOnOverflow(display);
  lc.shutdown(0,false);    // Activar las matrices
  lc.setIntensity(0,8);    // Poner el brillo a un valor intermedio
  lc.clearDisplay(0);      // Y borrar todo
  LCD();
}

void loop() {
  while(Serial.available()>0)  
    {
          String Varchar = Serial.readString();
          Serial.print("Recibiendo: ");
          Serial.println(Varchar);
          NLienzos++;
          modo = 'C';
          Pintando = 1; 
          //SPLIT E IMPRESION
          split(Varchar,';'); 
          lc.clearDisplay(0);    
          clearMatriz();
          modo = 'F';
          Pintando = 0;
          LCD();
    }
}

void insertarMatriz(int x, int y){
  matriz[x][y] = 1;
  Serial.print("Valores x,y: ");
  Serial.print(x);
  Serial.println(y);
}

void clearMatriz(){
  for(int i=0;i<8;i++){
    for(int j=0;j<8;j++){
      matriz[i][j]=0;
      }
    }
  }

void UpdateMatriz(){
  for(int i = 0; i < 8; i++){
        for(int j = 0; j < 8; j++){
            lc.setLed(0,i,j,matriz[i][j]);
            }
      }
}
  
void Imprimir(int Varchar){
  LCD();
  UpdateMatriz();
          switch(Varchar){
            case 0:
            PintarIzquierda();
            Serial.println("Pintar Izquierda");
            break;
            case 1:
            insertarMatriz(x,y);
            insertarMatriz(x+1,y);
            PintarDerecha();
            
            Serial.println("Pintar Derecha");
            break;
            case 2:
            PintarArriba();
            Serial.println("Pintar Arriba");
            break;
            case 3:
            insertarMatriz(x,y);
            insertarMatriz(x,y+1);
            PintarAbajo();
            
            Serial.println("Pintar Abajo");
            break;
            case 4:
            MoverDerecha();
            Serial.println("Mover Derecha");
            break;
            case 5:
            MoverIzquierda();
            Serial.println("Mover Izquierda");
            break;
            case 6:
            MoverArriba();
            Serial.println("Mover Arriba");
            break;
            case 7:
            MoverAbajo();
            Serial.println("Mover Abajo");
            break;
            case 8:
            insertarMatriz(x,y);
            insertarMatriz(x+9,y+1);
            DiagonalDerecha();
            Serial.println("Diagonal Derecha");
            
            break;
            case 9:
            insertarMatriz(x,y);
            insertarMatriz(x+7,y+1);
            DiagonalIzquierda();
            Serial.println("Diagonal Izquierda");
            
            break;
            case 10:
            CarreteArriba();
            Serial.println("Carrete Arriba");
            break;
            case 11:
            CilindroIzquierda();
            Serial.println("Cilindro Izquierda");
            break;
            case 12:
            RegresarDiagonalIzquierda();
            Serial.println("Mover Diagonal Izquierda");
            break;
            case 13:
            RegresarDiagonalDerecha();
            Serial.println("Mover Diagonal Derecha");
            break;
            case 14:
            CilindroDerecha();
            break;
            default:
            Serial.println("Caracter Desconocido");
            break;
          }
}
void PintarDerecha(){
  BajarLapiz();
  MoverDerecha();
  SubirLapiz();
  }
void PintarIzquierda(){
  BajarLapiz();
  MoverIzquierda();
  SubirLapiz();
  }
void PintarArriba(){
  BajarLapiz();
  MoverArriba();
  SubirLapiz();
  }
void PintarAbajo(){
  BajarLapiz();
  MoverAbajo();
  SubirLapiz();
  }
void BajarLapiz(){
  lapiz.write(bajarLapiz);
  delay(100);
  z=1;
  }
void SubirLapiz(){
  delay(200);
  lapiz.write(subirLapiz);
  z=0;
  }
void MoverDerecha(){
  int pos1 = posCilindro * 17;
  posCilindro++;
  int pos = posCilindro*17;
  for(int i=pos1;i<pos;i++){
    cilindro.write(i);
    delay(100);
    }
    //AUMENTO LA VARIABLE X PARA LAS COORDENADAS DE LA IMPRESORA
    x++;
  }
void MoverIzquierda(){
  int pos1 = posCilindro * 17;
  posCilindro--;
  int pos = posCilindro*17;
  for(int i=pos1;i>=pos;i--){
    cilindro.write(i);
    delay(100);
    }
}
void MoverAbajo(){
  Carrete.step(movAbajo);
  //AUMENTO LA VARIABLE Y PARA LAS COORDENADAS DE LA IMPRESORA
  y++;
  }
void MoverArriba(){
  Carrete.step(movArriba);
  }
void DiagonalDerecha(){
  BajarLapiz();
  int pos1 = posCilindro * 17;
  posCilindro++;
  int aux = 120;
  int pos = posCilindro*17;
  for(int i=pos1;i<pos;i++){
    cilindro.write(i);
    Carrete.step(aux);
    delay(100);
    }
  SubirLapiz();
}
void RegresarDiagonalDerecha(){
  SubirLapiz();
  int pos1 = posCilindro * 17;
  posCilindro--;
  int aux = 120;
  int pos = posCilindro*17;
  for(int i=pos1;i>=pos;i--){
    cilindro.write(i);
    Carrete.step(-aux);
    delay(100);
    }
}
void DiagonalIzquierda(){
  BajarLapiz();
  int pos1 = posCilindro * 17;
  posCilindro--;
  int aux = 120;
  int pos = posCilindro*17;
  for(int i=pos1;i>=pos;i--){
    cilindro.write(i);
    Carrete.step(aux);
    delay(100);
    }
  SubirLapiz();
}
void RegresarDiagonalIzquierda(){
  SubirLapiz();
  int pos1 = posCilindro * 17;
  posCilindro++;
  int aux = 120;
  int pos = posCilindro*17;
  for(int i=pos1;i<pos;i++){
    cilindro.write(i);
    Carrete.step(-aux);
    delay(100);
    }
}
void CilindroIzquierda(){
  cilindro.write(0);  
  posCilindro=0;
  //REINICIO COORDENADA X
  x=0;
}
void CilindroDerecha(){
  cilindro.write(180);  
  //REINICIO COORDENADA X
  x=0;
  }
void CarreteArriba(){
  Carrete.step(-16384);
  //REINICIO COORDENADA Y
  y=0;
}
void MoverDiagonalDerecha(){
  SubirLapiz();
  int pos1 = posCilindro * 17;
  posCilindro++;
  int aux = 60;
  int pos = posCilindro*17;
  for(double i=pos1;i<pos;i=i+0.5){
    cilindro.write(i);
    Carrete.step(aux);
    delay(100);
    }
}
void MoverDiagonalIzquierda(){
  SubirLapiz();
  int pos1 = posCilindro * 17;
  posCilindro--;
  int aux = 120;
  int pos = posCilindro*17;
  for(int i=pos1;i>=pos;i--){
    cilindro.write(i);
    Carrete.step(aux);
    delay(100);
    }
}
//ACTUALIZAR LCD
void LCD(){
  switch(Pintando){
    case 0://MODO ESPERA
        //----------Fila 1-----------
        lcd.setCursor(0,0);
        lcd.write(2);
        lcd.print("GRUPO 8A");
        lcd.write(2);
        lcd.print(" L"+String(NLienzos));
        lcd.print("      ");
        //----------Fila 2-----------
        lcd.setCursor(0,1);
        t1=millis()/1000;
        if(t1>59){t1=t1/60;t2=minutos+t1;}
        else{t2=minutos;}
        lcd.print("H"+String(hora)+":"+String(t2)+"  "+String(modo));
        lcd.print("      ");
        lcd.display();
    break;
    case 1://MODO PINTANDO
        //---------ACTUALIZANDO XCIL YCIL Y ZCIL---------------
        double xcil = cos(x);
        double ycil = sin(y);
        double zcil = tan(z);
        //----------------agarrando decimal--------------------
        String n = String(xcil);
        String n1 = String(ycil);
        String n2 = String(zcil);
        //----------Fila 1-----------
        lcd.setCursor(0,0);
        lcd.print("CAR "+ String(x) +", " + String(y) +",  " + String(z));
        lcd.print("      ");
        //----------Fila 2-----------
        lcd.setCursor(0,1);
        lcd.print("CIL "+ String(n.substring(0,2)) +", " + String(n1.substring(0,2)));
        lcd.write(1);
        lcd.print(", " + String(n2.substring(0,2)));
        lcd.print("      ");
        lcd.display();
    break;
  }
}
void split(String cadena, char escape){
  String resultado = "";
  for(int i =0; i< cadena.length(); i ++){
      if(cadena[i] == escape){
        //Serial.println(resultado);
        int r = resultado.toInt();
        Imprimir(r);
        resultado = "";
        }else{
          resultado += cadena[i];
          }
    }
}
