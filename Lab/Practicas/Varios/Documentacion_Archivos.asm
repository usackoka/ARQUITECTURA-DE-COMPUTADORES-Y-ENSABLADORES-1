Manejo de archivos
Hola de nuevo, después de un tiempo sin publicar nada les traigo este programa para manipular archivos, estoy seguro que les servirá.

El programa consta de un menú para ver si se quiere crear, abrir, modificar o eliminar un archivo, este archivo se guarda en el disco duro.

Para el manejo de archivos es escencial conocer las instrucciones e  interrupciones para dichas operaciones.

Para crear archivo: 3ch
Para abrir un archivo:  3dh
Para escribir sobre un archivo: 40h
Para cerrar un archivo: 3eh
Eliminar un archivo: 41h
Todas las instrucciones llevan la interrupción int 21h

En el caso de querer escribir sobre un archivo se necesita un handle. 
Un handle es una cierta cantidad de bytes que se cargan a un buffer de memoria 
"Un puntero inteligente" que son controlados por el sistema operativo, 
este handle nos permitirá escribir en nuestro archivo mas información.
También es importante mencionar que cada vez que se hace una operación sobre un archivo hay que abrirlo y cerrarlo,
en caso de crear un nuevo archivo no se abre pues este no existe, 
y al eliminar un archivo no se cierra por la misma razón

Limitaciones del programa:
El nombre del archivo siempre se define dentro del código, nunca en ejecución.
No se especifífica la ruta para guardarlo, por lo que el archivo siempre se guardará en la carpeta BIN de MASM.
Se puede escribir en el archivo siempre y cuando este vacio, para sobreescribir no lo hace correctamente.

Comenzemos con el programa, en esta ocación iré escribiendo el programa por partes y al final el código completo, para que haya menos confuciones:

Primero el menú, en esta parte no debe haber problemas, declaro variables y un macro para imprimir mensajes, comparo la opción digitada para hacer el salto a la opción que corresponda.

 imprime macro cadena
  mov ax,@data
  mov ds,ax
  mov ah,09
  mov dx,offset cadena
  int 21h
endm

.model small
.stack
.data
msj db 0ah,0dh, '***** Menu *****', '$'
msj2 db 0ah,0dh, '1.- Crear Archivo', '$'
msj3 db 0ah,0dh, '2.- Abrir Archivo', '$'
msj4 db 0ah,0dh, '3.- Modificar archivo', '$'
msj5 db 0ah,0dh, '4.- Eliminar archivo', '$'
msj6 db 0ah,0dh, '5.- Salir', '$'
msj7 db 0ah,0dh, 'El Cerrado de un arhcivo se hace automatico', '$'
msjelim db 0ah,0dh, 'Archivo eliminado con exito', '$'
msjcrear db 0ah,0dh, 'Archivo creado con exito', '$'
msjescr db 0ah,0dh, 'Archivo escrito con exito', '$'
msjnom db 0ah,0dh, 'Nombre del archivo: ', '$'
cadena db 'Cadena a Escribir en el archivo','$'
nombre db 'archivo2.txt',0  ;nombre archivo a manejar, debe terminar en 0
vec db 50 dup('$')   ;variable a usar para la escritura del archivo.
handle db 0 ;Se cargará para la escritura de archivos, tamaño en bytes.
linea db 10,13,'$'  ;Hace un solo salto de linea
.code
inicio:

menu:
  imprime msj
  imprime msj2
  imprime msj3
  imprime msj4
  imprime msj5
  imprime msj6
  imprime msj7

  mov ah,0dh
  int 21h
 ;comparamos la opción que se tecleó
  mov ah,01h
  int 21h
  cmp al,31h
  je crear
  cmp al,32h
  je abrir
  cmp al,33h
  je pedir
  cmp al,34h
  je eliminar
  cmp al,35h
  je salir

Si la opción tecleada fue 1 entonces crea el archivo:

crear:
mov ax,@data  ;Cargamos el segmento de datos para sacar el nombre del archivo.
mov ds,ax
mov ah,3ch ;instrucción para crear el archivo.
mov cx,0 
mov dx,offset nombre ;crea el archivo con el nombre archivo2.txt indicado indicado en la parte .data
int 21h
jc salir ;si no se pudo crear el archivo arroja un error, se captura con jc.
imprime msjcrear
mov bx,ax
mov ah,3eh ;cierra el archivo
int 21h
jmp menu

Si la opción tecleada fue 2 entonces abre el archivo en solo lectura:

abrir:
mov ah,3dh ;Instrucción para abrir el archivo
mov al,0h  ;0h solo lectura, 1h solo escritura, 2h lectura y escritura 
mov dx,offset nombre ;abre el archivo llamado archivo2.txt indicado en .data
int 21h
mov ah,42h ;Mueve el apuntador de lectura/escritura al archivo
mov al,00h
mov bx,ax
mov cx,50 ;Decimos que queremos leer 50 bytes del archivo
int 21h
;leer archivo
mov ah,3fh ;Lectura del archivo
mov bx,ax
mov cx,10
mov dx,offset vec
int 21h
mov ah,09h
int 21h
mov ah,3eh  ;Cierre de archivo
int 21h
jmp menu 

