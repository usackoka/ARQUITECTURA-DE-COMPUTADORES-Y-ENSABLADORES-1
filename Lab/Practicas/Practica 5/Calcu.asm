;-------------------IMPORTO EL .ASM CON LOS MACROS A UTILIZAR-------------
include macros.asm ;macros de proposito general jajaja xD
include macros2.asm ;macros con todo para el manejo de archivos
include macros3.asm ;macros para manejo del modo CALCULADORA
include macros4.asm ;macros para manejo del modo Carga de archivo
;------------------------------------------------------------------------
.model small
;-------------------SEGMENTO DE PILA--------------------------
.stack
;-------------------SEGMENTO DE DATO--------------------------
.data
	;-------------------------VARIABLES PARA LAS OPERACIONES CON EL ARCHIVO------------------------
	SumasYRestas dw 350 dup('$$'),'$' ;para guardar las sumas y restas a realizar
	ResArchivo dw ? ;para guardar el resultado de la operacion al cargar el archivo de entrada
	ArrRes db 5 dup(' '),'$'
	;-------------------------VARIABLES PARA LOS ARCHIVOS--------------------------------
	handlerEntrada dw ?
	handlerReporte dw ?
	tamano dw ?
	tamano2 dw ?
	ArrayInfo db 250 dup('$')
	ArrayPre db 250 dup('$')
	ArrayPost db 250 dup('$')
	ArrayRuta db 50 dup('$') ;un maximo de 50 caracteres para la ruta
	ArrayReporte db 50 dup('$')
	;----------------------------NUMEROS PARA MODO CALCULADORA------------------------------
	ArrayNum1 db 3 dup('#'),'$'
	ArrayNum2 db 3 dup('#'),'$'
	Operador db ? ,'$'
	Numero1 dw ? ,'$'
	Numero2 dw ? ,'$'
	Resultado dw ?
	ArrayRes db 5 dup('#'),'$'
	NegN1 dw ?
	NegN2 dw ?
	ANS dw ?
	NegANS dw ?
	NegRes dw ?
	SignoMenos db '-','$'
	UltimoFac dw 8
	SignoMayor dw 0
	;----------------------------MENSAJES---------------------------------------------------
	salt db 0ah,0dh, '	','$'
	;ENCABEZADO
	enc0 db 0ah,0dh, '	UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',0ah,0dh,'	FACULTAD DE INGENIERIA', 0ah,0dh, '	ESCUELA DE CIENCIAS Y SISTEMAS',0ah,0dh, '	ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 A',0ah,0dh, '	SEGUNDO SEMESTRE 2017',0ah,0dh, '	OSCAR RENE CUELLAR MANCILLA',0ah,0dh, '	201503712',0ah,0dh, '	SEGUNDA PRACTICA','$'
	;MENU PRINCIPAL
	enc1 db 0ah,0dh, '	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',0ah,0dh,'	%%%%%%% MENU PRINCIPAL %%%%%%%',0ah,0dh,'	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',0ah,0dh,'	%%%% 1. CARGAR ARCHIVO    %%%%',0ah,0dh,'	%%%% 2. MODO CALCULADORA  %%%%',0ah,0dh,'	%%%% 3. FACTORIAL         %%%%    ',0ah,0dh,'	%%%% 4. REPORTE           %%%%',0ah,0dh,'	%%%% 5. SALIR             %%%%',0ah,0dh,'	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%','$'
	;RUTA DEL ARCHIVO
	enc2 db 0ah,0dh, '	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',0ah,0dh,'	%% INGRESE RUTA DEL ARCHIVO %%',0ah,0dh,'	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%','$'
	;MENU DE OPERACIONES
	enc3 db 0ah,0dh, '	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',0ah,0dh,'	%%%% MENU DE OPERACIONES %%%%%',0ah,0dh,'	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',0ah,0dh,'	%%%% 1. RESULTADO         %%%%',0ah,0dh,'	%%%% 2. NOTACION PREFIJA  %%%%',0ah,0dh,'	%%%% 3. NOTACION POSFIJA  %%%%',0ah,0dh,'	%%%% 4. SALIR             %%%%',0ah,0dh,'	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%','$'
	enc4 db 0ah,0dh, '	REPORTE PRACTICA NO. 2',0ah,0dh,0ah,0dh,'	FECHA: 21 DE SEPTIEMBRE DE 2017','$'
	enc5 db 0ah,0dh, '	HORA: ','$'
	enc6 db 0ah,0dh, '	ENTRADA: ','$'
	Arrhora db 2 dup('$'),'$'
	Arrminuto db 2 dup('$'),'$'
	Arrsegundo db 2 dup('$'),'$'
	msgdospuntos db ':','$'
	;MENSAJES DE ERRORES
	err0 db 0ah,0dh, '	ERROR GENERAL, NO DEBERIA LLEGAR AQUI','$'
	err1 db 0ah,0dh, '	EL NOMBRE DEL ARCHIVO NO TIENE EXTENSION','$'
	err2 db 0ah,0dh, '	EXTENSION DEL ARCHIVO INCORRECTA',0ah,0dh,'	INGRESE ARCHIVO CON EXTENSION .ARQ','$'
	err3 db 0ah,0dh, '	EL NUMERO NO PUEDE CONTENER MAS DE 3 CARACTERES INCLUYENDO EL SIGNO','$'
	err4 db 0ah,0dh, '	CARACTER INVALIDO, INGRESE NUMERO O SIGNO','$'
	err5 db 0ah,0dh, '	OPERADOR INVALIDO, INGRESE (+,-,/,*)','$'
	err6 db 0ah,0dh, '	NUMERO INVALIDO VUELVA A INTENTARLO FORMATO: (00,01,02,..08)','$'
	err7 db 0ah,0dh, '	ERROR AL INTENTAR CREAR ARCHIVO','$'
	err8 db 0ah,0dh, '	ERROR AL INTENTAR ABRIR ARCHIVO',0ah,0dh,'	PUEDE QUE EL ARCHIVO NO EXISTA','$'
	err9 db 0ah,0dh, '	ERROR AL INTENTAR ESCRIBIR EN ARCHIVO','$'
	err10 db 0ah,0dh, '	ERROR AL INTENTAR LEER EN ARCHIVO','$'
	err11 db 0ah,0dh, '	ERROR AL INTENTAR CERRAR EL ARCHIVO','$'
	err12 db 0ah,0dh, '	CARACTER INVALIDO SE ESPERABA NUMERO, VINO ->','$'
	err13 db 0ah,0dh, '	CARACTER INVALIDO SE ESPERABA ESPACIO EN BLANCO, VINO ->','$'
	err14 db 0ah,0dh, '	CARACTER INVALIDO SE ESPERABA SIGNO ARITMETICO, VINO ->','$'
	err15 db 0ah,0dh, '	NO HA CARGADO NINGUNA RUTA PARA PODER GENERAR ',0ah,0dh,'	EL MISMO NOMBRE EN EL REPORTE','$'
	err16 db 0ah,0dh, '	SE ESPERABA PUNTO Y COMA PARA FINALIZAR LA CADENA DEL ARCHIVO','$'
	err17 db 0ah,0dh, '	RESULTADO: INDEFINIDO','$'
	;MENSAJES PARA EL MODO CALCULADORA
	cal0 db 0ah,0dh, '	NUMERO: ','$'
	cal1 db 		 '	OPERADOR ARITMETICO: ','$'
	cal2 db 		 '	RESULTADO: ','$'
	cal3 db 0ah,0dh, '	',0a8h,'DESEA SALIR DE LA CALCULADORA?',0ah,0dh, '	1. SI',0ah,0dh, '	2. NO','$'
	;MENSAJES FACTORIAL
	fac1 db 0ah,0dh, '	FACTORIAL: ','$'
	fac2 db 0ah,0dh, '	OPERACIONES: ','$'
	fac3 db 0ah,0dh, '	RESULTADO: ','$'
	pro0 db 0ah,0dh,'		0!=1;','$'
	pro1 db 0ah,0dh,'		0!=1;',0ah,0dh,'		1!=1;','$'
	pro2 db 0ah,0dh,'		0!=1;',0ah,0dh,'		1!=1;',0ah,0dh,'		2!=1*2=2;','$'
	pro3 db 0ah,0dh,'		0!=1;',0ah,0dh,'		1!=1;',0ah,0dh,'		2!=1*2=2;',0ah,0dh,'		3!=1*2*3=6;','$'
	pro4 db 0ah,0dh,'		0!=1;',0ah,0dh,'		1!=1;',0ah,0dh,'		2!=1*2=2;',0ah,0dh,'		3!=1*2*3=6;',0ah,0dh,'		4!=1*2*3*4=24;','$'
	pro5 db 0ah,0dh,'		0!=1;',0ah,0dh,'		1!=1;',0ah,0dh,'		2!=1*2=2;',0ah,0dh,'		3!=1*2*3=6;',0ah,0dh,'		4!=1*2*3*4=24;',0ah,0dh,'		5!=1*2*3*4*5=120;','$'
	pro6 db 0ah,0dh,'		0!=1;',0ah,0dh,'		1!=1;',0ah,0dh,'		2!=1*2=2;',0ah,0dh,'		3!=1*2*3=6;',0ah,0dh,'		4!=1*2*3*4=24;',0ah,0dh,'		5!=1*2*3*4*5=120;',0ah,0dh,'		6!=1*2*3*4*5*6=720;','$'
	pro7 db 0ah,0dh,'		0!=1;',0ah,0dh,'		1!=1;',0ah,0dh,'		2!=1*2=2;',0ah,0dh,'		3!=1*2*3=6;',0ah,0dh,'		4!=1*2*3*4=24;',0ah,0dh,'		5!=1*2*3*4*5=120;',0ah,0dh,'		6!=1*2*3*4*5*6=720;',0ah,0dh,'		7!=1*2*3*4*5*6*7=5040;','$'
	pro8 db 0ah,0dh,'		0!=1;',0ah,0dh,'		1!=1;',0ah,0dh,'		2!=1*2=2;',0ah,0dh,'		3!=1*2*3=6;',0ah,0dh,'		4!=1*2*3*4=24;',0ah,0dh,'		5!=1*2*3*4*5=120;',0ah,0dh,'		6!=1*2*3*4*5*6=720;',0ah,0dh,'		7!=1*2*3*4*5*6*7=5040;',0ah,0dh,'		8!=1*2*3*4*5*6*7*8=40320;','$'
	res0 db '1' , '$'
	res1 db '1' , '$'
	res2 db '2' , '$'
	res3 db '6' , '$'
	res4 db '24' , '$'
	res5 db '120' , '$'
	res6 db '720' , '$'
	res7 db '5040' , '$'
	res8 db '40320' , '$'
	num0 db '00' , '$'
	num1 db '01' , '$'
	num2 db '02' , '$'
	num3 db '03' , '$'
	num4 db '04' , '$'
	num5 db '05' , '$'
	num6 db '06' , '$'
	num7 db '07' , '$'
	num8 db '08' , '$'
	;MENSAJES DEBUGGER
	msg0 db 0ah,0dh, '	ARCHIVO LEIDO Y SIN ERRORES!!!!','$'
	msg1 db 0ah,0dh, '	REPORTE CREADO CON EXITO!!!!!','$'
	msg2 db 0ah,0dh, '	escribiendo numero','$'
	msg3 db 0ah,0dh, '	Simbolo mas o menos','$'
	msg4 db 0ah,0dh, '	Simbolo por o div','$'
	msg5 db 0ah,0dh, '	Guardando Resultado','$'
	msg6 db 0ah,0dh, '	fin','$'
	msg7 db 0ah,0dh, '	sumando','$'
	msg8 db 0ah,0dh, '	restando','$'
	msg9 db 0ah,0dh, '	signo?','$'
	msg10 db 0ah,0dh, '	dividiendo...','$'
	msg11 db 0ah,0dh, '	escribiendo mas o menos','$'
	msg12 db 0ah,0dh, '	NOTACION PREFIJA: ','$'
	msg13 db 0ah,0dh, '	NOTACION POSTFIJA: ','$'

