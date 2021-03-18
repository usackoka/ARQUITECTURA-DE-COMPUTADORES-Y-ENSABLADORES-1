;----NIVEL 3-------------
Nivel3 macro
LOCAL jugar,Mover,izquierda,derecha,Fin,Mantener,Saltar,SoltarPelota,GameWin,MP2,MP3,MP4,ETP2,ETP3

;pop ax
;mov segun,ax
LimpiarVid
;ModoTexto
;ModoGrafico
mov estadop1,1
mov estadop2,1
mov estadop3,1
mov yapaso,0
mov yapaso2,0
mov viva1,1
mov viva2,0
mov viva3,0
mov nivel,3
mov punteo,25 ;aseguro que tenga 10 cuando empiece el segundo nivel

mov solto,0
mov pelotas,1
PintarMarco
PintarBarra
;al modificar los parametros de pintar cubos modificar tambien en verificarChoque
mov lineas,4
mov cuadrosxlinea,5
mov anchocuadros,30
mov separacioncuadros,10

PintarCubos lineas,cuadrosxlinea,anchocuadros,separacioncuadros ;no lineas, cuadros por linea, ancho de los cuadros, separacion de los cuadros
mov p1,0e664h ;(320*184)+100
PintarPelota p1,3
mov p2,0e6dch ;(320*184)+220
;PintarPelota p2,3
mov p3,0e69eh ;(320*184)+158
;PintarPelota p3,3

jugar:
cmp perdio,1
je Fin
cmp punteo,45
je GameWin

ActualizarHUD

cmp solto,0
je Saltar

cmp viva1,1
jne MP2
MoverPelota p1,estadop1,viva1
MP2:
cmp punteo,32
jb MP3
cmp yapaso,1
je ETP2
mov viva2,1
inc pelotas
mov yapaso,1
ETP2:
cmp viva2,1
jne MP3
MoverPelota p2,estadop2,viva2

MP3:
cmp punteo,39
jb MP4
cmp yapaso2,1
je ETP3
mov viva3,1
inc pelotas
mov yapaso2,1
ETP3:
cmp viva3,1
jne MP4
MoverPelota p3,estadop3,viva3
MP4:

Delay 145

Saltar:
mov ah,01h
int 16h ;verificar si hay tecla lista para ser leida
jz jugar
mov ah,00h
int 16h ;leer la tecla

cmp ah,1 ;si es el boton ESC
jne Mover
Mantener:
mov ah,00h
int 16h ;esperar otro ESC o un Espacio
cmp ah,1 ;si es otro ESC
je jugar
cmp ah,57 ;salir del juego
je Fin
jmp Mantener

Mover:
cmp ah,57
je SoltarPelota
cmp ah,77
je derecha
cmp ah,75
je izquierda
jmp jugar

izquierda:
MoverIzquierda
jmp jugar

derecha:
MoverDerecha
jmp jugar

SoltarPelota:
mov solto,1
jmp jugar

GameWin:
Fin:
endm

;-------NIVEL 2--------------
Nivel2 macro
LOCAL jugar,Mover,izquierda,derecha,Fin,Mantener,Saltar,SoltarPelota,ANivel3,MP2,MP3,ETP2

;ModoTexto
;ModoGrafico
LimpiarVid
mov estadop1,1
mov estadop2,1
mov viva1,1
mov viva2,0
mov nivel,2
mov yapaso,0
mov punteo,10 ;aseguro que tenga 10 cuando empiece el segundo nivel

mov solto,0
mov pelotas,1
PintarMarco
PintarBarra
;al modificar los parametros de pintar cubos modificar tambien en verificarChoque
mov lineas,3
mov cuadrosxlinea,5
mov anchocuadros,30
mov separacioncuadros,10

PintarCubos lineas,cuadrosxlinea,anchocuadros,separacioncuadros ;no lineas, cuadros por linea, ancho de los cuadros, separacion de los cuadros
mov p1,0e6dch ;(320*184)+100 0e6dch
PintarPelota p1,3
mov p2,0e664h ;(320*184)+220
;PintarPelota p2,3

jugar:
cmp perdio,1
je Fin
cmp punteo,25
je ANivel3

ActualizarHUD

cmp solto,0
je Saltar

