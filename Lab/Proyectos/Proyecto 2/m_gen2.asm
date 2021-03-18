;--------OBTENER EL USUARIO// LIMITE DE 7 CARACTERES-----------------
ObtenerUsuario macro buffer
LOCAL Guardar,FIN,FIN2
push cx
xor cx,cx
xor si,si
Guardar:
cmp cx,7 ;--------si llego hasta 7 caracteres
je FIN2
getChar
cmp al,0dh ;--------salto de linea
je FIN
mov buffer[si],al
inc cx
inc si
jmp Guardar
FIN2:
print salto2
FIN:
inc si
mov buffer[si],24h
pop cx
endm

;-----OBTENER CONTRASEñA // 4 DIGITOS // MOSTRAR EL *
ObtenerContrasena macro buffer
LOCAL Guardar,FIN
push cx
xor cx,cx
xor si,si
Guardar:
cmp cx,4 ;--------si llego hasta 4 caracteres
je FIN
getChar2
cmp al,0dh ;--------salto de linea
je FIN
;---------verificar que solo vengan numeros
cmp al,30h
jb Error1
cmp al,39h
ja Error1

mov buffer[si],al
inc cx
inc si
printChar 2ah ;------imprimo *
jmp Guardar
FIN:
inc si
mov buffer[si],24h
pop cx
endm

;-----OBTENER CONTRASEñA // 4 DIGITOS // MOSTRAR EL *
ObtenerContrasena2 macro buffer
LOCAL Guardar,FIN
push cx
xor cx,cx
xor si,si
Guardar:
cmp cx,4 ;--------si llego hasta 4 caracteres
je FIN
getChar2
cmp al,0dh ;--------salto de linea
je FIN
;---------verificar que solo vengan numeros
cmp al,30h
jb Error2
cmp al,39h
ja Error2

mov buffer[si],al
inc cx
inc si
printChar 2ah ;------imprimo *
jmp Guardar
FIN:
inc si
mov buffer[si],24h
pop cx
endm

;-------VERIFICAR EL LOGGEO DE USUARIO====================
Loggear macro buffer,bufferUsr,bufferPas
LOCAL Verificar,Verificar2,Descartar,Descartar1,VerificarContra,NoExiste,Salir,V2,V3,Fin
xor si,si
xor di,di
xor cx,cx

cmp buffer[0],24h ; si es $ al principio de lo que lee del archivo
je NoExiste

Verificar:
mov al,buffer[si]
mov ah,bufferUsr[di]
cmp al,ah
jne Verificar2
inc si
inc di
jmp Verificar

Verificar2:
inc cx
cmp al,2ch ;ascii de la coma
jne Descartar1
cmp ah,24h ;ascii del $
jne Descartar
jmp VerificarContra

Descartar1:
cmp al,24h ;ascii del $
je NoExiste
Descartar:
inc si
mov al,buffer[si]
cmp al,0dh ;salto de linea
je Salir
cmp al,24h ;ascii del $
je NoExiste
jmp Descartar

Salir:
inc si
xor di,di
jmp Verificar

NoExiste:
print msg9 ;usr no existe
getChar2
jmp Ingresar

VerificarContra:
inc si
xor di,di
V2:
mov al,buffer[si]
;printChar buffer[si]
mov ah,bufferPas[di]
cmp al,ah
jne V3
inc si
inc di
jmp V2

V3:
cmp ah,24h ;ascii $
je Fin
cmp al,24h ;ascii $
je Fin
print msg10 ;contra incorrecta
print salto
jmp Contra2

Fin:
endm

;------VERIFICAR SI YA EXISTE EL USUARIO, CASO CONTRARIO GUARDARLO------
VerificarExistencia macro buffer,bufferUsr,bufferPas
LOCAL Verificar,Verificar2,Descartar,Descartar1,Existe,Valido,Guardar,Salir
xor si,si
xor di,di
xor cx,cx

cmp buffer[0],24h ; si es $ al principio de lo que lee del archivo
je Guardar

Verificar:
mov al,buffer[si]
mov ah,bufferUsr[di]
cmp al,ah
jne Verificar2
inc si
inc di
jmp Verificar

