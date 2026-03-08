; Ensamblador NASM, formato ELF de 32 bits, para Linux.
; Practica 5: Captura, visualización y detección de palíndromos.
; Instrucciones permitidas: add, sub, mov, jmp, cmp, je, loop, getch, getche, puts, putchar, inc, dec.

%include "./pc_io.inc"

section .data
    msj1:   db "Programa para capturar texto", 10, 0
    msj2:   db "Programa para saber si es o no Palindromo", 10, 0
    msj3:   db "Si es palindromo", 10, 0
    msj4:   db "No es palindromo", 10, 0

section .bss
    cadena  resb 254          

section .text
    global _start

_start:
    call clrscr
    call salto

    ; ----- Punto 1: Capturar cadena -----
    mov edx, msj1              ; Mensaje de solicitud
    call puts                  ; Mostrar mensaje (usamos puts de la librería)
    mov edx, cadena             ; Dirección del buffer
    call inputStr               ; Capturar y luego mostrar (puntos 1 y 2)

    ; ----- Punto 3: Verificar palíndromo -----
    mov edx, msj2              ; Mensaje de "Programa para saber..."
    call puts
    mov edx, cadena             ; La cadena capturada
    call palindromo             ; Evalúa e imprime resultado

fin:
    mov eax, 1
    mov ebx, 0
    int 80h

; ----------------------------------------------------------------------
; Subrutina inputStr
; Entrada:  edx = dirección del buffer donde almacenar la cadena.
; Salida:   eax = longitud de la cadena (sin contar el terminador).
;           La cadena queda terminada en 0.
; Modifica: eax, ebx, ecx, edx (pero edx se restaura al final)
; ----------------------------------------------------------------------
inputStr:
    push edx                   ; Guardamos la dirección original
    mov ebx, edx                ; ebx apunta al buffer
    xor ecx, ecx                ; ecx = contador de caracteres
.ciclo_cap:
    call getche                 ; Lee carácter con eco
    cmp al, 10                  ; ¿Es Enter?
    je .fin_cap
    mov [ebx + ecx], al         ; Almacena en buffer
    inc ecx
    jmp .ciclo_cap
.fin_cap:
    mov byte [ebx + ecx], 0     ; Terminador nulo
    mov eax, ecx                 ; Longitud en eax
    pop edx                      ; Recuperamos dirección original
    ; Mostramos la cadena usando nuestra propia rutina (punto 2)
    call outputStr
    ret

; ----------------------------------------------------------------------
; Subrutina outputStr
; Entrada:  edx = dirección de una cadena terminada en 0.
; Salida:   Ninguna. Imprime la cadena en la terminal.
; Modifica: eax, edx
; ----------------------------------------------------------------------
outputStr:
    push edx
.ciclo_muestra:
    mov al, [edx]               ; Toma un carácter
    cmp al, 0                   ; ¿Fin de cadena?
    je .fin_muestra
    call putchar                ; Lo imprime
    inc edx                     ; Siguiente carácter
    jmp .ciclo_muestra
.fin_muestra:
    pop edx
    ret

; ----------------------------------------------------------------------
; Subrutina palindromo
; Entrada:  edx = dirección de la cadena a evaluar (terminada en 0).
; Salida:   Imprime "Si es palindromo" o "No es palindromo".
; Modifica: eax, ebx, ecx, edx, esi, edi
; ----------------------------------------------------------------------
palindromo:
    push edx                     ; Guardamos dirección original
    ; 1. Calcular longitud
    mov esi, edx                 ; esi apunta al inicio
    xor ecx, ecx                 ; ecx = longitud
.calc_len:
    mov al, [esi + ecx]
    cmp al, 0
    je .len_done
    inc ecx
    jmp .calc_len
.len_done:                       ; ecx = número de caracteres (sin el 0)
    ; Si la cadena está vacía, es palíndromo
    cmp ecx, 0
    je .es_palindromo

    ; 2. Comparar desde los extremos
    mov esi, 0                   ; índice izquierdo
    lea edi, [ecx - 1]           ; índice derecho
.ciclo_pal:
    cmp esi, edi
    jge .es_palindromo           ; Si se cruzaron o son iguales, es palíndromo
    mov al, [edx + esi]
    mov bl, [edx + edi]
    cmp al, bl
    jne .no_palindromo
    inc esi
    dec edi
    jmp .ciclo_pal

.es_palindromo:
    pop edx                       ; Recuperamos dirección original (no necesaria)
    mov edx, msj3
    call outputStr
    ret

.no_palindromo:
    pop edx
    mov edx, msj4
    call outputStr
    ret

; ----------------------------------------------------------------------
; Subrutina salto (avance de línea)
; Utiliza: al
; ----------------------------------------------------------------------
salto:
    pushad
    mov al, 13
    call putchar
    mov al, 10
    call putchar
    popad
    ret