;-------------------SEGMENTO DE CODIGO------------------------
.code
main proc
	MenuPrincipal:
		;--------LIMPIANDO CONSOLA-------------------------
		LimpiarConsola
		;--------MOSTRANDO EL MENU PRINCIPAL--------------------------
		print enc0
		print enc1
		print salt
		;--------OBTENIENDO EL NUMERO ESCOGIDO------------------------
		getChar
		cmp al,31h; COMPARO CON EL ASCII DEL NUMERO 1 QUE ES 49 Y EN HEXA 31H
		je CargarArchivo
		cmp al,32h ;comparo con el ascii del numero 2
		je ModoCalculadora
		cmp al,33h
		je Factorial
		cmp al,34h
		je Reporte
		cmp al,35h
		je Salir
		jmp MenuPrincipal
;----------------------METODO CARGAR ARCHIVO---------------------------------------
	CargarArchivo:
		print enc2
		print salt
		mov si,0
		xor cx,cx
	Obtener_Ruta:	;esta etiqueta es necesaria ya que es recursiva, se manda a llamar en el macro ObtenerRuta
		ObtenerRuta ArrayRuta
	Verificar_Extension:	;esta etiqueta es necesaria ya que es recursiva, se manda a llamar en el macro VerificarExtension
		VerificarExtension ArrayRuta

		abrir ArrayRuta,handlerEntrada
		leer SIZEOF ArrayInfo,ArrayInfo,handlerEntrada
		cerrar handlerEntrada

		VerificarErrores ArrayInfo
		jmp MenuOperaciones
