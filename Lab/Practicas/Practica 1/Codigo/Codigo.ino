#include <FrequencyTimer2.h>
#include "Tonos.h"
#include "Caracteres.h"

/*INICIAN VARIABLES DE ITUNES*/
bool acierto = false;
int puntos = 0;
int velocidad = 0;
int estado = 0;
int estadoAnt = 0;
int top[4];
int tope = 0;
int tiempojuego1;
int tiempojuego2;
int tiempojuego3;
String result; 

byte NumeroColumna = 0;
byte leds[8][8];
int pins[17]= {-1, 23, 25, 27, 29, 31, 33, 35, 37, 22, 24, 26, 28, 30, 32, 34, 36};
int Columnas[8] = {pins[9], pins[10], pins[11], pins[12], pins[13], pins[14], pins[15], pins[16]};
int Filas[8] = {pins[1], pins[2], pins[3], pins[4], pins[5], pins[6], pins[7], pins[8]};
 
const int NumeroDeCaracteres =26;

byte Caracteres[NumeroDeCaracteres][8][8] = {ESPACIO,ASTERISCO,ESPACIO,T,P,uno,GUION,G,R,U,P,O,ESPACIO,ocho,GUION,S,E,C,C,I,O,N,ESPACIO,A,ASTERISCO }; //

int numerodecaracterreverso = sizeof(Caracteres);
int numerodecaracter = 0;

boolean EstadoInterruptor;
const int interruptor = 17;
const int boton = 18;
const int alarma = 13;

long tiempo,tiempo2,tiempo3;
int estadoboton=0;

bool gano = false;

String hora = "12";
int p1 = 0;
int p2 = 0;
int p3 = 0;
int t1 = 0;
int t2 = 0;
int t3 = 0;
int Cancion[4];
 
void setup() {

  Serial.begin(9600);
   //PINES DE ENTRADA
  pinMode(boton,INPUT);
  pinMode(interruptor,INPUT);
  //PINES DE SALIDA
  pinMode(alarma,OUTPUT);
  
  for (int i = 1; i <= 16; i++) {           // Habilitar pines como salidas
    pinMode(pins[i], OUTPUT);
  }
  
  for (int i = 0; i < 8; i++) {             // valores por defecto de las filas y columnas
    digitalWrite(Columnas[i], LOW);
    digitalWrite(Filas[i], LOW);
  }
 
  for (int i = 0; i < 8; i++) {             //Poner toda la matriz con valores ceros
    for (int j = 0; j < 8; j++) {
      leds[i][j] = 0;
    }
  }

  FrequencyTimer2::disable();
  FrequencyTimer2::setPeriod(200);
  FrequencyTimer2::setOnOverflow(display);

  EstadoInterruptor = digitalRead(interruptor);
}
 
void loop() {

  estadoboton = digitalRead(boton);
  EstadoInterruptor = digitalRead(interruptor);
  
  if(estadoboton == HIGH) 
  { 
    Serial.println("boton en 1");
     tiempo=millis();
     while(estadoboton == HIGH) 
     { 
       tiempo2=millis();
       estadoboton = digitalRead(boton);
     }
     tiempo3=tiempo2-tiempo;
    if(tiempo3>500)
    {
      Serial.println("EN MENU: BOTON PRESIONADO MAS DE DOS SEGUNDOS");
      //EL BOTON SE PULSO POR MAS DE DOS SEGUNDOS, MOSTRAR PUNTEOS MAS ALTOS
      Display_Barrido(hora+":"+String(t1)+"-"+String(p1)+" ");
      Display_Barrido(hora+":"+String(t2)+"-"+String(p2)+" ");
      Display_Barrido(hora+":"+String(t3)+"-"+String(p3)+" ");
    }
    else
    { 
      Serial.println("EN MENU: BOTON PRESIONADO MENOS DE DOS SEGUNDOS");
      //SE PRESIONO MENOS DE DOS SEGUNDOS, INICIAR JUEGO
      JUEGO();
    }
  }
  else
  {
    //MOSTRAR MENSAJE DE BIENVENIDA
    Serial.println("boton en 0");
    MENSAJE();
  }
 
}

