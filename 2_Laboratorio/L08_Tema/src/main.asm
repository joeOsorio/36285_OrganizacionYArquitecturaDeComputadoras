%include "./pc_io.inc"

%include "my_routines.asm"

section .data
    paso0: db "Laboratorio",10,0
    msjP1_0:   db "Capturar Cadena",10,0
    msjP1_1:   db  "Ingrese cadena: ", 0
    msjP1_2:    db "La cadena es: ", 0

section .bss
    cadena          resb    254
    direciones      resb    50  ; Direcciones de cada palabra
    longitud        resb    50  ; Numero de letras para cada palabra.
    simbolos        resb    100 ; Todavia no nos dice.
    temp            resb    8

section .text
    global _start


_start:
    call    clrscr
    call    salto
    mov     edx, paso0
    call    new_puts
    mov     edx,    msjP1_0
    call    new_puts
    mov     edx,    msjP1_1
    call    new_puts
    mov     ecx, 254
    mov     edx, cadena
    mov     ecx, 254
    call    inputStr
    mov     edx, msjP1_2
    call    new_puts
    mov     edx, cadena
    call    new_puts
    call    salto
    ; mov     eax, cadena
    ; mov     esi, temp
    ; call    printHex
    push    ebx
    mov     ebx,  cadena
    add     ebx, 5
    mov     edx, ebx 
    mov     edi, 5
    call    outputStr
    





    



mov eax, 1
mov ebx, 0
int 80h


buscar_