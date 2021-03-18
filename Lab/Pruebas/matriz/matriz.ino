void setup() {
  for (int j=2; j<19; j++)
        if(j>13){
          pinMode(j+40, OUTPUT);}
        else{
          pinMode(j, OUTPUT);}
}

void loop() {
  for (int j=2; j<10; j++)
           {
              digitalWrite(j, HIGH);     //Levantamos la columna
              for (int k= 10 ; k<18 ; k++)
                 {
                     if(k>13){
                      digitalWrite(k+40, LOW);   //Encendemos el punto
                      delay(50);
                      digitalWrite(k+40, HIGH);  //Apagamos el punto
                      }
                     else{
                      digitalWrite(k, LOW);   //Encendemos el punto
                      delay(150);
                      digitalWrite(k, HIGH);  //Apagamos el punto
                      }
                 }
              digitalWrite(j, LOW);                //Bajamos la columna
           }
}
