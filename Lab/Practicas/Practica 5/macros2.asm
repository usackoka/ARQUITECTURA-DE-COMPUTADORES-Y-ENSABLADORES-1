;--------------CAMBIAR EXTENSION DEL ARCHIVO A .REP------------------------------------
CambiarExtension macro ruta, reporte
xor si,si
xor cx,cx
jmp siguiente2
siguiente:
cmp cx,SIZEOF ruta
je Error15
mov al,ruta[si]
mov reporte[si],al
inc si
inc cx
siguiente2:
cmp ruta[si],2eh ;ascii del punto
jne siguiente

mov al,ruta[si]
mov reporte[si],al
inc si
mov al,72h ;ascii r
mov reporte[si],al
inc si
mov al,65h ;ascii e
mov reporte[si],al
inc si
mov al,70h ;ascii p
mov reporte[si],al
inc si
mov al,00h
mov reporte[si],al
xor si,si
endm
;--------------VERIFICAR SI EL ARCHIVO DE ENTRADA CONTIENE ERRORES---------------------
VerificarErrores macro buffer
xor si,si
xor cx,cx
seguir:
;-----esperando numero
mov al,buffer[si]
cmp al,30h
jb Error12
cmp al,39h
ja Error12
inc si
inc cx
mov al,buffer[si]
cmp al,30h
jb Error12
cmp al,39h
ja Error12
inc si
inc cx
;-----puede venir punto y coma
mov al,buffer[si]
cmp al,3bh ;ascii del punto y coma
je TerminaVR
cmp al,24h ;ascii del $
je Error16
;-----esperando espacio en blanco
cmp al,20h ;ascii del espacio en blanco
jne Error13
inc si
inc cx
;-----esperando algun simbolo aritmetico
mov al,buffer[si]
cmp al,2ah ;ascii del *
je sigue
cmp al,2bh ;ascii del +
je sigue
cmp al,2dh ;ascii del -
je sigue
cmp al,2fh ;ascii del /
je sigue
jmp Error14
;------esperando espacio en blanco
sigue:
inc si
inc cx
mov al,buffer[si]
cmp al,24h ;ascii del $
je Error16
cmp al,20h ;ascii del espacio en blanco
jne Error13
inc si
inc cx
jmp seguir

TerminaVR:
print msg0
endm
;--------------OBTENER RUTA DEL ARCHIVO A CARGAR---------------
ObtenerRuta macro buffer
mov ah,01h
int 21h
cmp al,23h ;ascii del # ;omite todos los # que encuentre al escribir la ruta ejemplo: ##c:\entrada.arq##
je Obtener_Ruta
cmp al,0dh ;ascii del \n
je FinRuta
mov buffer[si],al
inc si
jmp Obtener_Ruta
FinRuta:
mov buffer[si],00h
xor si,si
endm
;--------------VERIFICAR QUE LA EXTENSION SEA .ARQ-----------------------
VerificarExtension macro buffer
cmp buffer[si],2eh ;ascii punto
je VerSiguiente
inc si
inc cx
cmp cx,50 ;si ya es 50 no trae extension la ruta
je Error1
jmp Verificar_Extension
VerSiguiente:
inc si
cmp buffer[si],61h ;ascii letra a
jne Error2
inc si
cmp buffer[si],72h ;ascii letra r
jne Error2
inc si
cmp buffer[si],71h ;ascii letra q
jne Error2
xor si,si
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