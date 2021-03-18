;--------------OBTENER SIZE DE UN ARREGLO YA DEFINIDO PARA QUE NO SALGA EL $----------------------
ObtenerSize macro buffer,tam
mov tam,0
mov tam,SIZEOF buffer
dec tam
endm
;--------------OBTENER SIZE DE UN ARREGLO NO DEFINIDO PARA QUE NO SALGAN LOS $----------------------
ObtenerSize2 macro buffer,tam
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
;---------------IMPRIMIR NUMERO---------------------------
;--------SOLO SE PUEDE LLAMAR UNA VEZ, A MENOS QUE ESTE DENTRO DE UN LOOP---------
;---------------CONVERTIR RESULTADO---------------------
printInt macro res,buffer
;LOCAL segDiv4,segDiv3,FinCR3 	;para poder usar la macro mas de dos veces seguidas
xor si,si
xor cx,cx
xor ax,ax
xor dx,dx

mov ax,res
mov dl,0ah
jmp segDiv3

segDiv4:
xor ah,ah
segDiv3:
div dl
;;print msg10
inc cx
push ax
cmp al,00h ;si ya dio 0 en el cociente dejar de dividir
je FinCR3
jmp segDiv4

FinCR3:
pop ax
add ah,30h
mov buffer[si],ah
inc si
loop FinCR3

mov ah,24h ;ascii del $
mov buffer[si],ah
inc si
endm

;---------------COPIAR DE UN ARREGLO A OTRO TODO SU CONTENIDO-----------------------
;---------------AMBOS ARREGLOS DEBEN SER DEL MISMO TAMAñO PARA EVITAR ERRORES---------------------
;---------------AMBOS ARREGLOS DEBEN SER DE TIPO BYTE---------------------
CopiarArrayB macro fuente, destino
xor si,si
xor cx,cx
copiar:
;--------Preguntando si llegue al final del tamaño del arreglo
cmp cx,SIZEOF fuente
je FinCAB
cmp fuente[si],3bh ;ascii del ;
je FinCAB1
;--------------------
mov al,fuente[si]
mov destino[si],al
inc si
inc cx
jmp copiar
FinCAB1:
mov al,fuente[si]
mov destino[si],al
FinCAB:
xor si,si
xor cx,cx
endm

;-----------------------------------------------------------------------------
CopiarArrayA macro fuente, destino
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
ObtenerHora macro hour,min,seg
xor ax,ax
mov ah,2ch
int 21h
push dx
push cx

xor ax,ax
xor si,si
mov al,ch ;paso a AL la hora obtenida
xor cx,cx
mov dl,0ah ;guardo un 10 en dl para hacer las divisiones
jmp segDiv3
segDiv22:
xor ah,ah
segDiv3:
div dl
inc cx
push ax
cmp al,00h ;si ya dio 0 en el cociente dejar de dividir
je FinCR3
jmp segDiv22
FinCR3:
pop ax
add ah,30h
mov hour[si],ah
inc si
loop FinCR3

pop cx
xor ax,ax
xor si,si
mov al,cl ;paso a AL los minutos obtenidos
xor cx,cx
mov dl,0ah ;guardo un 10 en dl para hacer las divisiones
jmp segDiv4
segDiv33:
xor ah,ah
segDiv4:
div dl
inc cx
push ax
cmp al,00h ;si ya dio 0 en el cociente dejar de dividir
je FinCR4
jmp segDiv33
FinCR4:
pop ax
add ah,30h
mov min[si],ah
inc si
loop FinCR4

pop dx
xor ax,ax
xor si,si
mov al,dh ;paso a AL los segundos obtenidos
xor cx,cx
mov dl,0ah ;guardo un 10 en dl para hacer las divisiones
jmp segDiv5
segDiv44:
xor ah,ah
segDiv5:
div dl
inc cx
push ax
cmp al,00h ;si ya dio 0 en el cociente dejar de dividir
je FinCR5
jmp segDiv44
FinCR5:
pop ax
add ah,30h
mov seg[si],ah
inc si
loop FinCR5

endm
