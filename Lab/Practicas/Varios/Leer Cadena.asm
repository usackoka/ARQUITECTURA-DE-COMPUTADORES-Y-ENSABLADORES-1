Por ejemplo, para leer una cadena de maximo 90 caracteres seria asi... 

La declaras en el segmento de datos (las palabras en minusculas son nombres y datos que puedes modificar a tu conveniencia): 

nombre LABEL BYTE ; "nombre" es solo una etiqueta para identificar a tu cadena 
longitudmax DB SIZEOF cadena ; longitud maxima que podra tener la cadena 
longitudreal DB ? ;numero de bytes que mida tu cadena una vez leida 
cadena DB 90 DUP(0) ; vector de caracteres en el que se guardara la cadena 

La capturas de la siguiente forma: 

mov ah,0Ah 
mov dx,OFFSET nombre ;nota que se le da la etiqueta no el vector de caracteres 
int 21h 

E inmediatamente despues le pones el fin de cadena para que no te salgan errores: 

mov bh, 00 
mov bl, longitudreal 
mov cadena[bx], 07 
mov cadena[bx+1], '$' 

Y asi ya la puedes imprimir con el metodo convencional: 

mov ah,9 
mov dx,OFFSET cadena ;aqui si le das el vector de caracteres 
int 21h 

Con respecto a la conversion de ascii a decimal, si lo que capturas es un numero basta con restarle a AL(ya que hayas leido el numero) 48 o bien 30h, puesto que esta es la diferencia que hay entre los numeros y su equivalente en ascii. Para el caso contrario, si quieres imprimir un numero tendras que sumar en vez de restar. Obviamente existe la limitante de que solo funciona para un digito. 

ejemplos: 
;lees un 3, por lo que en AL se almacena un 51 
sub al,48 ;aqui AL ya queda con un 3 
;si tienes en alguna variable un 7 y lo quieres imprimir 
add variable,48 ;la variable ahora vale 55 que es el equivalente en ascii para el 7 ;ya se puede mandar a imprimir 

Bueno, espero que te sirva la informacion.