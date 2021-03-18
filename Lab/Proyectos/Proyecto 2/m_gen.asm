;--------------OBTENER SIZE DE UN ARREGLO YA DEFINIDO PARA QUE NO SALGA EL $----------------------
ObtenerSize macro buffer,tam
mov tam,0
mov tam,SIZEOF buffer
dec tam
endm
;--------------OBTENER SIZE DE UN ARREGLO NO DEFINIDO PARA QUE NO SALGAN LOS $----------------------
ObtenerSize2 macro buffer,tam
LOCAL see,FinBs,FinBs2
push cx
mov tam,0
mov cx,0
xor si,si
see:
cmp buffer[si],24h ;ascii del $
je FinBs
cmp buffer[si],3bh ;ascii del ;
je FinBs2
cmp buffer[si],00h ;ascii del null
je FinBs2
inc cx
inc si
jmp see
FinBs2:
inc cx
FinBs:
mov tam,cx
pop cx
endm
;--------------LIMPIAR CONSOLA---------------------------------
LimpiarConsola macro
mov ax,0600h
mov bh,89h
mov cx,0000h
mov dx,184Fh
int 10h
endm
;--------------OBTENER CARACTER DE CONSOLA CON ECHO A PANTALLA----------------------
getChar macro
mov ah,0dh
int 21h
mov ah,01h
int 21h
endm
;--------------OBTENER CARACTER DE CONSOLA SIN ECHO A PANTALLA----------------------
getChar2 macro
mov ah,08h
int 21h
endm
;-------------OBTENER CARACTERES ESPECIALES COMO LAS FLECHAS-----------
getChar3 macro
;ah = codigo de la tecla pulsada
;al = codigo ascii de la tecla
mov ah,00h
int 16h
endm
;-----------OBTENER CARACTER SI NO HAY CARACTER DISPONIBLE SALTA ESTA ESPERA---------
getChar4 macro
mov ah,01h
int 16h
;jnz ;cuando si hay un caracter disponible para leer
endm
;--------------MACRO IMPRESION DE CADENA---------------------------
print macro cadena
push ax
push dx
;push ds

mov ax,@data
mov ds,ax
mov ah,09
mov dx,offset cadena
int 21h
;equivalente a lea dx,cadena, inicializa en dx la posicion donde comienza la cadena

;pop ds
pop dx
pop ax
endm
;---------------IMPRIMIR EN MODO VIDEO-------------------
printVideo macro buffer
push ds
mov ax,@data
mov ds,ax
mov ah,09h
lea dx,buffer
int 21h
pop ds
endm
;--------------MACRO IMPRESION DE CARACTER------------------
printChar macro caracter
push ax
push dx
mov ah,02h
mov dl,caracter
int 21h
pop dx
pop ax
endm
;------------------------IMPRIMIR NUMERO EN PANTALLA
printNumero macro res
LOCAL Dividir,Dividir2,FinCR3 	;para poder usar la macro mas de dos veces seguidas
push ax
push cx
push dx
push bx
push si

xor si,si
xor cx,cx
xor ax,ax
xor dx,dx
xor bx,bx

mov ax,res
mov bx,0ah
jmp Dividir2

Dividir:
xor dx,dx
Dividir2:
div bx
inc cx
push dx
cmp ax,0 ;si ya dio 0 en el cociente dejar de dividir
je FinCR3
jmp Dividir

FinCR3:
pop dx
add dx,30h
printChar dl
inc si
loop FinCR3

pop si
pop bx
pop dx
pop cx
pop ax
endm
;-------------------------------------------------------------------------------------------
;---------------GUARDAR NUMERO SEGUN UN BUFFER CON EL NUMERO INGRESADO----------------------
ConvertToInt macro num,buffer
LOCAL FinNumero,SaveNum
push si
push ax
push dx

xor si,si
xor ax,ax
xor dx,dx

mov dl,10
mov al,buffer[si]
;printChar al
sub al,30h
inc si
cmp buffer[si],24h
je FinNumero
mul dl
mov dl,buffer[si]
sub dl,30h
xor dh,dh
xor ah,ah
add ax,dx

FinNumero:
xor ah,ah
mov num,ax
pop dx
pop ax
pop si
endm

;---------------GUARDAR NUMERO SEGUN UN BUFFER CON EL NUMERO INGRESADO----------------------
ConvertToInt2 macro num,buffer
LOCAL FinNumero,SaveNum
push si
push ax
push dx

