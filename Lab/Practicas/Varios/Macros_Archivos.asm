para abrir un archivo en assembler necesita varias cosas, primero necestita los sguientes macros 


fopen macro filename,handle 
lea dx,filename 
mov ah,3dh 
mov al, 00h 
int 21h 
mov handle,ax 
.if carry? 
mov ax,-1 
.endif 
endm 

fwrite macro numbytes,databuffer,handle 
mov ah,40h 
mov bx,handle 
mov cx,numbytes 
lea dx,databuffer 
int 21h 
endm 

fread macro numbytes,databuffer,handle 
mov ah,3fh 
mov bx,handle 
mov cx,numbytes 
lea dx,databuffer 
int 21h 
endm 

fclose macro handle
mov ah,3eh 
mov bx,handle 
int 21h 
endm 

entonces, por ejemplo si quiere abrir un archivo llamado archivo1.txt y ubicado en C:\ y quiere leer 10 bytes de el, entonces hace el siguiente programa 

include macros.txt ; archivo con los macros 

.model small 
.stack 
.data 

file db 'c:\archivo1.txt','00h' ;ojo con el 00h es importante 
handler dw ? 
buffer db 10 dup(' ') 

.code

main 

fopen file, handler 
fread 10,buffer,handler 
fclose handler ; siempre se debe cerrar un archivo 

.exit 
end main 


y listo tendra los primeros 10 bytes de su archivo1.txt en la la variable buffer 

Espero haberle ayudado