cmp viva1,1
jne MP2
MoverPelota p1,estadop1,viva1
MP2:
cmp punteo,17
jb MP3
cmp yapaso,1
je ETP2
mov viva2,1
inc pelotas
mov yapaso,1
ETP2:
cmp viva2,1
jne MP3
MoverPelota p2,estadop2,viva2
MP3:

Delay 170

Saltar:
mov ah,01h
int 16h ;verificar si hay tecla lista para ser leida
jz jugar
mov ah,00h
int 16h ;leer la tecla

cmp ah,1 ;si es el boton ESC
jne Mover
Mantener:
mov ah,00h
int 16h ;esperar otro ESC o un Espacio
cmp ah,1 ;si es otro ESC
je jugar
cmp ah,57 ;salir del juego
je Fin
cmp al,33h ;a nivel 3
je ANivel3
jmp Mantener

Mover:
cmp ah,57
je SoltarPelota
cmp ah,77
je derecha
cmp ah,75
je izquierda
jmp jugar

izquierda:
MoverIzquierda
jmp jugar

derecha:
MoverDerecha
jmp jugar

SoltarPelota:
mov solto,1
jmp jugar

ANivel3:
;mov ax,segun
;push ax
Nivel3
jmp Fin

Fin:
endm

;--------NIVEL 1----------------
Nivel1 macro nivel
LOCAL jugar,Mover,izquierda,derecha,Fin,Mantener,Saltar,SoltarPelota,ANivel2,ANivel3

;AH = 2ch: Leer hora del sistema(CH=hora; CL=min; DH=seg)
mov ah,2ch
int 21h
mov segundos,dh
mov minutos,cl

xor ah,ah
mov al,minutos
mov cx,60
mul cx
mov cl,segundos
xor ch,ch
add ax,cx
mov segun,ax

PintarMarco
PintarBarra
;al modificar los parametros de pintar cubos modificar tambien en verificarChoque
mov perdio,0
mov punteo,0
mov tiempo,0
mov nivel,1
mov lineas,2
mov cuadrosxlinea,5
mov anchocuadros,30
mov separacioncuadros,10
mov estadop1,1

mov pelotas,1
PintarCubos lineas,cuadrosxlinea,anchocuadros,separacioncuadros ;no lineas, cuadros por linea, ancho de los cuadros, separacion de los cuadros
mov p1,0e7a4h
PintarPelota p1,3

jugar:
cmp perdio,1
je Fin
cmp punteo,10
je ANivel2

ActualizarHUD

cmp solto,0
je Saltar
MoverPelota p1,estadop1,viva1
Delay 190

Saltar:
mov ah,01h
int 16h ;verificar si hay tecla lista para ser leida
jz jugar
mov ah,00h
int 16h ;leer la tecla

cmp ah,1 ;si es el boton ESC
jne Mover
Mantener:
mov ah,00h
int 16h ;esperar otro ESC o un Espacio
cmp ah,1 ;si es otro ESC
je jugar
cmp ah,57 ;salir del juego
je Fin
cmp al,32h ;a nivel 2
je ANivel2
cmp al,33h ;a nivel 3
je ANivel3
jmp Mantener

Mover:
cmp ah,57
je SoltarPelota
cmp ah,77
je derecha
cmp ah,75
je izquierda
jmp jugar

izquierda:
MoverIzquierda
jmp jugar

derecha:
MoverDerecha
jmp jugar

SoltarPelota:
mov solto,1
jmp jugar

ANivel2:
Nivel2
jmp Fin

ANivel3:
Nivel3
jmp Fin

Fin:
push punteo
push tiempo
push nivel
endm

;-------------ACTUALIZAR EL BUFFER HUD-----------------
ActualizarHUD macro
LOCAL Seguir,Otro,Saltar,Saltar2

printChar 32 ;espacio en blanco
printChar 32 ;espacio en blanco
printChar 32 ;espacio en blanco
printChar 32 ;espacio en blanco
printChar 32 ;espacio en blanco
printChar 32 ;espacio en blanco
printChar 32 ;espacio en blanco

printVideo regUsr

printChar 32 ;espacio en blanco
printChar 32 ;espacio en blanco
printChar 32 ;espacio en blanco
printChar 32 ;espacio en blanco
printChar 32 ;espacio en blanco

printChar 4eh ;n mayuscula
mov bx,nivel
add bl,30h
printChar bl ;numero de nivel

