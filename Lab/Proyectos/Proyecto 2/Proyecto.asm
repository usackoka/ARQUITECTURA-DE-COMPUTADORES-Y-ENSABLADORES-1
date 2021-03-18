include m_gen.asm ;archivo con los macros a utilizar
include m_graph.asm ;archivo con los macros para graficar
include m_gen2.asm
include m_juego2.asm

.model small
;-------------------SEGMENTO DE PILA--------------------------
.stack 128
;-------------------SEGMENTO DE DATO--------------------------
.data
;-----------------------------------------------------------------------------
tamano dw ?
bufftemp db 50 dup('$')
;////////////////////////VARIABLES ARCHIVO CON USUARIOS//////////////////////////
handleUsuarios dw ?
FileUsuarios db 'c:\p_usr.rep',00h
bufferUsuarios db 500 dup('$')
;////////////////////////VARIABLES ARCHIVO CON TOPS//////////////////////////
handleTop dw ?
FileTop db 'c:\p_top.rep',00h
bufferTop db 500 dup('$')
;/////////////////////////TIEMPOS .REP////////////////////////////////////////
handleTiempos dw ?
FileTiempos db 'c:\Tiempos.rep',00h
bufferTiempos db 1000 dup('$')
;////////////////////////PUNTOS .REP/////////////////////////////////////////
handlePuntos dw ?
FilePuntos db 'c:\Puntos.rep',00h
bufferPuntos db 1000 dup('$')
;///////////////////VARIABLES REGISTRO USUARIO/////////////////////////////////
regUsr db 8 dup('$')
regPas db 5 dup('$')
;////////////////////////MENSAJES//////////////////////////////////
err1 db 0ah,0dh, '	LA CONSTRASE',0a5h,'A SOLO PUEDE INCLUIR NUMEROS','$'
err7 db 0ah,0dh, '	ERROR AL INTENTAR CREAR ARCHIVO','$'
err8 db 0ah,0dh, '	ERROR AL INTENTAR ABRIR ARCHIVO',0ah,0dh,'	PUEDE QUE EL ARCHIVO NO EXISTA','$'
err9 db 0ah,0dh, '	ERROR AL INTENTAR ESCRIBIR EN ARCHIVO','$'
err10 db 0ah,0dh, '	ERROR AL INTENTAR LEER EN ARCHIVO','$'
err11 db 0ah,0dh, '	ERROR AL INTENTAR CERRAR EL ARCHIVO','$'
err12 db 0ah,0dh, '	ERROR AL INTENTAR BORRAR EL ARCHIVO','$'

salto db 0ah,0dh,'	','$'
salto2 db 0ah,0dh,'$'
esco db 0ah,0dh,'	ESCOJA UNA OPCION: ','$'

enc0 db 0ah,0dh, '	UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',0ah,0dh,'	FACULTAD DE INGENIERIA', 0ah,0dh, '	ESCUELA DE CIENCIAS Y SISTEMAS',0ah,0dh, '	ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 A',0ah,0dh, '	SEGUNDO SEMESTRE 2017',0ah,0dh, '	OSCAR RENE CUELLAR MANCILLA',0ah,0dh, '	201503712',0ah,0dh, '	PROYECTO','$'
enc1 db 0ah,0dh, '	MENU PRINCIPAL',0ah,0dh,0ah,0dh,'	1) INGRESAR',0ah,0dh,'	2) REGISTRAR',0ah,0dh,'	3) SALIR','$'
enc2 db 0ah,0dh, '	INGRESE EL NOMBRE DE USUARIO: ','$'
enc3 db '	INGRESE EL PASWORD: ','$'
enc4 db 0ah,0dh, '	SESION ADMINISTRADOR',0AH,0DH,'	1) TOP 10 PUNTOS',0AH,0DH,'	2) TOP 10 TIEMPOS',0AH,0DH,'	3) SALIR','$'

