;---------REGRESAR AL MODO DE TEXTO------------------
ModoTexto macro
;Regresar a modo texto  
mov ax,0003h    
int 10h
mov ax,@data
mov ds,ax
endm

;--------MODO GRAFICO-------------------
ModoGrafico macro
;Iniciacion de modo video  
mov ax,0013h
int 10h
mov ax, 0A000h
mov ds, ax  ; DS = A000h (memoria de graficos).
endm

;------PINTAR PIXEL GRAFICO
pixel macro x0, y0, color  
push cx
mov ah, 0ch
mov al, color
mov bh, 0h
mov dx, y0
mov cx, x0
int 10h 
pop cx
endm

;--------------------Pintar eje X
PintarX macro
LOCAL eje_x
;Dibujar eje de las abscisas  
mov cx,13eh 
eje_x:  
pixel cx,63h,4fh
loop eje_x 
endm

;-----------------Pintar eje Y
PintarY macro cent
LOCAL eje_y
;Dibujar eje de las ordenadas  
mov cx,0c6h
eje_y:  
pixel cent,cx,4fh  
loop eje_y 
endm