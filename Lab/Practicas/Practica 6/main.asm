include m_gen.asm
include m_func.asm
include m_graph.asm
.model small
;-------------------SEGMENTO DE PILA--------------------------
.stack
;-------------------SEGMENTO DE DATO--------------------------
.data
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%VARIABLES PARA LA FUNCION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Lim0 dw ?
Lim1 dw ?
doble dw ?
y2 dw ?
hayFuncion dw 0
EsIntegral dw 0
cero dw 0
y dw ?
x dw ?
Cintegracion dw ?
x0 dw 0
x1 dw 0
x2 dw 0
x3 dw 0
x4 dw 0
Dx0 dw 0
Dx1 dw 0
Dx2 dw 0
Dx3 dw 0
buffX0 db 4 dup('$'),'$'
buffX1 db 4 dup('$'),'$'
buffX2 db 4 dup('$'),'$'
buffX3 db 4 dup('$'),'$'
buffX4 db 4 dup('$'),'$'
FuncionOriginal db 100 dup('$'),'$'
FuncionDerivada db 100 dup('$'),'$'
FuncionIntegral db 100 dup('$'),'$'
numtemp dw ?
bufftemp db 6 dup('$'),'$'
resMenor dw 0
resMayor dw 100
tamano dw ?
handlerReporte dw ?
FileReporte db 'c:\reporte.rep',00h
hora db 2 dup('$'),'$'
minutos db 2 dup('$'),'$'
segundos db 2 dup('$'),'$'
dia db 2 dup('$'),'$'

