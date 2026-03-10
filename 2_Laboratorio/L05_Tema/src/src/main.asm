; Ensamblador NASM, formato ELF de 32 bits, para Linux.
; Practica 5: Captura, visualización y detección de palíndromos.
; Instrucciones permitidas: add, sub, mov, jmp, cmp, je, loop, getch, getche, puts, putchar, inc, dec.

;cd 2_Laboratorio/L05_Tema/
;
%include "./pc_io.inc"

section .data
    msj1:   db " Programa para imprimir asteriscos", 10, 0
    msj2:   db " Ingresa la cantidad a repetir", 10, 0
section .bss
    num     resb 1
    cadena  resb 254          

section .text
    global _start

_start:
    call clrscr
    call salto
    mov edx, msj1              
    call puts
    call salto
    mov edx, msj2
    call puts
    call getche
    sub al, 48
    mov ebx, num
    mov [ebx], al
    call salto
    call imprime
    call salto
retunr0:
    mov eax, 1
    mov ebx, 0
    int 80h

imprime:
; Entrada:  ecx = Contador de cuanto se repite.
; Modifica: al, esi, edi
; Salida:   Terminal
    mov al, '*'
    mov edi, ecx
    .ciclo_imprime:
        cmp ecx, 0
        je  .fin_imprime
        mov esi, ecx
        .ciclo_renglon:
        cmp esi, 0
        je .fin_renglon
        call putchar
        inc esi
        jmp .ciclo_renglon
        .fin_renglon:
        call salto
        dec ecx
        jmp .ciclo_imprime
    .fin_imprime:
ret


salto:
	pushad
	mov     al,         13
	call    putchar
	mov     al,         10
	call    putchar
	popad
	ret