printChar 32 ;espacio en blanco
printChar 32 ;espacio en blanco
printChar 32 ;espacio en blanco
printChar 32 ;espacio en blanco
printChar 32 ;espacio en blanco

ConvertToString2 punteo,bufftemp
;xor si,si
;printChar bufftemp[si]
;inc si
;cmp bufftemp[si],24h
;je Saltar
;printChar bufftemp[si]
;Saltar:

printChar 32 ;espacio en blanco
printChar 32 ;espacio en blanco
printChar 32 ;espacio en blanco
printChar 32 ;espacio en blanco
printChar 32 ;espacio en blanco

;AH = 2ch: Leer hora del sistema(CH=hora; CL=min; DH=seg)
mov ah,2ch
int 21h

mov numtemp,dh
xor ah,ah
mov al,cl
mov bx,60
mul bx
mov dl,numtemp
xor dh,dh
add ax,dx
sub ax,segun
;mov ax,segun
mov tiempo,ax

ConvertToString2 tiempo,bufftemp
;xor si,si
;Saltar2:
;printChar bufftemp[si]
;inc si
;cmp bufftemp[si],24h
;jne Saltar2

printChar 0dh ;retorno de carro
endm

;----------------CONVERTIR A STRING 2---------------------
ConvertToString2 macro res,buffer
LOCAL Dividir,Dividir2,FinCR3 	;para poder usar la macro mas de dos veces seguidas
xor si,si
xor cx,cx
xor dx,dx

mov ax,res
mov bx,0ah ;para la division entre 10
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
add dl,30h
printChar dl
mov buffer[si],dl
inc si
loop FinCR3

mov ah,24h ;ascii del $
mov buffer[si],ah
endm

;-------PINTAR MARCO----------
PintarMarco macro
LOCAL Primera,Segunda,tercera,cuarta
mov dx,5 ;color del marco

mov di,1905h ;(320 * 20) + 5 donde comienza la linea horizontal superior
Primera: ;linea horizontal superior
mov [di],dl
inc di
cmp di,1a3ch ;(320 * 21) - 4  fin de la primera linea
jne Primera

mov di,0f505h ;(320 * 196) + 5 donde comienza la linea horizontal inferior
Segunda: ;linea horizontal inferior
mov [di],dl
inc di
cmp di,0f63ch ;(320 * 197) - 4  fin de la segunda linea
jne Segunda

mov di,1905h ;(320 * 20) + 5 donde comienza la linea vertical izquierda
tercera:
mov [di],dl
add di,140h
cmp di,0f645h ;(320 * 197) + 5  fin de la tercera linea
jne tercera

mov di,1a3ch ;(320 * 21) - 4 donde comienza la linea vertical derecha
cuarta:
mov [di],dl
add di,140h
cmp di,0f63ch ;(320 * 197) - 4  fin de la tercera linea
jne cuarta

endm

;------- PINTAR BARRA----------------
PintarBarra macro
LOCAL Seguir,FinPB
;inicia en columna 6 fila 193
mov dx,50

mov inicioBarra,0eca4h ;(320*189)+100
mov ax,inicioBarra
mov finBarra,ax
mov bx,ax
add finBarra,50   ; 50 ancho en pixeles de la barra
mov di,inicioBarra

Seguir:
mov [di],dl
mov [di+320],dl
mov [di+640],dl
inc bx
inc di
cmp bx,finBarra
ja FinPB
jmp Seguir

FinPB:
endm

;----PINTAR CUBOS----------------
PintarCubos macro noFilas,cuadrosPorFila,ancho,separacion
LOCAL Seguir,Pintar,Fin,Comp,Otro
mov dl,70 ;color de los cubos
xor cx,cx
xor si,si
xor bx,bx
mov ax,noFilas

mov di,01f7ch ;(320*25)+60 ;inicio de los cubos :D :3

Comp:
;cmp cubos[si],0
;je Otro2
;cmp cubos[si],1
;jne Fin

mov cx,ancho ;ancho del cubo
Seguir:
mov [di],dl ;color de los cubos
mov [di+320],dl
mov [di+640],dl
inc di
loop Seguir
jmp Otro

Otro:
inc si
inc bx
add di,separacion
cmp bx,cuadrosPorFila ;cuadros por fila
jne Comp

cmp ax,1
je Fin
dec ax
sub di,200 ;regreso al principio 
add di,0f00h ;(320*12)
xor bx,bx
jmp Comp

Fin:
endm

