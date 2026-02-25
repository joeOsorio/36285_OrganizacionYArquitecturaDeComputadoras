%include "./pc_io.inc"

section .data	;Datos inicializados
	msg1:	db "Ingresa tu nombre",10,0
	msg2:	db "Hola ",0

section .bss	;Datos no inicializados
	nombre	resb 256

section .text
	global _start:

_start:
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

	mov eax, 1
	mov ebx, 0
	int 80h