void MENSAJE(){
     EstadoInterruptor = digitalRead(interruptor);
     if(EstadoInterruptor==true){
      Serial.print("Interruptor en: ");
      Serial.println(EstadoInterruptor);
       numerodecaracter = ++numerodecaracter % NumeroDeCaracteres;
       BarridoCaracter(numerodecaracter);
     }
     else
     {
      Serial.print("Interruptor en: ");
      Serial.println(EstadoInterruptor);
      numerodecaracterreverso = --numerodecaracterreverso % NumeroDeCaracteres;
      BarridoCaracter(numerodecaracterreverso);
      if(numerodecaracterreverso==0){numerodecaracterreverso=sizeof(Caracteres);}
     }
}

void Display_Barrido(String mensaje)
{
  int contador = 0;
  int NoLetras = mensaje.length();
  byte WIN[16][8][8] = {cero,uno,dos,tres,cuatro,cinco,seis,siete,ocho,nueve,W,I,N,ESPACIO,GUION,DOSPUNTOS};
  
  int cont = 0;
  while(cont<NoLetras)
  {
    char let = mensaje[cont];
    char let2 = mensaje[NoLetras-cont];
    int no = PosicionByChar(let);
    int no2 = PosicionByChar(let2);
  
    for (int l = 0; l < 8; l++) {
      if(EstadoInterruptor==true)
      {
        for (int i = 0; i < 7; i++) 
        {
          for (int j = 0; j < 8; j++) 
          {
            leds[j][i] = leds[j][i+1];       
          }
        }
      }
      else
      {
        for (int i = 7; i >= 0; i--) 
        {
          for (int j = 8; j >=0; j--) 
          {
            leds[j][i] = leds[j][i-1];       
          }
        }
      }
      for (int j = 0; j < 8; j++) 
      {
        if(EstadoInterruptor==true)
        {
          leds[j][7] = WIN[no][j][l];
        }
        else
        {
          leds[j][0] = WIN[no2][j][7-l];
        }
      }
      delay(100);
    }
    cont ++;
  }
}

void Display_LxL(String mensaje)
{
  int NoLetras = mensaje.length();
  byte WIN[16][8][8] = {cero,uno,dos,tres,cuatro,cinco,seis,siete,ocho,nueve,W,I,N,ESPACIO,GUION,DOSPUNTOS};
  
    int cont = 0;
    while(cont<NoLetras)
    {
      char let = mensaje[cont];
      int no = PosicionByChar(let);
      for (int l = 0; l < 8; l++)
      {
        for (int j = 0; j < 8; j++) 
        {
          leds[j][l] = WIN[no][j][l];
        }
      }
      delay(300);
      cont++;
    }
}

int PosicionByChar(char l)
{
  switch(l)
  {
    case '0':
    return 0;
    case '1':
    return 1;
    case '2':
    return 2;
    case '3':
    return 3;
    case '4':
    return 4;
    case '5':
    return 5;
    case '6':
    return 6;
    case '7':
    return 7;
    case '8':
    return 8;
    case '9':
    return 9;
    case 'W':
    return 10;
    case 'I':
    return 11;
    case 'N':
    return 12;
    case ' ':
    return 13;
    case '-':
    return 14;
    case ':':
    return 15;
  }
}

void BarridoCaracter(int numerodecaracter) {
  
  for (int l = 0; l < 8; l++) {
    EstadoInterruptor = digitalRead(interruptor);
    if(EstadoInterruptor==1)
    {
      for (int i = 0; i < 7; i++) {
        for (int j = 0; j < 8; j++) {
          leds[j][i] = leds[j][i+1];       
      }
    }
    }
    else
    {
      for (int i = 7; i >= 0; i--) {
        for (int j = 8; j >=0; j--) {
          leds[j][i] = leds[j][i-1];      
      }
    }
    }
    for (int j = 0; j < 8; j++) {
      if(EstadoInterruptor==1)
      {
        leds[j][7] = Caracteres[numerodecaracter][j][l];
      }
      else
      {
        leds[j][0] = Caracteres[numerodecaracterreverso][j][7-l];
      }
    }
    delay(100);
  }
}

void display() {
  digitalWrite(Columnas[NumeroColumna], HIGH);
  NumeroColumna++;
  if (NumeroColumna == 8) {
    NumeroColumna = 0;
  }
  for (int NumeroFila = 0; NumeroFila < 8; NumeroFila++) {
    if (leds[NumeroColumna][NumeroFila] == 1) {
      digitalWrite(Filas[NumeroFila], HIGH);
    }
    else {
      digitalWrite(Filas[NumeroFila], LOW);
    }
  }
  digitalWrite(Columnas[NumeroColumna], LOW);
}