;-----------------CREAR REPORTE-------------------------------------------------
	Reporte:
		CambiarExtension ArrayRuta,ArrayReporte ;en este macro cambio la extension de .arq a .rep para tener el mismo nombre en el reporte
		crear ArrayReporte,handlerReporte
		
		ObtenerSize enc0,tamano
		escribir tamano, enc0, handlerReporte ;escribiendo el ENCABEZADO
		ObtenerSize salt,tamano
		escribir tamano, salt, handlerReporte ;escribiendo salto de linea
		ObtenerSize enc4,tamano
		escribir tamano, enc4, handlerReporte ;escribiendo reporte practica y fecha
		ObtenerSize enc5,tamano
		escribir tamano, enc5, handlerReporte ;escribiendo HORA

		ObtenerHora Arrhora,Arrminuto,Arrsegundo
		ObtenerSize Arrhora,tamano
		escribir tamano, Arrhora, handlerReporte ;escribiendo hora
		ObtenerSize msgdospuntos,tamano
		escribir tamano, msgdospuntos, handlerReporte ;escribiendo :
		ObtenerSize Arrminuto,tamano
		escribir tamano, Arrminuto, handlerReporte ;escribiendo minutos
		ObtenerSize msgdospuntos,tamano
		escribir tamano, msgdospuntos, handlerReporte ;escribiendo :
		ObtenerSize Arrsegundo,tamano
		escribir tamano, Arrsegundo, handlerReporte ;escribiendo segudos

		ObtenerSize salt,tamano
		escribir tamano, salt, handlerReporte ;escribiendo salto de linea
		ObtenerSize enc6,tamano

		escribir tamano, enc6, handlerReporte ;escribiendo ENTRADA
		ObtenerSize2 ArrayInfo,tamano2
		escribir tamano2, ArrayInfo, handlerReporte ;escribiendo todo lo que tiene la entrada
		ObtenerSize fac3,tamano
		escribir tamano, fac3, handlerReporte ;escribiendo resultado:
		ObtenerSize ArrRes,tamano
		escribir tamano, ArrRes, handlerReporte ;escribiendo el numero de resultado
		ObtenerSize msg12,tamano
		escribir tamano, msg12, handlerReporte ;escribiendo NOTACION PreFIJA
		escribir tamano2, ArrayPre, handlerReporte ;escribiendo la cadena en prefija
		ObtenerSize msg13,tamano
		escribir tamano, msg13, handlerReporte ;escribiendo NOTACION POSTFIJA
		escribir tamano2, ArrayPost, handlerReporte ;escribiendo la cadena en postfija

		ObtenerSize salt,tamano
		escribir tamano, salt, handlerReporte ;escribiendo salto de linea

		ObtenerSize fac1,tamano
		mov ax,UltimoFac
		cmp ax,0
		je Cero1
		cmp ax,1
		je Uno1
		cmp ax,2
		je Dos1
		cmp ax,3
		je Tres1
		cmp ax,4
		je Cuatro1
		cmp ax,5
		je Cinco1
		cmp ax,6
		je Seis1
		cmp ax,7
		je Siete1
		cmp ax,8
		je Ocho1
		jmp Error

	Cero1:
		escribir tamano, fac1, handlerReporte ;escribiendo factorial: 
		ObtenerSize num0,tamano
		escribir tamano, num0, handlerReporte ;escribiendo el numero
		ObtenerSize fac2,tamano
		escribir tamano, fac2, handlerReporte ;escribiendo OPERACIONES:
		ObtenerSize pro0,tamano
		escribir tamano, pro0, handlerReporte ;escribiendo todos los procedimientos para el factorial de 0#
		ObtenerSize fac3,tamano
		escribir tamano, fac3, handlerReporte ;escribiendo resultado
		ObtenerSize res0,tamano
		escribir tamano, res0, handlerReporte ;escribiendo el resultado
		jmp FinRep
	Uno1:
		escribir tamano, fac1, handlerReporte ;escribiendo factorial: 
		ObtenerSize num1,tamano
		escribir tamano, num1, handlerReporte ;escribiendo el numero
		ObtenerSize fac2,tamano
		escribir tamano, fac2, handlerReporte ;escribiendo OPERACIONES:
		ObtenerSize pro1,tamano
		escribir tamano, pro1, handlerReporte ;escribiendo todos los procedimientos para el factorial de 0#
		ObtenerSize fac3,tamano
		escribir tamano, fac3, handlerReporte ;escribiendo resultado
		ObtenerSize res1,tamano
		escribir tamano, res1, handlerReporte ;escribiendo el resultado
		jmp FinRep
	Dos1:
		escribir tamano, fac1, handlerReporte ;escribiendo factorial: 
		ObtenerSize num2,tamano
		escribir tamano, num2, handlerReporte ;escribiendo el numero
		ObtenerSize fac2,tamano
		escribir tamano, fac2, handlerReporte ;escribiendo OPERACIONES:
		ObtenerSize pro2,tamano
		escribir tamano, pro2, handlerReporte ;escribiendo todos los procedimientos para el factorial de 0#
		ObtenerSize fac3,tamano
		escribir tamano, fac3, handlerReporte ;escribiendo resultado
		ObtenerSize res2,tamano
		escribir tamano, res2, handlerReporte ;escribiendo el resultado
		jmp FinRep
	Tres1:
		escribir tamano, fac1, handlerReporte ;escribiendo factorial: 
		ObtenerSize num3,tamano
		escribir tamano, num3, handlerReporte ;escribiendo el numero
		ObtenerSize fac2,tamano
		escribir tamano, fac2, handlerReporte ;escribiendo OPERACIONES:
		ObtenerSize pro3,tamano
		escribir tamano, pro3, handlerReporte ;escribiendo todos los procedimientos para el factorial de 0#
		ObtenerSize fac3,tamano
		escribir tamano, fac3, handlerReporte ;escribiendo resultado
		ObtenerSize res3,tamano
		escribir tamano, res3, handlerReporte ;escribiendo el resultado
		jmp FinRep
	Cuatro1:
		escribir tamano, fac1, handlerReporte ;escribiendo factorial: 
		ObtenerSize num4,tamano
		escribir tamano, num4, handlerReporte ;escribiendo el numero
		ObtenerSize fac2,tamano
		escribir tamano, fac2, handlerReporte ;escribiendo OPERACIONES:
		ObtenerSize pro4,tamano
		escribir tamano, pro4, handlerReporte ;escribiendo todos los procedimientos para el factorial de 0#
		ObtenerSize fac3,tamano
		escribir tamano, fac3, handlerReporte ;escribiendo resultado
		ObtenerSize res4,tamano
		escribir tamano, res4, handlerReporte ;escribiendo el resultado
		jmp FinRep
	Cinco1:
		escribir tamano, fac1, handlerReporte ;escribiendo factorial: 
		ObtenerSize num5,tamano
		escribir tamano, num5, handlerReporte ;escribiendo el numero
		ObtenerSize fac2,tamano
		escribir tamano, fac2, handlerReporte ;escribiendo OPERACIONES:
		ObtenerSize pro5,tamano
		escribir tamano, pro5, handlerReporte ;escribiendo todos los procedimientos para el factorial de 0#
		ObtenerSize fac3,tamano
		escribir tamano, fac3, handlerReporte ;escribiendo resultado
		ObtenerSize res5,tamano
		escribir tamano, res5, handlerReporte ;escribiendo el resultado
		jmp FinRep
	Seis1:
		escribir tamano, fac1, handlerReporte ;escribiendo factorial: 
		ObtenerSize num6,tamano
		escribir tamano, num6, handlerReporte ;escribiendo el numero
		ObtenerSize fac2,tamano
		escribir tamano, fac2, handlerReporte ;escribiendo OPERACIONES:
		ObtenerSize pro6,tamano
		escribir tamano, pro6, handlerReporte ;escribiendo todos los procedimientos para el factorial de 0#
		ObtenerSize fac3,tamano
		escribir tamano, fac3, handlerReporte ;escribiendo resultado
		ObtenerSize res6,tamano
		escribir tamano, res6, handlerReporte ;escribiendo el resultado
		jmp FinRep
	Siete1:
		escribir tamano, fac1, handlerReporte ;escribiendo factorial: 
		ObtenerSize num7,tamano
		escribir tamano, num7, handlerReporte ;escribiendo el numero
		ObtenerSize fac2,tamano
		escribir tamano, fac2, handlerReporte ;escribiendo OPERACIONES:
		ObtenerSize pro7,tamano
		escribir tamano, pro7, handlerReporte ;escribiendo todos los procedimientos para el factorial de 0#
		ObtenerSize fac3,tamano
		escribir tamano, fac3, handlerReporte ;escribiendo resultado
		ObtenerSize res7,tamano
		escribir tamano, res7, handlerReporte ;escribiendo el resultado
		jmp FinRep
	Ocho1:
		escribir tamano, fac1, handlerReporte ;escribiendo factorial: 
		ObtenerSize num8,tamano
		escribir tamano, num8, handlerReporte ;escribiendo el numero
		ObtenerSize fac2,tamano
		escribir tamano, fac2, handlerReporte ;escribiendo OPERACIONES:
		ObtenerSize pro8,tamano
		escribir tamano, pro8, handlerReporte ;escribiendo todos los procedimientos para el factorial de 0#
		ObtenerSize fac3,tamano
		escribir tamano, fac3, handlerReporte ;escribiendo resultado
		ObtenerSize res8,tamano
		escribir tamano, res8, handlerReporte ;escribiendo el resultado
		jmp FinRep
	FinRep:
		cerrar handlerReporte

		print msg1
		jmp EsperarEnter
