;---------GUARDAR EN EL ARREGLO, LA FUNCION ORIGINAL PARA MOSTRARLA-------------------------
ObtenerFuncion macro buffer,n0,n1,n2,n3,n4
LOCAL SeguirN3,SeguirN2,SeguirN1,SeguirN0,FinOF
xor si,si
xor ax,ax
xor dx,dx
xor cx,cx
mov dl,10
mov buffer[si],09h ;ascii del tabulador
inc si
mov buffer[si],66h ;ascii de la letra f
inc si
mov buffer[si],28h ;ascii del (
inc si
mov buffer[si],78h ;ascii de la letra x
inc si
mov buffer[si],29h ;ascii del )
inc si
mov buffer[si],20h ;ascii del espacio en blanco
inc si
mov buffer[si],3dh ;ascii del =
inc si
mov buffer[si],20h ;ascii del espacio en blanco
inc si
cmp n4,0
je SeguirN3
MeterNumero n4,34h,buffer
SeguirN3:
cmp n3,0
je SeguirN2
MeterNumero n3,33h,buffer
SeguirN2:
cmp n2,0
je SeguirN1
MeterNumero n2,32h,buffer
SeguirN1:
cmp n1,0
je SeguirN0
MeterNumero n1,31h,buffer
SeguirN0:
cmp n0,0
je FinOF
MeterNumero n0,30h,buffer
FinOF:
endm

;-------------------------------------------------------
;-------------MACRO PARA METER LOS NUMEROS AL ARREGLO DE LA FUNCION ORIGINAL
MeterNumero macro n,exp,buffer
LOCAL Pos,Dividir44,Dividir4,Fin4,OmitirEx
mov ax,n
test ax,1000000000000000
jz Pos
neg ax
mov buffer[si],2dh ;ascii del -
inc si
mov buffer[si],20h ;ascii del espacio en blanco
inc si
jmp Dividir4
Pos:
mov buffer[si],2bh ;ascii del +
inc si
mov buffer[si],20h ;ascii del espacio en blanco
inc si
jmp Dividir4
Dividir44:
xor ah,ah
Dividir4:
div dl
inc cx
push ax
cmp al,00h ;si ya dio 0 en el cociente dejar de dividir
je Fin4
jmp Dividir44
Fin4:
pop ax
add ah,30h
mov buffer[si],ah
inc si
loop Fin4
mov bl,exp
cmp bl,30h
je OmitirEx
mov buffer[si],2ah ;ascii del *
inc si
mov buffer[si],78h ;ascii de la letra x
inc si
mov buffer[si],exp ;ascii del exponente
inc si
mov buffer[si],20h ;ascii del espacio en blanco
inc si
OmitirEx:
endm
;---------------------------------------------------------
;-------OBTENER CONSTANTES DE LA DERIVADA-----------------
ObtenerConstantesD macro c1,c2,c3,c4,dc1,dc2,dc3,dc4
LOCAL Saltar1,Saltar2,Saltar3,Saltar4
xor ax,ax
xor dx,dx
mov dc1,0
mov dc2,0
mov dc3,0
mov dc4,0

;---constante 1 siempre se queda con el valor de x1
cmp c1,0
je Saltar1
mov ax,c1
mov dc1,ax

Saltar1:
;---constante 2 se multiplica por 2
cmp c2,0
je Saltar2
mov dl,02h
mov ax,c2
mul dx
mov dc2,ax

Saltar2:
;---constante 3 se multiplica por 3
cmp c3,0
je Saltar3
mov dl,03h
mov ax,c3
mul dx
mov dc3,ax

Saltar3:
;---constante 4 se multiplica por 4
cmp c4,0
je Saltar4
mov dl,04h
mov ax,c4
mul dx
mov dc4,ax

