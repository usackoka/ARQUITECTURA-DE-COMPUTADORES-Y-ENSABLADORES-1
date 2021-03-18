;---------------CONVERTIR RESULTADO---------------------
ConvertirResultado macro res,buffer
xor si,si
xor cx,cx
xor ax,ax
xor dx,dx
mov ax,res
mov dl,0ah
jmp segDiv

segDiv1:
xor ah,ah
segDiv:
div dl
;print msg10
inc cx
push ax
cmp al,00h ;si ya dio 0 en el cociente dejar de dividir
je FinCR
jmp segDiv1

FinCR:
pop ax
add ah,30h
mov buffer[si],ah
inc si
loop FinCR

mov ah,24h ;ascii del $
mov buffer[si],ah
inc si
endm
;---------------OPERAR LO QUE INGRESARON MODO CALCULADORA-----------------
Operar macro n1,op,n2,res,flag1,flag2,flag3
xor ax,ax
mov flag3,0
;------Case del operador que se escoja
cmp op,2ah ;ascii del *
je Multiplicacion
cmp op,2bh ;ascii del +
je Suma
cmp op,2dh ;ascii del -
je Resta
cmp op,2fh ;ascii del /
je Division
jmp Error

Suma:
mov ax,n1
add ax,n2

mov bx,flag2
cmp flag1,bx
je flagIg
jmp flagDif

flagDif:
cmp flag1,1
je DesN1
cmp flag2,1
je DesN2
jmp SeguirFl
DesN1:
neg n1
cmp flag2,1
je DesN2
jmp SeguirFl
DesN2:
neg n2
SeguirFl:
mov bx,n2
cmp n1,bx
ja MayorUno
jb MayorDos
jmp NoComple
MayorDos:
cmp flag2,1
je SiComple
jmp NoComple
MayorUno:
cmp flag1,1
je SiComple
jmp NoComple
flagIg:
cmp flag1,1
je SiComple
jmp NoComple
SiComple:
mov flag3,1
neg ax
NoComple:

mov res,ax
jmp FinOper

Resta:
mov ax,n1
sub ax,n2

mov bx,flag2
cmp flag1,bx
je flagIg3
jmp flagDif3

flagDif3:
cmp flag1,1
je DesN13
cmp flag2,1
je DesN23
jmp SeguirFl3
DesN13:
neg n1
cmp flag2,1
je DesN23
jmp SeguirFl3
DesN23:	;viene una resta a un negativo 5 - -8 mejor lo cambio a positivo
neg n2
mov op, 2bh; ascii del +
mov flag2,0
jmp Suma
SeguirFl3:
mov bx,n2
cmp n1,bx
ja MayorUno3
jb MayorDos3
jmp NoComple3
MayorDos3:
cmp flag2,1
je SiComple3
jmp NoComple3
MayorUno3:
cmp flag1,1
je SiComple3
jmp NoComple3

flagIg3:
cmp flag1,1
je SiComple3
jmp NoComple4
SiComple3:
mov op, 2bh; ascii del +
neg n2
mov flag2,0
jmp Suma
;mov flag3,1
;neg ax
NoComple3:
mov res,ax
jmp FinOper
NoComple4: ;cuando viene una resta entre dos numeros positivos para evitar cosas como (5)-(10), mejor hago (5)+(-10) 
mov op, 2bh; ascii del +
neg n2
mov flag2,1
jmp Suma

Multiplicacion:
cmp flag1,1
jne Preguntar2
neg n1
Preguntar2:
cmp flag2,1
jne Multipli
neg n2
Multipli:
mov ax,n1
mov bx,n2
mul bx
mov res,ax
jmp FinOper

Division:
cmp flag1,1
jne Preguntar3
neg n1
Preguntar3:
cmp flag2,1
jne divi2
neg n2
divi2:
mov ax,n1
mov bx,n2
cmp n2,0
je Error17
div bl
xor ah,ah
mov res,ax
jmp FinOper

FinOper:
endm
;---------------GUARDANDO LOS NUMEROS--------------------------------
GuardarNumeros macro arr1,arr2,n1,n2,isNeg1,isNeg2,anss,isNegAns
xor si,si
xor di,di
xor ax,ax
xor bl,bl
xor cx,cx
mov dl,10
mov isNeg1,0
mov isNeg2,0
;------------GUARDANDO PRIMER NUMERO POSITIVO
PriN:
cmp arr1[si],2dh ;ascii del -
jne Neg1

mov isNeg1,1
inc si ;paso al primer numero

Neg1:
mov bl,arr1[si] ;muevo el ascii del primer numero al registro BL

cmp bl,41h ;ascii de la letra A
je TerminaN1Ans
cmp bl,61h ;ascii de la letra a
je TerminaN1Ans

sub bl,30h ;le resto 30h que es la diferencia que hay entre los numeros y sus respectivos asciis
inc si ;paso al siguiente digito
add al,bl	;sumo lo que llevo en AL contra lo que acabo de encontrar
cmp arr1[si],23h ;ascii del #
je TerminaN1
cmp arr1[si],24h ;ascii del $
je TerminaN1
mul dl	;multiplico el valor que llevo en AL contra 10
jmp PriN
;------------GUARDANDO SEGUNDO NUMERO POSITIVO
SegN:
cmp arr2[di],2dh ;ascii del -
jne Neg2

mov isNeg2,1
inc di ;paso al primer numero

Neg2:
mov bl,arr2[di] ;muevo el ascii del primer numero al registro BL

