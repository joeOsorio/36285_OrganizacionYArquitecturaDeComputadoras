; Ensamblador NASM, formato ELF de 32 bits, para Linux.

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
	mov     edx,    msj5		; Mostrar mensaje 1
	call    puts
	mov		ebx, 	cadena
	call	inputStr
	;-------------- 2 - Palindromo --------------
	mov     edx,	msj6	; Mostrar mensaje
	call    puts
	call 	palindromo
	cmp	edx, 1
	je pal
	mov     edx,	msj8	; Mostrar mensaje
	call    puts
	jmp fin
	pal:
	mov     edx,	msj7	; Mostrar mensaje
	call    puts
	fin:
	;-------------- Fin --------------
	mov     eax,        1	;Carga la instruccion de salida de programa.
	mov     ebx,        0	;Indica que termino correctamente, como un return 0 en c.
	int     80h				;Llamada a kener con las anteriores mensajes. Fin del programa main.

inputStr:
	; Entrada:	EDX	-> Dir de la variable.
	; Salida:	AL	-> Caracter capturado.
	; 			EDI -> Acumuladro de cuento me desplace.
	mov edi, 0
	capturar:
		call getche
		cmp al, 10			; Compara con el salto de linea para terminar la captura.
		je 	fin_captura
		mov byte [ebx + edi], al
		inc edi
		jmp capturar
	fin_captura:
	ret

outputStr:
	; Entrada:	EBX -> 	Dir de la variable.
	;			EDI ->	Longitud cadena
	; Salida:	Terminal	-> Muestra en terminal la cadena. 	
	mov esi,	0
	mstCad:
		cmp esi, edi			; Compara con el salto de linea para terminar la captura.
		je 	fin_captura
		cmp	[ebx], '0'
		je 	fin_captura

		
		mov byte [ebx + esi], al
		inc edi
		jmp capturar
	fin_mstCad:
	ret

palindromo:
	; Entrada:	EBX -> Direccion de la cadena a evaluar. 
	;			EDI -> Longitud de cadena
	; Utiliza:	ESI
	; Salida:	DL bandera que indica 0: No palindromo, 1: Si palindromo
	mov 	edx,	0	; Bandera
	dec  	edi			; Quiene
	mov		esi, 	0
	ciclo:
		mov ah,		[ebx + edi]
		mov al, 	[ebx + esi]
		cmp ah,		al
		jne fin_ciclo
		dec edi
		inc esi
		cmp edi, 	esi
		je sies
		jmp ciclo
	sies:
		mov edx, 1
	fin_ciclo:
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