centro dw 159
relacion dw ?
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
salt db 0ah,0dh,'$'
coef0 db '	COEFICIENTE DE X0: ','$'
coef1 db '	COEFICIENTE DE X1: ','$'
coef2 db '	COEFICIENTE DE X2: ','$'
coef3 db '	COEFICIENTE DE X3: ','$'
coef4 db '	COEFICIENTE DE X4: ','$'
msg1 db 0ah,0dh, '	FUNCION GUARDADA CON EXITO!!! ','$'
msg2 db 0ah,0dh, '	FUNCION ORIGINAL: ','$'
msg3 db 0ah,0dh, '	REPORTE CREADO CON EXITO!!! ','$'
msg4 db 0ah,0dh, '	FUNCION DERIVADA: ','$'
msg5 db 0ah,0dh, '	FUNCION INTEGRAL: ','$'
msg6 db 0ah,0dh, '	INGRESE INTERVALO ENTRE [-99,99] ','$'
msg7 db 0ah,0dh, '	LIMITE INFERIOR: ','$'
msg8 db '	LIMITE SUPERIOR: ','$'
msg9 db 0ah,0dh, '	valor de x: ','$'
msg10 db 0ah,0dh, '	valor de y: ','$'
msg11 db '	pos ','$'
msg12 db '	neg ','$'
msg13 db 0ah,0dh, '	Seguir: ','$'
msg14 db 0ah,0dh, '	VerMayor ','$'
msg15 db 0ah,0dh, '	VerMayor2 ','$'
msg16 db 0ah,0dh, '	NoDibujar ','$'
msg17 db ',','$'
msg18 db 0ah,0dh, '	INGRESE VALOR DE CONSTANTE DE INTEGRACION: ','$'
elij db 0ah,0dh, '	ELIJA UNA OPCION: ','$'
enc0 db 0ah,0dh, '	UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',0ah,0dh,'	FACULTAD DE INGENIERIA', 0ah,0dh, '	ESCUELA DE CIENCIAS Y SISTEMAS',0ah,0dh, '	ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 A',0ah,0dh, '	SEGUNDO SEMESTRE 2017',0ah,0dh, '	OSCAR RENE CUELLAR MANCILLA',0ah,0dh, '	201503712',0ah,0dh, '	TERCERA PRACTICA','$'
enc1 db 0ah,0dh, '	MENU PRINCIPAL',0ah,0dh,0ah,0dh,'	1) INGRESAR FUNCION ',9fh,'(x)',0ah,0dh, '	2) FUNCION EN MEMORIA',0ah,0dh, '	3) DERIVADA ',9fh,27h,'(x)',0ah,0dh, '	4) INTEGRAL F(x)',0ah,0dh, '	5) GRAFICAR FUNCIONES',0ah,0dh, '	6) REPORTE',0ah,0dh, '	7) SALIR', '$'
enc2 db 0ah,0dh, '	REPORTE PRACTICA NO. 3','$'
enc3 db 0ah,0dh, '	FECHA: ','$'
enc4 db 0ah,0dh, '	HORA: ','$'
enc5 db ':','$'
enc6 db ' DE OCTUBRE DE 2017','$'
enc7 db 0ah,0dh, '	MENU GRAFICAS',0ah,0dh,0ah,0dh,'	1) GRAFICAR ORIGINAL ',9fh,'(x)',0ah,0dh, '	2) GRAFICAR DERIVADA ',9fh,27h,'(x)',0ah,0dh, '	3) GRAFICAR INTEGRAL F(x)',0ah,0dh, '	4) REGRESAR', '$'
err db 0ah,0dh, '	ERROR GENERAL NO DEBERIA LLEGAR HASTA AQUI','$'
err1 db 0ah,0dh, '	ERROR CARACTER NO VALIDO, INGRESE UNICAMENTE NUMEROS O SIGNO +, -','$'
err2 db 0ah,0dh, '	ERROR INGRESO MAS DE LA CANTIDAD DE CARACTERES SOPORTADOS','$'
err3 db 0ah,0dh, '	NO HAY UNA FUNCION CARGADA, CARGUE UNA PARA PODER REALIZAR OPERACIONES','$'
err4 db 0ah,0dh, '	EL LIMITE INFERIOR NO ES MENOR QUE EL SUPERIOR >:v ','$'
err5 db 0ah,0dh, '	CARACTER NO VALIDO ','$'
err7 db 0ah,0dh, '	ERROR AL INTENTAR CREAR ARCHIVO','$'
err8 db 0ah,0dh, '	ERROR AL INTENTAR ABRIR ARCHIVO',0ah,0dh,'	PUEDE QUE EL ARCHIVO NO EXISTA','$'
err9 db 0ah,0dh, '	ERROR AL INTENTAR ESCRIBIR EN ARCHIVO','$'
err10 db 0ah,0dh, '	ERROR AL INTENTAR LEER EN ARCHIVO','$'
err11 db 0ah,0dh, '	ERROR AL INTENTAR CERRAR EL ARCHIVO','$'
err12 db 0ah,0dh, '	LOS LIMITES NO SON CUADRADOS, ASI NO SALE :(','$'
;-------------------SEGMETNO DE CODIGO------------------------
.code
main proc
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%% MENU PRINCIPAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Menu_Principal:
		LimpiarConsola
		print enc0
		print salt
		print enc1
		print salt
		print elij
		getChar
		cmp al,31h
		je IngresarFuncion
		cmp al,32h
		je MostrarFuncion
		cmp al,33h
		je Derivada
		cmp al,34h
		je Integral
		cmp al,35h
		je Graficar
		cmp al,36h
		je Reporte
		cmp al,37h
		je Salir
		jmp Menu_Principal
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%% INGRESAR FUNCION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	IngresarFuncion:
		print salt
		mov hayFuncion,1
		mov x0,0
		mov x1,0
		mov x2,0
		mov x3,0
		mov x4,0
		LimpiarArr buffX0, 24h,SIZEOF buffX0
		LimpiarArr buffX1, 24h,SIZEOF buffX0
		LimpiarArr buffX2, 24h,SIZEOF buffX0
		LimpiarArr buffX3, 24h,SIZEOF buffX0
		LimpiarArr buffX4, 24h,SIZEOF buffX0
		print coef4
		ObtenerNumero buffX4,5
		print coef3
		ObtenerNumero buffX3,5
		print coef2
		ObtenerNumero buffX2,5
		print coef1
		ObtenerNumero buffX1,5
		print coef0
		ObtenerNumero buffX0,5
		ConvertToInt x0,buffX0
		ConvertToInt x1,buffX1
		ConvertToInt x2,buffX2
		ConvertToInt x3,buffX3
		ConvertToInt x4,buffX4
		print salt
		print msg1
		getChar
		jmp Menu_Principal
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%% MOSTRAR FUNCION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	MostrarFuncion:
		cmp hayFuncion,0
		je Error3
		LimpiarArr FuncionOriginal,24h,SIZEOF FuncionOriginal
		ObtenerFuncion FuncionOriginal,x0,x1,x2,x3,x4
		print salt
		print salt
		print msg2
		print salt
		print FuncionOriginal
		print salt
		getChar
		jmp Menu_Principal
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%% MOSTRAR DERIVADA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Derivada:
		cmp hayFuncion,0
		je Error3
		LimpiarArr FuncionDerivada,24h,SIZEOF FuncionDerivada
		ObtenerConstantesD x1,x2,x3,x4,Dx0,Dx1,Dx2,Dx3
		ObtenerFuncionD FuncionDerivada,Dx0,Dx1,Dx2,Dx3
		print salt
		print salt
		print msg4
		print salt
		print FuncionDerivada
		print salt
		getChar
		jmp Menu_Principal
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%% MOSTRAR INTEGRAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Integral:
		cmp hayFuncion,0
		je Error3
		LimpiarArr FuncionIntegral,24h,SIZEOF FuncionIntegral
		ObtenerFuncionI FuncionIntegral,x0,x1,x2,x3,x4
		print salt
		print salt
		print msg5
		print salt
		print FuncionIntegral
		print salt
		getChar
		jmp Menu_Principal
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%% MENU GRAFICAS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Graficar:
		cmp hayFuncion,0
		je Error3
		LimpiarConsola
		print enc7
		print salt
		print elij
		getChar
		cmp al,31h
		je GraficarOriginal
		cmp al,32h
		je GraficarDerivada
		cmp al,33h
		je GraficarIntegral
		cmp al,34h
		je Menu_Principal
		jmp Graficar
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%% GRAFICAR ORIGINAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	GraficarOriginal:
		;LimpiarConsola
		PedirRango Lim0,Lim1,bufftemp,centro

		ModoGrafico
		PintarX
		PintarY centro
		EvaluarFuncion x0,x1,x2,x3,x4,cero,Lim0,Lim1,relacion,centro,y,x,resMayor,EsIntegral

		getChar
		ModoTexto
		;LimpiarConsola
		jmp Graficar
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%% GRAFICAR DERIVADA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	GraficarDerivada:
		;LimpiarConsola
		PedirRango Lim0,Lim1,bufftemp,centro

		ModoGrafico
		PintarX
		PintarY centro
		EvaluarFuncion Dx0,Dx1,Dx2,Dx3,cero,cero,Lim0,Lim1,relacion,centro,y,x,resMayor,EsIntegral

		getChar
		ModoTexto
		;LimpiarConsola
		jmp Graficar
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%% GRAFICAR INTEGRAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	GraficarIntegral:
		;LimpiarConsola
		PedirRango Lim0,Lim1,bufftemp,centro
		PedirConstanteIntegracion Cintegracion
		mov EsIntegral,1

		ModoGrafico
		PintarX
		PintarY centro
		EvaluarFuncion Cintegracion,x0,x1,x2,x3,x4,Lim0,Lim1,relacion,centro,y,x,resMayor,EsIntegral

		getChar
		ModoTexto
		;LimpiarConsola
		mov EsIntegral,0
		jmp Graficar
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%% CREAR REPORTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Reporte:
		crear FileReporte,handlerReporte
		ObtenerSize enc0,tamano
		escribir tamano,enc0,handlerReporte ;encabezado
		ObtenerSize salt,tamano
		escribir tamano,salt,handlerReporte ;salto de linea
		ObtenerSize enc2,tamano
		escribir tamano,enc2,handlerReporte ;reporte practica 2
		ObtenerSize salt,tamano
		escribir tamano,salt,handlerReporte ;salto de linea
		ObtenerHora hora,minutos,segundos,dia
		ObtenerSize enc3, tamano
		escribir tamano,enc3,handlerReporte ;fecha:
		ObtenerSize dia,tamano
		escribir tamano,dia,handlerReporte ;dia
		ObtenerSize enc6, tamano
		escribir tamano,enc6,handlerReporte ;de OCTUBRE de 2017
		ObtenerSize enc4,tamano
		escribir tamano,enc4,handlerReporte ;hora:
		ObtenerSize hora,tamano
		escribir tamano,hora,handlerReporte ;##
		ObtenerSize enc5, tamano
		escribir tamano,enc5,handlerReporte ;:
		ObtenerSize minutos,tamano
		escribir tamano,minutos,handlerReporte ; ##
		ObtenerSize enc5, tamano
		escribir tamano,enc5,handlerReporte ;:
		ObtenerSize segundos,tamano
		escribir tamano,segundos,handlerReporte ;##
		ObtenerSize salt,tamano
		escribir tamano,salt,handlerReporte ;salto de linea
		ObtenerSize msg2,tamano
		escribir tamano,msg2,handlerReporte ;Funcion ORIGINAL:
		ObtenerSize salt,tamano
		escribir tamano,salt,handlerReporte ;salto de linea
		ObtenerSize2 FuncionOriginal,tamano
		escribir tamano,FuncionOriginal,handlerReporte ;funcion
		ObtenerSize salt,tamano
		escribir tamano,salt,handlerReporte ;salto de linea
		ObtenerSize msg4,tamano
		escribir tamano,msg4,handlerReporte ;Funcion DERIVADA:
		ObtenerSize salt,tamano
		escribir tamano,salt,handlerReporte ;salto de linea
		ObtenerSize2 FuncionDerivada,tamano
		escribir tamano,FuncionDerivada,handlerReporte ;funcion
		ObtenerSize salt,tamano
		escribir tamano,salt,handlerReporte ;salto de linea
		ObtenerSize msg5,tamano
		escribir tamano,msg5,handlerReporte ;Funcion Integral:
		ObtenerSize salt,tamano
		escribir tamano,salt,handlerReporte ;salto de linea
		ObtenerSize2 FuncionIntegral,tamano
		escribir tamano,FuncionIntegral,handlerReporte ;funcion
		cerrar handlerReporte
		print msg3
		getChar
		jmp Menu_Principal
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%% MENSAJES DE ERROR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Error: ;NUNCA DEBERIA MOSTRAR ESTE MENSAJE
		print err
		getChar
		jmp Menu_Principal
	Error1: ; error, al ingresar un carcter invalido en los coeficientes
		print err1
		print salt
		getChar
		jmp IngresarFuncion
	Error2: ; error, al ingresar mas de 4 caracteres para los coeficientes
		print err2
		print salt
		getChar
		jmp IngresarFuncion
	Error3: ; error, cuando quiere ver funcion en memoria pero no hay ninguna cargada
		print err3
		print salt
		getChar
		jmp Menu_Principal
	Error4: ; error, cuando el limite inferior no es menor que el superior
		print err4
		print salt
		getChar
		jmp Graficar
	Error5: ;Caracter invalido al ingresar limites
		print err5
		getChar
		jmp Graficar
	Error7: ;NO SE PUDO CREAR
		print err7
		getChar
		jmp Menu_Principal
	Error8: ;NO SE PUDO ABRIR
		print err8
		getChar
		jmp Menu_Principal
	Error9: ;NO SE PUDO ESCRIBIR
		print err9
		getChar
		jmp Menu_Principal
	Error10: ;NO SE PUDO LEER
		print err10
		getChar
		jmp Menu_Principal
	Error11: ;NO SE PUDO CERRAR
		print err11
		getChar
		jmp Menu_Principal
	Error12: ;NO SON CUADRADOS LOS LIMITES
		print err12
		getChar
		jmp Graficar
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%% FINALIZAR PROGRAMA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Salir:
		mov ah, 4ch	;Numero de funcion para finalizar el programa
		xor al,al
		int 21h
main endp
end main