cmp bl,41h ;ascii de la letra A
je TerminaN2Ans
cmp bl,61h ;ascii de la letra a
je TerminaN2Ans

sub bl,30h ;le resto 30h que es la diferencia que hay entre los numeros y sus respectivos asciis
inc di ;paso al siguiente digito
add al,bl	;sumo lo que llevo en AL contra lo que acabo de encontrar
cmp arr2[di],23h ;ascii del #
je TerminaN2
cmp arr2[di],24h ;ascii del $
je TerminaN2
mul dl	;multiplico el valor que llevo en AL contra 10
jmp SegN

;------------FIN DE LOS NUMEROS
TerminaN1:
cmp isNeg1,1
jne NoSacar
neg ax
NoSacar:
mov n1,ax ;guardo en el numero 1 el valor del numero
xor ax,ax
jmp SegN

TerminaN2:
cmp isNeg2,1
jne NoSacar2
neg ax
NoSacar2:
mov n2,ax ;guardo en el numero 2 el valor del numero
xor ax,ax
jmp LimpiarR

TerminaN1Ans:
mov ax,anss
mov bx,isNegAns
mov isNeg1,bx
cmp isNegAns,1
je siNeg
jmp noNeg
siNeg:
neg ax
noNeg:
mov n1,ax
xor ax,ax
jmp SegN

TerminaN2Ans:
mov ax,anss
mov bx,isNegAns
mov isNeg2,bx
cmp isNegAns,1
je siNeg2
jmp noNeg2
siNeg2:
neg ax
noNeg2:
mov n2,ax
xor ax,ax
jmp LimpiarR

LimpiarR:
xor si,si
xor dx,dx
xor cx,cx
xor ax,ax
xor bx,bx
xor di,di
endm
;--------------OBTENER OPERADOR---------------------------------------
ObtenerOperador macro buffer
mov ah,01h
int 21h
cmp al,2ah ;ascii del *
je val
cmp al,2bh ;ascii del +
je val
cmp al,2dh ;ascii del -
je val
cmp al,2fh ;ascii del /
je val
jmp Error5
val:
mov buffer,al
endm
;--------------METODO PARA LIMPIAR LOS ARREGLOS DE LOS NUMEROS-----------
LimpiarNumeros macro buffer,buffer2,buffer3
xor si,si
mov cx,3
mov al,23h ;ascii del #
mov ah,24h ;ascii del $

L1:
mov buffer[si],al
inc si
loop L1

xor si,si
mov cx,3
L2:
mov buffer2[si],al
inc si
loop L2
xor si,si

xor si,si
mov cx,5
L3:
mov buffer3[si],ah
inc si
loop L3
xor si,si

xor cx,cx
endm
;--------------OBTENER NUMERO----------------------------------
ObtenerNumero1 macro buffer
xor cx,cx
xor si,si

ON1:
cmp cx,4
je Error3 ;error cuando ingresa mas de 3 caracteres
mov ah,01h
int 21h
cmp al,0dh ;ascii del \n
je FinON
cmp al,30h ;ascii del 0
jb Signo
cmp al,39h ;ascii del 9
ja Ans1
jmp valido

Ans1:
cmp al,41h ;ascii de la A
je valido
cmp al,4eh ;ascii de la N
je valido
cmp al,53h ;ascii de la S
je valido
cmp al,61h ;ascii de la a
je valido
cmp al,6eh ;ascii de la n
je valido
cmp al,73h ;ascii de la s
je valido
jmp Error4

Signo:
cmp al,2bh ;ascii del +
je valido
cmp al,2dh ;ascii del -
je valido
jmp Error4

valido:
mov buffer[si],al
inc si
inc cx
jmp ON1

FinON:
xor si,si
endm
;--------------OBTENER NUMERO----------------------------------
ObtenerNumero2 macro buffer
xor cx,cx
xor si,si

ON2:
cmp cx,4
je Error3 ;error cuando ingresa mas de 3 caracteres
mov ah,01h
int 21h
cmp al,0dh ;ascii del \n
je FinON2
cmp al,30h ;ascii del 0
jb Signo2
cmp al,39h ;ascii del 9
ja Ans2
jmp valido2

Ans2:
cmp al,41h ;ascii de la A
je valido2
cmp al,4eh ;ascii de la N
je valido2
cmp al,53h ;ascii de la S
je valido2
cmp al,61h ;ascii de la a
je valido2
cmp al,6eh ;ascii de la n
je valido2
cmp al,73h ;ascii de la s
je valido2
jmp Error4

Signo2:
cmp al,2bh ;ascii del +
je valido2
cmp al,2dh ;ascii del -
je valido2
jmp Error4

valido2:
mov buffer[si],al
inc si
inc cx
jmp ON2

FinON2:
xor si,si
endm

;-------------METODO PARA VER SI SE TIENE O NO QUE IMPRIMIR EL SIGNO MENOS----------------
ImprimirSigno macro signo,flag1,op,flag2,flag3,flag4
xor ax,ax
mov al,op
mov flag3,0

cmp al,2ah ;ascii del *
je MultiYDivi
cmp al,2bh ;ascii del +
je Rayos
cmp al,2dh ;ascii del -
je Rayos
cmp al,2fh ;ascii del /
je MultiYDivi
jmp Error

MultiYDivi:
mov ax,flag2
cmp flag1,ax
je FinImpS
jmp SiImp

SiImp:
printChar signo
mov flag3,1
jmp FinImpS

Rayos:
cmp flag4,1
je SiImp
jmp FinImpS

FinImpS:
endm