;-------MOVER BARRA DERECHA----------
MoverDerecha macro
LOCAL FinMD

mov di,finBarra
mov ax,[di+1]
cmp al,05h ;si hay color de marco no mover
je FinMD
mov ax,[di+2]
cmp al,05h ;si hay color de marco no mover
je FinMD
mov ax,[di+3]
cmp al,05h
je FinMD
mov ax,[di+4]
cmp al,05h
je FinMD
mov ax,[di+5]
cmp al,05h
je FinMD
mov ax,[di+6]
cmp al,05h
je FinMD
mov ax,[di+7]
cmp al,05h
je FinMD
mov ax,[di+8]
cmp al,05h
je FinMD

mov di,inicioBarra
mov dl,0 ;color negro
mov [di],dl
mov [di+320],dl
mov [di+640],dl
mov [di+1],dl
mov [di+321],dl
mov [di+641],dl
mov [di+2],dl
mov [di+322],dl
mov [di+642],dl
mov [di+3],dl
mov [di+323],dl
mov [di+643],dl
mov [di+4],dl
mov [di+324],dl
mov [di+644],dl
mov [di+5],dl
mov [di+325],dl
mov [di+645],dl
mov [di+6],dl
mov [di+326],dl
mov [di+646],dl
mov [di+7],dl
mov [di+327],dl
mov [di+647],dl

add finBarra,08h
add inicioBarra,08h

mov di,finBarra
mov dl,50 ;color de la barra
mov [di],dl
mov [di+320],dl
mov [di+640],dl
mov [di-1],dl
mov [di+319],dl
mov [di+639],dl
mov [di-2],dl
mov [di+318],dl
mov [di+638],dl
mov [di-3],dl
mov [di+317],dl
mov [di+637],dl
mov [di-4],dl
mov [di+316],dl
mov [di+636],dl
mov [di-5],dl
mov [di+315],dl
mov [di+635],dl
mov [di-6],dl
mov [di+314],dl
mov [di+634],dl
mov [di-7],dl
mov [di+313],dl
mov [di+633],dl

cmp nivel,1
jne FinMD
cmp solto,1
je FinMD
PintarPelota p1,0 ;pinto pelota color negro
add p1,08h
PintarPelota p1,3 ;pinto color de la pelota

FinMD:
endm

;------MOVER IZQUIERDA--------------
MoverIzquierda macro
LOCAL FinMI

mov di,inicioBarra
mov ax,[di-1]
cmp al,05h
je FinMI
mov ax,[di-2]
cmp al,05h
je FinMI
mov ax,[di-3]
cmp al,05h
je FinMI
mov ax,[di-4]
cmp al,05h
je FinMI
mov ax,[di-5]
cmp al,05h
je FinMI
mov ax,[di-6]
cmp al,05h
je FinMI
mov ax,[di-7]
cmp al,05h
je FinMI
mov ax,[di-8]
cmp al,05h
je FinMI

sub inicioBarra,08h

mov di,inicioBarra
mov dl,50 ;color de la barra
mov [di],dl
mov [di+320],dl
mov [di+640],dl
mov [di+1],dl
mov [di+321],dl
mov [di+641],dl
mov [di+2],dl
mov [di+322],dl
mov [di+642],dl
mov [di+3],dl
mov [di+323],dl
mov [di+643],dl
mov [di+4],dl
mov [di+324],dl
mov [di+644],dl
mov [di+5],dl
mov [di+325],dl
mov [di+645],dl
mov [di+6],dl
mov [di+326],dl
mov [di+646],dl
mov [di+7],dl
mov [di+327],dl
mov [di+647],dl

mov di,finBarra
mov dl,0 ;color negro
mov [di],dl
mov [di+320],dl
mov [di+640],dl
mov [di-1],dl
mov [di+319],dl
mov [di+639],dl
mov [di-2],dl
mov [di+318],dl
mov [di+638],dl
mov [di-3],dl
mov [di+317],dl
mov [di+637],dl
mov [di-4],dl
mov [di+316],dl
mov [di+636],dl
mov [di-5],dl
mov [di+315],dl
mov [di+635],dl
mov [di-6],dl
mov [di+314],dl
mov [di+634],dl
mov [di-7],dl
mov [di+313],dl
mov [di+633],dl

sub finBarra,08h