Saltar4:
endm
;-----------------------------------------------------------------------------------------------
;---------GUARDAR EN EL ARREGLO, LA FUNCION DERIVADA PARA MOSTRARLA-------------------------
ObtenerFuncionD macro buffer,n0,n1,n2,n3
LOCAL SeguirN3,SeguirN2,SeguirN1,SeguirN0,FinOF
xor si,si
xor ax,ax
xor dx,dx
xor cx,cx
mov dl,10
mov buffer[si],09h ;ascii del tabulador
inc si
mov buffer[si],66h ;ascii de la letra f
inc si
mov buffer[si],27h ;ascii de '
inc si
mov buffer[si],28h ;ascii del (
inc si
mov buffer[si],78h ;ascii de la letra x
inc si
mov buffer[si],29h ;ascii del )
inc si
mov buffer[si],20h ;ascii del espacio en blanco
inc si
mov buffer[si],3dh ;ascii del =
inc si
mov buffer[si],20h ;ascii del espacio en blanco
inc si
cmp n3,0
je SeguirN2
MeterNumero n3,33h,buffer
SeguirN2:
cmp n2,0
je SeguirN1
MeterNumero n2,32h,buffer
SeguirN1:
cmp n1,0
je SeguirN0
MeterNumero n1,31h,buffer
SeguirN0:
cmp n0,0
je FinOF
MeterNumero n0,30h,buffer
FinOF:
endm

;-----------------------------------------------------------------------------------------------
;---------GUARDAR EN EL ARREGLO, LA FUNCION INTEGRAL PARA MOSTRARLA-------------------------
ObtenerFuncionI macro buffer,n0,n1,n2,n3,n4
LOCAL SeguirN3,SeguirN2,SeguirN1,SeguirN0,FinOF
xor si,si
xor ax,ax
xor dx,dx
xor cx,cx
mov dl,10
mov buffer[si],09h ;ascii del tabulador
inc si
mov buffer[si],46h ;ascii de la letra F
inc si
mov buffer[si],28h ;ascii del (
inc si
mov buffer[si],78h ;ascii de la letra x
inc si
mov buffer[si],29h ;ascii del )
inc si
mov buffer[si],20h ;ascii del espacio en blanco
inc si
mov buffer[si],3dh ;ascii del =
inc si
mov buffer[si],20h ;ascii del espacio en blanco
inc si
cmp n4,0
je SeguirN3
MeterNumero2 n4,35h,buffer
SeguirN3:
cmp n3,0
je SeguirN2
MeterNumero2 n3,34h,buffer
SeguirN2:
cmp n2,0
je SeguirN1
MeterNumero2 n2,33h,buffer
SeguirN1:
cmp n1,0
je SeguirN0
MeterNumero2 n1,32h,buffer
SeguirN0:
cmp n0,0
je FinOF
MeterNumero2 n0,31h,buffer
FinOF:
mov buffer[si],2bh ;ascii del +
inc si
mov buffer[si],20h ;ascii del espacio en blanco
inc si
mov buffer[si],43h ;ascii de la letra C
inc si
endm

;-------------------------------------------------------
;-------------MACRO PARA METER LOS NUMEROS AL ARREGLO DE LA FUNCION ORIGINAL
MeterNumero2 macro n,exp,buffer
LOCAL Pos,Dividir44,Dividir4,Fin4,OmitirEx,OmitirExp
mov ax,n
test ax,1000000000000000
jz Pos
neg ax
mov buffer[si],2dh ;ascii del -
inc si
mov buffer[si],20h ;ascii del espacio en blanco
inc si
jmp Dividir4
Pos:
mov buffer[si],2bh ;ascii del +
inc si
mov buffer[si],20h ;ascii del espacio en blanco
inc si
jmp Dividir4
Dividir44:
xor ah,ah
Dividir4:
div dl
inc cx
push ax
cmp al,00h ;si ya dio 0 en el cociente dejar de dividir
je Fin4
jmp Dividir44
Fin4:
pop ax
add ah,30h
mov buffer[si],ah
inc si
loop Fin4

mov bl,exp
cmp bl,31h
je OmitirExp
mov buffer[si],2fh ;ascii del /
inc si
mov buffer[si],exp
inc si

OmitirExp:
mov bl,exp
cmp bl,30h
je OmitirEx
mov buffer[si],2ah ;ascii del *
inc si
mov buffer[si],78h ;ascii de la letra x
inc si
mov buffer[si],exp ;ascii del exponente
inc si
mov buffer[si],20h ;ascii del espacio en blanco
inc si
OmitirEx:
endm

;-------------------------------------------------------------
;--------PEDIR RANGO PARA LOS LIMITES DE LA GRAFICA-----------
PedirRango macro inf,sup,buffer,cen
print msg6 ;ingrese
print msg7 ;lim inf
LimpiarArr buffer,24h,SIZEOF buffer
ObtenerNumero2 buffer,4
ConvertToInt inf,buffer
print msg8 ;lim sup
LimpiarArr buffer,24h,SIZEOF buffer
ObtenerNumero2 buffer,4
ConvertToInt sup,buffer
LimpiarArr buffer,24h,SIZEOF buffer ;verficar que el inf sea menor al sup
VerificarMayor inf,sup,cen
endm

