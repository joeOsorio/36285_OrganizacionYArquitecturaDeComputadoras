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
    mov edx, [ebx]
    call inputStr
    mov ebx, cadena
    mov edx, ebx
    call outputStr
    call salto

    ; call puts
retunr0:
    mov eax, 1
    mov ebx, 0
    int 80h

inputStr:
; Entrada:  edx = Direccion donde guardar.
; Salida:   eax = Longitud.
; Modifica: esi
    push edx                        ; Guardamos la dirección original
    mov esi, 0                    ; esi = contador de caracteres
    .ciclo_inputStr:
        call getche                 ; Lee carácter con eco
        cmp al, 10                  ; ¿Es Enter?
        je .fin_intputStr
        mov[ebx + esi], al         ; Almacena en buffer
        inc esi
        jmp .ciclo_inputStr
    .fin_intputStr:
        mov byte[ebx + esi], 0      ; Terminador nulo
        mov eax, esi                 ; Longitud en eax
        pop edx                      ; Recuperamos dirección original
ret

outputStr:
; Entrada:  edx = dirección de una cadena terminada en 0.
; Salida:   Terminal = Imprime la cadena en la terminal.
; Modifica: 
    push edx
    .ciclo_muestra:
        mov al, [edx]               ; Toma un carácter
        cmp al, 0                   ; Fin de cadena?
        je .fin_muestra
        call putchar                ; Lo imprime
        inc edx                     ; Siguiente carácter
        jmp .ciclo_muestra
    .fin_muestra:
    pop edx
ret


outputStrInvert:
; Entrada:  edx = dirección de una cadena terminada en 0.
; Salida:   Terminal = Imprime la cadena en la terminal.
; Modifica: 
    push edx
    .ciclo_OSI:
        mov al, [edx]               ; Toma un carácter
        cmp al, 0                   ; Fin de cadena?
        je .fin_muestra
        call putchar                ; Lo imprime
        inc edx                     ; Siguiente carácter
        jmp .ciclo_muestra
    .fin_ciclo_:
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