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
	msj2:	db	"programa para saber si es o no Palindromo ", 10, 0
	msj3:	db	"Si es palindromo", 10, 0
	msj4:	db	"No es palindromo", 10, 0

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
	; Entrada:	EDX	-> Direccion de la variable.
	; Modifica: eax, ebx, ecx, edx, esi, edi
	; Salida:	AL	-> Caracter capturado.
	; 			EDI -> longitud de cadena.
	mov		edi, 0
	.ciclo_captura:
		call	getch
		cmp 	al, 	'+'			; Compara con el salto de linea para terminar la captura.
		je 		.fin_captura
		mov 	[ebx + edi], 	al
		inc 	edi
		jmp 	.ciclo_captura
	.fin_captura:
		mov 	byte[edx + edi + 1], 	0
		call	outputStr
	ret

outputStr:
	; Entrada:	EDX 		->	Dir de la variable.
	;			EDI 		->	Longitud cadena
	; utiliza:	AL
	; Salida:	Terminal	->	Muestra en terminal la cadena. 	
	mov esi,	0
	.ciclo_mostrar:
		cmp 	esi, 	edi		; Compara con el salto de linea para terminar la captura.
		je 		.fin_mostrar
		cmp		byte[ebx + esi], 				'0'
		je		.fin_mostrar
		mov		al,		[eax]
		call	putchar
		inc		edi
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
	.ciclo_palindromo:
		cmp 	esi,	edi
		jge 	.es_palindromo           ; Si se cruzaron o son iguales, es palíndromo
		mov 	al,		[edx + esi]
		mov 	ah ,	[edx + edi]
		cmp 	al,		ah 
		jne 	.no_palindromo
		inc 	esi
		dec 	edi
		jmp 	.ciclo_palindromo
	.es_palindromo:
		mov 	edx, 	msj3
		call 	outputStr
		ret
	.no_palindromo:
		pop 	edx
		mov 	edx, 	msj4
		call 	outputStr
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

printHex:
;	Entrada:	EAX -> Valor a convertir.
;				ESI -> Necesita una cadena de minimo 10 byte's.
;	Salida:		Muestra valor en consola.
  pushad
  mov edx, eax
  mov ebx, 0fh
  mov cl, 28
.nxt: shr eax,cl
.msk: and eax,ebx
  cmp al, 9
  jbe .menor
  add al,7
.menor:add al,'0'
  mov byte [esi],al
  inc esi
  mov eax, edx
  cmp cl, 0
  je .print
  sub cl, 4
  cmp cl, 0
  ja .nxt
  je .msk
.print: mov eax, 4
  mov ebx, 1
  sub esi, 8
  mov ecx, esi
  mov edx, 8
  int 80h
  popad
  ret