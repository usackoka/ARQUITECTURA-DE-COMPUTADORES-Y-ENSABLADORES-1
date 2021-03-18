Obte macro buffer,buffer2
LOCAL Guardar,Sacar
xor di,di
xor ax,ax
mov cx,4
Guardar:
mov al,buffer[si]
push ax
inc si
Loop Guardar

xor di,di
mov cx,4
Sacar:
pop ax
mov buffer2[di],al
inc di
Loop Sacar
endm

;-----OBTENGO EL TAMAÑO, EL ANCHO Y EL ALTO DE LA IMAGEN
;-----Y LOS GUARDO COMO VARIABLES
;Los primeros 2 bytes tienen los asciis BM (nos los saltamos)
;los siguientes 4 bytes tienen el numero que representa tamano en bytes pero al revez, meterlos a la pila
ObtenerAtributosImagen macro buffInfo,arrtam,arranch,arralt,arrinicio
xor si,si
add si,02h ; salto los primeros 2 bytes
;-----Obteniendo tam bytes
Obte buffInfo,arrtam
add si,04h ;salto los 4 que siguen que no se que son :'v
;----Obteniendo donde comienza la paleta de pixeles
Obte buffInfo,arrinicio
add si,04h ;salto los 4 que siguen que no se que son :'v
;----Obteniendo ancho en pixeles
Obte buffInfo,arranch
;----Obteniendo alto en pixeles
Obte buffInfo,arralt
xor di,di
xor si,si
endm

;-------------CONVIERTE A NUMERO ENTERO DECIMAL EL NUMERO QUE VINO
PasarADecimal macro arrtam,tam
;--pasando el de tamano en bytes
xor si,si
xor ax,ax
xor cx,cx

add si,02h
mov bx,256 ;16^2
mov al,arrtam[si]
mul bx
inc si
mov cl,arrtam[si]
add ax,cx
mov tam,ax
endm

;-----------LEE LOS ATRIBUTOS DEL ENCABEZADO---------------
leerEncabezado macro numBytes,buffer,sizePaleta,anch,alt,handle,sizeFile
mov ah,3fh
mov cx,numBytes
lea dx,buffer
mov bx,handle
int 21h
jc Error10

mov ax,buffer[02h]
mov sizeFile,ax
mov ax,buffer[0Ah]
sub ax,numBytes
shr ax,1
shr ax,1
mov sizePaleta,ax
mov ax,buffer[12h]
mov anch,ax 
mov ax,buffer[16h]
mov alt,ax
endm

;------LEE Y GUARDA LA PALETA DE COLORES-------------------
leerPaletaDeColores macro size,buffer,handle,uno,dos,tres
LOCAL Seguir2
mov ah,3fh
mov cx,size
shl cx,1 ;multiplicar por 4 para obtener tamano en bytes
shl cx,1
lea dx,buffer
mov bx,handle
int 21h

lea si,buffer
mov cx,size
mov dx,3c8h
mov al,0
out dx,al
inc dx
Seguir2:
mov al,[si+uno]
shr al,1
shr al,1
out dx,al

mov al,[si+dos]
shr al,1
shr al,1
out dx,al

mov al,[si+tres]
shr al,1
shr al,1
out dx,al
add si,4
loop Seguir2
endm

;------LEE Y GUARDA LA PALETA DE COLORES-------------------
leerPaletaDeColoresB macro size,buffer,handle,uno,dos,tres
LOCAL Seguir2
mov ah,3fh
mov cx,size
shl cx,1 ;multiplicar por 4 para obtener tamano en bytes
shl cx,1
lea dx,buffer
mov bx,handle
int 21h

lea si,buffer
mov cx,size
mov dx,3c8h
mov al,0
out dx,al
inc dx

Seguir2:
mov al,[si+uno]
shr al,1
shr al,1
call met_brillo
out dx,al

mov al,[si+dos]
shr al,1
shr al,1
call met_brillo
out dx,al

mov al,[si+tres]
shr al,1
shr al,1
call met_brillo
out dx,al
add si,4
loop Seguir2

endm

;------LEE Y GUARDA LA PALETA DE COLORES-------------------
leerPaletaDeColoresN macro size,buffer,handle,uno,dos,tres
LOCAL Seguir2
mov ah,3fh
mov cx,size
shl cx,1 ;multiplicar por 4 para obtener tamano en bytes
shl cx,1
lea dx,buffer
mov bx,handle
int 21h

lea si,buffer
mov cx,size
mov dx,3c8h
mov al,0
out dx,al
inc dx
Seguir2:
mov al,[si+uno]
shr al,1
shr al,1
mov ah,al
mov al,64
sub al,ah
out dx,al

mov al,[si+dos]
shr al,1
shr al,1
mov ah,al
mov al,64
sub al,ah
out dx,al

mov al,[si+tres]
shr al,1
shr al,1
mov ah,al
mov al,64
sub al,ah
out dx,al
add si,4
loop Seguir2
endm

;------LEE Y GUARDA LA PALETA DE COLORES-------------------
leerPaletaDeColoresN2 macro size,buffer,handle,uno,dos,tres
LOCAL Seguir2
mov ah,3fh
mov cx,size
shl cx,1 ;multiplicar por 4 para obtener tamano en bytes
shl cx,1
lea dx,buffer
mov bx,handle
int 21h

lea si,buffer
mov cx,size
mov dx,3c8h
mov al,0
out dx,al
inc dx
Seguir2:
mov al,[si+2]
sub al,0ffh
neg al
shr al,1
shr al,1
out dx,al