cmp nivel,1
jne FinMI
cmp solto,1
je FinMI
PintarPelota p1,0 ;pinto pelota color negro
sub p1,08h
PintarPelota p1,3 ;pinto color de la pelota

FinMI:
endm

;------------VERIFICAR SI HUBO CHOQUE CON LA PELOTA O NO----------------
validarChoque macro noFilas,cuadrosPorFila,ancho,separacion
LOCAL Seguir,Seguir2,Pintar,Fin,Fin2,Comp,Otro,Otro2,Choco
xor cx,cx
xor si,si
xor bx,bx
mov ax,noFilas

mov di,01f7ch ;(320*25)+60 ;inicio de los cubos :D :3

Comp:
push di
mov dl,[di]
cmp dl,0 ;no hay cubo
je Otro2
mov dl,[di]
cmp dl,70 ;hay cubo
jne Fin

mov cx,ancho ;ancho del cubo
Seguir:
mov dl,[di-320] ;arriba
cmp dl,3 ;color de la pelota
je Choco
mov dl,[di-1] ;izquierda
cmp dl,3 ;color de la pelota
je Choco
mov dl,[di+1] ;derecha
cmp dl,3 ;color de la pelota
je Choco

mov dl,[di+319] ;izquierda
cmp dl,3 ;color de la pelota
je Choco
mov dl,[di+321] ;derecha
cmp dl,3 ;color de la pelota
je Choco

mov dl,[di+639] ;izquierda
cmp dl,3 ;color de la pelota
je Choco
mov dl,[di+641] ;derecha
cmp dl,3 ;color de la pelota
je Choco
mov dl,[di+960] ;abajo
cmp dl,3 ;color de la pelota
je Choco

inc di
loop Seguir
jmp Otro

Choco:
;mov cubos[si],0 ;cubo eliminado
pop di ;saco el inicio de ese cubo
mov dl,0 ;lo voy a pintar de color negro
mov cx,ancho ;ancho del cubo
Seguir2:
mov [di],dl
mov [di+320],dl
mov [di+640],dl
inc di
loop Seguir2
inc punteo ;incremento la cantidad de puntos que tiene el jugador
jmp Fin2

Otro2:
pop di
;inc si
add di,ancho
add di,separacion
inc bx ;bloques por fila
jmp Comp

Otro:
pop cx ;saco de la pila lo que habia metido del di aunque no me sirva
;inc si ;siguiente bloque
inc bx ;contador de bloques puestos por fila
add di,separacion
cmp bx,cuadrosPorFila ;cuadros por fila
jne Comp

cmp ax,1
je Fin
dec ax
sub di,200 ;regreso al principio 
add di,0f00h ;(320*12)
xor bx,bx
jmp Comp

Fin:
pop cx
Fin2:
endm

;---------------MOVER LA PELOTA 1-------------------------------
MoverPelota macro posicionPelota,estadoPelota,viva
LOCAL Estado1,Estado2,Estado3,Estado4,Fin,Fin2,Fin3,AE1,AE2,AE3,AE4,ChoqueBloque,SigueLive

mov viva,1

cmp estadoPelota,1
je Estado1
cmp estadoPelota,2
je Estado2
cmp estadoPelota,3
je Estado3
cmp estadoPelota,4
je Estado4

Estado1:
PintarPelota posicionPelota,0 ;pinto pelota color negro
sub posicionPelota,319
PintarPelota posicionPelota,3 ;pinto color de la pelota
;//////////////////CHOQUE MURO O BARRA///////////////////////
mov di,posicionPelota
mov al,[di-319]
cmp al,05h ;choque marco
je AE4
cmp al,70 ;choque bloque
je AE4
mov al,[di-318]
cmp al,05h
je AE4
cmp al,70 ;choque bloque
je AE4
mov al,[di+3]
cmp al,05h
je AE2
cmp al,70 ;choque bloque
je AE2
mov al,[di+323]
cmp al,05h
je AE2
cmp al,70 ;choque bloque
je AE2
mov al,[di-317]
cmp al,05h
je AE4
cmp al,70 ;choque bloque
je AE4
jmp Fin3

