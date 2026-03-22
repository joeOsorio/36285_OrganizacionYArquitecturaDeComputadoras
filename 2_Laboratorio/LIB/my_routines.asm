; ============================================================
; my_routines.asm - Subrutinas personales OAC
; Joshua Osorio - 36285
; ============================================================

section .text

; ------------------------------------------------------------
; print_newline: imprime un salto de línea
; Uso: call print_newline
; ------------------------------------------------------------
global print_newline
print_newline:
    push eax
    push ebx
    push ecx
    push edx
    mov  eax, 4
    mov  ebx, 1
    mov  ecx, _newline
    mov  edx, 1
    int  80h
    pop  edx
    pop  ecx
    pop  ebx
    pop  eax
    ret


; ------------------------------------------------------------
; print_spaces: imprime EBX espacios
; Entrada: EBX = número de espacios
; ------------------------------------------------------------
global print_spaces
print_spaces:
    push eax
    push ecx
    push edx
    .loop:
        test ebx, ebx
        jz   .done
        mov  eax, 4
        mov  ecx, _space
        mov  edx, 1
        push ebx
        mov  ebx, 1
        int  0x80
        pop  ebx
        dec  ebx
        jmp  .loop
    .done:
    pop  edx
    pop  ecx
    pop  eax
    ret

; -- Agrega tus subrutinas aquí --

salto:
	; Utiliza:	al
	pushad
	mov     al,         13
	call    putchar
	mov     al,         10
	call    putchar
	popad
ret

string_len:
	; Entrada:	EBX -> Direccion de la cadena a evaluar. 
	;			EDI -> Longitud de cadena sin contemplar 0
	; Utiliza:	Al
	; Salida:   Ninguna
	mov		edi, 	0
	.ciclo_len:
		mov al, 	[ebx + edi]
		cmp al, 	0
		je 	.fin_ciclo_len
		inc	edi
		jmp .ciclo_len
	.fin_ciclo_len:
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

outputStr:
	; Entrada:	edx 		->	Dir de la variable.
	;			EDI 		->	Longitud cadena
	; utiliza:	ESI
	; Salida:	Terminal	->	Muestra en terminal la cadena. 	
	mov esi,	0
	.ciclo_mostrar:
		cmp 	esi, 	edi		; Compara con el salto de linea para terminar la captura.
		je 		.fin_mostrar
		mov		al,		[edx + esi]
		cmp		al, 				0
		; cmp		al, 				'+'   ; caracter especial para finalizar cadena
		je		.fin_mostrar
		call	putchar
		inc		esi
		jmp		.ciclo_mostrar
	.fin_mostrar:
ret

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
		je 		.fin_captura
		mov 	[edx + edi], 	al
		inc 	edi
		jmp 	.ciclo_captura
	.fin_captura:
		mov 	byte[edx + edi + 1], 0 ; Agrego 0 para poder utilizar puts
		; call	salto
		; call	outputStr
		call 	salto
	.fin_captura2: ; Para cadenas de logitud 0
ret

printHex:
;   La proporciona el maestro.
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

new_puts:
	; Entrada:	edx 		->	Dir de la cadena.
	; 			Cana termina con caracter nulo.
	; Salida:	Terminal	->	Muestra en terminal la cadena. 
	push	edx			; Guardar la direccion en pila
	.ciclo_new_puts:
		mov		al,		[edx]	; Cargamos el primer caracter en al
		cmp		al,		0		
		je		.fin_new_puts
		call	putchar
		inc		edx
		jmp		.ciclo_new_puts
	.fin_new_puts:
	pop	edx
ret

section .data
    _newline db 0x0A
    _space   db 0x20