;---------------MENU OPERACIONES----------------------------------------------------
	MenuOperaciones1:
		LimpiarConsola
	MenuOperaciones:
		print enc3 ;menu OPERACIONES
		print salt
		getChar
		cmp al,31h
		je ResultadoArchivo
		cmp al,32h
		je NotacionPrefija
		cmp al,33h
		je NotacionPostfija
		cmp al,34h
		je MenuPrincipal
		jmp MenuOperaciones1
;---------------RESULTADO ARCHIVO---------------------------------------------------
	ResultadoArchivo:
		AnalizarEntrada ArrayInfo, SumasYRestas
		ObtenerResultado ResArchivo,SumasYRestas
		ConvertirResultado2 ResArchivo, ArrRes

		print fac3 ;mostrando resultado:
		print ArrRes
		getChar
		jmp MenuOperaciones
;---------------------MODO CALCULADORA----------------------------------------------
	ModoCalculadora:
		LimpiarConsola
	ModoCalculadora1:
		LimpiarNumeros ArrayNum1,ArrayNum2,ArrayRes
		print cal0 ;Numero1
		ObtenerNumero1 ArrayNum1
		print cal1 ;Operador Aritmetico
		ObtenerOperador Operador
		print cal0 ;Numero2
		ObtenerNumero2 ArrayNum2												;guardo el numero en el arreglo de asciis
		GuardarNumeros ArrayNum1,ArrayNum2,Numero1,Numero2,NegN1,NegN2,ANS,NegANS		;guardo los numeros en las variables
		Operar Numero1,Operador,Numero2,Resultado,NegN1,NegN2,SignoMayor					;Mando a operar lo que ingresaron
		ConvertirResultado Resultado,ArrayRes									;convierto el resultado a ascii para poder mostrarlo
		
		mov dx, Resultado
		mov ANS,dx		 														;guardo el resultado en la variable ANS para que pueda ser usado despues
		print cal2 ;Resultado
		ImprimirSigno SignoMenos,NegN1,Operador,NegN2,NegRes,SignoMayor
		mov dx,NegRes
		mov NegANS,dx
		print ArrayRes
		print cal3	;desea salir
		print salt

		getChar
		cmp al,31h
		je MenuPrincipal
		cmp al,32h
		je ModoCalculadora1
		jmp ModoCalculadora