/*----------------------INICIA CODIGO DE ITUNES----------------------------*/
void JUEGO() {
  gano = false;
  tiempojuego1 = millis();
  while(gano==false)
  {
    EstadoInterruptor = digitalRead(interruptor);
    if(EstadoInterruptor==1)
    {
      giroDerecha();
    }
    else
    {
      giroIzquierda();
    }
  }
  Display_LxL("WIN"+result);
  Display_LxL("WIN"+result);
  
  gano = false;
  
  FrequencyTimer2::setPeriod(200);
}

void giroDerecha(){ //secuencia hacia la derecha
  //tiempojuego1 = millis();
  s0();             // llama el primer estado parte superior y posicion de acierto
  ruleta();
  verificar(); if(gano==true){return 0;}
  s1();
  ruleta();
  verificar();
  s2();
  ruleta();
  verificar();
  s3();
  ruleta();
  verificar();
  s4();
  ruleta();
  verificar();
  s5();
  ruleta();
  verificar();
  s6();
  ruleta();
  verificar();
  s7();
  ruleta();
  verificar();
  s8();
  ruleta();
  verificar();
  s9();
  ruleta();
  verificar();
  s10();
  ruleta();
  verificar();
  s11();
  ruleta();
  verificar();
  s12();
  ruleta();
  verificar();
  s13();
  ruleta();
  verificar();
}

void giroIzquierda(){ //secuencia hacia la izquierda
  //tiempojuego1 = millis();
  s0();               //estado inicial parte superior y posicion de acierto
  ruleta();
  verificar();if(gano==true){return 0;}
  s13();
  ruleta();
  verificar();
  s12();
  ruleta();
  verificar();
  s11();
  ruleta();
  verificar();
  s10();
  ruleta();
  verificar();
  s9();
  ruleta();
  verificar();
  s8();
  ruleta();
  verificar();
  s7();
  ruleta();
  verificar();
  s6();
  ruleta();
  verificar();
  s5();
  ruleta();
  verificar();
  s4();
  ruleta();
  verificar();
  s3();
  ruleta();
  verificar();
  s2();
  ruleta();
  verificar();
  s1();
  ruleta();
  verificar();
}

void ruleta(){
  FrequencyTimer2::setPeriod(velocidad);
}

void GuardarPunteoYTiempo(int punteo, int tiempo)
{
  if(punteo>p3)
  {
    p3 = punteo;
    t3 = tiempo;
  }
  ORDENAR();
}

void ORDENAR()
{
  //ORDENAMIENTO
    if(p3>p2)
    {
      int temp = p2;
      int temp2 = t2;
      p2 = p3;
      t2 = t3;
      p3 = temp;
      t3 = temp2;
    }
    if(p2>p1)
    {
      int temp = p1;
      int temp2 = t1;
      p1 = p2;
      t1 = t2;
      p2 = temp;
      t2 = temp2;
    }
    Serial.print("Punteo1: ");
    Serial.print(p1);
    Serial.print(" Tiempo1: ");
    Serial.println(t1);

    Serial.print("Punteo2: ");
    Serial.print(p2);
    Serial.print(" Tiempo2: ");
    Serial.println(t2);

    Serial.print("Punteo3: ");
    Serial.print(p3);
    Serial.print(" Tiempo3: ");
    Serial.println(t3);
  }

int Nivel=0;
int tSonido;
void verificar(){  
  estadoboton = digitalRead(boton);
  if((estadoboton == HIGH) && (estadoAnt == LOW)){
    estado = 1 - estado;
    delay(40);
  }
  estadoAnt = estadoboton;
  
  if((estadoboton == HIGH) && ( acierto == true)){
    tSonido =millis();
    Nivel++;
    Buzzer(Nivel);
    velocidad = velocidad + 20;
    Serial.println("ACERTASTE");
    Serial.println("PUNTEO: ");
    Serial.println(puntos);
    if(velocidad == 100){
      velocidad = 0;
      tope = tope+1;
      topJugadores(puntos);
      tiempojuego2 = millis();
      tiempojuego3 = tiempojuego2 - tiempojuego1;
      gano = true;
      int t = tiempojuego3/10;
      result = String(puntos) + "-" + String(t);
      
      GuardarPunteoYTiempo(puntos,t);
      
      puntos = 0;
      Nivel = 0;
      }
      puntos = puntos + 5;
    }
  else if((estadoboton == HIGH) && (acierto == false))
  {
    puntos = puntos - 1;
    Serial.println("FALLASTE");
    Serial.println(puntos);
    if(puntos <= 0)
    {
      puntos = 0;
    }
  }
}

