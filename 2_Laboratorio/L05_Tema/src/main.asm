; Ensamblador NASM, formato ELF de 32 bits, para Linux.
; Practica 5: Captura, visualización y detección de palíndromos.
; Instrucciones permitidas: add, sub, mov, jmp, cmp, je, loop, getch, getche, puts, putchar, inc, dec.

;cd 2_Laboratorio/L05_Tema/
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
    call    clrscr
    call    salto
    mov     edx,        msj1        ; Cargar la direccion del mensaje    
    call    puts                    ; mostrar en terminal
    mov     edx,        msj2        ; Cargar la direccion del mensaje
    call    puts                    ; mostrar en terminal
    call    getche					; Capturar numero 1
	mov     ebx,        num         ; cargar a la variable al registro
	sub     al,         48			; Realizar casteo a numero.
	mov     byte[ebx],  al			; Guardar numero en variable.
    mov     ecx,        [ebx]       ; Cargar el contenido en el registro ecx
    call    salto
    call    salto
    call    piramide                ; Llamado a la sub rutina
    call    salto
    mov     ebx,        num         ; Cargar la direccion de la variable
    mov     ecx,        [ebx]       ; Cargar el contenio en ecx
    call    cuadrado
    mov     eax, 1
    mov     ebx, 0
    int     80h

piramide:
; Entrada:  ecx = Contador de cuanto se repite.
; Modifica: al, esi, edi
; Salida:   Terminal
    mov al, '*'
    .ciclo_imprime:
        cmp ecx, 0
        je  .fin_imprime
        mov edi, ecx
        ; mov esi, ecx
        .ciclo_renglon:
        cmp     edi, 0
        je      .fin_renglon
        call    putchar
        dec     edi
        jmp     .ciclo_renglon
        .fin_renglon:
        call salto
        mov al, "*"
        dec ecx
        jmp .ciclo_imprime
    .fin_imprime:
ret

cuadrado:
; Entrada:  ecx = Contador de cuanto se repite.
; Modifica: al, esi, edi
; Salida:   Terminal
    mov edi, ecx    ; renglones
    mov esi, ecx    ; columnas
    .ciclo_Cuadrado:
        cmp     edi,    ecx
        je      .imp_renglon_esp
        cmp     edi,    1
        je      .imp_renglon_esp
        cmp     edi,    0
        je     .fin_cuadrado
        mov     esi,    ecx
        .ciclo_renglon_c:
            cmp     esi, ecx
            je      .imp_C
            cmp     esi, 1
            je      .imp_C
            cmp     esi, 0
            je      .fin_renglon_c
            mov     al, " "
            call    putchar
            dec     esi
            jmp     .ciclo_renglon_c
            .imp_C:
                mov     al, "*"
                call    putchar
                dec     esi
                jmp     .ciclo_renglon_c 
            .imp_renglon_esp:
            mov     edx, ecx
            .ciclo_renglon_esp:
                cmp     edx, 0
                je      .fin_ciclo_imprimeSiOSi 
                mov     al, "*"
                call    putchar
                dec     edx
                jmp     .ciclo_renglon_esp
            .fin_ciclo_imprimeSiOSi:
            .fin_renglon_c:
                dec     edi
                call salto
                jmp .ciclo_Cuadrado
    .fin_cuadrado:
ret

salto:
	pushad
	mov     al,         13
	call    putchar
	mov     al,         10
	call    putchar
	popad
	ret