mov al,[si+1]
sub al,0ffh
neg al
shr al,1
shr al,1
out dx,al

mov al,[si]
sub al,0ffh
neg al
shr al,1
shr al,1
out dx,al
add si,4
loop Seguir2
endm

;--------------MOSTRAR LA IMAGEN NORMAL
MostrarNormal macro buffer,anch,alt,handle
LOCAL Seguir
mov cx,alt

;valores para centrar
  push cx
  shr cx,1
  push dx
  mov dx,100
  sub dx,cx
  mov cambio_y,dx


  mov cx,ancho
  shr cx,1
  mov dx,160
  sub dx,cx
  mov cambio_x,dx


  pop dx
  pop cx

  ;printn cx 

  mov cx,alt

Seguir:
push cx
add cx,cambio_y
  mov     di,cx
mov ax,320
mul cx
mov di,ax
add di,cambio_x
leer anch,buffer,handle

cld
mov cx,anch
lea si,buffer
rep movsb
pop cx

loop Seguir
endm

;--------------MOSTRAR GIRO 180
MostrarGiro180 macro buffer,anch,alt,handle
LOCAL Seguir,Fin
mov cx,alt

;valores para centrar
  push cx
  shr cx,1
  push dx
  mov dx,100
  sub dx,cx
  mov cambio_y,dx


  mov cx,ancho
  shr cx,1
  mov dx,160
  sub dx,cx
  mov cambio_x,dx


  pop dx
  pop cx

  ;printn cx 

  mov cx,-1
  
Seguir:
add cx,1
push cx
add cx,cambio_y
  mov     di,cx
mov ax,320
mul cx
mov di,ax
add di,cambio_x
leer anch,buffer,handle

cld
mov cx,anch
lea si,buffer
rep movsb
pop cx

cmp cx,alt
jne Seguir
Fin:
endm

;--------------MOSTRAR GIRO DERECHA
MostrarGiroDerecha macro buffer,anch,alt,handle
LOCAL Seguir,Fin,Otra
mov cx,0
Seguir:
push cx
mov di,cx ;donde lo pinta
leer anch,buffer,handle
cld
mov cx,anch
lea si,buffer ;lo que pinta
Otra:
movsb
add di,319
cmp di,64000
ja Fin
loop Otra
Fin:
pop cx 
inc cx
cmp cx ,alt
jne Seguir
endm

;--------------MOSTRAR GIRO IZQUIERDA
MostrarGiroIzquierda macro buffer,anch,alt,handle
LOCAL Seguir,Fin,Otra
mov cx,alt
Seguir:
push cx
mov di,cx ;donde lo pinta
leer anch,buffer,handle
cld
mov cx,anch
lea si,buffer ;lo que pinta
Otra:
movsb
add di,319
cmp di,64000
ja Fin
loop Otra
Fin:
pop cx 
dec cx
cmp cx ,0
jne Seguir
endm

;--------------MOSTRAR GIRO HORIZONTAL
MostrarGiroHorizontal macro buffer,anch,alt,handle
LOCAL Seguir
mov cx,alt
Seguir:
push cx
mov ax,320
mul cx
mov di,ax

leer anch,buffer,handle
Invertir buffer,anch

cld
mov cx,anch
lea si,buffer
rep movsb
pop cx
loop Seguir
endm

;-----------MOSTRAR GIRO VERTICAL
MostrarGiroVertical macro buffer,anch,alt,handle
LOCAL Seguir,Fin
mov cx,0
Seguir:
push cx
mov ax,320
mul cx
mov di,ax

leer anch,buffer,handle

cld
mov cx,anch
lea si,buffer
rep movsb

pop cx
inc cx
cmp cx,alt
je Fin
jmp Seguir

Fin:
endm

;-----------INVERTIR LOS BYTES DE UN BUFFER
;--------EJEMPLO : 1 2 3 4 5 -> 5 4 3 2 1
Invertir macro buffer,size
LOCAL Meter,Sacar
push di
xor di,di
mov cx,size
Meter:
xor ah,ah
mov al,buffer[di]
push ax
inc di
loop Meter

xor di,di
mov cx,size
Sacar:
pop ax
mov buffer[di],al
inc di
loop Sacar
pop di
endm

;-----------------------------
metodoBrillo macro
LOCAL sig55,sig56,sig57,sig58,sig59,sig60,sig61,sig62,sig63,sig,fin,solo_sumar10
  cmp al,54
  jb solo_sumar10

  ;sumar 9
  cmp al,54
  jne sig55
  add al,9

  sig55:

  ;sumar 8
  cmp al,55
  jne sig56
  add al,8

  sig56:

  ;sumar 7
  cmp al,56
  jne sig57
  add al,7

  sig57:

  ;sumar 6
  cmp al,57
  jne sig58
  add al,6

  sig58:

  ;sumar 5
  cmp al,58
  jne sig59
  add al,5

  sig59:

  ;sumar 4
  cmp al,59
  jne sig60
  add al,4

  sig60:

  ;sumar 3
  cmp al,60
  jne sig61
  add al,3

  sig61:

  ;sumar 2
  cmp al,61
  jne sig62
  add al,2

  sig62:

  ;sumar 3
  cmp al,62
  jne sig63
  add al,1

  sig63:

  jmp fin

  solo_sumar10:
  add al,10

  fin:
endm