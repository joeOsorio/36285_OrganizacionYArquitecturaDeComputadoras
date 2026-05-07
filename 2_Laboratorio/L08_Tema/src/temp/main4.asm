%include "./pc_io.inc"

%include "my_routines.asm"
section .data
    titulo:      db "Laboratorio",10,0
    msjP1_0:    db "Capturar Cadena binaria de 16 bits",10,0
    msjP1_0_1:  db "Ejemplo: 0110111100011000",10,0
    msjP1_1:    db "Ingrese cadena binaria: ", 0
    msjP1_2:    db "La cadena en hex es: ", 0
    StrBin:     dw    1111111111110001b  ; 16 bits
    ; StrBin:     dw 0110111100011000b  ; 16 bits
    ;  6    f    1    8
    ; 0110 1111 0001 1000 b

section .bss
    cadena      resb 256    ; para entrada del usuario
    cad         resb 5

section .text
    global _start

_start:
    call    clrscr
    call    salto
    mov     edx,            titulo
    call    new_puts
    mov     edx,            msjP1_0
    call    new_puts
    mov     edx,            msjP1_0_1
    call    new_puts

    ; Opcional: entrada del usuario
    ; mov     edx, msjP1_1
    ; call    new_puts
    ; mov     edx, cadena
    ; mov     ecx, 255
    ; call    inputStr

    mov     ebx,            StrBin
    mov     edx,            [ebx]
    mov     esi,            cad

    call    cadBinToHex
    mov     byte[esi + 5],  "0"
    mov     edx,            esi
    call    new_puts

    ; Salir
    mov     eax, 1
    mov     ebx, 0
    int     80h

cadBinToHex:
    ; Entrada: EDX = puntero a cadena binaria (solo '0' y '1')
    ; Salida:  ESI = cadena convertida a Hexadecimal.
    pushad
    mov     ecx,    4  ; Para recorrer de 1 byte en 1.
    mov     eax,    0
    .recorrido:
        rol     dx,     4 ; Mover 4 bites.
        push    dx
        and     dl,     0fh
        cmp     dl,     9
        jbe     .convertirASCII
        add     dl,     7
        .convertirASCII:
            add     dl,                 "0"
            mov     byte[esi+eax] ,     dl
            inc     eax ; Recorro el apuntador a la sifuiente posicion
            pop     dx
        loop .recorrido
    popad
    ret

; cadStrToBin:
;     ; Entrada: EDX = puntero a cadena de caracteres  (solo '0' y '1') y finaliza con 0
;     pushad
;     xor     ecx,ecx

;     .recorrer_cadena:
;         cmp     byte[edx + cl], 0
;         jmp     .fin_recorrido_cadStrToBin
        
;         cmp     byte[edx + cl], "0"
;         jmp     .esCero_cadStrToBin

;         cmp     byte[edx + cl], "1"
;         jmp     .esUno_cadStrToBin

;         jmp     .error_cadStrToBin

;         .esCero_cadStrToBin:

    
;         .esUno_cadStrToBin:

;         .error_cadStrToBin:
;     loop .recorrer_cadena
; ret