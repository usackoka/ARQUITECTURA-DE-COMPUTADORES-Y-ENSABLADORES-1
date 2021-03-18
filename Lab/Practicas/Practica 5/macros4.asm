AnalizarEntrada macro bufferinfo,buffersumas
xor si,si
xor di,di
xor bp,bp
xor cx,cx
xor ax,ax
xor bx,bx
xor dx,dx
mov dl,10

Num:
;------------GUARDANDO EL PRIMER NUMERO EN AL
xor ax,ax
xor bx,bx
xor dx,dx
mov dl,10
mov bl,bufferinfo[si] ;muevo el ascii del primer numero al registro BL
sub bl,30h ;le resto 30h que es la diferencia que hay entre los numeros y sus respectivos asciis
inc si ;paso al siguiente digito
add al,bl ;sumo lo que llevo en AL contra lo que acabo de encontrar
mul dl ;lo multiplico por 10
xor bl,bl
mov bl,bufferinfo[si] ;muevo el ascii del primer numero al registro BL
sub bl,30h ;le resto 30h que es la diferencia que hay entre los numeros y sus respectivos asciis
add al,bl ;sumo lo que llevo en AL contra lo que acabo de encontrar
;escribo el numero en mi buffer de sumas
mov buffersumas[di],ax
add di,02h ;aumento dos posiciones ya que es arreglo de tipo word
;print msg2
inc si ;antes numero, despues espacio en blanco o punto y coma
cmp bufferinfo[si],3bh ; ;
je FinAE
inc si ;despues signo aritmetico

Sim:
;-------------PREGUNTANDO QUE SIGNO VIENE
cmp bufferinfo[si],2bh ; +
je SYR
cmp bufferinfo[si],2dh ; -
je SYR
cmp bufferinfo[si],2ah ; *
je Opero
cmp bufferinfo[si],2fh ; /
je Opero
cmp bufferinfo[si],3bh ; ;
je FinAE
jmp Error

SYR:
;print msg3
;--------------GUARDANDO NUMERO Y SIGNO
xor ax,ax
mov al,bufferinfo[si] ;guardando el simbolo mas o menos
mov buffersumas[di],ax
add di,02h
;print msg11
inc si ;antes signo aritmetico despues espacio en blanco
inc si ;despues numero
jmp Num

Opero:
;print msg4
;-------------OPERANDO MULTIPLICACION O DIVISION
cmp bufferinfo[si],2ah ; *
je mult
cmp bufferinfo[si],2fh ; /
je divi
jmp Error1

divi:
inc si ;antes signo aritmetico despues espacio en blanco
inc si ;despues numero
xor dx,dx
xor bx,bx
xor ax,ax
mov cl,10
;------------guardo en dx el numero anterior
sub di,02h
mov dx,buffersumas[di]
;------------agarro el siguiente numero
mov bl,bufferinfo[si] ;muevo el ascii del primer numero al registro BL
sub bl,30h ;le resto 30h que es la diferencia que hay entre los numeros y sus respectivos asciis
inc si ;paso al siguiente digito
add al,bl ;sumo lo que llevo en AL contra lo que acabo de encontrar
mul cl ;lo multiplico por 10
mov bl,bufferinfo[si] ;muevo el ascii del primer numero al registro BL
sub bl,30h ;le resto 30h que es la diferencia que hay entre los numeros y sus respectivos asciis
add al,bl ;sumo lo que llevo en AL contra lo que acabo de encontrar
;------------opero num anterior x num siguiente
push ax
mov ax,dx
pop dx
div dl
inc si; antes numero despues espacio en blanco
jmp Res11

mult:
inc si ;antes signo aritmetico despues espacio en blanco
inc si ;despues numero
xor dx,dx
xor bx,bx
xor ax,ax
mov cl,10
;------------guardo en dx el numero anterior
dec di
dec di
mov dx,buffersumas[di]
;------------agarro el siguiente numero
mov bl,bufferinfo[si] ;muevo el ascii del primer numero al registro BL
sub bl,30h ;le resto 30h que es la diferencia que hay entre los numeros y sus respectivos asciis
inc si ;paso al siguiente digito
add al,bl ;sumo lo que llevo en AL contra lo que acabo de encontrar
mul cl ;lo multiplico por 10
mov bl,bufferinfo[si] ;muevo el ascii del primer numero al registro BL
sub bl,30h ;le resto 30h que es la diferencia que hay entre los numeros y sus respectivos asciis
add al,bl ;sumo lo que llevo en AL contra lo que acabo de encontrar
;------------opero num anterior x num siguiente
mul dl
inc si; antes numero despues espacio en blanco
jmp Res