xor si,si
xor ax,ax
xor dx,dx

mov dl,10
mov al,buffer[si]
;printChar al
sub al,30h
inc si
cmp buffer[si],24h
je FinNumero
mul dl
mov dl,buffer[si]
sub dl,30h
xor dh,dh
xor ah,ah
add ax,dx
inc si
cmp buffer[si],24h
je FinNumero
mov dl,10
mul dl
mov dl,buffer[si]
sub dl,30h
xor dh,dh
xor ah,ah
add ax,dx

FinNumero:
xor ah,ah
mov num,ax
pop dx
pop ax
pop si
endm

;---------------CONVERTIR RESULTADO---------------------
ConvertToString macro res,buffer
LOCAL Dividir,Dividir2,FinCR3 	;para poder usar la macro mas de dos veces seguidas
push ax
push cx
push dx
push bx
push si

xor si,si
xor cx,cx
xor ax,ax
xor dx,dx
xor bx,bx

mov ax,res
mov bx,0ah
jmp Dividir2

Dividir:
xor dx,dx
Dividir2:
div bx
;print msg12
inc cx
push dx
cmp ax,0 ;si ya dio 0 en el cociente dejar de dividir
je FinCR3
jmp Dividir

FinCR3:
pop dx
add dx,30h
mov buffer[si],dl
inc si
loop FinCR3

mov ah,24h ;ascii del $
mov buffer[si],ah
inc si

pop si
pop bx
pop dx
pop cx
pop ax
endm

;-------------OBTENER UN TEXTO---------------------
ObtenerTexto macro buffer
LOCAL ObtenerChar, FinOT
xor si,si ;igual a mov si,0
ObtenerChar:
getChar
cmp al,0dh ;ascii del salto de linea en hexadecimal
je FinOT
mov buffer[si],al ;mov destino,fuente
inc si ;si = si + 1
jmp ObtenerChar
FinOT:
mov al,24h ;ascii del signo dolar
mov buffer[si],al
endm

;----------OBTENER UNA RUTA------------------
ObtenerRuta macro buffer
LOCAL ObtenerChar, FinOT
xor si,si ;igual a mov si,0
ObtenerChar:
getChar
cmp al,0dh ;ascii del salto de linea en hexadecimal
je FinOT
mov buffer[si],al ;mov destino,fuente
inc si ;si = si + 1
jmp ObtenerChar
FinOT:
mov al,00h ;ascii del caracter nulo
mov buffer[si],al
;----validacion de extension .bmp
dec si
dec si
dec si
cmp buffer[si],62h ;b
jne Error6
inc si
cmp buffer[si],6dh ;m
jne Error6
inc si
cmp buffer[si],70h ;p
jne Error6
inc si
endm

;---------------COPIAR DE UN ARREGLO A OTRO TODO SU CONTENIDO-----------------------
;---------------AMBOS ARREGLOS DEBEN SER DEL MISMO TAMAñO PARA EVITAR ERRORES---------------------
;---------------AMBOS ARREGLOS DEBEN SER DE TIPO BYTE---------------------
CopiarArray macro fuente, destino
LOCAL copiar2, FinCAB11, FinCAB2
xor si,si
xor cx,cx
copiar2:
;--------Preguntando si llegue al final del tamaño del arreglo
cmp cx,SIZEOF fuente
je FinCAB2
cmp fuente[si],3bh ;ascii del ;
je FinCAB11
;--------------------
mov al,fuente[si]
mov destino[si],al
inc si
inc cx
jmp copiar2
FinCAB11:
mov al,fuente[si]
mov destino[si],al
FinCAB2:
xor si,si
xor cx,cx
endm
;-----------OBTENER HORA DEL SISTEMA-----------------------------------
;la interrupcion int 21h, con las siguientes funciones
;AH = 2ah: lee fecha del sistema(CX=año; DH=mes; DL=dia)
;AH = 2bh: Establece fecha del sistema(CX=año; DH=mes; DL=dia)
;AH = 2ch: Leer hora del sistema(CH=hora; CL=min; DH=seg)
;AH = 2dh: Establece hora del sistema(CH=hora; CL=min; DH=seg)
ObtenerHora macro hour,min,seg,numDia
xor ax,ax
xor bx,bx
mov ah,2ch
int 21h
mov bl,ch
ConvertToString bx,hour
mov bl,cl
ConvertToString bx,min
mov bl,dh
ConvertToString bx,seg
mov ah,2ah
int 21h
mov bl,dl
ConvertToString bx,numDia
endm

