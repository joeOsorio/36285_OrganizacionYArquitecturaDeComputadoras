; ============================================================
; P11_enASM.asm
; Practica 11 - OAC (Linux / ELF32, Ubuntu)
; Reutiliza la libreria compartida LIB (libpc_io.a / pc_io.inc)
; en vez de reescribir puts, putchar, getche.
;
; IMPORTANTE - convenciones de llamada mezcladas en este archivo:
;   - gets, atoi, printDec, printHex, mostrarCadena: CDECL
;     (llamadas desde C: argumento(s) en la pila, via [ebp+8])
;   - puts, putchar, getche (de libpc_io.a): convencion propia
;     por registro (EDX = puntero de cadena, AL = caracter),
;     SIN argumentos en pila. Por eso nunca se llaman
;     directamente desde C, solo desde este .asm.
; ============================================================

%include "pc_io.inc"        ; extern puts, putchar, getch, getche, gotoxy, clrscr

section .bss
    bufferDec resb 12       ; 10 digitos max (2^32-1) + signo + nulo
    bufferHex resb 10       ; 8 nibbles hex + margen

section .text
    global gets
    global atoi
    global printDec
    global printHex
    global mostrarCadena

; ------------------------------------------------------------------
; void gets(int *direccion_donde_se_guarda_la_cadena_capturada)
; Lee caracteres con getche (de la LIB) hasta encontrar '*'.
; getche ya hace echo en la terminal, no hay que imprimir aparte.
; Guarda cada caracter en la direccion apuntada por ESI,
; al final coloca un 0 en vez del '*'.
; ------------------------------------------------------------------
; gets:
;     push ebp
;     mov  ebp, esp
;     push esi

;     mov esi, [ebp+8]         ; esi = direccion del buffer destino

; .leer_caracter:
;     call getche               ; caracter leido queda en AL (con eco de la tty)
;     cmp  al, '*'
;     je   .fin_cadena

;     call putchar          ; eco manual y controlado
;     mov  [esi], al
;     inc  esi
;     jmp  .leer_caracter

; .fin_cadena:
;     mov byte [esi], 0        ; terminador nulo

;     pop esi
;     mov esp, ebp
;     pop ebp
;     ret

gets:
    push ebp
    mov  ebp, esp
    push esi

    mov esi, [ebp+8]

; NOTA: se usa getch (no getche) porque getche deja el bit ECHO
; de la terminal activo y solo alterna ICANON por caracter, lo que
; genera una condicion de carrera que duplicaba el eco del '*'.
; Con getch (ICANON y ECHO apagados) el eco se hace manualmente
; con putchar, evitando el doble eco.

.leer_caracter:
    call getch                ; SIN eco automatico (ICANON y ECHO apagados)
    cmp  al, '*'
    je   .fin_cadena

    call putchar               ; eco manual y explicito, un solo eco garantizado
    mov  [esi], al
    inc  esi
    jmp  .leer_caracter

.fin_cadena:
    mov byte [esi], 0

    pop esi
    mov esp, ebp
    pop ebp
    ret


; ------------------------------------------------------------------
; unsigned int atoi(int *cadena_con_numero)
; Convierte una cadena de digitos ASCII (terminada en 0) a un
; numero decimal sin signo. Retorna el resultado en EAX.
; Maximo valor soportado: 4,294,967,295 (2^32 - 1)
; ------------------------------------------------------------------
atoi:
    push ebp
    mov  ebp, esp
    push esi
    push ebx

    mov esi, [ebp+8]
    xor eax, eax

.siguiente_digito:
    movzx ebx, byte [esi]; Un caracter tine 8 bits 
    cmp   ebx, 0
    je    .fin_conversion
    cmp   ebx, '0'
    jl    .fin_conversion
    cmp   ebx, '9'
    jg    .fin_conversion

    sub  ebx, '0'
    imul eax, eax, 10
    add  eax, ebx

    inc esi
    jmp .siguiente_digito

.fin_conversion:
    pop ebx
    pop esi
    mov esp, ebp
    pop ebp
    ret


; ------------------------------------------------------------------
; void printDec(unsigned int valor_a_imprimir)
; Convierte el valor a cadena decimal y lo muestra reutilizando
; la "puts" real de la LIB (que espera el puntero en EDX).
; ------------------------------------------------------------------
printDec:
    push ebp
    mov  ebp, esp
    push edi
    push ebx
    push edx

    mov eax, [ebp+8]
    mov edi, bufferDec + 11
    mov byte [edi], 0
    mov ebx, 10

.convertir:
    xor edx, edx
    div  ebx                  ; eax = eax/10 , edx = residuo
    add  edx, '0'
    dec  edi
    mov  [edi], dl
    cmp  eax, 0
    jne  .convertir

    mov edx, edi              ; puts (LIB) espera el puntero en EDX
    call puts

    pop edx
    pop ebx
    pop edi
    mov esp, ebp
    pop ebp
    ret


; ------------------------------------------------------------------
; void printHex(unsigned int valor_a_imprimir)
; Algoritmo proporcionado por el profe (my_routines.asm),
; adaptado a CDECL para poder llamarse directo desde C.
; Imprime el valor en 8 digitos hexadecimales.
; ------------------------------------------------------------------
printHex:
    push ebp
    mov  ebp, esp
    pushad

    mov eax, [ebp+8]
    mov esi, bufferHex
    mov edx, eax
    mov ebx, 0fh
    mov cl, 28
.nxt:
    shr eax, cl
.msk:
    and eax, ebx
    cmp al, 9
    jbe .menor
    add al, 7
.menor:
    add al, '0'
    mov byte [esi], al
    inc esi
    mov eax, edx
    cmp cl, 0
    je  .imprimir
    sub cl, 4
    cmp cl, 0
    ja  .nxt
    je  .msk
.imprimir:
    mov eax, 4
    mov ebx, 1
    sub esi, 8
    mov ecx, esi
    mov edx, 8
    int 0x80

    popad
    mov esp, ebp
    pop ebp
    ret


; ------------------------------------------------------------------
; void mostrarCadena(char *cadena)
; Wrapper CDECL para poder llamar a "puts" (de la LIB) desde C.
; Necesario porque la puts real de libpc_io.a usa convencion de
; registro (EDX), no la convencion cdecl que usa GCC para C.
; ------------------------------------------------------------------
mostrarCadena:
    push ebp
    mov  ebp, esp

    mov edx, [ebp+8]
    call puts

    mov esp, ebp
    pop ebp
    ret


section .note.GNU-stack noalloc noexec nowrite progbits
