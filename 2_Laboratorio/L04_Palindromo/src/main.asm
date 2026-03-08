; Ensamblador NASM, formato ELF de 32 bits, para Linux.
; Practica 5: Captura, visualización y detección de palíndromos.
; Instrucciones permitidas: add, sub, mov, jmp, cmp, je, loop, getch, getche, puts, putchar, inc, dec.


; Notas: 
; - Direccion relativa en el repositorio.  >cd 2_Laboratorio/L04_Palindromo/
; - Para ensamblar: > nasm -f elf32 -Isrc/LIB src/main.asm -o output/main.o
; - Para asociar: 	>  ld -m elf_i386 -s -o bin/main output/main.o src/LIB/libpc_io.a
; - Para ejecutar: 	> ./main12

%include "./pc_io.inc"

section .data						;Datos inicializados
	msj1:	db	"Programa para capturar texto", 10, 0
	msj22:	db	"Cadena capturada:", 0
	msj2:	db	"programa para saber si es o no Palindromo ", 10, 0
	msj3:	db	"Si es palindromo", 10, 0
	len3:	equ	$-msj3
	msj4:	db	"No es palindromo", 10, 0
	len4:	equ	$-msj4

section .bss						;Datos no inicializados
	cadena 		resb 	254

section .text
	global  _start:

_start:
	call    clrscr					; Limpiamos pantalla
	call    salto
	;-------------- 1 - Capturar cadena --------------
	mov     edx,    msj1		; Mostrar mensaje 1
	call    puts
	mov		ecx, 	254
	mov		edx, 	cadena
	call	inputStr			; Capturar y luego mostrar
	;-------------- Punto 3: Verificar palindromo --------------
	mov     edx,	msj2	; Mostrar mensaje
	call    puts
	mov		edx, 	cadena
	call 	palindromo
	;-------------- Fin --------------
	mov     eax,        1	;Carga la instruccion de salida de programa.
	mov     ebx,        0	;Indica que termino correctamente, como un return 0 en c.
	int     80h				;Llamada a kener con las anteriores mensajes. Fin del programa main.

inputStr:
	; Entrada:	EDX	-> 	Direccion de la variable.
	;			ECX	-> 	logitud de cadena		
	; Salida:	AL	-> 	Caracter capturado.
	; 			EDI -> 	longitud de cadena.
	mov		edi, 0
	.ciclo_captura:
		cmp		edi,	ecx
		je		.fin_captura2
		call	getche
		cmp 	al, 	'+'			; Compara con el caracter + para terminar la captura.
		mov 	[edx + edi], 	al
		je 		.fin_captura
		inc 	edi
		jmp 	.ciclo_captura
	.fin_captura:
		mov 	byte[edx + edi + 1], 0 ; Agrego 0 para poder utilizar puts
		call	salto
		call	salto
		; call 	puts	
		; mov     edx,		msj22	; Mostrar mensaje
		; call    puts

		mov		bh, edig
		call	gotoxy 
		call	outputStr
		call 	salto
		call 	salto
	.fin_captura2: ; Para cadenas de logitud 0
	ret

outputStr:
	; Entrada:	EDX 		->	Dir de la variable.
	;			EDI 		->	Longitud cadena
	; utiliza:	ESI
	; Salida:	Terminal	->	Muestra en terminal la cadena. 	
	mov esi,	0
	.ciclo_mostrar:
		cmp 	esi, 	edi		; Compara con el salto de linea para terminar la captura.
		je 		.fin_mostrar
		mov		al,		[edx + esi]
		cmp		al, 				'+'
		je		.fin_mostrar
		call	putchar
		inc		esi
		jmp		.ciclo_mostrar
	.fin_mostrar:
	ret

palindromo:
	; Entrada:	EDX -> Direccion de la cadena a evaluar. 
	;			EDI -> Longitud de cadena
	; Utiliza:	ESI
	; Salida:	DL bandera que indica 0: No palindromo, 1: Si palindromo
    
	; Si la cadena está vacía, es palíndromo
    cmp		edi, 	0
    je		.no_palindromo
    mov 	esi, 	0                   ; índice izquierdo
	dec		edi
	.ciclo_palindromo:
		cmp 	esi,	edi
		je 		.es_palindromo           ; Si se cruzaron o son iguales, es palíndromo
		mov 	al,		[edx + esi]
		mov 	ah ,	[edx + edi]
		cmp 	al,		ah 
		jne 	.no_palindromo
		inc 	esi
		dec 	edi
		jmp 	.ciclo_palindromo
	.es_palindromo:
		mov 	edx, 	msj3
		mov		edi, 	len3
		call 	outputStr		;no utiliza prin
		; call 	puts		;no utiliza prin
		ret
	.no_palindromo:
		mov 	edx, 	msj4
		mov		edi, 	len4
		call 	outputStr		;no utiliza prin
		; call 	puts
		ret
ret

string_len:
	; Entrada:	EDX -> Direccion de la cadena a evaluar. 
	;			EDI -> Longitud de cadena sin contemplar 0
	; Utiliza:	ESI y Al
	; Salida:
	mov		esi,	edx
	mov		edi, 	0
	.ciclo_len:
		mov al, 	[esi + edi]
		cmp al, 	0
		je 	.fin_ciclo_len
		inc	edi
		jmp .ciclo_len
	.fin_ciclo_len:
ret

salto:
	; Utiliza:	al
	pushad
	mov     al,         13
	call    putchar
	mov     al,         10
	call    putchar
	popad
	ret