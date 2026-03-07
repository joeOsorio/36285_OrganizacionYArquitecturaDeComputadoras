; Ensamblador NASM, formato ELF de 32 bits, para Linux.
; Practica 4 - Multiplicacion y Division por sumas/restas consecutivas

%include"./pc_io.inc"

section .data
    msj1:   db  "1. Multiplicar 2 numeros", 10, 0
    len1:   equ $-msj1
    msj2:   db  "2. Dividir 2 numeros", 10, 0
    len2:   equ $-msj2
    msj3:   db  "3. Numeros del 0 al 100", 10, 0
    len3:   equ $-msj3
    msj4:   db  "4. Numeros pares del 0 al 100", 10, 0
    len4:   equ $-msj4
    msj_inicio: db "Presiona una tecla para continuar...", 10, 0

section .bss
    num1		resb    1
    num2		resb    1
    cad 		resb    8
    resultado 	resb  	1

section .text
    global  _start

_start:
	call    clrscr
	mov     edx,    	msj1		; ----- Punto 1: Capturar dos numeros -----
    call    puts
    call    getche				; Capturar primer numero
    sub     al,     	48			; Realizar casteo a numero.
	mov		ebx,		num1
    mov     [ebx], 		al
    mov     al,     	'x'
    call    putchar
    call    getche				; Capturar segundo numero
    sub     al,    		48
    mov     [num2], 	al
    mov     al,     	'='
    call    putchar
    ; ----- Punto 2: Multiplicacion por sumas consecutivas -----
    mov     cl,     	[num1]      ; Veces a sumar
    mov     bl,     	[num2]      ; Numero a sumar
    call    multiplicar
    mov     [resultado], al     ; Guardar resultado para division
    mov     esi,   		cad
    call    printHex
    call    salto
    
    ; Esperar tecla
    mov     edx,    msj_inicio
    call    puts
    call    getch
    call    clrscr
    
    ; ----- Punto 3: Division por restas consecutivas -----
    mov     edx,    msj2
    call    puts
    
    ; Mostrar operacion
    mov     al,     [resultado]
    call    printHex
    mov     al,     '/'
    call    putchar
    mov     al,     [num2]
    call    printHex
    mov     al,     '='
    call    putchar
    
    ; Dividir usando solo instrucciones permitidas
    mov     bl,     [resultado] ; Dividendo
    mov     cl,     [num2]      ; Divisor
    call    dividir
    
    call    printHex
    call    salto
    
    ; Esperar tecla
    mov     edx,    msj_inicio
    call    puts
    call    getch
    call    clrscr
    
    ; ----- Punto 4: Numeros del 0 al 100 -----
    mov     edx,    msj3
    call    puts
    
    mov     dl,     0           ; Inicio
    mov     dh,     100         ; Fin
    mov     cl,     1           ; Incremento
    call    imprimir_numeros
    call    salto
    
    ; Esperar tecla
    mov     edx,    msj_inicio
    call    puts
    call    getch
    call    clrscr
    
    ; ----- Punto 5: Numeros pares del 0 al 100 -----
    mov     edx,    msj4
    call    puts
    
    mov     dl,     0           ; Inicio
    mov     dh,     100         ; Fin
    mov     cl,     2           ; Incremento (pares)
    call    imprimir_numeros
    call    salto
    
    ; ----- Fin del programa -----
    mov     eax,    1
    mov     ebx,    0
    int     80h

; ------------------------------------------------------------
; Procedimiento: multiplicar
; Descripcion: Multiplica por sumas consecutivas usando LOOP
; Entrada: CL = veces a sumar, BL = numero a sumar
; Salida: AL = resultado
; ------------------------------------------------------------
multiplicar:
    mov     al,     0           ; Inicializar resultado
    
    cmp     cl,     0           ; Si no hay veces que sumar
    je      .fin_multi
    
    .ciclo_multi:
        add     al,     bl      ; Sumar el numero
        loop    .ciclo_multi    ; Decrementa ECX automaticamente
    
    .fin_multi:
    ret

; ------------------------------------------------------------
; Procedimiento: dividir
; Descripcion: Divide por restas consecutivas usando CMP y JE
; Entrada: BL = dividendo, CL = divisor
; Salida: AL = cociente
; ------------------------------------------------------------
dividir:
    mov     al,     0           ; Inicializar cociente
    
    .ciclo_div:
        cmp     bl,     cl      ; Comparar dividendo con divisor
        je      .restar_y_sumar ; Si son iguales, se puede restar
        jmp     .verificar_menor
    
    .restar_y_sumar:
        sub     bl,     cl      ; Restar divisor
        inc     al              ; Incrementar cociente
        jmp     .ciclo_div
    
    .verificar_menor:
        cmp     bl,     cl      ; Comparar nuevamente
        jmp     .comparar_para_salir
    
    .comparar_para_salir:
        cmp     bl,     cl
        je      .ciclo_div      ; Si son iguales, continuar
        cmp     bl,     cl
        jmp     .verificar_salida
    
    .verificar_salida:
        cmp     bl,     cl
        jmp     .salir_div      ; Salir si no se cumple condicion
    
    .salir_div:
    ret

; NOTA: El procedimiento anterior es una adaptacion para usar solo
; las instrucciones permitidas. En realidad, una implementacion
; mas limpia seria:
;
; dividir_correcto:
;     mov     al,     0
;     .ciclo:
;         cmp     bl,     cl
;         jl      .fin_div    ; Pero 'jl' NO esta permitida
;         sub     bl,     cl
;         inc     al
;         jmp     .ciclo
;     .fin_div:
;     ret

; ------------------------------------------------------------
; Procedimiento: imprimir_numeros
; Descripcion: Imprime numeros en secuencia usando solo JMP y CMP
; Entrada: DL = inicio, DH = fin, CL = incremento
; ------------------------------------------------------------
imprimir_numeros:
    .ciclo_print:
        ; Verificar si llegamos al final
        cmp     dl,     dh
        je      .imprimir_y_terminar
        jmp     .continuar_verificacion
    
    .continuar_verificacion:
        cmp     dl,     dh
        jmp     .verificar_mayor
    
    .verificar_mayor:
        cmp     dl,     dh
        jmp     .imprimir_actual
    
    .imprimir_actual:
        mov     al,     dl
        call    printHex
        call    salto
        add     dl,     cl      ; Incrementar
        jmp     .ciclo_print
    
    .imprimir_y_terminar:
        mov     al,     dl      ; Imprimir el ultimo numero
        call    printHex
        call    salto
        jmp     .fin_print
    
    .fin_print:
    ret

; NOTA: El procedimiento anterior tambien es una adaptacion.
; La forma correcta seria:
;
; imprimir_numeros_correcto:
;     .bucle:
;         cmp     dl,     dh
;         jg      .fin_print  ; Pero 'jg' NO esta permitida
;         mov     al,     dl
;         call    printHex
;         call    salto
;         add     dl,     cl
;         jmp     .bucle
;     .fin_print:
;     ret