Verificar2:
cmp al,2ch ;ascii de la coma
jne Descartar1
cmp ah,24h ;ascii del $
jne Descartar
jmp Existe

Descartar1:
cmp al,24h ;ascii del $
je Guardar
Descartar:
inc si
mov al,buffer[si]
cmp al,0dh ;salto de linea
je Salir
cmp al,24h ;ascii del $
je Guardar
jmp Descartar

Salir:
inc si
xor di,di
jmp Verificar

Existe:
print msg8 ;usr ya Existe
jmp Registrar

Guardar:
mov bufftemp[0],0dh

borrar FileUsuarios
crear FileUsuarios,handleUsuarios
ObtenerSize2 buffer,tamano
escribir tamano,buffer,handleUsuarios
ObtenerSize2 bufftemp,tamano
escribir tamano,bufftemp,handleUsuarios ;salto de linea

ObtenerSize2 bufferUsr,tamano	
escribir tamano,bufferUsr,handleUsuarios ;usuario
mov bufftemp[0],02ch ;ascii de la coma
mov bufftemp[1],24h ;ascii $
ObtenerSize2 bufftemp,tamano
escribir tamano,bufftemp,handleUsuarios	;coma
ObtenerSize2 bufferPas,tamano
escribir tamano,bufferPas,handleUsuarios ;contrasena
cerrar handleUsuarios
print msg7 ;usr guardado

getChar2
endm

;---------ORDENAR EL TOP 10 DE PUNTOS
TopPuntos macro bufferIn,bufferOut
LOCAL Fin,PT,Punteo1,Punteo2,Termina,Guardar,Diez,Nombre,Saltos,Seguir
mov top,45
mov contador,0
xor di,di
;%%%%%%%%%%%%%INICIO ARCHIVO%%%%%%%%%%%%%%
xor si,si
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%% TERMINA? %%%%%%%%%%%%%%%%%%%%%%%
Termina:
cmp contador,10
je Fin
;------paso a la segunda coma
mov cx,2
Seguir:
;printChar bufferIn[si]
inc si
cmp bufferIn[si],24h ;fin del archivo
je PT
cmp bufferIn[si],44 ;ascii de la coma
jne Seguir
loop Seguir
;getChar
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%PUNTEO = TOP?%%%%%%%%%%%%%%%%
;----------guardo el numero en un buffer
xor bx,bx
mov buffernumero[1],24h ;limpio del numero anterior
Punteo1:
inc si
cmp bufferIn[si],44 ;ascii de la coma
je Punteo2
mov al,bufferIn[si]
mov buffernumero[bx],al
;printChar al
inc bx
jmp Punteo1
;----------convierto ese numero a entero
Punteo2:
inc si;paso esta coma
ConvertToInt tamano,buffernumero ;punteo del jugador
mov ax,top
cmp tamano,ax ;si punteo es igual a top
jne Termina
;%%%%%%%%%%GUARDAR%%%%%%%%%%%%%%%%%%%%%%%
Guardar:
dec si
cmp bufferIn[si],0dh ;salto de linea
jne Guardar

inc contador
inc si ;me paso al inicio del nombre
inc si ;me paso el salto de linea
cmp contador,10
je Diez
mov al,contador ;del 1 al 9
add al,30h ;paso a ascii
mov bufferOut[di],al ;numero
inc di
mov bufferOut[di],46 ;punto
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
jmp Nombre

Diez:
mov bufferOut[di],31h ;numero
inc di
mov bufferOut[di],30h ;numero
inc di
mov bufferOut[di],46 ;punto
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di

Nombre:
mov al,bufferIn[si]
mov bufferOut[di],al
;printChar al
inc si
inc di
cmp bufferIn[si],44 ;coma
jne Nombre
;getChar

mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di

inc si ;nivel
mov al,bufferIn[si] ;nivel
mov bufferOut[di],al
inc di


inc si ;coma
inc si ;numero de punteo
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
;------------punteo
mov al,bufferIn[si]
mov bufferOut[di],al
inc si
inc di
mov al,bufferIn[si]
cmp al,44 ;coma
je Saltos
mov bufferOut[di],al
inc di 
inc si ;paso a la siguiente coma

