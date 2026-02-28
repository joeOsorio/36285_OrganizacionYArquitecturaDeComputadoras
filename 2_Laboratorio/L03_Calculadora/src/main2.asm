; Nota: direccion relativa en el repositorio.  >cd 2_Laboratorio/L02_Introduccion

%include"./pc_io.inc"

section .data													;Datos inicializados
	msj1:   	db      "Programa para multiplicar 2 numeros", 10, 0

section .bss													;Datos no inicializados
	num1    resb       1										; 1 byte va desde 0 hasta 255.
	num2    resb       1

section .text
	global  _start:

_start:
	call    clrscr                                              ; Limpiamos pantalla
	call    salto

	;Mostrar mensaje 1
	mov     edx,        msj1
	call    puts

	;Capturar
	call    getche
	mov     ebx,        num1
	sub     al,         48										; Realizar casteo a numero.
	mov     [ebx],      al										; Guardar numero en variable.


	;Mostrar mensaje 2
	mov     al,         'x'
	call    putchar

	;Capturar
	call    getche
	mov     ebx,        num2
	sub     al,         48										; Realizar casteo a numero.
	mov     [ebx],      al

	;Mostrar mensaje 2
	mov     al,         '='
	call    putchar
	
	;	Logica para comvertir el utimo caracter a numero.
	mov     al,         0
	mov ebx, num2
	mov ecx, [ebx]												; Guardar el numero en el contador.

	mov     ebx,        num1
	;	Logica para multiplicar.
	.rep:
		cmp ecx, 0												; Compara el registro ecx con 0, Seria como el if
		je .finrep												; Realiza salto al fin.
		;Contenido de codigo.
		add     al,         [ebx]								;Multiplicar es sumar tantas veces el mismo numero.
		loop .rep ; Esta funcion revisa el registo ecx y en automatico decrementa. Solo decrementa cl pero como 
	.finrep:
	add al, 48													; Solo para resultados menores a 9
	call	impDec
	call    putchar	
	call    salto

	mov     eax,        1                                          ;Carga la instruccion de salida de programa.
	mov     ebx,        0                                          ;Indica que termino correctamente, como un return 0 en c.
	int     80h                                                    ;Llamada a kener con las anteriores mensajes. Fin del programa main.

salto:
	pushad
	mov     al,         13
	call    putchar
	mov     al,         10
	call    putchar
	popad
	ret

impDec:
	pushad
	
	; mov     al,         13
	; call    putchar
	; mov     al,         10
	; call    putchar
	popad
	ret


;Notas adicionales

; mox ecx, al
; 	.rep:
; 		cmp ecx, 0
; 		je .finrep
; 		dec ecx
		
; 		loop rep
; 	.fmrep