msg1 db 0ah,0dh,'	REPORTE CREADO CON EXITO!','$'
msg2 db 0ah,0dh,'	REPORTE CUARTA PRACTICA ','$'
msg3 db 0ah,0dh,'	FECHA:  ','$'
msg4 db '	DE OCTUBRE DE 2017 ','$'
msg5 db 0ah,0dh,'	HORA: ','$'
msg6 db ':','$'
msg7 db 0ah,0dh,'	USUARIO REGISTRADO CON EXITO!','$'
msg8 db 0ah,0dh,'	EL USUARIO YA EXISTE INTENTELO DE NUEVO!','$'
msg9 db 0ah,0dh,'	EL USUARIO NO EXISTE INTENTELO DE NUEVO!','$'
msg10 db 0ah,0dh,'	CONSTRASE',0a5h,'A INCORRECTA INTENTELO DE NUEVO!','$'
msg11 db 0ah,0dh,'		TOP 10 PUNTOS','$'
msg12 db 0ah,0dh,'		TOP 10 TIEMPOS','$'
;-------------VARIABLES JUEGO-------------------------
inicioBarra dw 0eca4h ;(320*189)+100
finBarra dw ?
nivel dw ?
punteo dw ?
perdio dw 0
pelotas dw 1 ;cuantas pelotas hay en juego
bufferHUD db 25 dup('#'),'$'
buffernumero db 3 dup('$'),'$'
;cubos db 20 dup('$'),'$'
;----------pixeles de la pelota 1-------------------
estadop1 db 1
p1 dw 0e7a4h
viva1 dw 1
;----------pixeles de la pelota 2-------------------
estadop2 db 1
p2 dw 0e7a4h
viva2 dw 1
;----------pixeles de la pelota 3-------------------
estadop3 db 1
p3 dw 0e7a4h
viva3 dw 1
;---------------------------------------------------
lineas dw 0
cuadrosxlinea dw 0
anchocuadros dw 0
separacioncuadros dw 0
coma db 1 dup(','),'$'
solto dw 0
minutos db 0
segundos db 0
segun dw 0
numtemp db 0
numtemp2 dw 0
tiempo dw 0
top dw 0
contador db 0
yapaso dw 0
yapaso2 dw 0
;-------------------SEGMETNO DE CODIGO------------------------
.code
main proc
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%% MenuPrincipal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	MenuPrincipal:
		print salto
		print enc0
		print salto
		print enc1
		print salto
		print esco
		getChar
		cmp al,31h
		je Ingresar
		cmp al,32h
		je Registrar
		cmp al,33h
		je Salir
		LimpiarConsola
		jmp MenuPrincipal
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% REGISTRAR %%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Registrar:
		LimpiarArr2 regUsr
		print enc2 ;nombre de USUARIO
		ObtenerUsuario regUsr
	Contra:
		LimpiarArr2 regPas
		print enc3 ;contrasena
		ObtenerContrasena regPas

		LimpiarArr2 bufferUsuarios
		abrir FileUsuarios,handleUsuarios
		leer SIZEOF bufferUsuarios,bufferUsuarios,handleUsuarios
		cerrar handleUsuarios

		VerificarExistencia bufferUsuarios,regUsr,regPas
		
		jmp MenuPrincipal
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% INGRESAR %%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Ingresar:
		LimpiarArr2 bufferTop
		LimpiarArr2 regUsr
		print enc2 ;nombre de USUARIO
		ObtenerUsuario regUsr
	Contra2:
		LimpiarArr2 regPas
		print enc3 ;contrasena
		ObtenerContrasena2 regPas

		LimpiarArr2 bufferUsuarios
		abrir FileUsuarios,handleUsuarios
		leer SIZEOF bufferUsuarios,bufferUsuarios,handleUsuarios
		cerrar handleUsuarios

		Loggear bufferUsuarios,regUsr,regPas

		cmp cx,1 ;si es 1 es por que entro como administrador
		je Administrador

		ModoGrafico
		Nivel1 nivel
		ModoTexto
		pop nivel
		pop tiempo
		pop punteo

		;print FileTop
		abrir FileTop, handleTop
		leer SIZEOF bufferTop,bufferTop,handleTop
		cerrar handleTop

		borrar FileTop
		crear FileTop,handleTop
		ObtenerSize2 bufferTop,tamano
		escribir tamano,bufferTop,handleTop
		;abrir FileTop,handleTop

		ObtenerSize2 regUsr,tamano
		escribir tamano,regUsr,handleTop
		;printChar 35

		escribir 1,coma,handleTop
		;printChar 35

		ConvertToString nivel,bufftemp
		ObtenerSize2 bufftemp,tamano
		escribir tamano,bufftemp,handleTop

		escribir 1,coma,handleTop
		;printChar 35

		ConvertToString punteo,bufftemp
		ObtenerSize2 bufftemp,tamano
		escribir tamano,bufftemp,handleTop
		;printChar 35

		escribir 1,coma,handleTop
		;printChar 35

		ConvertToString tiempo,bufftemp
		ObtenerSize2 bufftemp,tamano
		escribir tamano,bufftemp,handleTop
		;printChar 35

		mov bufftemp[0],0dh
		mov bufftemp[1],0ah
		escribir 2,bufftemp,handleTop
		;printChar 35

		cerrar handleTop

		;getChar
		LimpiarArr2 bufferTop
		jmp MenuPrincipal
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% ADMINISTRADOR %%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Administrador:
		print salto
		print enc4
		print salto
		print esco
		getChar
		cmp al,31h
		je Top10Puntos
		cmp al,32h
		je Top10Tiempos
		cmp al,33h
		je MenuPrincipal
		LimpiarConsola
		jmp Administrador
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% TOP 10 PUNTOS %%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Top10Puntos:
		LimpiarArr2 bufferTop
		LimpiarArr2 bufferPuntos
		abrir FileTop, handleTop
		leer SIZEOF bufferTop,bufferTop,handleTop
		cerrar handleTop

		;print salto
		;print bufferTop
		;getChar

		TopPuntos bufferTop,bufferPuntos
		;print salto
		;print bufferPuntos
		;printChar 35
		print msg11
		print salto2
		print bufferPuntos

		borrar FilePuntos
		crear FilePuntos,handlePuntos

		ObtenerSize2 enc0,tamano
		escribir tamano,enc0,handlePuntos
		ObtenerSize2 salto2,tamano
		escribir tamano,salto2,handlePuntos
		ObtenerSize2 msg11,tamano
		escribir tamano,msg11,handlePuntos
		ObtenerSize2 salto2,tamano
		escribir tamano,salto2,handlePuntos
		ObtenerSize2 bufferPuntos,tamano
		escribir tamano,bufferPuntos,handlePuntos
		cerrar handlePuntos

		getChar
		jmp Administrador
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% TOP 10 TIEMPOS %%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Top10Tiempos:
		LimpiarArr2 bufferTop
		LimpiarArr2 bufferTiempos
		abrir FileTop, handleTop
		leer SIZEOF bufferTop,bufferTop,handleTop
		cerrar handleTop

		;print salto
		;print bufferTop
		;getChar

		TopTiempos bufferTop,bufferTiempos
		;print salto
		;print bufferPuntos
		;printChar 35
		print msg12
		print salto2
		print bufferTiempos

		borrar FileTiempos
		crear FileTiempos,handleTiempos

		ObtenerSize2 enc0,tamano
		escribir tamano,enc0,handleTiempos
		ObtenerSize2 salto2,tamano
		escribir tamano,salto2,handleTiempos
		ObtenerSize2 msg12,tamano
		escribir tamano,msg12,handleTiempos
		ObtenerSize2 salto2,tamano
		escribir tamano,salto2,handleTiempos
		ObtenerSize2 bufferTiempos,tamano
		escribir tamano,bufferTiempos,handleTiempos
		cerrar handleTiempos

		getChar
		jmp Administrador
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% ERRORES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Error1: ;CONSTRASEÑA SOLO PUEDE LLEVAR NUMEROS
		print err1
		getChar2
		print salto2
		jmp Contra
	Error2: ;CONSTRASEÑA SOLO PUEDE LLEVAR NUMEROS
		print err1
		getChar2
		print salto2
		jmp Contra2
	Error7: ;NO SE PUDO CREAR
		print err7
		getChar2
		jmp MenuPrincipal
	Error8: ;NO SE PUDO ABRIR
		print err8
		getChar2
		jmp MenuPrincipal
	Error9: ;NO SE PUDO ESCRIBIR
		print err9
		getChar2
		jmp MenuPrincipal
	Error10: ;NO SE PUDO LEER
		print err10
		getChar2
		jmp MenuPrincipal
	Error11: ;NO SE PUDO CERRAR
		print err11
		getChar2
		jmp MenuPrincipal
	Error12: ;NO SE PUDO BORRAR
		print err12
		getChar2
		jmp MenuPrincipal
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% SALIR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Salir: ;etiqueta salir
		mov ah, 4ch	;Numero de funcion para finalizar el programa
		xor al,al
		int 21h
main endp
end main