;-------------guardo la respuesta
Res11:
xor ah,ah
Res:
mov buffersumas[di],ax
add di,02h
;print msg5
cmp bufferinfo[si],3bh ; ;
je FinAE
inc si; despues signo aritmetico
jmp Sim

FinAE:
xor ax,ax
mov al,3bh	;ascii ;
mov buffersumas[di],ax
;print msg6
endm

;---------------------OBTENER EL RESULTADO DE TODAS LAS SUMAS Y RESTAS--------------------------
ObtenerResultado macro res,arrayWord
mov res,0
xor di,di
xor ax,ax
xor dx,dx
xor cx,cx
xor bx,bx
mov ax, arrayWord[di]
add di,02h

Sim2:
mov cx,arrayWord[di]
cmp cx,003bh ; ;
je FinObt
cmp cx,002bh ; +
je Sumita
cmp cx,002dh ; -
je Restita
jmp Error

Sumita:
;print msg7
add di,02h
add ax,arrayWord[di]
add di,02h
jmp Sim2

Restita:
;print msg8
add di,02h 
sub ax,arrayWord[di]
add di,02h
jmp Sim2

FinObt:
;print msg6
mov res,ax
endm

;---------------CONVERTIR RESULTADO---------------------
ConvertirResultado2 macro res,buffer
xor si,si
xor cx,cx
xor ax,ax
xor dx,dx

mov ax,res
mov dl,0ah
jmp segDiv2

segDiv11:
xor ah,ah
segDiv2:
div dl
;;print msg10
inc cx
push ax
cmp al,00h ;si ya dio 0 en el cociente dejar de dividir
je FinCR2
jmp segDiv11

FinCR2:
pop ax
add ah,30h
mov buffer[si],ah
inc si
loop FinCR2

mov ah,24h ;ascii del $
mov buffer[si],ah
inc si
endm

;------------------METODO PARA OBTENER EL PREORDEN DE LA CADENA ARITMETICA-------------------------
ObtenerPreorden macro buffer
xor si,si
;-------------ORDENANDO LAS MULTIPLICACIONES Y DIVISIONES
VNum:
inc si;antes numero,despues numero
inc si;antes numero, despues espacio en blanco o punto y coma
cmp buffer[si],3bh ; ;
je FinOrdenMyD
inc si;antes espacio en blanco, despues signo aritmetico

VSigno:
cmp buffer[si],2ah ; *
je OrdenarMyD
cmp buffer[si],2fh ; /
je OrdenarMyD
cmp buffer[si],3bh ; ;
je FinOrdenMyD
cmp buffer[si],2bh ; +
je VOmitir
cmp buffer[si],2dh ; -
je VOmitir
jmp Error

VOmitir:
inc si; antes signo aritmetico, despues espacio en blanco
inc si; despues numero
jmp VNum

OrdenarMyD:
xor bx,bx
xor ax,ax
mov bh,20h ;ascii del espacio en blanco
mov bl,buffer[si]; guardo el signo aritmetico
dec si; regreso al espacio en blanco
dec si; regreso al ultimo digito del numero anterior
mov al,buffer[si]
dec si; regreso al primer digito del numero anterior
mov ah, buffer[si]
mov buffer[si],bl
inc si; subo al segundo digito donde ahora va a ir espacio en blanco
mov buffer[si],bh
inc si; subo donde va a ir el primer digito del numero
mov buffer[si],ah
inc si; subo segundo digito
mov buffer[si],al
inc si ;espacio en blanco
inc si ;segundo num digito 1
inc si ;segundo num digito 2
inc si ;viene espacio o punto y coma
cmp buffer[si],3bh ; ;
je FinOrdenMyD
inc si ;viene signo aritmetico
jmp VSigno