;------------------------------------------------------
;--------------GUARDAR NUMERO--------------------------
;---GUARDA UN NUMERO CON SIGNO, PERMITE EL SIGNO + O - SOLO AL PRINCIPIO
ObtenerNumero macro buffer,lim
LOCAL ON2,Signo2,valido2,FinON2
xor cx,cx
xor si,si

ON2:
cmp cx,lim
je Error2 ;error cuando ingresa mas de los caracteres soportados
mov ah,01h
int 21h
cmp al,0dh ;ascii del \n
je FinON2
cmp al,30h ;ascii del 0
jb Signo2
cmp al,39h ;ascii del 9
ja Error1
jmp valido2

Signo2:
cmp cx,0
jne Error1	;error cuando vuelve a ingresar un + o - luego del inicio
cmp al,2bh ;ascii del +
je valido2
cmp al,2dh ;ascii del -
je valido2
jmp Error1

valido2:
mov buffer[si],al
inc si
inc cx
jmp ON2

FinON2:
xor si,si
endm

;------------------------------------------------------
;--------------GUARDAR NUMERO--------------------------
;---GUARDA UN NUMERO CON SIGNO, PERMITE EL SIGNO + O - SOLO AL PRINCIPIO
ObtenerNumero2 macro buffer,lim
LOCAL ON2,Signo2,valido2,FinON2
xor cx,cx
xor si,si

ON2:
cmp cx,lim
je Error2 ;error cuando ingresa mas de los caracteres soportados
mov ah,01h
int 21h
cmp al,0dh ;ascii del \n
je FinON2
cmp al,30h ;ascii del 0
jb Signo2
cmp al,39h ;ascii del 9
ja Error5
jmp valido2

Signo2:
cmp cx,0
jne Error5	;error cuando vuelve a ingresar un + o - luego del inicio
cmp al,2bh ;ascii del +
je valido2
cmp al,2dh ;ascii del -
je valido2
jmp Error5

valido2:
mov buffer[si],al
inc si
inc cx
jmp ON2

FinON2:
xor si,si
endm

;------------------------------------------------------------------------------------------
;----------LIMPIAR UN ARREGLO CON CARACTER ESPECIFICO Y LIMITE ESPECIFICO----
LimpiarArr macro buffer,caracter,lim
LOCAL Limpiar, FinLA
pop cx
xor si,si
xor cx,cx

Limpiar:
cmp cx,lim
je FinLA
mov buffer[si],caracter
inc si
inc cx
jmp Limpiar

FinLA:
mov buffer[si],24h
push cx
endm

;------------------------------------------------------------------------------------------
;----------LIMPIAR UN ARREGLO CON CARACTER ESPECIFICO Y LIMITE ESPECIFICO----
LimpiarArr2 macro buffer
LOCAL Limpiar, FinLA
pop cx
xor si,si
xor cx,cx

Limpiar:
cmp cx,SIZEOF buffer
je FinLA
mov buffer[si],24h
inc si
inc cx
jmp Limpiar

FinLA:
push cx
endm

;----------------MACROS PARA UTILIZAR EL ARCHIVO-----------------
crear macro ruta,handle
lea dx,ruta
mov ah,3ch
mov cx,00h
int 21h
mov handle,ax
jc Error7
endm

abrir macro ruta,handle
;impCad ruta
lea dx,ruta
mov ah,3dh 
mov al, 00h 
int 21h 
jc Error8
mov handle,ax
endm 

escribir macro numbytes,databuffer,handle
mov ah,40h 
mov bx,handle 
mov cx,numbytes 
lea dx,databuffer 
int 21h
jc Error9
endm 

leer macro numbytes,databuffer,handle 
mov ah,3fh 
mov bx,handle
mov cx,numbytes
lea dx,databuffer
int 21h
jc Error10
endm 

cerrar macro handle
mov ah,3eh 
mov bx,handle 
int 21h
jc Error11
endm 

borrar macro databuffer
mov ah,41h
lea dx,databuffer
int 21h
jc Error12
endm
;----------------------------------------------------------------