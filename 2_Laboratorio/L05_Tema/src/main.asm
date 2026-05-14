%include "pc_io.inc"
%include "my_routines.asm"

section .data
    msj:    db  "Practica 5", 10, 0
    paso1:  db  "Parte 1 - contar letras", 10, 0   
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
    paso4:  db  "Paso 4 - Contrar vocales",10, 0
    p4msj:  db  "Cadena a revisar: ",   0
    p4msj0: db  "No se encontraron vocales.",0
    p4msj1: db  " Se encontraron ",0
    p4msj2: db  " veces.",0
    Caracter_voacales: db "AEIOU",0



section .bss
    cadena      resb    254
    cadena2     resb    254
    temp        resb    8
    letra       resb    1
    ; Vocales
    vocales     resb    4
    vocal_A     resb    4
    vocal_E     resb    4
    vocal_I     resb    4
    vocal_O     resb    4
    vocal_U     resb    4


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
    mov     edx,    paso4
    call    new_puts
    mov     edx,    p4msj
    call    new_puts
    mov     edx,    cadena
    call    new_puts
    call    salto
    mov     edx,    cadena
    call    contar_vocales
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
        cmp     al, 32 ; comparar con espacio
        je      .espacio
        ; call    upperLater
        sub     al, 32
        .espacio:
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
    ; Saber si 97 < AL > 123
    ; Solo en ese caso si se  resta.
    ; Pero aun no hemos mirado otros saltos. 
    ; codigo ascci 97 = a ,  z = 122
    sub al, 32
    ; otra solucion si dejara el rocha
    ; cmp al, 97
ret

contar_vocales:
    ; Entrada: edx = Dir de la cadena a evaluar.
    ;   Tener una 5 variables de 1 byte para contar
    push    edx
    push    ecx
    push    eax
    push    edi

    mov     edi, 0
    mov     ecx, 0
    .ciclo_recorrer:
        mov     al, [edx + edi]
        cmp     al, 0
        je      .fin_recorrer
        call    vocal
        inc     edi
        jmp     .ciclo_recorrer
    .fin_recorrer:
        cmp     ch, 0
        je      .no_Vocales
    .si_vocales:
        mov     edi,    0
        call    putchar
        .ciclo_datos:
            mov     edx,    Caracter_voacales
            mov     al, [edx + edi]
            cmp     al, 0
            je      .fin_contar
            call    putchar 
            mov     edx, p4msj1
            call    puts
            call    mostrar_cantidad_letra
            inc     edi
            call    salto
            jmp     .ciclo_datos
    .no_Vocales:
        mov     edx, p4msj0
        call    puts
    .fin_contar:
    pop edi
    pop eax
    pop ecx
    pop edx
ret

vocal:
;   Entrada:    al = caracter en codigo ASCCI.
;   Salida:     cl = 0/1 para saber si es vocal.
    push    edx
    mov     cl,     0
    ; Compar vocales minisculas.
    cmp     al,     'a'
    je      .es_a
    cmp     al,     'e'
    je      .es_e
    cmp     al,     'i'
    je      .es_i
    cmp     al,     'o'
    je      .es_o
    cmp     al,     'u'
    je      .es_u
    ; Comparar vocales mayúsculas.
    cmp     al,     'A'
    je      .es_a
    cmp     al,     'E'
    je      .es_e
    cmp     al,     'I'
    je      .es_i
    cmp     al,     'O'
    je      .es_o
    cmp     al,     'U'
    je      .es_u
    ; Si no hacer nada.
    jmp     .fin_vocal

    .es_a:
        mov     edx,    vocal_A
        add     byte[edx],  1
        jmp     .es_vocal
    .es_e:
        inc     byte[vocal_E]
        jmp     .es_vocal
    .es_i:
        inc     byte[vocal_I]
        jmp     .es_vocal
    .es_o:
        inc     byte[vocal_O]
        jmp     .es_vocal
    .es_u:
        inc     byte[vocal_U]
        jmp     .es_vocal
    .es_vocal:
        mov     ch, 1      ; Para mentener el valor de si es vocal.
    .fin_vocal:
pop     edx
ret



mostrar_cantidad_letra:
    push    esi
    push    eax
    push    edx

    mov     esi,    temp ; Se realiza para poder utilizar printHex

    ; Como manejo edi como indice de AEIOU
    ;                       edi      01234
    cmp     edi, 0 
    je      .count_a

    cmp     edi, 1
    je      .count_e

    cmp     edi, 2
    je      .count_i

    cmp     edi, 3
    je      .count_o

    cmp     edi, 4
    je      .count_u


    .count_a:
        mov     edx,    vocal_A
        mov     eax,    [edx]
        call    printHex
        jmp     .fin_count
    .count_e:
        mov     edx,    vocal_E
        mov     eax,    [edx]
        call    printHex
        jmp     .fin_count
    .count_i:
        mov     edx,    vocal_I
        mov     eax,    [edx]
        call    printHex
        jmp     .fin_count
    .count_o:
        mov     edx,    vocal_O
        mov     eax,    [edx]
        call    printHex
        jmp     .fin_count
    .count_u:
        mov     edx,    vocal_U
        mov     eax,    [edx]
        call    printHex
        jmp     .fin_count

    .fin_count:
    pop     edx
    pop     eax
    pop     esi
ret