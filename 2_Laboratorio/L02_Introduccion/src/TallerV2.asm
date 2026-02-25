
; Nota: direccion relativa en el repositorio.  >cd 2_Laboratorio/L02_Introduccion

%include "./pc_io.inc"

section .data	;Datos inicializados					
	msj1:	db	"Programa para sumar 2 numeros",10,0

section	.bss	;Datos no inicializados
    num1    resb 1      ; 1 byte va desde 0 hasta 255.
    num2    resb 1

section .text
	global _start:

_start:
    call clrscr ; Limpiamos pantalla
    call salto 

    ;Mostrar mensaje 1
    mov edx, msj1 
    call puts

    ;Capturar
    call getche
    mov ebx, num1
    mov [ebx], al

    ;Mostrar mensaje 2
    mov al, '+'
    call putchar

    ;Capturar
    call getche
    mov ebx, num2
    mov [ebx], al

    ;Mostrar mensaje 2
    mov al, '='
    call putchar

    ;Logica de sumar   
    mov al, [ebx]
    mov ebx, num1
    add al, [ebx]
    sub al, 48

    call putchar
    call salto

mov eax, 1	;Carga la instruccion de salida de programa.
mov ebx, 0	;Indica que termino correctamente, como un return 0 en c.
int 80h		;Llamada a kener con las anteriores mensajes. Fin del programa main.

    salto:
        pushad
        mov al, 13
        call putchar
        mov al, 10
        call putchar
        popad
        ret