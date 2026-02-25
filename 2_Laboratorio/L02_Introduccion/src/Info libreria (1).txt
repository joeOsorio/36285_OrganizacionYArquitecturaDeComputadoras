Ejemplo:

global _start
section .text
_start:
    ; sys_write(stdout, message, length)
    mov eax, 4
    mov ebx, 1
    mov ecx, message
    mov edx, length
    int 80h

    ; sys_exit(return_code)
    mov eax, 1      ;sys_exit syscall
    mov ebx, 0      ;return 0 (todo correcto)
    int 80h

section  .data
    message: db 'Hello, world!', 0x0A       ;mensaje y nueva linea
    length: equ $-message                  ;Obtenemos la longitud de la cadena

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Fin de Ejemplo

Pasos para ensamblar con NASM:

Comando para ensamblar: nasm -f elf <archivo.asm>
Comando para enlazar: ld -m elf_i386 <archivos.o> -o <output_file>

Rutina: clrscr
Parametros:
;    Entrada:  ninguno
;    Salida:   ninguno

Rutina: gotoxy
Parametros:
;    Entrada:  BH posicion  x (columna)
;              BL posicion  y (renglon)
;    Salida:   ninguno

Rutina: putchar
Parametros:
;    Entrada:  AL contiene el caracter a desplegar
;    Salida:

Rutina: puts
Parametros:
;     Entrada:  edx  contiene el aputador a la cadena a imprimir
;      Salida:  ninguno

Rutina: getche
Parametros:
;    Entrada:
;    Salida:   AL contiene el caracter tecleado

Rutina: getch
Parametros:
;    Entrada:
;    Salida:   AL contiene el caracter tecleado


Como añadir librerias contenidas en carpetas.
%include "./LIB/pc_io.inc"

Ensamblar
nasm -f elf entrada.asm

Ensamblar 2
ld -m elf_i386 -s -o entrada  entrada.o LIB/libpc_io.a



Otros codigos.
;en eax el valor a convertir mostrar en hexadecimal
printHex:
  pushad
  mov edx, eax
  mov ebx, 0fh
  mov cl, 28
.nxt: shr eax,cl
.msk: and eax,ebx
  cmp al, 9
  jbe .menor
  add al,7
.menor:add al,'0'
  mov byte [esi],al
  inc esi
  mov eax, edx
  cmp cl, 0
  je .print
  sub cl, 4
  cmp cl, 0
  ja .nxt
  je .msk
.print: mov eax, 4
  mov ebx, 1
  sub esi, 8
  mov ecx, esi
  mov edx, 8
  int 80h
  popad
  ret