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
	buffer:	times 10 db 0	; Espacio para almacenar hasta 10 dígitos
	len 	equ	10

section .bss						;Datos no inicializados
	num1    resb       1			; 1 byte va desde 0 hasta 255.
	num2    resb       1
	resu    resb       1

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
	call    getche					; Capturar -----------------
	mov     ebx,        num2
	sub     al,         48			; Realizar casteo a numero.
	mov     [ebx],      al
	mov     al,         '='			; Mostrar mensaje 2
	call    putchar
	mov     al,         0			; Logica para comvertir el utimo caracter a numero.
	mov ebx, num2
	mov ecx, [ebx]					; Guardar el numero en el contador.
	mov     ebx,        num1
	call multi
	movzx eax, byte [resu]			; Cargamos el numero a convertir (extendemos a 32 bits).
	lea edi, [buffer + len - 1]		; Apuntamos al final del buffer.
	mov ebx, 10						; Base decimal
	call convert_loop
	lea edx, [buffer]				; Cargamos la dirección del buffer.
	call    puts	
	call    salto
	mov     eax,        1			;Carga la instruccion de salida de programa.
	mov     ebx,        0			;Indica que termino correctamente, como un return 0 en c.
	int     80h						;Llamada a kener con las anteriores mensajes. Fin del programa main.

salto:
	pushad
	mov     al,         13
	call    putchar
	mov     al,         10
	call    putchar
	popad
	ret

multi: 						; Ocupa el registro ecx, ebx y al
	pusha
	.rep:					; Logica para multiplicar.
		cmp ecx, 0			; Compara el registro ecx con 0, Seria como el if
		je .finrep			; Realiza salto al fin.
		add     al,[ebx]	; Multiplicar es sumar tantas veces el mismo numero.
		loop .rep 			; Esta funcion revisa el registo ecx y en automatico decrementa. Solo decrementa cl pero como 
	.finrep:
	mov [resu], al			
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


	; otros

	;en eax el valor a convertir mostrar en hexadecimal
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


;Prueba


convert_loop:
	pushad
	.loop:
		xor edx, edx          ; Limpiar EDX para la división
		div ebx               ; EAX = cociente, EDX = residuo
		add dl, '0'           ; Convertir residuo a ASCII (sumar 30h)
		mov [edi], dl         ; Guardar caracter
		dec edi               ; Mover puntero del búfer hacia atrás
		test eax, eax         ; ¿El cociente es 0?
		jnz .loop             ; Si no, continuar el loop
	popad	
	ret