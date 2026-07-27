; ============================================================
; pc_io_reconstruido.asm
;
; Reconstruccion comentada del codigo fuente de pc_io.o
; (libpc_io.a), generada a partir de:
;   - objdump -d -Mintel pc_io.o   (instrucciones)
;   - objdump -t pc_io.o           (tabla de simbolos, incluye
;                                    nombres reales: termios,
;                                    c_iflag, c_oflag, c_cflag,
;                                    c_lflag, c_line, c_cc, cls_cmd)
;   - objdump -r pc_io.o           (relocaciones .data/.bss)
;
; NOTA: esta es una reconstruccion, no el .asm original exacto.
; Los comentarios, el orden de macros, y algunos detalles de
; formato se perdieron al compilar a .o. La logica e instrucciones
; SI son fieles al binario.
; ============================================================

section .data
    ; 7 bytes, usados por clrscr (write con edx=7).
    ; Secuencia ANSI clasica: borra pantalla + cursor a home.
    cls_cmd: db 0x1b, '[', '2', 'J', 0x1b, '[', 'H'   ; ESC[2J ESC[H

section .bss
    ; struct termios de Linux (x86). Los offsets 0,4,8,0xc,0x10,0x11
    ; calzan EXACTO con el struct termios real de <termios.h>:
    ;   struct termios {
    ;       tcflag_t c_iflag;   // offset 0x00
    ;       tcflag_t c_oflag;   // offset 0x04
    ;       tcflag_t c_cflag;   // offset 0x08
    ;       tcflag_t c_lflag;   // offset 0x0c  <-- aqui viven ICANON y ECHO
    ;       cc_t     c_line;    // offset 0x10
    ;       cc_t     c_cc[...]; // offset 0x11
    ;   };
    termios:
    c_iflag: resd 1
    c_oflag: resd 1
    c_cflag: resd 1
    c_lflag: resd 1          ; bit 0x2 = ICANON, bit 0x8 = ECHO
    c_line:  resb 1
    c_cc:    resb 32         ; tamano aproximado, ajustar si se necesita exacto

section .text
    global clrscr
    global gotoxy
    global putchar
    global puts
    global getche
    global getch

; ------------------------------------------------------------------
; void clrscr(void)
; Escribe la secuencia ANSI de cls_cmd directo a stdout (fd 1).
; ------------------------------------------------------------------
clrscr:
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 4          ; sys_write
    mov ebx, 1          ; fd = stdout
    mov ecx, cls_cmd
    mov edx, 7          ; longitud de cls_cmd
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret


; ------------------------------------------------------------------
; void gotoxy(bh=fila, bl=columna)   [convencion propia por registro]
; Imprime la secuencia ANSI  ESC [ fila ; columna f
; Convierte cada byte (bl, bh) a sus digitos decimales con div,
; e imprime digito por digito via putchar.
; ------------------------------------------------------------------
gotoxy:
    push eax
    push ebx
    push ecx

    mov al, 0x1b            ; ESC
    call putchar
    mov al, '['
    call putchar

    ; --- columna (bl) en decimal ---
    movzx ax, bl
    mov cl, 10
    div cl                  ; al = bl/10 , ah = bl%10
    cmp al, 0
    je  .next               ; si decenas = 0, no imprimir el 0 de mas
    add al, '0'
    call putchar
.next:
    mov al, ah
    add al, '0'
    call putchar

    mov al, ';'
    call putchar

    ; --- fila (bh) en decimal ---
    movzx ax, bh
    div cl
    cmp al, 0
    je  .next2
    add al, '0'
    call putchar
.next2:
    mov al, ah
    add al, '0'
    call putchar

    mov al, 'f'
    call putchar

    pop ecx
    pop ebx
    pop eax
    ret


; ------------------------------------------------------------------
; void putchar(al = caracter)   [convencion propia por registro]
; Escribe 1 byte (el que esta en AL) a stdout via syscall write.
; ------------------------------------------------------------------
putchar:
    push edx
    push ecx
    push ebx
    push eax            ; el byte a escribir queda en la pila (en [esp])

    mov eax, 4          ; sys_write
    mov ebx, 1          ; fd = stdout
    mov ecx, esp        ; apunta al byte recien pusheado
    mov edx, 1          ; longitud = 1 byte
    int 0x80

    pop eax
    pop ebx
    pop ecx
    pop edx
    ret


; ------------------------------------------------------------------
; void puts(edx = puntero a cadena)   [convencion propia por registro]
; Imprime caracter por caracter llamando a putchar hasta el 0 final.
; ------------------------------------------------------------------
puts:
    push eax
    push edx

.next_char:
    mov al, [edx]
    cmp al, 0
    je  .fin
    call putchar
    inc edx
    jmp .next_char

.fin:
    pop edx
    pop eax
    ret


; ------------------------------------------------------------------
; al = getche(void)   [convencion propia por registro]
; Lee 1 caracter de stdin. Apaga ICANON (modo linea) antes de leer
; y lo vuelve a prender despues. El bit ECHO NUNCA se toca aqui,
; por lo que el eco en pantalla lo produce el driver de la tty
; (no una instruccion explicita de esta rutina).
; ------------------------------------------------------------------
getche:
    push edx
    push ecx
    push ebx
    push 0              ; reserva 1 dword en la pila para el byte leido

    call ICANON_disable

    mov eax, 3          ; sys_read
    mov ebx, 0          ; fd = stdin
    mov ecx, esp        ; buffer = tope de pila (donde se hizo push 0)
    mov edx, 1          ; leer 1 byte
    int 0x80

    call ICANON_enable

    pop eax             ; al = caracter leido
    pop ebx
    pop ecx
    pop edx
    ret


; ------------------------------------------------------------------
; al = getch(void)   [convencion propia por registro]
; Igual que getche, pero apaga ICANON *y* ECHO -> lectura totalmente
; silenciosa, sin eco automatico de la terminal. El llamador debe
; hacer su propio eco (por ejemplo, con putchar) si lo necesita.
; ------------------------------------------------------------------
getch:
    push edx
    push ecx
    push ebx
    push 0

    call ICANON_ECHO_disable

    mov eax, 3
    mov ebx, 0
    mov ecx, esp
    mov edx, 1
    int 0x80

    call ICANON_ECHO_enable

    pop eax
    pop ebx
    pop ecx
    pop edx
    ret


; ------------------------------------------------------------------
; ICANON_disable / ICANON_enable
; TCGETS (0x5401) lee el termios actual de fd 0 hacia [termios],
; se modifica el bit ICANON (0x2) en c_lflag, y TCSETS (0x5402)
; vuelve a aplicarlo. El bit ECHO (0x8) NUNCA se toca en este par.
; ------------------------------------------------------------------
ICANON_disable:
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 0x36        ; sys_ioctl
    mov ebx, 0           ; fd = stdin
    mov ecx, 0x5401      ; TCGETS
    mov edx, termios
    int 0x80

    and dword [c_lflag], 0xfffffffd   ; apaga bit ICANON (0x2)

    mov eax, 0x36
    mov ebx, 0
    mov ecx, 0x5402      ; TCSETS
    mov edx, termios
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret


ICANON_enable:
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 0x36
    mov ebx, 0
    mov ecx, 0x5401      ; TCGETS
    mov edx, termios
    int 0x80

    or dword [c_lflag], 0x2            ; prende bit ICANON de nuevo

    mov eax, 0x36
    mov ebx, 0
    mov ecx, 0x5402      ; TCSETS
    mov edx, termios
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret


; ------------------------------------------------------------------
; ICANON_ECHO_disable / ICANON_ECHO_enable
; Igual que el par anterior, pero ademas apaga/prende el bit ECHO
; (0x8) de c_lflag. Usado por getch para lectura silenciosa.
; ------------------------------------------------------------------
ICANON_ECHO_disable:
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 0x36
    mov ebx, 0
    mov ecx, 0x5401
    mov edx, termios
    int 0x80

    and dword [c_lflag], 0xfffffffd    ; apaga ICANON (0x2)
    and dword [c_lflag], 0xfffffff7    ; apaga ECHO   (0x8)

    mov eax, 0x36
    mov ebx, 0
    mov ecx, 0x5402
    mov edx, termios
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret


ICANON_ECHO_enable:
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 0x36
    mov ebx, 0
    mov ecx, 0x5401
    mov edx, termios
    int 0x80

    or dword [c_lflag], 0x2            ; prende ICANON (0x2)
    or dword [c_lflag], 0x8            ; prende ECHO   (0x8)

    mov eax, 0x36
    mov ebx, 0
    mov ecx, 0x5402
    mov edx, termios
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret


; ------------------------------------------------------------------
; pHex_n(al = nibble)   [interno, usado por pHex_w]
; Imprime un solo nibble (4 bits bajos de AL) en hexadecimal.
; ------------------------------------------------------------------
pHex_n:
    push eax
    and al, 0x0f
    cmp al, 0xa
    jb  .num
    add al, 7            ; ajusta 'A'-'F'
.num:
    add al, '0'
    call putchar
    pop eax
    ret


; ------------------------------------------------------------------
; pHex_w(ax = word de 16 bits)
; Imprime un word completo en hex (4 nibbles), rotando ax de 4 en 4.
; ------------------------------------------------------------------
pHex_w:
    push eax
    push ecx
    mov ecx, 4
.next:
    rol ax, 4
    call pHex_n
    loop .next
    pop ecx
    pop eax
    ret


; ------------------------------------------------------------------
; p_LF(void)
; Imprime un salto de linea (0x0A).
; ------------------------------------------------------------------
p_LF:
    push eax
    mov al, 0x0a
    call putchar
    pop eax
    ret


section .note.GNU-stack noalloc noexec nowrite progbits