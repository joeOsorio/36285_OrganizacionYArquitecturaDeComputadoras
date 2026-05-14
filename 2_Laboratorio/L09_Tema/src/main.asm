%include "pc_io.inc"
%include "my_routines.asm"

section .data
    msj0: db    "Practica 9 - Arreglos",10,0
    msj1: db    "Ingrese el taño del arreglo:",10,0
    msj2: db    "",10,0

section .bss
    cad     resb    4
    temp    resb    3
    array   resb    99

section .text
    global _start

_start:
    call   capturarDecimal
    mov    esi, cad
    call    salto
    call    printHex




; retun 0
mov eax, 1
mov ebx, 0
int 80h


capturarDecimal:
    ; Entradas: AX
    ; Salidas: AX    
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
        cmp     ecx, 3
        je      .mul_100
        cmp     ecx, 2
        je      .mul_10
        ; add     dx, al
        jmp     .sumar
        .noNumero:
            inc     ecx   
            jmp     .finCapDec
        .mul_100:
            mov     dx, 100
            mul     dx
            jmp    .sumar
        .mul_10:
            mov     dx, 10
            mul     dx
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