; Nota: direccion relativa en el repositorio.  >cd 2_Laboratorio/L02_Introduccion

%include "./pc_io.inc"

section .data	;Datos inicializados
	msg1:	db	"Ingresa tu nombre",10,0 ; 10 es desiguiente linea.
	msg2:	db	"Hola ",0
	; msj:	db	'Ingrese un digito (0-9)',0x0A
	; msj:	db	'Ingrese un digito (0-9)',0x0 ;Segunda modificacion de la practica.
	msj:	db	'Ingrese un digito (0-9)',10,0 ;Segunda modificacion de la practica.
	len:	equ	$-msj							

section	.bss	;Datos no inicializados
	num1 	resb 1
	nombre	resb 256
	num2 	resb 1	;Pate 11: se necesita agregar esta variable.

section .text
	global _start:

_start:
	; call clrscr ;Rutina para limpiar consola.
	; ;Inicio de codigo base.
	; mov edx, msg1	;Imprimir mensaje 1
	; call puts
	; mov ebx, nombre

	;Inicio de practica
	
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
	; mov edx, msj
	; call puts

	; call getche
	; call putchar
	
	
	; Parte 7 y 8
	mov edx, msj
	call puts
	call salto
	call getch
	call salto
	call putchar
	call salto

	; Parte 9: Sumarle 1 e imprimir en terminal.
	mov ebx, num1 
	mov byte[ebx], al 
	add byte[ebx], 1 
	mov al, byte[ebx] 
	call putchar 

	; Parte 11: 
	mov ebx, num1
	mov al, [ebx]
	mov ebx, num2
	add [ebx], al
	mov al, byte[ebx]
	call putchar

	mov ebx, nombre
	;-----------
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
	call putchar



	mov eax, 1	;Carga la instruccion de salida de programa.
	mov ebx, 0	;Indica que termino correctamente, como un return 0 en c.
	int 80h		;Llamada a kener con las anteriores mensajes.

	; Parte 7: Primer salto sugerido en la practica. 
	; salto:
	; 	mov al, 13
	; 	call putchar
	; 	mov al, 10
	; 	call putchar
	; 	ret

	; Parte 8: Segundo saldo sugerido en la practica. 
	salto:
		pushad
		mov al, 13
		call putchar
		mov al, 10
		call putchar
		popad
		ret


;##############################################################################################################
;Solución al problema de la suma.

; Nota: direccion relativa en el repositorio.  >cd 2_Laboratorio/L02_Introduccion

; %include "./pc_io.inc"

; section .data	;Datos inicializados					
; 	msj1:	db	"Programa para sumar 2 numeros",10,0
; 	msj2:	db	"Ingresa un numero (0 - 9)",10,0
; 	msj3:	db	"Ingresa otro numero (0 - 9)",10,0
;     msj4:	db	"El resultado es ",0

; section	.bss	;Datos no inicializados
;     num1    resb 1      ; 1 byte va desde 0 hasta 255.
;     num2    resb 1

; section .text
; 	global _start:

; _start:
;     call clrscr ; Limpiamos pantalla
;     call salto 

;     ;Mostrar mensaje 1
;     mov edx, msj1 
;     call puts

;     ;Mostrar mensaje 2
;     mov edx, msj2
;     call puts

;     ;Capturar
;     call getche
;     mov ebx, num1
;     mov [ebx], al
;     call salto

;     ;Mostrar mensaje 3
;     mov edx, msj3
;     call puts

;     ;Capturar
;     call getche
;     mov ebx, num2
;     mov [ebx], al
;     call salto

;     ;Mostrar mensaje 4
;     mov edx, msj4
;     call puts

;     ;Logica de sumar   
;     mov al, [ebx]
;     mov ebx, num1
;     add al, [ebx]
;     sub al, 48

;     call putchar
;     call salto

; mov eax, 1	;Carga la instruccion de salida de programa.
; mov ebx, 0	;Indica que termino correctamente, como un return 0 en c.
; int 80h		;Llamada a kener con las anteriores mensajes. Fin del programa main.

;     salto:
;         pushad
;         mov al, 13
;         call putchar
;         mov al, 10
;         call putchar
;         popad
;         ret