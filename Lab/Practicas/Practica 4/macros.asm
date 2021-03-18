;--------------MACRO IMPRESION DE CADENA---------------------------
impCad macro cadena
  mov ax,@data
  mov ds,ax
  mov ah,09
  mov dx,offset cadena ;equivalente a lea dx,cadena, inicializa en dx la posicion donde comienza la cadena
  int 21h
endm
;--------------MACRO IMPRESION DE CARACTER------------------
imp macro caracter
mov ah,02h
mov dl,caracter
int 21h
endm
;----------------MACROS PARA UTILIZAR EL ARCHIVO-----------------
crear macro ruta,handle
lea dx,ruta
mov ah,3ch
mov cx,00h
int 21h
mov handle,ax
jc ErrorAlCrear
endm

abrir macro ruta,handle
;impCad ruta
lea dx,ruta
mov ah,3dh 
mov al, 00h 
int 21h 
mov handle,ax 
jc NoSeEncontroRuta
endm 

escribir macro numbytes,databuffer,handle 
mov ah,40h 
mov bx,handle 
mov cx,numbytes 
lea dx,databuffer 
int 21h 
endm 

leer macro numbytes,databuffer,handle 
mov ah,3fh 
mov bx,handle
mov cx,numbytes
lea dx,databuffer
int 21h
jc ErrorAlLeer
endm 

cerrar macro handle
mov ah,3eh 
mov bx,handle 
int 21h
jc ErrorAlCerrar
endm 
;----------------------------------------------------------------