;----------------------NOTACION PRE-FIJA------------------------------------------
	NotacionPrefija:
		CopiarArrayB ArrayInfo,ArrayPre
		ObtenerPreorden ArrayPre
		print salt
		print msg12
		print salt
		print ArrayPre
		print salt
		getChar
		jmp MenuOperaciones
;----------------------NOTACION POST-FIJA------------------------------------------
	NotacionPostfija:
		CopiarArrayA ArrayInfo,ArrayPost
		ObtenerPostOrden ArrayPost
		print salt
		print msg13
		print salt
		print ArrayPost
		print salt
		getChar
		jmp MenuOperaciones
;---------------------FACTORIAL DE UN NUMERO DEL 00-08-----------------------------
	Factorial:
		print fac1 ;factorial:
		getChar
		getChar
		cmp al,30h ;ascii del 0
		je Cero
		cmp al,31h
		je Uno
		cmp al,32h
		je Dos
		cmp al,33h
		je Tres
		cmp al,34h
		je Cuatro
		cmp al,35h
		je Cinco
		cmp al,36h
		je Seis
		cmp al,37h
		je Siete
		cmp al,38h
		je Ocho
		jmp Error6
	Cero:
		mov UltimoFac,0
		print fac2
		print pro0
		print fac3
		print res0
		print salt
		jmp EsperarEnter
	Uno:
		mov UltimoFac,1
		print fac2
		print pro1
		print fac3
		print res1
		print salt
		jmp EsperarEnter
	Dos:
		mov UltimoFac,2
		print fac2
		print pro2
		print fac3
		print res2
		print salt
		jmp EsperarEnter
	Tres:
		mov UltimoFac,3
		print fac2
		print pro3
		print fac3
		print res3
		print salt
		jmp EsperarEnter
	Cuatro:
		mov UltimoFac,4
		print fac2
		print pro4
		print fac3
		print res4
		print salt
		jmp EsperarEnter
	Cinco:
		mov UltimoFac,5
		print fac2
		print pro5
		print fac3
		print res5
		print salt
		jmp EsperarEnter
	Seis:
		mov UltimoFac,6
		print fac2
		print pro6
		print fac3
		print res6
		print salt
		jmp EsperarEnter
	Siete:
		mov UltimoFac,7
		print fac2
		print pro7
		print fac3
		print res7
		print salt
		jmp EsperarEnter
	Ocho:
		mov UltimoFac,8
		print fac2
		print pro8
		print fac3
		print res8
		print salt
		jmp EsperarEnter
	EsperarEnter:
		getChar
		jmp MenuPrincipal