void topJugadores(int pts){
  if(tope < 4){
    top[pts];
  }
}

void ordenarPts(){
  int aux=0;
  for(int i=0; i<4; i++){
    for(int j=i; j<4; j++){
      if(top[i] > top[j]){
        aux = top[i];
        top[i] = top[j];
        top[j] = aux;
      }
    }
  }
}

void s0(){
  acierto = true;
  for(int i=0;i<8;i++){
    for(int j=0;j<8;j++){
      leds[i][j]=f1[i][j]; 
    }
  }
}

void s1(){
  acierto = false;
  for(int i=0;i<8;i++){
    for(int j=0;j<8;j++){
      leds[i][j]=f2[i][j]; 
    }
  }
}

void s2(){
  acierto = false;
  for(int i=0;i<8;i++){
    for(int j=0;j<8;j++){
      leds[i][j]=f3[i][j]; 
    }
  }
}

void s3(){
  acierto = false;
  for(int i=0;i<8;i++){
    for(int j=0;j<8;j++){
      leds[i][j]=f4[i][j]; 
    }
  }
}

void s4(){
  acierto = false;
  for(int i=0;i<8;i++){
    for(int j=0;j<8;j++){
      leds[i][j]=f5[i][j]; 
    }
  }
}

void s5(){
  acierto = false;
  for(int i=0;i<8;i++){
    for(int j=0;j<8;j++){
      leds[i][j]=f6[i][j]; 
    }
  }
}

void s6(){
  acierto = false;
  for(int i=0;i<8;i++){
    for(int j=0;j<8;j++){
      leds[i][j]=f7[i][j]; 
    }
  }
}

void s7(){
  acierto = false;
  for(int i=0;i<8;i++){
    for(int j=0;j<8;j++){
      leds[i][j]=f8[i][j]; 
    }
  }
}

void s8(){
  acierto = false;
  for(int i=0;i<8;i++){
    for(int j=0;j<8;j++){
      leds[i][j]=f9[i][j]; 
    }
  }
}

void s9(){
  acierto = false;
  for(int i=0;i<8;i++){
    for(int j=0;j<8;j++){
      leds[i][j]=f10[i][j]; 
    }
  }
}

void s10(){
  acierto = false;
  for(int i=0;i<8;i++){
    for(int j=0;j<8;j++){
      leds[i][j]=f11[i][j]; 
    }
  }
}

void s11(){
  acierto = false;
  for(int i=0;i<8;i++){
    for(int j=0;j<8;j++){
      leds[i][j]=f12[i][j]; 
    }
  }
}

void s12(){
  acierto = false;
  for(int i=0;i<8;i++){
    for(int j=0;j<8;j++){
      leds[i][j]=f13[i][j]; 
    }
  }
}

void s13(){
  acierto = false;
  for(int i=0;i<8;i++){
    for(int j=0;j<8;j++){
      leds[i][j]=f14[i][j]; 
    }
  }
}


void Buzzer(int Nivel){
  switch(Nivel){
    case 1:
      Cancion[0]= NOTE_C4; Cancion[1]= NOTE_F7; Cancion[2]= NOTE_AS6; Cancion[3]= NOTE_C2;
      Reproducir();
      break;
    case 2:
      Cancion[0]= NOTE_B0; Cancion[1]= NOTE_GS1; Cancion[2]= NOTE_A3; Cancion[3]= NOTE_DS4;
      Reproducir();
      break;
    case 3:
      Cancion[0]= NOTE_FS5; Cancion[1]= NOTE_D4; Cancion[2]= NOTE_GS4; Cancion[3]= NOTE_AS7;
      Reproducir();
      break;
    case 4:
      Cancion[0]= NOTE_E5; Cancion[1]= NOTE_D6; Cancion[2]= NOTE_A6; Cancion[3]= NOTE_B4;
      Reproducir();
      break;
    case 5:
      Cancion[0]= NOTE_G1; Cancion[1]= NOTE_D1; Cancion[2]= NOTE_DS8; Cancion[3]= NOTE_B6;
      Reproducir();
      break;
  }
}

void Reproducir(){
  for(int Nota=0;Nota < 4; Nota++){
    analogWrite(alarma,Cancion[Nota]);
    delay(200);
  }
  analogWrite(alarma,0);
}

