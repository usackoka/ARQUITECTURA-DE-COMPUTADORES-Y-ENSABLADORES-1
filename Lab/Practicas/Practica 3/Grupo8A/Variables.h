LiquidCrystal lcd(38, 40, 42, 44, 46, 48);

#define pin1 23
#define pin2 25
#define pin3 27
#define pin4 29
#define pinDireccion 31

#define PinEcho 34
#define PinTrigger 36
#define alarma 6
#define interruptor 7

#define STEPS 64 //Número de pasos que necesita para dar una vuelta 64

unsigned long delaytime=200;

int kills = 0;
int EstadoInterruptor = 1;
int EstadoAnterior = 1;
int Mover = 1;
int estadoRadar=0;
int stepp=0;

int duracion = 250;
int fMin = 2000;
int fMax =4000;
//int i = 0;

char modo = 'R';
String mensaje1 = "iGRUPO 8 A! K";
long tiempo, distancia;  
int delayServo = 50;
LedControl lc=LedControl(32,28,30, 1);  // Creamos una instancia de LedControl

int hora=2;
int minutos=30;

int t1;
int t2;
int t3;

int pm = 500;
int PM = 2300;
int pos = 0;

int PinServo = 11;
int PinServo2 = 12;
int posAnterior = 0;

