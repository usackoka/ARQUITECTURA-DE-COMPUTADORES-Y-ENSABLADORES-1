;===============SECCION DE MACROS ===========================
include c6_m.asm

;================= DECLARACION TIPO DE EJECUTABLE ============
.model small 
.stack 100h 
.data 
;================ SECCION DE DATOS ========================
encab db 0ah,0dh, '1) Abrir archivo', 0ah,0dh,'2) Crear Archivo',0ah,0dh,'3) Salir',0ah,0dh,'$'
msm1 db 0ah,0dh,'FUNCION ABRIR','$'
msm2 db 0ah,0dh,'FUNCION CREAR','$'
msmError1 db 0ah,0dh,'Error al abrir archivo','$'
msmError2 db 0ah,0dh,'Error al leer archivo','$'
msmError3 db 0ah,0dh,'Error al crear archivo','$'
rutaArchivo db 100 dup('$')
bufferLectura db 100 dup('$')
handleFichero dw ?
.code ;segmento de código
;================== SECCION DE CODIGO ===========================
	main proc 
		Menu:
			print encab
			getChar
			cmp al,49
			je ABRIR
			cmp al,50
			je CREAR
			cmp al,51
			je SALIR
			jmp Menu
		ABRIR:
			print msm1
			getRuta rutaArchivo
			;print rutaArchivo
			abrirF rutaArchivo,handleFichero
			leerF SIZEOF bufferLectura,bufferLectura,handleFichero
			print bufferLectura
			getChar
			jmp Menu
		CREAR:
			print msm2
			getRuta rutaArchivo
			crearF rutaArchivo,handleFichero
			getChar
			jmp Menu
	    ErrorAbrir:
	    	print msmError1
	    	getChar
	    	jmp Menu
	    ErrorLeer:
	    	print msmError2
	    	getChar
	    	jmp Menu
	    ErrorCrear:
	    	print msmError3
	    	getChar
	    	jmp Menu
		SALIR: 
			MOV ah,4ch 
			int 21h
	main endp
;================ FIN DE SECCION DE CODIGO ========================
end