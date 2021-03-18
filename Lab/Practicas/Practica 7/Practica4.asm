include m_gen.asm ;archivo con los macros a utilizar
include m_graph.asm ;archivo con los macros para graficar
include m_img.asm ;archivo con los macros que hacen los filtros

.model small
;-------------------SEGMENTO DE PILA--------------------------
.stack 128
;-------------------SEGMENTO DE DATO--------------------------
.data
;////////////////////////VARIABLES PARA EL REPORTE///////////////////////
msg2 db 0ah,0dh,'	NOMBRE DE LA IMAGEN: ','$'
msg3 db 0ah,0dh,'	ANCHO DE LA IMAGEN: ','$'
msg4 db 0ah,0dh,'	ALTO DE LA IMAGEN: ','$'
msg5 db 0ah,0dh,'	TAMAÑO DE LA IMAGEN: ','$'
msg6 db ' bytes','$'
msg7 db ' pixeles','$'
buffancho db 7 dup('$')
ancho dw ?
buffalto db 7 dup('$')
alto dw ?
bufftamanno db 7 dup('$')
tamanno dw ?
cambio_x dw 0
cambio_y dw 0
buffTemp db 8 dup('$')
inicio dw ?
buffinicio db 7 dup('$')
tamanoPaleta dw ?
buffEncabezado label word; db 54 dup('$')
buffPaleta db 1024 dup('$')
Lineas db 320 dup(0)
;/////////////////////////VARIABLES PARA LA ImagenBMP////////////////////
FileImagen db 50 dup('$')
;BytesImagen db 64000 dup('$')
handleImagen dw ?
;////////////////////////VARIABLES REPORTE//////////////////////////
tamano dw ?
handlerReporte dw ?
FileReporte db 'c:\ReporteImagen.rep',00h
hora db 2 dup('$'),'$'
minutos db 2 dup('$'),'$'
segundos db 2 dup('$'),'$'
dia db 2 dup('$'),'$'
;////////////////////////MENSAJES//////////////////////////////////
err6 db 0ah,0dh, '	ARCHIVO CON EXTENSION INCORRECTA, INTENTELO DE NUEVO','$'
err7 db 0ah,0dh, '	ERROR AL INTENTAR CREAR ARCHIVO','$'
err8 db 0ah,0dh, '	ERROR AL INTENTAR ABRIR ARCHIVO',0ah,0dh,'	PUEDE QUE EL ARCHIVO NO EXISTA','$'
err9 db 0ah,0dh, '	ERROR AL INTENTAR ESCRIBIR EN ARCHIVO','$'
err10 db 0ah,0dh, '	ERROR AL INTENTAR LEER EN ARCHIVO','$'
err11 db 0ah,0dh, '	ERROR AL INTENTAR CERRAR EL ARCHIVO','$'
salto db 0ah,0dh,'	','$'
esco db 0ah,0dh,'	ESCOJA UNA OPCION: ','$'
enc8 db 0ah,0dh, '	MENU GIRAR',0ah,0dh,0ah,0dh,'	1) 90',0f8h,' HACIA LA DERECHA',0ah,0dh,'	2) 90',0f8h,' HACIA LA IZQUIERDA',0ah,0dh,'	3) 180',0f8h,0ah,0dh,'$'
enc9 db 0ah,0dh, '	MENU VOLTEAR',0ah,0dh,0ah,0dh,'	1) HORIZONTAL',0ah,0dh,'	2) VERTICAL','$'
enc0 db 0ah,0dh, '	UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',0ah,0dh,'	FACULTAD DE INGENIERIA', 0ah,0dh, '	ESCUELA DE CIENCIAS Y SISTEMAS',0ah,0dh, '	ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 A',0ah,0dh, '	SEGUNDO SEMESTRE 2017',0ah,0dh, '	OSCAR RENE CUELLAR MANCILLA',0ah,0dh, '	201503712',0ah,0dh, '	CUARTA PRACTICA','$'
enc1 db 0ah,0dh, '	MENU PRINCIPAL',0ah,0dh,0ah,0dh,'	1) IMAGEN BMP',0ah,0dh,'	2) SALIR','$'
enc2 db 0ah,0dh, '	MENU OPERACIONES',0ah,0dh,0ah,0dh,'	1) VER IMAGEN',0ah,0dh,'	2) GIRAR',0ah,0dh,'	3) VOLTEAR',0ah,0dh,'	4) ESCALA DE GRISES',0ah,0dh,'	5) BRILLO',0ah,0dh,'	6) NEGATIVO',0ah,0dh,'	7) REPORTE',0ah,0dh,'	8) REGRESAR','$'
msg0 db 0ah,0dh,'	INGRESE RUTA DE LA IMAGEN: ','$'
msg1 db 0ah,0dh,'	REPORTE CREADO CON EXITO!','$'
enc3 db 0ah,0dh,'	REPORTE CUARTA PRACTICA ','$'
enc4 db 0ah,0dh,'	FECHA:  ','$'
enc5 db '	DE OCTUBRE DE 2017 ','$'
enc6 db 0ah,0dh,'	HORA: ','$'
enc7 db ':','$'
msg12 db 0ah,0dh,'	dividiendo...','$'
;-------------------SEGMETNO DE CODIGO------------------------
.code
main proc
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%% MenuPrincipal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	MenuPrincipal: ;etiqueta prueba 
		print salto
		print enc0
		print salto
		print enc1
		print salto
		print esco
		getChar
		cmp al,31h
		je ImagenBMP
		cmp al,32h
		je Salir
		LimpiarConsola
		jmp MenuPrincipal
	MenuPrincipal1:
		cerrar handleImagen
		jmp MenuPrincipal
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% IMAGEN BMP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	ImagenBMP:
		print salto
		print msg0 ;ingrese ruta
		print salto

		LimpiarArr FileImagen,24h,SIZEOF FileImagen
		;LimpiarArr BytesImagen,24h,SIZEOF BytesImagen
		LimpiarArr bufftamanno,24h,SIZEOF bufftamanno
		LimpiarArr buffancho,24h,SIZEOF buffancho
		LimpiarArr buffalto,24h,SIZEOF buffalto
		LimpiarArr buffinicio,24h,SIZEOF buffinicio

		ObtenerRuta FileImagen
	ImagenBMP2:
		abrir FileImagen,handleImagen
		leerEncabezado 54,buffEncabezado,tamanoPaleta,ancho,alto,handleImagen,tamanno
		;leer SIZEOF BytesImagen,BytesImagen,handleImagen
		;ObtenerAtributosImagen BytesImagen,bufftamanno,buffancho,buffalto,buffinicio
		
		;PasarADecimal bufftamanno,tamanoPaleta
		;PasarADecimal buffancho,ancho
		;PasarADecimal buffalto,alto
		;PasarADecimal buffinicio,inicio

		ConvertToString2 tamanno,bufftamanno
		ConvertToString2 ancho,buffancho
		ConvertToString2 alto,buffalto
		;ConvertToString2 inicio,buffinicio

		jmp MenuOperaciones
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% MENU OPERACIONES %%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	MenuOperaciones:
		print salto
		print enc2
		print salto
		print esco
		getChar
		cmp al,31h
		je VerImagen
		cmp al,32h
		je GirarImagen
		cmp al,33h
		je VoltearImagen
		cmp al,34h
		je EscalaDeGrises
		cmp al,35h
		je Brillo
		cmp al,36h
		je Negativo
		cmp al,37h
		je Reporte
		cmp al,38h
		je MenuPrincipal1
		LimpiarConsola
		jmp MenuOperaciones
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% VER IMAGEN  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	VerImagen:
		ModoGrafico
		leerPaletaDeColores tamanoPaleta,buffPaleta,handleImagen,02h,01h,00h
		push es
		MostrarNormal Lineas,ancho,alto,handleImagen
		pop es
	EsperarV:
		getChar
		cmp al,76h ;ascii de la letra v
		jne EsperarV
		ModoTexto
		jmp ImagenBMP2
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% GIRAR IMAGEN  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	GirarImagen:
		print salto
		print enc8
		print salto
		print esco
		getChar
		cmp al,31h
		je GirarDerecha
		cmp al,32h
		je GirarIzquierda
		cmp al,33h
		je Girar180
		jmp GirarImagen

		EsperarG:
		getChar
		cmp al,67h ;ascii de la letra g
		jne EsperarG
		ModoTexto
		jmp ImagenBMP2
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% GIRAR 90 DERECHA  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	GirarDerecha:
		ModoGrafico
		leerPaletaDeColores tamanoPaleta,buffPaleta,handleImagen,02h,01h,00h
		push es
		MostrarGiroDerecha Lineas,ancho,alto,handleImagen
		pop es
		jmp EsperarG
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% GIRAR 90 IZQUIERDA  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	GirarIzquierda:
		ModoGrafico
		leerPaletaDeColores tamanoPaleta,buffPaleta,handleImagen,02h,01h,00h
		push es
		MostrarGiroIzquierda Lineas,ancho,alto,handleImagen
		pop es
		jmp EsperarG
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% GIRAR 180  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Girar180:
		ModoGrafico
		leerPaletaDeColores tamanoPaleta,buffPaleta,handleImagen,02h,01h,00h
		push es
		MostrarGiro180 Lineas,ancho,alto,handleImagen
		pop es
		jmp EsperarG
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% VOLTEAR IMAGEN  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	VoltearImagen:
		print salto
		print enc9
		print salto
		print esco
		getChar
		cmp al,31h
		je Horizontal
		cmp al,32h
		je Vertical
		jmp ImagenBMP2
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% VOLTEAR HORIZONTAL  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Vertical:
		ModoGrafico
		leerPaletaDeColores tamanoPaleta,buffPaleta,handleImagen,02h,01h,00h
		push es
		MostrarGiroVertical Lineas,ancho,alto,handleImagen
		pop es
		jmp EsperarV
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% VOLTEAR HORIZONTAL  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Horizontal:
		ModoGrafico
		leerPaletaDeColores tamanoPaleta,buffPaleta,handleImagen,02h,01h,00h
		push es
		MostrarGiroHorizontal Lineas,ancho,alto,handleImagen
		pop es
		jmp EsperarV
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% ESCALA DE GRISES  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	EscalaDeGrises:
		ModoGrafico
		leerPaletaDeColores tamanoPaleta,buffPaleta,handleImagen,00h,00h,00h
		push es
		MostrarNormal Lineas,ancho,alto,handleImagen
		pop es
	EsperarE:
		getChar
		cmp al,65h ;ascii de la letra e
		jne EsperarE
		ModoTexto
		jmp ImagenBMP2
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% BRILLO  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Brillo:
		ModoGrafico
		leerPaletaDeColoresB tamanoPaleta,buffPaleta,handleImagen,02h,01h,00h
		push es
		MostrarNormal Lineas,ancho,alto,handleImagen
		pop es
	EsperarB:
		getChar
		cmp al,62h ;ascii de la letra b
		jne EsperarB
		ModoTexto
		jmp ImagenBMP2
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% NEGATIVO  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Negativo:
		getChar
		cmp al,31h
		je Negativo1
		ModoGrafico
		leerPaletaDeColoresN2 tamanoPaleta,buffPaleta,handleImagen,02h,01h,00h
		push es
		MostrarNormal Lineas,ancho,alto,handleImagen
		pop es
	EsperarN:
		getChar
		cmp al,6Eh ;ascii de la letra n
		jne EsperarN
		ModoTexto
		jmp ImagenBMP2
	Negativo1:
		ModoGrafico
		leerPaletaDeColoresN tamanoPaleta,buffPaleta,handleImagen,02h,01h,00h
		push es
		MostrarNormal Lineas,ancho,alto,handleImagen
		pop es
		jmp EsperarN
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% REPORTE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Reporte:
		crear FileReporte,handlerReporte
		ObtenerSize enc0,tamano
		escribir tamano,enc0,handlerReporte ;encabezado
		ObtenerSize salto,tamano
		escribir tamano,salto,handlerReporte ;salto de linea
		ObtenerSize enc3,tamano
		escribir tamano,enc3,handlerReporte ;reporte practica 4
		ObtenerSize salto,tamano
		escribir tamano,salto,handlerReporte ;salto de linea
		ObtenerHora hora,minutos,segundos,dia
		ObtenerSize enc4, tamano
		escribir tamano,enc4,handlerReporte ;fecha:
		ObtenerSize dia,tamano
		escribir tamano,dia,handlerReporte ;dia
		ObtenerSize enc5, tamano
		escribir tamano,enc5,handlerReporte ;de SEPTIEMBRE de 2017
		ObtenerSize enc6,tamano
		escribir tamano,enc6,handlerReporte ;hora:
		ObtenerSize hora,tamano
		escribir tamano,hora,handlerReporte ;##
		ObtenerSize enc7, tamano
		escribir tamano,enc7,handlerReporte ;:
		ObtenerSize minutos,tamano
		escribir tamano,minutos,handlerReporte ; ##
		ObtenerSize enc7, tamano
		escribir tamano,enc7,handlerReporte ;:
		ObtenerSize segundos,tamano
		escribir tamano,segundos,handlerReporte ;##
		ObtenerSize salto,tamano
		escribir tamano,salto,handlerReporte ;salto de linea
		ObtenerSize msg2,tamano
		escribir tamano,msg2,handlerReporte ;nonbre de la imagen:
		ObtenerSize2 FileImagen,tamano
		dec tamano
		escribir tamano,FileImagen,handlerReporte ;nombre de la imagen.bmp
		ObtenerSize salto,tamano
		escribir tamano,salto,handlerReporte ;salto de linea
		ObtenerSize msg3,tamano
		escribir tamano,msg3,handlerReporte ;ancho de la imagen:
		ObtenerSize2 buffancho,tamano
		escribir tamano,buffancho,handlerReporte ;ancho
		ObtenerSize msg7,tamano
		escribir tamano,msg7,handlerReporte ;pixeles
		ObtenerSize salto,tamano
		escribir tamano,salto,handlerReporte ;salto de linea
		ObtenerSize msg4,tamano
		escribir tamano,msg4,handlerReporte ;alto de la imagen:
		ObtenerSize2 buffalto,tamano
		escribir tamano,buffalto,handlerReporte ;alto
		ObtenerSize msg7,tamano
		escribir tamano,msg7,handlerReporte ;pixeles
		ObtenerSize salto,tamano
		escribir tamano,salto,handlerReporte ;salto de linea
		ObtenerSize msg5,tamano
		escribir tamano,msg5,handlerReporte ;tamanno de la imagen:
		ObtenerSize2 bufftamanno,tamano
		escribir tamano,bufftamanno,handlerReporte ;tamanno
		ObtenerSize msg6,tamano
		escribir tamano,msg6,handlerReporte ;bytes
		cerrar handlerReporte
		print msg1
		getChar
		jmp ImagenBMP2

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% ERRORES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Error6: ;EXTENSION INCORRECTA
		print err6
		getChar
		jmp ImagenBMP
	Error7: ;NO SE PUDO CREAR
		print err7
		getChar
		jmp MenuPrincipal
	Error8: ;NO SE PUDO ABRIR
		print err8
		getChar
		jmp MenuPrincipal
	Error9: ;NO SE PUDO ESCRIBIR
		print err9
		getChar
		jmp MenuPrincipal
	Error10: ;NO SE PUDO LEER
		print err10
		getChar
		jmp MenuPrincipal
	Error11: ;NO SE PUDO CERRAR
		print err11
		getChar
		jmp MenuPrincipal
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% SALIR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Salir: ;etiqueta salir
		mov ah, 4ch	;Numero de funcion para finalizar el programa
		xor al,al
		int 21h
main endp

met_brillo proc
  
  ;mov al,63
  cmp al,54
  jb solo_sumar10

  ;sumar 9
  cmp al,54
  jne sig55
  add al,9

  sig55:
  ;sumar 8
  cmp al,55
  jne sig56
  add al,8

  sig56:
  ;sumar 7
  cmp al,56
  jne sig57
  add al,7

  sig57:
  ;sumar 6
  cmp al,57
  jne sig58
  add al,6

  sig58:
  ;sumar 5
  cmp al,58
  jne sig59
  add al,5

  sig59:
  ;sumar 4
  cmp al,59
  jne sig60
  add al,4

  sig60:
  ;sumar 3
  cmp al,60
  jne sig61
  add al,3

  sig61:
  ;sumar 2
  cmp al,61
  jne sig62
  add al,2

  sig62:
  ;sumar 1
  cmp al,62
  jne sig63
  add al,1

  sig63:

  jmp fin

  solo_sumar10:
  add al,12

  fin:
  ret 
met_brillo endp
end main