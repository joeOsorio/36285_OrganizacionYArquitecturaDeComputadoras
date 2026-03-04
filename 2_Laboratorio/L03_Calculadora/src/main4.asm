; Ensamblador NASM, formato ELF de 32 bits, para Linux.
; El programa multiplica dos números de un dígito ingresados por el usuario y muestra el resultado.

; Notas: 
; - Direccion relativa en el repositorio.  >cd 2_Laboratorio/L03_Calculadora/
; - Para ensamblar: > nasm -f elf32 -Isrc/LIB src/main3.asm -o output/main.o
; - Para asociar: 	>  ld -m elf_i386 -s -o bin/main output/main.o src/LIB/libpc_io.a
; - Para ejecutar: 	> ./main12

%include"./pc_io.inc"

section .data						;Datos inicializados
	msj1:	db	"Programa para multiplicar 2 numeros", 10, 0
	len1:	equ	$-msj1
	msj2:	db	"Programa para dividir 2 numeros", 10, 0
	len:	equ	$-msj2
	msj3:	db	"Programa para imprimir del 0 al 100", 10, 0
	len3:	equ	$-msj3
	msj4:	db	"Programa para imprimir numeros pares del 0 al 100", 10, 0
	len4:	equ	$-msj4
	msj5:	db	"Programa para capturar texto", 10, 0
	len5:	equ	$-msj5
	msj6:	db	"Palindromo ", 10, 0
	len6:	equ	$-msj6
	msj7:	db	"Si es palindromo", 10, 0
	len7:	equ	$-msj7

section .bss						;Datos no inicializados
	num1    	resb	1			; 1 byte va desde 0 hasta 255.
	num2    	resb	1			
	cad 		resb 	8
	cadena 		resb 	256
section .text
	global  _start:

_start:
	call    clrscr					; Limpiamos pantalla
	call    salto	
	; mov     edx,        msj1		; Mostrar mensaje 1
	; call    puts
	; call    getche					; Capturar numero 1
	; mov     ebx,        num1
	; sub     al,         48			; Realizar casteo a numero.
	; mov     [ebx],      al			; Guardar numero en variable.
	; mov     al,         'x'			; Mostrar mensaje 2
	; call    putchar
	; call    getche					; Capturar numero 2
	; mov     edx,        num2
	; sub     al,         48			; Realizar casteo a numero.
	; mov     [edx],      al
	; mov     al,         '='			; Mostrar mensaje 2
	; call    putchar

	; ;-------------- 1 - Para multiplicar --------------
	; ; mov 	ebx, num2				; Guardar el numero en ebx para la multiplicacion.
	; mov 	ecx, 		[edx]		; Guardar el numero en el contador para funcion ebx.
	; mov 	ebx, 		num1		; El registro ebx lo utiliza la funcion multi.
	; call 	multi					; como el resultado lo regresa en al ya no es necesario cargar en eax.
	; mov 	esi, 		cad			; Es necesario para utilizar printHex
	; call	printHex
	; call 	salto
	; ;-------------- 2 - Para Dividir --------------
	; mov     edx,        msj2		; Mostrar mensaje 1
	; call    puts
	; mov 	dh, al
	; mov		ebx, num1
	; mov		dl, [ebx]
	; call	divi
	; mov 	esi, 		cad			; Es necesario para utilizar printHex
	; call	printHex
	; call 	salto
	; ;-------------- 3 - Para numeros 0 al 100 --------------
	; mov     edx,        msj3		; Mostrar mensaje 1
	; call    puts
	; mov 	dh, 100
	; mov		dl, 0
	; call numeros
	; call salto
	; ;-------------- 4 - Para numeros pares --------------
	; mov     edx,        msj4		; Mostrar mensaje 1
	; call    puts
	; mov 	dh, 100
	; mov		dl, 0
	; call pares
	; call salto
	;-------------- 5 - Capturar texto --------------
	mov     edx,        msj5		; Mostrar mensaje 1
	call    puts
	mov		ebx, cadena
	call capturarTxt
	;-------------- 6 - Palindromo --------------
	mov     edx,        msj6		; Mostrar mensaje 1
	call    puts
	mov 	ebx,	cadena
	call 	palindromo
	mov al, dl
	mov ebx, 0
	mov esi, cad
	call printHex
	;-------------- Fin --------------
	mov     eax,        1			;Carga la instruccion de salida de programa.
	mov     ebx,        0			;Indica que termino correctamente, como un return 0 en c.
	int     80h						;Llamada a kener con las anteriores mensajes. Fin del programa main.


