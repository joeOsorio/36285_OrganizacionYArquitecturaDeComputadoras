; ============================================================
; P11_enASM.asm
; Practica 11 - OAC
; Subrutinas: gets, atoi, printHex, printDec, puts
; NASM -f win32  |  GCC (mingw.org) -m32
; ============================================================

extern _getchar
extern _putchar

section .data
    ; (sin cadenas de datos fijas aqui, los prompts van en el .c)

section .bss
    bufferDec resb 12      ; 10 digitos max (2^32-1) + signo + nulo
    bufferHex resb 9       ; 8 nibbles hex + nulo

section .text
    global _gets
    global _atoi
    global _printHex
    global _printDec
    global _puts

; ------------------------------------------------------------------
; void gets(int *direccion_donde_se_guarda_la_cadena_capturada)
; Lee caracteres del teclado y los guarda en la direccion apuntada
; por ESI, hasta encontrar '*'. Al final coloca un 0 (byte nulo)
; en vez del '*'.
; ------------------------------------------------------------------
_gets:
    push ebp
    mov  ebp, esp
    push esi

    mov esi, [ebp+8]        ; esi = direccion del buffer destino

.leer_caracter:
    call _getchar             ; caracter leido queda en EAX
    cmp  al, '*'
    je   .fin_cadena

    mov  [esi], al            ; guardar caracter en el buffer
    inc  esi
    jmp  .leer_caracter

.fin_cadena:
    mov byte [esi], 0         ; terminador nulo

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
_atoi:
    push ebp
    mov  ebp, esp
    push esi
    push ebx

    mov esi, [ebp+8]        ; esi = direccion de la cadena
    xor eax, eax             ; eax = acumulador = 0

.siguiente_digito:
    movzx ebx, byte [esi]
    cmp   ebx, 0
    je    .fin_conversion

    cmp ebx, '0'
    jl  .fin_conversion
    cmp ebx, '9'
    jg  .fin_conversion

    sub  ebx, '0'             ; caracter ascii -> valor numerico
    imul eax, eax, 10         ; acumulador *= 10
    add  eax, ebx             ; acumulador += digito

    inc esi
    jmp .siguiente_digito

.fin_conversion:
    pop ebx
    pop esi
    mov esp, ebp
    pop ebp
    ret


; ------------------------------------------------------------------
; void printHex(unsigned int valor_a_imprimir)
; Imprime el valor recibido en formato hexadecimal de 8 digitos
; (con ceros a la izquierda), ej: 12345 -> "00003039"
; ------------------------------------------------------------------
_printHex:
    push ebp
    mov  ebp, esp
    push esi
    push ebx
    push ecx

    mov eax, [ebp+8]
    mov ecx, 8                 ; 8 nibbles (32 bits)
    mov esi, bufferHex + 8
    mov byte [esi], 0

.siguiente_nibble:
    dec esi
    mov ebx, eax
    and ebx, 0xF
    cmp ebx, 9
    jle .es_digito
    add ebx, 'A' - 10
    jmp .guardar
.es_digito:
    add ebx, '0'
.guardar:
    mov [esi], bl
    shr eax, 4
    loop .siguiente_nibble

    push esi
    call _puts
    add  esp, 4

    pop ecx
    pop ebx
    pop esi
    mov esp, ebp
    pop ebp
    ret


; ------------------------------------------------------------------
; void printDec(unsigned int valor_a_imprimir)
; Convierte el valor a cadena decimal y lo imprime en pantalla.
; Maximo valor soportado: 4,294,967,295 (2^32 - 1)
; ------------------------------------------------------------------
_printDec:
    push ebp
    mov  ebp, esp
    push esi
    push edi
    push ebx

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

    push edi
    call _puts
    add  esp, 4

    pop ebx
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret


; ------------------------------------------------------------------
; void puts(char *cadena)
; Imprime una cadena terminada en 0, seguida de salto de linea.
; ------------------------------------------------------------------
_puts:
    push ebp
    mov  ebp, esp
    push esi

    mov esi, [ebp+8]

.imprimir_caracter:
    movzx eax, byte [esi]
    cmp   eax, 0
    je    .fin_puts

    push eax
    call _putchar
    add  esp, 4

    inc esi
    jmp .imprimir_caracter

.fin_puts:
    push 10                    ; '\n'
    call _putchar
    add  esp, 4

    pop esi
    mov esp, ebp
    pop ebp
    ret