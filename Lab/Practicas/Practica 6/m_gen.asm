;--------------OBTENER SIZE DE UN ARREGLO YA DEFINIDO PARA QUE NO SALGA EL $----------------------
ObtenerSize macro buffer,tam
mov tam,0
mov tam,SIZEOF buffer
dec tam
endm
;--------------OBTENER SIZE DE UN ARREGLO NO DEFINIDO PARA QUE NO SALGAN LOS $----------------------
ObtenerSize2 macro buffer,tam
LOCAL see,FinBs,FinBs2
mov tam,0
mov cx,0
xor si,si
see:
cmp buffer[si],24h ;ascii del $
je FinBs
cmp buffer[si],3bh ;ascii del ;
je FinBs2
inc cx
inc si
jmp see
FinBs2:
inc cx
FinBs:
mov tam,cx
endm
;--------------LIMPIAR CONSOLA---------------------------------
LimpiarConsola macro
mov ax,0600h
mov bh,89h
mov cx,0000h
mov dx,184Fh
int 10h
endm
;--------------OBTENER CARACTER DE CONSOLA----------------------
getChar macro
mov ah,0dh
int 21h
mov ah,01h
int 21h
endm
;--------------MACRO IMPRESION DE CADENA---------------------------
print macro cadena
push ax
push dx
mov ax,@data
mov ds,ax
mov ah,09
mov dx,offset cadena ;equivalente a lea dx,cadena, inicializa en dx la posicion donde comienza la cadena
int 21h
pop dx
pop ax
endm
;--------------MACRO IMPRESION DE CARACTER------------------
printChar macro caracter
mov ah,02h
mov dl,caracter
int 21h
endm
;-------------------------------------------------------------------------------------------
;---------------GUARDAR NUMERO SEGUN UN BUFFER CON EL NUMERO INGRESADO----------------------
ConvertToInt macro num,buffer
LOCAL FinNumero,SaveNum,OmitirMas,NoComplementoA2
xor si,si
xor cx,cx
xor ax,ax
xor dx,dx
xor bx,bx
mov dl,10

cmp buffer[si],2bh ;ascii del +
je OmitirMas
cmp buffer[si],2dh ;ascii del -
jne SaveNum

mov cx,1 ;bandera para saber si tengo que sacar complemento o no
OmitirMas:
inc si ;paso al primer numero

SaveNum:
;print err2
mov bl,buffer[si] ;muevo el ascii del primer numero al registro BL
sub bl,30h ;le resto 30h que es la diferencia que hay entre los numeros y sus respectivos asciis
inc si ;paso al siguiente digito
add al,bl	;sumo lo que llevo en AL contra lo que acabo de encontrar
cmp buffer[si],20h ;ascii del espacio en blanco
je FinNumero
cmp buffer[si],24h ;ascii del $
je FinNumero
mul dl	;multiplico el valor que llevo en AL contra 10
jmp SaveNum

FinNumero:
cmp cx,1
jne NoComplementoA2
neg ax
NoComplementoA2:
mov num,ax
;print salt
endm
;---------------IMPRIMIR NUMERO---------------------------
;---------------CONVERTIR RESULTADO---------------------
ConvertToString macro res,buffer
LOCAL Dividir,Dividir2,FinCR3 	;para poder usar la macro mas de dos veces seguidas
push ax
push cx
push dx

xor si,si
xor cx,cx
xor ax,ax
xor dx,dx

mov ax,res
mov dl,0ah

test ax,1000000000000000
jz Dividir2
;print msg12
neg ax
jmp Dividir2

Dividir:
xor ah,ah
Dividir2:
div dl
inc cx
push ax
cmp al,00h ;si ya dio 0 en el cociente dejar de dividir
je FinCR3
jmp Dividir

FinCR3:
pop ax
add ah,30h
mov buffer[si],ah
inc si
loop FinCR3

mov ah,24h ;ascii del $
mov buffer[si],ah
inc si
pop dx
pop cx
pop ax
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
LOCAL ON2,Signo2,valido2,FinON2,NoCero
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
cmp cx,0 ;si no ingreso nada, solo el enter, asigno un 0 default
jne NoCero
mov buffer[si],30h
NoCero:
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
mov handle,ax 
jc Error8
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
;----------------------------------------------------------------