;----------------PASO LOS MAS Y LOS MENOS PARA LA IZQUIERDA------------------------
FinOrdenMyD:
xor si,si
xor ax,ax
xor bx,bx

Buscando:
cmp buffer[si],2bh ;ascii del +
je Intercambiar
cmp buffer[si],2dh ;ascii del -
je Intercambiar
cmp buffer[si],3bh ; ;
je FinPre
inc si
jmp Buscando

Intercambiar:
mov bx,si
push bx
mov ah,buffer[si]

Mientras:
dec si
dec si
mov al,buffer[si]
inc si
inc si
mov buffer[si],al
dec si
cmp si,0
je FinMientras
jmp Mientras

FinMientras:
mov buffer[si],ah
inc si
mov buffer[si],20h
pop bx
mov si,bx
inc si
jmp Buscando

FinPre:
endm

;------------------METODO PARA OBTENER EL PREORDEN DE LA CADENA ARITMETICA-------------------------
ObtenerPostOrden macro buffer
xor si,si
;-------------ORDENANDO LAS MULTIPLICACIONES Y DIVISIONES
VNum2:
inc si;antes numero,despues numero
inc si;antes numero, despues espacio en blanco o punto y coma
cmp buffer[si],3bh ; ;
je FinOrdenMyD2
inc si;antes espacio en blanco, despues signo aritmetico

VSigno2:
cmp buffer[si],2ah ; *
je OrdenarMyD2
cmp buffer[si],2fh ; /
je OrdenarMyD2
cmp buffer[si],3bh ; ;
je FinOrdenMyD2
cmp buffer[si],2bh ; +
je VOmitir2
cmp buffer[si],2dh ; -
je VOmitir2
jmp Error

VOmitir2:
inc si; antes signo aritmetico, despues espacio en blanco
inc si; despues numero
jmp VNum2

OrdenarMyD2:
xor bx,bx
xor ax,ax
mov bh,20h ;ascii del espacio en blanco
mov bl,buffer[si]; guardo el signo aritmetico

inc si; regreso al espacio en blanco
inc si; regreso al primer digito del numero siguiente
mov al,buffer[si]
inc si; regreso al segundo digito del numero siguiente
mov ah, buffer[si]
mov buffer[si],bl
dec si; subo al primer digito donde ahora va a ir espacio en blanco
mov buffer[si],bh
dec si; subo donde va a ir el segundo digito del numero
mov buffer[si],ah
dec si; subo segundo digito
mov buffer[si],al

inc si ;espacio en blanco
inc si ;segundo num digito 1
inc si ;segundo num digito 2
inc si ;viene espacio o punto y coma
cmp buffer[si],3bh ; ;
je FinOrdenMyD2
inc si ;viene signo aritmetico
jmp VSigno2

;---------------------------------------
FinOrdenMyD2:
xor si,si
xor ax,ax
xor bx,bx

BuscandoSumasYRestas:
cmp buffer[si],2bh ; +
je Encontrado
cmp buffer[si],2dh ; -
je Encontrado
cmp buffer[si],3bh ; ;
je FinPost
inc si
jmp BuscandoSumasYRestas

Encontrado:
mov bl,buffer[si]

BuscandoSignos:
;---copiando para atras
inc si
inc si
mov ah,buffer[si]
dec si
dec si
mov buffer[si],ah
inc si

cmp buffer[si],2ah ; *
je PorDiv
cmp buffer[si],2fh ; /
je PorDiv
cmp buffer[si],3bh ; ;
je FinPost
cmp buffer[si],2bh ; +
je SumRest
cmp buffer[si],2dh ; -
je SumRest

jmp BuscandoSignos

PorDiv:
mov bh,buffer[si]
mov buffer[si],bl
inc si
jmp BuscandoSumasYRestas

SumRest:
mov bh,buffer[si]
mov buffer[si],bl
mov bl,bh
;inc si
jmp BuscandoSignos

FinPost:
dec si
dec si
mov dl,20h
mov buffer[si],dl
inc si
mov buffer[si],bl
endm