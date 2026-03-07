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
	msj6:	db	"programa para saber si es o no Palindromo ", 10, 0
	len6:	equ	$-msj6
	msj7:	db	"Si es palindromo", 10, 0
	len7:	equ	$-msj7
	msj8:	db	"No es palindromo", 10, 0
	len8:	equ	$-msj8

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
	mov     edx,        msj1		; Mostrar mensaje 1
	call    puts
	call    getche					; Capturar numero 1
	mov     ebx,        num1
	sub     al,         48			; Realizar casteo a numero.
	mov     [ebx],      al			; Guardar numero en variable.
	mov     al,         'x'			; Mostrar mensaje 2
	call    putchar
	call    getche					; Capturar numero 2
	mov     edx,        num2
	sub     al,         48			; Realizar casteo a numero.
	mov     [edx],      al
	mov     al,         '='			; Mostrar mensaje 2
	call    putchar

	;-------------- 1 - Para multiplicar --------------
	mov		edx, 		num1
	mov 	cl, 		[edx]	
	mov		edx, 		num2
	mov 	bl, 		[edx]
	mov		eax, 		0		
	call 	multi					; Como el resultado lo regresa en al ya no es necesario cargar en eax solo limpiarlo. 
	mov 	esi, 		cad			; Es necesario para utilizar printHex
	call	printHex
	call 	salto
	;-------------- 2 - Para Dividir --------------
	mov		bl,			al			; Muevo el resultado para utiliarza la funcion dividir.
	mov     edx,        msj2		; Mostrar mensaje
	call    puts
	call	printHex				; Mostrar resultado anterior guardado en al
	mov     al,        '/' 
	call    putchar
	mov		al,			[num2]
	call    printHex
	mov     al,        	'='
	call    putchar
	mov		edx, 		num2
	mov 	eax,		0
	mov		cl,			[edx]
	mov		eax,		0
	call	divi
	call	printHex
	call 	salto
	; -------------- 3 - Para numeros 0 al 100 --------------
	mov     edx,        msj3		; Mostrar mensaje
	call    puts
	mov 	dh, 100
	mov		dl, 0
	call numeros
	call salto
	; -------------- 4 - Para numeros pares --------------
	mov     edx,        msj4		; Mostrar mensaje
	call    puts
	mov		dl, 0
	mov 	dh, 100
	call 	numPares
	call 	salto
	;-------------- utilizar num1 como badera --------------
	mov		edx,	num1
	mov		ecx, 1
	mov		[edx],	ecx
	prueba2:

	;-------------- 5 - Capturar texto --------------
	mov     edx,    msj5		; Mostrar mensaje 1
	call    puts
	mov		ebx, 	cadena
	call	capturarTxt
	;-------------- 6 - Palindromo --------------

	mov     edx,	msj6	; Mostrar mensaje
	call    puts
	call 	palindromo
	; mov		eax,	edx		; Cargar EAX para funcion printHex
	; mov 	esi, 	cad
	; call	printHex
	cmp	edx, 1
	je pal
	mov     edx,	msj8	; Mostrar mensaje
	call    puts
	jmp fin
	pal:
	mov     edx,	msj7	; Mostrar mensaje
	call    puts
	fin:


	;-------------- Probar otro palindromo --------------
	mov		edx,	num1
	mov 	eax, 	[edx]
	cmp		eax,	0
	je		fin2
	sub		eax,	1
	jmp		prueba2
	fin2:
	;-------------- Fin --------------
	mov     eax,        1	;Carga la instruccion de salida de programa.
	mov     ebx,        0	;Indica que termino correctamente, como un return 0 en c.
	int     80h				;Llamada a kener con las anteriores mensajes. Fin del programa main.

multi:
	; Entrada: 	cl	->	Veces que se repite la suma.
	; 			bl	->	numero a sumar
	; Salida:   al	->	Resultado
	mov		al, 0			;Limpiar todo el registro eax porque ahi guardamos el resultado.
	.ciclo:
		add     al,bl		; Multiplicar es sumar tantas veces el mismo numero.
		loop .ciclo			; Esta funcion revisa el registo ecx y en automatico decrementa. Solo decrementa ebx
	ret

divi:
	;	Entrada:  cl -> Divisor
	;             bl -> Dividendo
	;	Salida:   al-> Resultado
    mov al, 0				; cociente = 0
	.bucle:
		cmp bl, cl			; Dividendo es menor que divisor
		jb .fin_divi		; Si es menor, terminamos
		sub bl, cl			; Dividendo -= divisor
		inc al				; cociente++
		jmp .bucle
	.fin_divi:
    ret

numPares:
	;	Entrada:  DL -> Inicio
	;			  DH -> Fin
	;	Salida:   Muesta los valores en consola
	.bucle:
		cmp 	dh, dl			; Dividendo es menor que divisor	
		jb 		.fin_divi		; Si es menor, terminamos
		mov 	al, 		dl
		call	printHex
		call 	salto
		add 	dl, 2        ; Dividendo -= divisor
		jmp .bucle
	.fin_divi:
    ret

numeros:
	;	Entrada:  DL -> Inicio
	;			  DH -> Fin
	;	Salida:   Muesta los valores en consola
	.bucle:
		cmp 	dh, dl			; Dividendo es menor que divisor	
		jb 		.fin_divi		; Si es menor, terminamos
		mov 	al, 		dl
		call	printHex
		call 	salto
		add 	dl, 1        ; Dividendo -= divisor
		jmp .bucle
	.fin_divi:
    ret

capturarTxt:
	; Entrada:	EBX -> Dir de la variable.
	; Salida:	AL -> Caracter capturado.
	; 			EDI -> Acumuladro de cuento me desplace.
	mov edi, 0
	capturar:
		call getche
		cmp al, 10			; Compara con el salto de linea para terminar la captura.
		je 	fin_captura
		; je enter no agrer caracter.
		mov byte [ebx + edi], al
		inc edi
		jmp capturar
	fin_captura:
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