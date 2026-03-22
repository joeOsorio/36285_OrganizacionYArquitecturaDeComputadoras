%include "pc_io.inc"
%include "my_routines.asm"

section .data
    msj:    db  "Practica 5", 10, 0
    paso1:  db  "Parte 1 contar letras", 10, 0   
    msj0:   db  "Ingrese cadena: ", 0
    msj1:   db  "Ingrese la letra a buscar: ", 0
    msj2:   db  "La letra se encotro en la posicion ", 0
    msj3:   db  "La letra se encontro ",0
    msj33:  db  " veces",10,0
    msj4:   db  "Cadena original: ",0
    msj5:   db  "Cadena invertidaL: ",0
    paso2:  db  "Paso 2 - invertir cadena", 10, 0 
    paso3:  db  "Paso 3 - Uper casting", 10,0
    P3msj0: db  "Cadena original: ", 0
    P3msj1: db  "Cadena en mayusculas: ",0
    paso4:  db  "Contrar vocales",0
    p4msj:  db  "Cadena a revisar: ",   0


section .bss
    cadena      resb    254
    cadena2      resb    254
    temp        resb    8
    letra       resb    1

section .text
    global _start

_start:
    call    clrscr
    call    salto
    mov     edx,        msj
    call    new_puts
    mov     edx,        paso1
    call    new_puts
    mov     edx,        msj0
    call    new_puts
    mov     edx,        cadena
    mov     ecx,        254     ; Se indica la longitud de cadena.
    call    inputStr
    call    buscarLetra
    mov     edx,        paso2   ; Mostrar mensaje.
    call    new_puts
    mov     edx,        cadena
    mov     edi,        cadena2
    call    invertir
    mov     edx,    msj4
    call    new_puts
    mov     edx,    cadena
    call    new_puts
    call    salto
    mov     edx,    msj5
    call    new_puts
    mov     edx,    cadena2
    call    new_puts
    call    salto
    mov     edx,    paso3
    call    new_puts
    mov     edx,    P3msj0
    call    new_puts
    mov     edx,    cadena
    call    new_puts
    mov     edx,    cadena
    call    salto
    call    upperCase
    mov     edx,    P3msj1
    call    new_puts
    mov     edx,    cadena
    call    new_puts
    call    salto
                
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
ret

invertir:
;   Entrada:    edx = dir origen
;               edi = dir destino
;   Utiliza:
;   Salida:
;   Nota: La cadena oringen debe finalizar con caracter nulo
    push    edx         ; resguardar direccion origen
    push    edi         ; Resguardar direccion destino
    mov     ecx, 0      ; Limpiar registro.
    mov     esi, 0      ; Limpiar registro.
    .ciclo_push:
        mov     cl, [edx]
        cmp     cl, 0
        je      .ciclo_pop
        inc     edx
        inc     esi
        push    ecx
        jmp     .ciclo_push
    .ciclo_pop:
        cmp     esi, 0
        je      .fin_invert
        pop     ecx
        mov     byte[edi], cl
        inc     edi
        dec     esi
        jmp     .ciclo_pop
    .fin_invert:
        inc edi
        mov byte[edi], 0
    pop edx
    pop edi
ret


upperCase:
    ; Entrada:  edx = dir cadena
    ; Salidan:  Cadena en mayusculas.
    push edx
    push eax
    .ciclo_upperCase:
        mov     al, [edx]
        cmp     al, 0
        je      .fin_upperCase
        ; call    upperLater
        sub     al, 32
        mov     byte[edx],  al ; guardar letra casteada
        inc     edx     ; moverme a la siguiente posicion
        jmp     .ciclo_upperCase  
    .fin_upperCase:
    pop edx
    pop eax
ret

upperLater:
    ; Entrada:  al = Caracter convertir mayuscula.
    ; Salida    al = Letra mayuscula
    
    sub al, 32
    ; otra solucion si dejara el rocha

    ; cmp al, 97
ret


PASO_4:
    ; Entrada: edx = Dir de la cadena a evaluar.

    .ciclo_