;---------------------MENSAJES DE ERRORES-------------------------------------------
	Error: ;ERROR DESPUES DE LOS JUMPS NUNCA DEBERIA LLEGAR AQUI
		print err0
		jmp EsperarEnter
	Error1: ;NO HAY EXTENSION EN EL NOMBRE DEL ARCHIVO
		print err1
		jmp CargarArchivo
	Error2: ;EXTENSION INCORRECTA
		print err2
		jmp CargarArchivo
	Error3: ;ERROR AL INGRESAR NUMERO EN MODO CALCULADORA
		print err3
		jmp ModoCalculadora
	Error4: ;ERROR AL INGRESAR CARACTER QUE NO ES NUMERO NI SIGNO
		print err4
		jmp ModoCalculadora
	Error5: ;OPERADOR INVALIDO
		print err5
		jmp ModoCalculadora
	Error6: ;NUMERO NO VALIDO
		print err6
		jmp Factorial
	Error7: ;NO SE PUDO CREAR
		print err7
		jmp EsperarEnter
	Error8: ;NO SE PUDO ABRIR
		print err8
		jmp CargarArchivo
	Error9: ;NO SE PUDO ESCRIBIR
		print err9
		jmp CargarArchivo
	Error10: ;NO SE PUDO LEER
		print err10
		jmp CargarArchivo
	Error11: ;NO SE PUDO CERRAR
		print err11
		jmp CargarArchivo
	Error12: ;SE ESPERABA NUMERO
		print err12
		printChar ArrayInfo[si]
		jmp CargarArchivo
	Error13: ;SE ESPERABA ESPACIO
		print err13
		printChar ArrayInfo[si]
		jmp CargarArchivo
	Error14: ;SE ESPERABA SIGNO ARITMETICO
		print err14
		printChar ArrayInfo[si]
		jmp CargarArchivo
	Error15: ;NO HAY RUTA PARA PONER EL NOMBRE EN REPORTE
		print err15
		jmp EsperarEnter
	Error16: ;SE ESPERABA PUNTO Y COMA
		print err16
		jmp CargarArchivo
	Error17: ;division con 0 de divisor
		print err17
		getChar
		jmp ModoCalculadora
;---------------------METODO PARA FINALIZAR EL PROGRAMA-----------------------------
	Salir:
		mov ah, 4ch
		mov al, 00h
		int 21h
main endp ;Termina proceso
end main