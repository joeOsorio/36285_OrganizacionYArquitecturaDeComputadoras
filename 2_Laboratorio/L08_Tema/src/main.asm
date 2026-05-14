%include "./pc_io.inc"

%include "my_routines.asm"
section .data
    titulo:      db "Laboratorio",10,0
    msjP1_0:    db "Capturar Cadena binaria de 32 bits",10,0
    msjP1_0_1:  db "Ejemplo: 11111111111111111111111111111111b",10,0
    ; msjP1_0_1:  db "Ejemplo: 0110111100011000",10,0
    msjP1_1:    db "Ingrese cadena binaria: ", 0
    msjP1_2:    db "La cadena en hex es: ", 0
    StrBin:     dw      00000000000000000000000000001111b  ; 32 bits
    ; StrBin:     dw    00000000000000001111111111110001b  ; 32 bits
    ; StrBin:     dw      00000000001111010000100100000000  ; 32 bits
    ;                 1111111111110001  -> 65521 decimal
    ; StrBin:     dw 0110111100011000b  ; 16 bits
    ;  6    f    1    8
    ; 0110 1111 0001 1000 b

    cadena      resb 256    ; para entrada del usuario
    cad         resb 5      ; Se reservan 5 por el 0 al final.

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

    call    cadBinToDec
    mov     byte[esi + 5],  "0"
    mov     edx,            esi
    call    new_puts

    ; Salir
    mov     eax, 1
    mov     ebx, 0
    int     80h

cadBinToDec:
    ; Entrada: EDX = puntero a cadena binaria (solo '0' y '1')
    ; Salida:  ESI = cadena convertida a Hexadecimal.
    pushad
    mov     ecx,    8  ; Para recorrer de 1 niblel en 1.
    mov     eax,    0
    mov     edi,    0   ; Carri
    .recorrido:
        rol     edx,     4 ; Mover 4 bites.
        push    edx
        and     dl,     0fh
        cmp     edi,    1
        jne      .SinAcarreo
        add     dl,     1
        mov     edi,    0
        .SinAcarreo:
        cmp     dl,     9
        jbe     .convertirASCII
        mov     edi,    1 ; carri en  1
        sub     dl,     9 ; 
        .convertirASCII:
            add     dl,                 "0"
            mov     byte[esi+eax] ,     dl
            inc     eax ; Recorro el apuntador a la sifuiente posicion
            pop     edx
        loop .recorrido
    popad
    ret