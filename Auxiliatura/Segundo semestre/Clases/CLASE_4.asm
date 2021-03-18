.model small
.stack 100h 
.data
;================ SEGMENTO DE DATOS ==============================
var db 0ah,0dh,'Hola mundo','$'
;db -> dato byte -> 8 bits
;dw -> dato word -> 16 bits
;dd -> doble word -> 32 bits
.code ;segmento de código
;================== SEGMENTO DE CODIGO ===========================
	main proc
			MOV ah,09h
			MOV dx,@data
			MOV ds,dx 
			MOV dx,offset var
			int 21h
		Salir: 
			MOV ah,4ch
			int 21h
	main endp
end