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
    xor     eax,    eax
    mov     cx,     2
    mov     ax,     10
    call    pow
    mov     esi,    cad
    call    printHex


    ; call   capturarDecimal
    ; mov    esi, cad
    ; call    salto
    ; call    printHex




; retun 0
mov eax, 1
mov ebx, 0
int 80h


capturarDecimal:
    ; Entradas: ECX -> longitud del numero
    ; Salidas:  AX    
    push    ebx
    push    ecx
    push    edx
    mov     ecx, 3
    xor     eax, eax
    xor     dx, dx  ;Limpiar registro.
    xor     ebx, ebx
    .capDec:
        call    getche
        cmp     al, "0"
        jb      .noNumero
        cmp     al, "9"
        ja      .noNumero
        sub     al, "0"     ; Se combierte en numero.        
        cmp     ecx, 1
        ja      .mul_base
        jmp     .sumar
        .noNumero:
            inc     ecx   
            jmp     .finCapDec
        .mul_base:
            push    eax
            mov     eax, 10
            call    pow
            mov     ebx, eax ; ebx esta el resutado final.
            pop     eax


        .sumar:
            add     ax, dx
            mov     bx, ax
        .finCapDec:
    loop    .capDec
    mov     eax,    ebx
    pop     edx
    pop     ecx
    pop     ebx
    ret


    pow:
	; Entradas: AX -> Base
	; 			CX -> Exponente
	; Salida: 	AX
	; push	cx
	; push 	bx
	mov		bx, ax 
	dec		cx
	.ciclo_pow:
		imul ax, bx
		loop .ciclo_pow
	; pop		bx
	; pop 	cx
	ret