;-------------------------------------------------------------------
;-----PEDIR LA CONSTANTE DE INTEGRACION PARA LA GRAFICA---------------
PedirConstanteIntegracion macro num
LimpiarArr bufftemp,24h,SIZEOF bufftemp
print msg18
ObtenerNumero2 bufftemp,4
ConvertToInt num,bufftemp
endm
;-------------------------------------------------------------
;--------VERIFICAR QUE EL LIMITE INF SEA MENOR QUE EL SUP-----------
VerificarMayor macro limI,limS,cen
LOCAL PosI,NegI,PosPos,PosNeg,NegPos,NegNeg,FinV,Comparar,CentroNormal
mov ax,limI
test ax,1000000000000000
jz PosI
jmp NegI

PosI:
mov ax,limS
test ax,1000000000000000
jz PosPos
jmp PosNeg

NegI:
mov ax,limS
test ax,1000000000000000
jz NegPos
jmp NegNeg

PosPos:
mov ax,limI
cmp ax,limS
ja Error4
je Error4
xor dx,dx
mov ax,319
mov bx,limI
mov cx,limS
add bx,cx ; (limI+limS)
div bx    ; 319/(limI+limS)
mov bx,limI
mul bx	  ; limI * 319/(limI+limS)
mov cen,ax
jmp FinV

PosNeg:;nunca va a estar bien
jmp Error4

NegPos:;siempre va a estar bien
mov ax,limI
neg ax
Comparar:
cmp ax,limS
je CentroNormal
xor dx,dx
mov ax,319
mov bx,limI
neg bx
mov cx,limS
add bx,cx ; (limI+limS)
div bx    ; 319/(limI+limS)
mov bx,limI
neg bx
mul bx	  ; limI * 319/(limI+limS)
mov cen,ax
jmp FinV

NegNeg:
mov ax,limI
mov bx,limS
neg ax
neg bx
cmp bx,ax
ja Error4
je Error4
jmp FinV

CentroNormal:
mov cen,159
FinV:
endm

;-------EVALUAR FUNCION PARA DIBUJARLA
EvaluarFuncion macro c0,c1,c2,c3,c4,c5,inf,sup,rel,cent,yy,xx,rM,isIntegral
LOCAL CuadranteIyIV,Fin,Seguir,NoDoble,Doblel,nodob,SiPin
xor ax,ax
xor bx,bx
xor cx,cx
xor dx,dx
mov doble,0
;---------ver si hay que dibujar doble o no
cmp c5,0
jne Doblel
cmp c4,0
jne NoDoble
cmp c3,0
je NoDoble
Doblel:
mov doble,1
NoDoble:
;--------relacion = centro / limite ;para ver cuantos pixeles representan cada numero
mov ax,centro
mov dx,sup
div dl
xor ah,ah
mov rel,ax
;----------------------------------Numero de iteraciones
mov cx,sup
mov tamano,cx;voy a evaluar numero de puntos = lim sup

;--------primera vuelta cuadrante I y cuadrante IV
CuadranteIyIV:
xor bx,bx
xor dx,dx
push bx
;-------------------------obtengo f(cx)
mov cx,5
Valuar c5,tamano,cx
mov cx,4
Valuar c4,tamano,cx
mov cx,3
Valuar c3,tamano,cx
mov cx,2
Valuar c2,tamano,cx
mov cx,1
Valuar c1,tamano,cx
mov cx,0
Valuar c0,tamano,cx ;resultado final de F(cx) queda en AX

;test ax,1000000000000000
;jz Posit
;print msg12
;jmp NoPos
;Posit:
;print msg11
;NoPos:
;------------------------------------------------------------
;----------guardo el mayor resultado que puede dar la funcion
mov bx,sup
cmp tamano,bx
jne Seguir
mov rM,ax
Seguir:
mov numtemp,ax

