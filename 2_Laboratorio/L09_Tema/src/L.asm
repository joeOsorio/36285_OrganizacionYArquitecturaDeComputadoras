%include "./pc_io.inc"

global _start

section .data
  tabla: db '0123456789'
    
section .bss

section .text

_start:

mov eax, 1504863646d
call printDec

mov eax, 1
mov ebx, 0
int 80h

printDec:
  mov ebx, tabla 
  mov ecx, 10
  mov ebp, 0

  cmp eax, 0
  jne .saltar
  mov al , '0'
  call putchar
  ret

  .saltar:
  .dividir:
    mov edx, 0
    div ecx
    push eax
    mov eax, edx
    xlat
    movzx edx, al
    pop eax
    push edx
    inc ebp
    cmp eax, 0
    je .imprimir
  jmp .dividir
  

  .imprimir:
    cmp ebp, 0
    je .salir
    pop eax
    call putchar
    dec ebp
  jmp .imprimir
  .salir:
ret