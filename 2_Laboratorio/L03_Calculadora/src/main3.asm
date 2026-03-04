; Ensamblador NASM, formato ELF de 32 bits, para Linux.
; El programa multiplica dos números de un dígito ingresados por el usuario y muestra el resultado.

; Notas: 
; - Direccion relativa en el repositorio.  >cd 2_Laboratorio/L03_Calculadora/
; - Para ensamblar: >nasm -f elf32 main12.asm -o main12.o
; - Para asociar: 	>ld -m elf_i386 main12.o -o main12
; - Para ejecutar: 	>./main12

%include"./pc_io.inc"

section .data						;Datos inicializados
	msj1:	db	"Programa para multiplicar 2 numeros", 10, 0
	len:	equ	$-msj1

section .bss						;Datos no inicializados
	num1    	resb	1			; 1 byte va desde 0 hasta 255.
	num2    	resb	1			
	cad 		resb 	8
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

	;-------------- Para multiplicar --------------
	; mov 	ebx, num2				; Guardar el numero en ebx para la multiplicacion.
	mov 	ecx, [edx]				; Guardar el numero en el contador para funcion ebx.
	mov 	ebx, num1				; El registro ebx lo utiliza la funcion multi.
	call 	multi					; como el resultado lo regresa en al ya no es necesario cargar en eax.
	mov esi, cad					; Es necesario para utilizar printHex
	call	printHex
	call 	salto
	;-------------- Para Dividir --------------
	

	; Fin

	mov     eax,        1			;Carga la instruccion de salida de programa.
	mov     ebx,        0			;Indica que termino correctamente, como un return 0 en c.
	int     80h						;Llamada a kener con las anteriores mensajes. Fin del programa main.



multi: 						; Ocupa el registro ecx: contador, ebx: numero a sumar y al : resultado.'
	mov		eax, 0			;Limpiar todo el registro eax porque ahi guardamos el resultado.
	.ciclo:
		add     al,[ebx]	; Multiplicar es sumar tantas veces el mismo numero.
		loop .ciclo			; Esta funcion revisa el registo ecx y en automatico decrementa. Solo decrementa cl pero como

	ret

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