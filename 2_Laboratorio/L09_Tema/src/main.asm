%include "pc_io.inc"
%include "my_routines.asm"

section .data
    msj0: db    "Practica 9 - Arreglos",10,0
    msj1: db    "Ingrese el taño del arreglo:",10,0
    msj2: db    "ngresarvalordecimalde3dígitos",10,0

section .bss
    cad     resb    4
    temp    resb    3
    array   resb    99

section .text
    global _start

_start:
    mov     ecx, 3
    xor     eax, eax
    call    capturarDecimal
    mov     esi, cad
    call    salto
    call    printHex
    



; retun 0
mov eax, 1
mov ebx, 0
int 80h


capturarDecimal:
    ; Entradas: ECX -> longitud del numero
    ; Salidas:  AX    
    ; push    bx
    ; push    cx
    ; push    dx
    pushad
    xor     ax, ax
    xor     bx, bx  ; Suma acumulativa para 
    .capDec:
        call    getche
        cmp     al, "0"
        jb      .noNumero
        cmp     al, "9"
        ja      .noNumero
        sub     al, "0"     ; Se combierte en numero.        
        cmp     ecx, 1      ; Contador de posición  es igual o mayor a 1.
        jae      .mul_base  ; Multiplca por base 10
        jmp     .sumar      ; Solo sumar el numero comvertido.
        .noNumero:
            inc     ecx   
            jmp     .finCapDec
        .mul_base:
            mov     dx, ax
            mov     ax, 10
            call    pow
            mul     dx
            add     bx, ax ; ebx esta el resutado final.
            jmp     .finCapDec 
        .sumar:
            add     bx, ax
        .finCapDec:
    loop    .capDec
    mov     ax,    bx
    pop     dx
    pop     cx
    pop     bx
    ret

pow:
	; Entradas: AX -> Base
	; 			CX -> Exponente
	; Salida: 	AX
    push    bx
    push    dx
	mov     dx, cx    
    push	cx
    mov     cx, dx

	mov		bx, ax 
	dec		cx
	.ciclo_pow:
		imul ax, bx
		loop .ciclo_pow
	
    pop 	cx
    pop     dx
    pop		bx
	ret