%include "./pc_io.inc"

section .data
    msj1:   db " Programa para invertir cadenas", 10, 0
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
    call inputStr               ; edi = longitud de la cadena

    call salto
    mov ebx, cadena
    call print                  ; Imprime cadena original con propia sub rutina.

    call salto
    mov ebx, cadena             ; edi = longitud
    call invert                 ; Solo invierte, no imprime

    call salto
    mov edx, cadena
    call puts                  ; Imprime cadena ya invertida

retunr0:
    mov eax, 1
    mov ebx, 0
    int 80h

inputStr:
; Entrada:  ebx = Direccion donde guardar.
; Salida:   edi = Longitud de la cadena capturada.
    push ebx
    mov edi, 0                      ; edi = contador de caracteres
    .ciclo_inputStr:
        call getche                 ; Lee caracter con eco
        cmp al, 10                  ; Es Enter?
        je .fin_inputStr
        mov [ebx + edi], al         ; Almacenar
        inc edi
        jmp .ciclo_inputStr
    .fin_inputStr:
        mov byte[ebx + edi], 0      ; Terminador nulo
        pop ebx                     ; Recupera dirección original
ret

print:
; Entrada:  ebx = dirección de cadena terminada en 0.
    push ebx
    .ciclo_print:
        mov al, [ebx]
        cmp al, 0
        je .fin_print
        call putchar
        inc ebx
        jmp .ciclo_print
    .fin_print:
    pop ebx
ret

invert:
    push ebx
    push ecx
    push esi
    push edi

    ; Calcular longitud/2 en ecx usando solo add
    mov ecx, 0
    mov eax, 0
    .calcular_mitad:
        add eax, 2              ; avanzamos de 2 en 2
        inc ecx                 ; contamos cuántas veces
        cmp eax, edi            ; ¿llegamos o superamos la longitud?
        je .iniciar             ; longitud par: mitad exacta
        ; si eax > edi significa longitud impar, pero sin jg...
        ; usamos el truco: restamos y comparamos con 0
        mov edx, eax
        sub edx, edi
        cmp edx, 0
        je .iniciar             ; eax == edi  (par)
        sub edx, 1
        cmp edx, 0
        je .iniciar             ; eax == edi+1 (impar, nos pasamos por 1)
        jmp .calcular_mitad

    .iniciar:
        mov esi, 0
        dec edi                 ; edi = índice del último carácter

    .ciclo_invert:
        mov dl, [ebx + esi]
        mov dh, [ebx + edi]
        mov [ebx + esi], dh
        mov [ebx + edi], dl

        inc esi
        dec edi
        loop .ciclo_invert      ; decrementa ecx, salta si ecx != 0

    .fin_invert:
        pop edi
        pop ecx
        pop esi
        pop ebx
ret

salto:
    pushad
    mov al, 10
    call putchar
    popad
ret