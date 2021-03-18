mov ax,0600h ; Peticion para limpiar pantalla
mov bh,89h ; Color de letra ==9 "Azul Claro"
; Fondo ==8 "Gris"
mov cx,0000h ; Se posiciona el cursor en Ren=0 Col=0
mov dx,184Fh ; Cursor al final de la pantalla Ren=24(18) 
; Col=79(4F)
int 10h ; interrupcion al BIOS
;------------------------------------------------------------------------------
mov ah,02h ; Peticion para colocar el cursor
mov bh,00 ; Nunmero de pagina a imprimir
mov dh,05 ; Cursor en el renglon 05
mov dl,05 ; Cursor en la columna 05
int 10h ; interrupcion al bios
;-------------------------------------------------------------