Si la opción digitada es 3 entonces escribe sobre el archivo:
Para esta parte antes de escribir en un archivo pido una cadena de texto, que la escriba el usuario y después se guarda la cadena en el archivo, el tamaño máximo de la cadena es de 50 carácteres.

pedir:
  mov ah,01h
  int 21h
  mov vec[si],al
  inc si
  cmp al,0dh
  ja pedir
  jb pedir
editar:
;abrir el archivo
mov ah,3dh
mov al,1h ;Abrimos el archivo en solo escritura.
mov dx,offset nombre
int 21h
jc salir ;Si hubo error

;Escritura de archivo
mov bx,ax ; mover hadfile
mov cx,si ;num de caracteres a grabar
mov dx,offset vec
mov ah,40h
int 21h
imprime msjescr
cmp cx,ax
jne salir ;error salir
mov ah,3eh  ;Cierre de archivo 
int 21h
jmp menu

Si la tecla digitada fue 4 se elimina el archivo.

eliminar:
mov ah,41h 
mov dx, offset nombre
int 21h  
jc salir ;Si hubo error
imprime msjelim

Si la tecla digitada fue 5 fin del programa:
salir:
mov ah,04ch
int 21h
end

Código completo:

imprime macro cadena
  mov ax,@data
  mov ds,ax
  mov ah,09
  mov dx,offset cadena
  int 21h
endm

.model small
.stack
.data
msj db 0ah,0dh, '***** Menu *****', '$'
msj2 db 0ah,0dh, '1.- Crear Archivo', '$'
msj3 db 0ah,0dh, '2.- Abrir Archivo', '$'
msj4 db 0ah,0dh, '3.- Modificar archivo', '$'
msj5 db 0ah,0dh, '4.- Eliminar archivo', '$'
msj6 db 0ah,0dh, '5.- Salir', '$'
msj7 db 0ah,0dh, 'El Cerrado de un arhcivo se hace automatico', '$'
msjelim db 0ah,0dh, 'Archivo eliminado con exito', '$'
msjcrear db 0ah,0dh, 'Archivo creado con exito', '$'
msjescr db 0ah,0dh, 'Archivo escrito con exito', '$'
msjnom db 0ah,0dh, 'Nombre del archivo: ', '$'
cadena db 'Cadena a Escribir en el archivo','$'
nombre db 'archivo2.txt',0 ;nombre archivo y debe terminar en 0
vec db 50 dup('$')
handle db 0
linea db 10,13,'$'
.code
inicio:

menu:
  imprime msj
  imprime msj2
  imprime msj3
  imprime msj4
  imprime msj5
  imprime msj6
  imprime msj7

  mov ah,0dh
  int 21h
 ;comparamos la opcion que se tecleo
  mov ah,01h
  int 21h
  cmp al,31h
  je crear
  cmp al,32h
  je abrir
  cmp al,33h
  je pedir
  cmp al,34h
  je eliminar
  cmp al,35h
  je salir

crear:
mov ax,@data
mov ds,ax
;crear
mov ah,3ch
mov cx,0
mov dx,offset nombre
int 21h
jc salir ;si no se pudo crear
imprime msjcrear
mov bx,ax
mov ah,3eh ;cierra el archivo
int 21h
jmp menu

abrir:
;abrir
mov ah,3dh
mov al,0h ;0h solo lectura, 1h solo escritura, 2 lectura y escritura 
mov dx,offset nombre
int 21h
mov ah,42h
mov al,00h
mov bx,ax
mov cx,50
int 21h
;leer archivo
mov ah,3fh
;mov bx,ax
mov bx,ax
mov cx,10
mov dx,offset vec
;mov dl,vec[si]
int 21h
mov ah,09h
int 21h

;Cierre de archivo
mov ah,3eh
int 21h
jmp menu

pedir:
  mov ah,01h
  int 21h
  mov vec[si],al
  inc si
  cmp al,0dh
  ja pedir
  jb pedir

editar:
;abrir
mov ah,3dh
mov al,1h
mov dx,offset nombre
int 21h
jc salir ;Si hubo error
;Escritura de archivo
mov bx,ax ; mover hadfile
mov cx,si ;num de caracteres a grabar
mov dx,offset vec
mov ah,40h
int 21h
imprime msjescr
cmp cx,ax
jne salir ;error salir
mov ah,3eh ;Cierre de archivo
int 21h
jmp menu

eliminar:
mov ah,41h 
mov dx, offset nombre
int 21h  
jc salir ;Si hubo error
imprime msjelim

salir:
mov ah,04ch
int 21h
end