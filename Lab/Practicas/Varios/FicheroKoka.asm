;-------------SE ABRE EL FICHERO---------------------
		;si se ejecuta correctamente devuelve el handle en AX
		mov ah,3dh ;Instrucción para abrir el archivo
		mov al,2h  ;0h solo lectura, 1h solo escritura, 2h lectura y escritura 
		mov dx,offset ArrayRuta ;abre el archivo llamado archivo2.txt indicado en .data
		int 21h
		jc NoSeEncontroRuta
		;------------MUEVE EL APUNTADOR PARA LEER DESDE EL PRINCIPIO---------
		mov ah,42h ;Mueve el apuntador de lectura/escritura al archivo
		mov al,00h ;Empieza en la pos 0
		mov bx,ax ;handle del fichero
		mov cx,50 ;Decimos que queremos leer 50 bytes del archivo
		int 21h
		;----------- LECTURA DEL FICHERO--------------------
		mov ah,3fh ;Lectura del archivo
		mov bx,ax ;handle del fichero
		mov cx,50 ;numero de bytes a leer
		mov dx,offset ArrayInfo ;Donde se depositaran los caracteres leidos
		int 21h
		jc ErrorAlLeer
		;------------ CIERRE DEL FICHERO---------------------
		mov ah,3eh  ;Cierre de archivo
		mov bx,ax ;handle del fichero
		int 21h
		jc ErrorAlCerrar