Estado2:
PintarPelota posicionPelota,0 ;pinto pelota color negro
sub posicionPelota,321
PintarPelota posicionPelota,3 ;pinto color de la pelota
;//////////////////CHOQUE MURO O BARRA///////////////////////
mov di,posicionPelota
mov al,[di-320]
cmp al,05h
je AE3
cmp al,70 ;choque bloque
je AE3
mov al,[di-319]
cmp al,05h
je AE3
cmp al,70 ;choque bloque
je AE3
mov al,[di-1]
cmp al,05h
je AE1
cmp al,70 ;choque bloque
je AE1
mov al,[di+319]
cmp al,05h
je AE1
cmp al,70 ;choque bloque
je AE1
mov al,[di-321]
cmp al,05h ;choque marco
je AE3
cmp al,70 ;choque bloque
je AE3
jmp Fin3

Estado3:
PintarPelota posicionPelota,0 ;pinto pelota color negro
add posicionPelota,319
PintarPelota posicionPelota,3 ;pinto color de la pelota
;//////////////////CHOQUE MURO O BARRA///////////////////////
mov di,posicionPelota
mov al,[di+319]
cmp al,05h ;choque marco
je AE4
cmp al,70 ;choque bloque
je AE4
mov al,[di+639]
cmp al,05h
je AE4
cmp al,70 ;choque bloque
je AE4
mov al,[di+960]
cmp al,05h
je Fin2
cmp al,50
je AE2
cmp al,70 ;choque bloque
je AE2
mov al,[di+961]
cmp al,05h
je Fin2
cmp al,50
je AE2
cmp al,70 ;choque bloque
je AE2
mov al,[di+959]
cmp al,05h
je AE4
cmp al,70 ;choque bloque
je AE4
jmp Fin3

Estado4:
PintarPelota posicionPelota,0 ;pinto pelota color negro
add posicionPelota,321
PintarPelota posicionPelota,3 ;pinto color de la pelota
;//////////////////CHOQUE MURO O BARRA///////////////////////
mov di,posicionPelota
mov al,[di+323]
cmp al,05h ;choque marco
je AE3
cmp al,70 ;choque bloque
je AE3
mov al,[di+643]
cmp al,05h
je AE3
cmp al,70 ;choque bloque
je AE3
mov al,[di+961]
cmp al,05h
je Fin2
cmp al,50
je AE1
cmp al,70 ;choque bloque
je AE1
mov al,[di+962]
cmp al,05h
je Fin2
cmp al,50
je AE1
cmp al,70 ;choque bloque
je AE1
mov al,[di+963]
cmp al,05h
je AE3
cmp al,70 ;choque bloque
je AE3
jmp Fin3

ChoqueBloque:
validarChoque lineas,cuadrosxlinea,anchocuadros,separacioncuadros;no lineas, cuadros por linea, ancho de los cuadros, separacion de los cuadros
jmp Fin3

AE1:
mov estadoPelota,1
jmp Fin
AE2:
mov estadoPelota,2
jmp Fin
AE3:
mov estadoPelota,3
jmp Fin
AE4:
mov estadoPelota,4
jmp Fin

Fin2:
cmp pelotas,1
jne SigueLive
mov perdio,1
jmp Fin3

SigueLive:
dec pelotas
mov viva,0
PintarPelota posicionPelota,0 ;la desaparezco
jmp Fin3

Fin:
jmp ChoqueBloque
Fin3:
endm

;-------------PINTAR PELOTA
PintarPelota macro pos,color
mov di,pos
mov dl,color
mov [di],dl
mov [di+1],dl
mov [di+2],dl
mov [di+320],dl
mov [di+321],dl
mov [di+322],dl
mov [di+640],dl
mov [di+641],dl
mov [di+642],dl
endm

;-------------DELAY 1 PARA QUE SEA VISIBLE
Delay macro constante
LOCAL D1,D2,Fin
push si
push di

mov si,constante
D1:
dec si
jz Fin
mov di,constante
D2:
dec di
jnz D2
jmp D1

Fin:
pop di
pop si
endm

;-------------METER LOS 10 PRIMEROS CUBOS
meterCubos macro cantidad
LOCAL Meter
xor bx,bx
Meter:
mov cubos[bx],1
inc bx
cmp bx,cantidad
jne Meter
endm

;---------LIMPIAR TODOS LOS PIXELES
LimpiarVid macro
LOCAL Seguir,Seguir2
mov di,1900h;(320*20)
mov dl,0

mov cx,180
Seguir2:
push cx
mov cx,320
Seguir:
mov [di],dl ;color negro
inc di
loop Seguir
pop cx
loop Seguir2

endm