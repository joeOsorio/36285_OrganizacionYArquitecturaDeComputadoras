
%include "pc_io.inc"
%include "my_routines.asm"

; Primera practica de OAC ver como es mi primer HOLA MUNDO sus elemento y componentes.
	global  _start
	section .text
_start:
	; sys_write(stdout, message, length)
	call	clrscr
	call	print_newline
	mov     eax,        4
	mov     ebx,        1
	mov     ecx,        message
	mov     edx,        length
	int     80h

	; sys_exit(return_code)
	mov     eax,        1                              ;sys_exit syscall
	mov     ebx,        0                              ;return 0 (todo correcto)
	int     80h

	section .data
message:    	db      'Hello,     world!',    0x0A   ;mensaje y nueva linea
length:     	equ     $-message                      ;Obtenemos la longitud de la cadena