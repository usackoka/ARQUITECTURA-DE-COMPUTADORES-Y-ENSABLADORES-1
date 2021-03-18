.model small
;-------------------SEGMENTO DE PILA--------------------------
.stack
;-------------------SEGMENTO DE DATO--------------------------
.data
cadena db 0ah,0dh,'HOLA MUNDO!!','$'
;-------------------SEGMETNO DE CODIGO------------------------
.code
main proc
	prueba:
		mov ax,@data
		mov ds,ax
		mov ah,09h	;Numero de funcion para imprimir cadena en pantalla
		mov dx,offset cadena ;equivalente a lea dx,cadena, inicializa en dx la posicion donde comienza la cadena
		int 21h
	Salir:
		mov ah, 4ch	;Numero de funcion para finalizar el programa
		xor al,al
		int 21h
main endp
end main