;******************************************************************************
;Ejemplo de manejo de archivos
; el programa combina los contenidos de dos archivos
; genera un tercer archivo con los caracteres alternados de los archivos leidos
;******************************************************************************
;
;  elaborado por Fernando Monrroy Dipp
;
;******************************************************************************
.model small
.stack 64
.data
arch1 db 'uno.txt',0    ;un archivo, debe estar en la misma carpeta del ejecutable
arch2 db 'dos.txt',0    ;otro archivo, debe estar en la misma carpeta del ejecutable
arch3 db 'tres.txt',0    ;se crea al ejecutar el programa
buf1 db 20 dup(?)    ;buffer de lectura del archivo 1
buf2 db 20 dup(?)    ;buffer de lectura del archivo 2
buf3 db 40 dup(?)    ;buffer de escritura del archivo 3
erm db 10,13,'error!!!!',10,13,'$'
exm db 10,13,'exito!!!!',10,13,'$'
fiha1 dw ?
fiha2 dw ?

.code
uno:    mov ax,@data
    mov ds,ax    ; lo de siempre
    lea dx,arch1
    mov ax,3d00h
    int 21h        ;abre archivo 1
    jc error
    mov fiha1,ax
    mov bx,fiha1
    mov ah,3fh
    mov cx,20
    lea dx,buf1
    int 21h        ;lee archivo 1 en buf1
    jc error    
    mov ah,3eh
    int 21h        ;cierra arch1
    lea dx,arch2
    mov ax,3d00h
    int 21h        ;abre archivo 2
    jc error
    mov fiha1,ax
    mov bx,ax
    mov ah,3fh
    mov cx,20
    lea dx,buf2
    int 21h        ;lee archivo 2 en buf2
    jc error
    mov ah,3eh
    int 21h        ;cierra archivo 2
    mov ah,3ch
    lea dx,arch3
    mov al,0
    mov cx,0
    int 21h        ;crea archivo 3
    jc error
    mov fiha2,ax

    xor bx,bx        ;base para apuntar los tres buffers
    mov cx,20        ;caracteres a mover
    xor si,si        ;indice para desplazar buffer 3
lazo:    mov al,buf1[bx]        ;lee ch de buffer 1
    mov buf3[bx+si],al    ;mueve a buffer 3
    inc si            ;desplaza indice
    mov al,buf2[bx]        ;lee ch de buffer 2
    mov buf3[bx+si],al    ; mueve a buffer 3

    inc bx            ;actualiza base
    loop lazo        ;repite lazo hasta que cx sea 0

    mov bx,fiha2    ;    
    mov ah,40h
    lea dx,buf3
    mov cx,40
    int 21h        ;escribe 40 ch de buffer 3 a archivo 3
    jc error
    mov ah,3eh
    int 21h        ;cierra archivo
    jc error
    lea dx,exm    ;
    mov ah,9
    int 21h        ;muestra mensaje de exito
    jmp fin
error:    lea dx,erm
    mov ah,9
    int 21h        ;muestra mensaje de error
fin:    mov ah,4ch
    int 21h        ;retorna al ss oo
    end uno