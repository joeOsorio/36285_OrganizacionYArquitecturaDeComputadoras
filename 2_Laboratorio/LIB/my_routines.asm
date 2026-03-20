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
    int  0x80
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


section .data
    _newline db 0x0A
    _space   db 0x20