multi:
	;    Entrada:  ECX Veces que se repite la suma.
	;              EBX numero a sumar
	;    Salida:   AL Resultado
	mov		eax, 0			;Limpiar todo el registro eax porque ahi guardamos el resultado.
	.ciclo:
		add     al,[ebx]	; Multiplicar es sumar tantas veces el mismo numero.
		loop .ciclo			; Esta funcion revisa el registo ecx y en automatico decrementa. Solo decrementa cl
	ret

divi:
	;	Entrada:  DH -> Divisor
	;             DL -> Dividendo
	;	Salida:   AL -> Resultado
    mov eax, 0        ; cociente = 0
	.bucle:
		cmp dh, dl        ; Dividendo es menor que divisor
		jb .fin_divi      ; Si es menor, terminamos
		sub dh, dl        ; Dividendo -= divisor
		inc al            ; cociente++
		jmp .bucle

	.fin_divi:
    ret

pares:
	;	Entrada:  DH -> Fin
	;			  DL -> Inicio
	;	Salida:   Ninguna
	.bucle:
		cmp 	dh, dl			; Dividendo es menor que divisor	
		jb 		.fin_divi		; Si es menor, terminamos
		mov 	al, 		dl
		call 	salto
		call	printHex
		add 	dl, 2        ; Dividendo -= divisor
		jmp .bucle
	.fin_divi:
    ret

numeros:
	;	Entrada:  DH -> Fin
	;			  DL -> Inicio
	;	Salida:   Ninguna
	.bucle:
		cmp 	dh, dl			; Dividendo es menor que divisor	
		jb 		.fin_divi		; Si es menor, terminamos
		mov 	al, 		dl
		call 	salto
		call	printHex
		add 	dl, 1        ; Dividendo -= divisor
		jmp .bucle
	.fin_divi:
    ret

capturarTxt:
	;	Entrada:  EDX -> Dir de la variable.
	;	Salida:   AL -> Caracter capturado.
	capturar:
		call getche
		cmp al, 10			; Compara con el salto de linea para terminar la captura.
		je 	fin_captura
		mov byte [ebx], al
		inc ebx
		jmp capturar
	fin_captura:
	ret

palindromo:
	; Entrada: ebx cadena a evaluar. 
	; Salida: dl bandera que indica 0: No palindromo, 1: Si palindromo
	mov edx, 0
	dec  esi
	.ciclo:
		mov ah, [ebx + esi]
		cmp al, [ebx + edi]
		je fin_ciclo
		dec edi
		inc esi
		cmp edi, esi
		mov dl, 1
		je fin_ciclo
	fin_ciclo:
	; cmp dl, 0
	; je siEs

	; siEs:
	; 	mov     edx,        msj6		; Mostrar mensaje 6
	; 	call    puts
	
	; mov     edx,        msj7		; Mostrar mensaje 1
	; call    puts


ret

; divi: 						; Ocupa el registro ecx: contador, ebx: numero a sumar y al : resultado.
; 	mov eax,	0
; 	.bucle:
; 		cmp	dh, 0
; 		je	fin_divi
; 		; xor al, al				; Limpiar el resultado.
; 		; .rep:					; Logica para multiplicar.
; 		sub     dh, dl	; Multiplicar es sumar tantas veces el mismo numero.
; 			; loop .rep 			; Esta funcion revisa el registo ecx y en automatico decrementa. Solo decrementa cl pero como
; 		inc al
; 		jmp .bucle
; 	.fin_divi:
; 	ret




; no modificado
; divi: 						; Ocupa el registro ecx: contador, ebx: numero a sumar y al : resultado.
; 	cmp	dl, 0
; 	je	fin_divi
; 	; xor al, al				; Limpiar el resultado.
; 	; .rep:					; Logica para multiplicar.
; 	sub     dl, cl	; Multiplicar es sumar tantas veces el mismo numero.
; 		; loop .rep 			; Esta funcion revisa el registo ecx y en automatico decrementa. Solo decrementa cl pero como
; 	inc al
; 	jmp divi
; fin_divi:

; divi: 						; Ocupa el registro ecx: contador, ebx: numero a dividir y al : resultado.
; 	xor al, al				; Limpiar el resultado.
; 	.rep:					; Logica para multiplicar.
; 		cmp ecx, 0			; Compara el registro ecx con 0, Seria como el if
; 		je .finrep			; Realiza salto al fin.
; 		sub     al,[ebx]	; Multiplicar es sumar tantas veces el mismo numero.
; 		loop .rep 			; Esta funcion revisa el registo ecx y en automatico decrementa. Solo decrementa cl pero como 
; 	.finrep:
; 	; mov [resu], al			
; 	ret

salto:
	pushad
	mov     al,         13
	call    putchar
	mov     al,         10
	call    putchar
	popad
	ret
;en el registro eax el valor a convertir mostrado en hexadecimal
;en el registro esi poner la direccion de una cadena de al menos 10 bytes
printHex:
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