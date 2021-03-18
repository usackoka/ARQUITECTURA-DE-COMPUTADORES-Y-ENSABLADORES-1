//----------------------------- LCD ---------------------------------
LiquidCrystal lcd(22,24,26,28,30,32);
//23,25,27 matriz
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

 
byte ohm[8] =
 {
    0b00000000,     // Los definimos como binarios 0bxxxxxxx
    0b00000000,
    0b00001110,
    0b00010001,
    0b00010001,
    0b00001010,
    0b00011011,
    0b00000000
 };

int NLienzos = 0;
char modo = 'F';
int hora=14;
int minutos=30;
int t1;
int t2;
int Pintando = 0;