;print salt
;ConvertToString numtemp,bufftemp
;print bufftemp
;-----------------------Obtengo coordenada Y
ObtenerCoordenadaY rM,numtemp,yy
;-----------------------Obtengo coordenada X
ObtenerCoordenadaX cent,rel,tamano,xx
;-----------------------Pinto en el pixel especificado
;print salt
;print msg9
;ConvertToString xx,bufftemp
;print bufftemp
;print msg10
;ConvertToString yy,bufftemp
;print bufftemp
cmp yy,200
je nodob
pixel xx,yy,0ch
cmp doble,1
jne nodob
cmp tamano,0
jne SiPin
mov doble,0
jmp nodob
SiPin:
ObtenerCoordenadaX2 cent,rel,tamano,xx
pixel xx,y2,0ch
nodob:
;--------------------------
;ConvertToString tamano,bufftemp
;print bufftemp
;print salt

mov dx,inf
cmp tamano,dx
je Fin
dec tamano
jmp CuadranteIyIV

Fin:
mov doble,0
xor ax,ax
xor bx,bx
xor cx,cx
xor dx,dx
endm

;----------------------------------------------------------------
;---------cuando estan consecutivos se van sumando o restando dependiendo del signo
;----------------------VALUAR UN constante(valor)^potencia
Valuar macro constante,val,potencia
LOCAL SoloNumero,Fin,Operar,Mientras,Multiplicar
cmp constante,0
je Fin
cmp potencia,0
je SoloNumero
jmp Operar
SoloNumero:
pop bx
mov ax,constante
add ax,bx
push ax
jmp Fin
Operar:
xor bx,bx
mov ax,val
mov cx,potencia
mov bx,ax
jmp Mientras
Multiplicar:
mul bx
Mientras:
loop Multiplicar
mov bx,constante
mul bx
pop bx
add ax,bx
push ax
jmp Fin
Fin:
endm

;------------------------------------
;--------OBTENER LA COORDENADA Y
ObtenerCoordenadaY macro rM,res,coordenada
LOCAL Fin,RespuestaEsMenor,Seguir,Seguir2,VerMayor,NoDibujar,VerMayor2,Saltar,NoDoble
xor dx,dx
mov ax,rM
test ax,1000000000000000
jz Saltar
neg ax
Saltar:
cmp ax,99
jb RespuestaEsMenor
je RespuestaEsMenor

;guardo en cx la relacion que hay entre el mayor numero y 99
mov bx,99
div bx
mov cx,ax
jmp Seguir

RespuestaEsMenor:
mov bx,ax
mov ax,99
div bx
mov cx,ax
jmp Seguir2

Seguir2:
xor dx,dx
mov ax,res
mul cx ;resp*rel2
test ax,1000000000000000
jz VerMayor;si el resultado es positivo
jmp VerMayor2

Seguir:
xor dx,dx
xor ax,ax
mov ax,res
div cx ;resp/rel2
test ax,1000000000000000 ;el resultado se vuelve positivo no se por que :(
jz VerMayor;si el resultado es positivo
jmp VerMayor2

VerMayor:
cmp ax,99
ja NoDibujar
mov bx,99
sub bx,ax ;99 - res/rel2  cuando es positivo y no mayor a 99
mov coordenada,bx
cmp doble,1
jne NoDoble
mov bx,99
add bx,ax
mov y2,bx
jmp Fin
NoDoble:
mov y2,200
jmp Fin

VerMayor2: ;cuando empiezan los negativos
neg ax
mov bx,99
add bx,ax ;99 - (-res/rel2)
cmp bx,198
ja NoDibujar
mov coordenada,bx
jmp Fin

NoDibujar:
mov coordenada,200
jmp Fin

Fin:
;ConvertToString rM,bufftemp
;print bufftemp
;print msg17
;ConvertToString res,bufftemp
;print bufftemp
;print msg17
;ConvertToString coordenada,bufftemp
;print bufftemp
;print msg17
;mov numtemp, cx
;ConvertToString numtemp,bufftemp
;print bufftemp
;print salt
endm

;-------------------------------
;--------OBTENER COORDENADA X
ObtenerCoordenadaX macro cent,rel,val,xx
mov ax,rel
mov dx,val
mul dx
mov cx,cent
add cx,ax
mov xx,cx
endm
;--------OBTENER COORDENADA X2
ObtenerCoordenadaX2 macro cent,rel,val,xx
mov ax,rel
mov dx,val
mul dx
mov cx,cent
sub cx,ax
mov xx,cx
endm