Saltos:
mov bufferOut[di],0dh ;salto de linea
inc di
mov bufferOut[di],0ah ;salto de linea
inc di
inc si ;paso esta coma
jmp Termina
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%PREGUNTAR TOP%%%%%%%%%%%%%%%%%
PT:
cmp top,0
je Fin
dec top
xor si,si
jmp Termina
;%%%%%%%%%%%%FIN%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fin:
endm

;------------TOP DE TIEMPOS HECHOS-----------------
TopTiempos macro bufferIn,bufferOut
LOCAL Fin,PT,Punteo1,Punteo2,Tiemp,Termina,Guardar,Diez,Nombre,Saltos,Seguir
mov top,250
mov contador,0
xor di,di
;%%%%%%%%%%%%%INICIO ARCHIVO%%%%%%%%%%%%%%
xor si,si
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%% TERMINA? %%%%%%%%%%%%%%%%%%%%%%%
Termina:
cmp contador,10
je Fin
;------paso a la segunda coma
mov cx,3
Seguir:
;printChar bufferIn[si]
inc si
cmp bufferIn[si],24h ;fin del archivo
je PT
cmp bufferIn[si],44 ;ascii de la coma
jne Seguir
loop Seguir
;getChar
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%PUNTEO = TOP?%%%%%%%%%%%%%%%%
;----------guardo el numero en un buffer
xor bx,bx
;mov buffernumero[1],24h ;limpio del numero anterior
mov buffernumero[1],24h ;limpio del numero anterior
mov buffernumero[2],24h ;limpio del numero anterior
Punteo1:
inc si
cmp bufferIn[si],0dh ;ascii de la coma
je Punteo2
cmp bufferIn[si],0ah ;ascii de la coma
je Punteo2
mov al,bufferIn[si]
mov buffernumero[bx],al
;printChar al
inc bx
jmp Punteo1
;----------convierto ese numero a entero
Punteo2:
;getChar
;inc si;paso esta coma
ConvertToInt2 tamano,buffernumero ;punteo del jugador
;ConvertToString tamano,bufftemp
;print bufftemp
;getChar
mov ax,top
cmp tamano,ax ;si punteo es igual a top
jne Termina
;%%%%%%%%%%GUARDAR%%%%%%%%%%%%%%%%%%%%%%%
Guardar:
dec si
cmp bufferIn[si],0dh ;salto de linea
jne Guardar

inc contador
inc si ;me paso al inicio del nombre
inc si ;me paso el salto de linea
cmp contador,10
je Diez
mov al,contador ;del 1 al 9
add al,30h ;paso a ascii
mov bufferOut[di],al ;numero
inc di
mov bufferOut[di],46 ;punto
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
jmp Nombre

Diez:
mov bufferOut[di],31h ;numero
inc di
mov bufferOut[di],30h ;numero
inc di
mov bufferOut[di],46 ;punto
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di

Nombre:
mov al,bufferIn[si]
mov bufferOut[di],al
;printChar al
inc si
inc di
cmp bufferIn[si],44 ;coma
jne Nombre
;getChar

mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di

inc si ;nivel
mov al,bufferIn[si] ;nivel
mov bufferOut[di],al
inc di

mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di
mov bufferOut[di],32 ;espacio
inc di

inc si ;coma
inc si ;numero de punteo
inc si ;sgundo numero del punteo
cmp bufferIn[si],44 ;coma
je Tiemp
inc si ;coma
Tiemp:
;inc si ;numero de tiempo
;------------tiempo
Saltos2:
inc si
mov al,bufferIn[si]
;printChar al
cmp al,0dh ;salto de linea
je Saltos
mov bufferOut[di],al
inc di
jmp Saltos2
;getChar

Saltos:
mov bufferOut[di],0dh ;salto de linea
inc di
mov bufferOut[di],0ah ;salto de linea
inc di
inc si ;paso esta coma
jmp Termina
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%PREGUNTAR TOP%%%%%%%%%%%%%%%%%
PT:
cmp top,0
je Fin
dec top
xor si,si
jmp Termina
;%%%%%%%%%%%%FIN%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fin:
endm