; Ensamblador NASM, formato ELF de 32 bits, para Linux.
; Practica 5: Captura, visualización y detección de palíndromos.
; Instrucciones permitidas: add, sub, mov, jmp, cmp, je, loop, getch, getche, puts, putchar, inc, dec.

;cd 2_Laboratorio/L05_Tema/
;
%include "./pc_io.inc"

section .data
    msj1:   db " Programa para imvertir cadenas", 10, 0
section .bss
    cadena  resb 254          
section .text
    global _start

_start:
    call clrscr
    call salto
    mov edx, msj1              
    call puts
    mov ebx, cadena
    mov edx, ebx
    call inputStr
    call print
    call salto
    mov edx, ebx
    call invert
    ; mov edx, ebx
    ; call print

    ; mov edx, cadena

    ; mov ebx, cadena
    ; mov edx, [ebx]
    ; call puts
    ; mov ebx, cadena
    ; mov edi, eax
    ; mov edx, [ebx]
    ; call invert
    ; mov edx, ebx
    ; call puts
    ; mov edx, ebx
    call salto

    ; call puts
retunr0:
    mov eax, 1
    mov ebx, 0
    int 80h

inputStr:
; Entrada:  edx = Direccion donde guardar.
; Salida:   edi = Longitud.
; Modifica: esi
    push edx
    push edi                        ; Guardamos la dirección original
    mov edi, 0                    ; edi = contador de caracteres
    .ciclo_inputStr:
        call getche                 ; Lee carácter con eco
        cmp al, 10                  ; ¿Es Enter?
        je .fin_intputStr
        mov byte[edx + edi], al         ; Almacena en buffer
        inc edi
        jmp .ciclo_inputStr
    .fin_intputStr:
        mov byte[edx + edi], 0      ; Terminador nulo
        pop edi
        pop edx                      ; Recuperamos dirección original
ret

print:
; Entrada:  edx = dirección de una cadena terminada en 0.
; Salida:   Terminal = Imprime la cadena en la terminal.
; Modifica: 
    push edx
    .ciclo_print:
        mov al, [edx]               ; Toma un carácter
        cmp al, 0                   ; Fin de cadena?
        je .fin_print
        call putchar                ; Lo imprime
        inc edx                     ; Siguiente carácter
        jmp .ciclo_print
    .fin_print:
    pop edx
ret


invert:
; Entrada:  edx = dirección de una cadena terminada en 0.
;           cx = logitud de la cadena
; Salida:   Terminal = Imprime la cadena en la terminal.
; Modifica: 
    push edx
    dec edi
    mov esi, 0
    .ciclo_Invert:
        cmp esi, edi
        je .fin_invert
        mov bl , [edx+esi]
        mov al, bl
        call putchar
        mov bh , [edx+edi]
        mov al, bh
        call putchar
        mov byte[edx+esi] , bh
        mov byte[edx+edi] , bl
        inc esi
        dec edi
        jmp .ciclo_Invert
    .fin_invert:
        pop edx
ret

salto:
	pushad
	mov     al,         13
	call    putchar
	mov     al,         10
	call    putchar
	popad
	ret