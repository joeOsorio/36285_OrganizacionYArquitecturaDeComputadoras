; Nota: direccion relativa en el repositorio.  >cd 2_Laboratorio/L02_Introduccion

%include "./pc_io.inc"

section .data	;Datos inicializados
	msg1:	db	"Ingresa tu nombre",10,0 ; 10 es desiguiente linea.
	msg2:	db	"Hola ",0
	; msj:	db	'Ingrese un digito (0-9)',0x0A
	msj:	db	'Ingrese un digito (0-9)',0x0 ;Segunda modificacion de la practica.
	len:	equ	$-msj							

section	.bss	;Datos no inicializados
	num1 	resb 1
	nombre	resb 256

section .text
	global _start:

_start:
	; ; Codigo 1.
	; mov eax, 4 		;Carga instruccion del sistema.
	; mov ebx, 1		;Indica que muestre algo en pantalla.
	; mov ecx, msj	;Carga la direccion de mensaje.
	; mov edx, len	;Carga la longitud del mensaje.
	; int 80h			;Finaliza instruccion.

	; ;Codigo 2.
	; mov eax, 3		;carga instruccion al sistema.
	; mov ebx, 0		;Instruccion captura.
	; mov ecx, num1	;Direccion de variable.
	; mov edx, 2		;Longitud de variable.
	; int 80h			;Ejecuta instruccion.

	; ;Codigo 3
	; mov eax, 4		;Carga instruccion para el sistema
	; mov ebx, 1		;Carga la instruccion de mostrar en pantalla.
	; mov ecx, num1	;Direccion de variable a imprimir
	; mov edx, 1		;Logitud de variable.
	; int 80h			;Ejecutar instrucción

	;Parte 5.b practica
	mov edx, msj
	call puts

	;Inicio de codigo base.
	mov edx, msg1	;Imprimir mensaje 1
	call puts
	mov ebx, nombre
	capturar:
		call getche
		mov byte [ebx], al
		inc ebx
	cmp al, 10
	jne capturar
	mov byte [ebx], 0

	mov edx, msg2
	call puts

	mov edx, nombre
	call puts

	mov eax, 1	;Carga la instruccion de salida de programa.
	mov ebx, 0	;Indica que termino correctamente, como un return 0 en c.
	int 80h		;Llamada a kener con las anteriores mensajes.