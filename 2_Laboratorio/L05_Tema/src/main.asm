%include "pc_io.inc"
%include "my_routines.asm"

section .data
    msj:    db "Practica 5", 10, 0
    paso1:  db  "Paso 1", 10, 0   
    msj0:   db "Ingrese cadena: ", 0
    msj1:   db  "Ingrese la letra a buscar: ", 0
    msj2:   db  "La letra se encotro en la posicion ", 0
    msj3:   db  "La letra se encontro ",0
    msj33:  db  " veces",10,0
    paso2:  db  "Paso 2", 10, 0 
    



section .bss
    cadena      resb    254
    temp        resb    8
    letra       resb    1

section .text
    global _start

_start:
    call    clrscr
    call    salto
    mov     edx,        msj
    call    puts
    mov     edx,        paso1
    call    puts
    mov     edx,        msj0
    call    puts
    mov     edx,        cadena
    mov     ecx,        254     ; Se indica la longitud de cadena.
    call    inputStr
    call    buscarLetra

    mov     edx,        paso2
    call    puts

    mov     eax,    1
    mov     ebx,    0
    int     80h 


buscarLetra:
;   Entrada:    edx: direccion de cadena, edi: longitud cadena
;   Utiliza:    
;   Salida:     
    mov     esi,    0
    mov     ecx,    edx    ; Guardar temporalmente dir
    mov     ebx,     0
    mov     edx,    msj1
    call    puts
    call    getche
    mov     bl,     al  ; Caracter a buscar en bl
    call    salto
    .ciclo_buscar:
        cmp     esi,    edi
        je      .fin_buscar
        push    ebx
        mov     bh,     [ecx + esi]
        cmp     bh,     bl      ;Letra capturaeda vs letra cadena
        pop     ebx
        je      .encontrada
        inc     esi
        jmp     .ciclo_buscar
    .encontrada:
        mov     edx,    msj2
        call    puts
        mov     eax,    esi     ; cargar numero
        push    esi
        mov     esi,    temp    ; Cargar cadena
        call    printHex
        pop     esi
        call    salto
        inc     bh
        inc     esi
        jmp     .ciclo_buscar
    .fin_buscar:
        push    esi
        mov     edx,    msj3
        call    puts
        mov     eax,    0
        mov     al,    bh
        mov     esi,    temp
        call    printHex
        pop     esi
        mov     edx,    msj33
        call    puts
        call    salto
ret
    