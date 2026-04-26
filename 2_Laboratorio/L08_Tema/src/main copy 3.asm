%include "./pc_io.inc"

%include "my_routines.asm"

section .data
    paso0:      db "Laboratorio",10,0
    msjP1_0:    db "Capturar Cadena binaria de 32 bits",10,0
    msjP1_0_1:  db "Ejemplo: 0110111100011000",10,0
    msjP1_1:    db "Ingrese cadena binaria: ", 0
    msjP1_2:    db "La cadena es: ", 0
    StrBin:  db "0110111100011000",0
    len: equ $-StrBin

section .bss
    cadena          resb    254
    direciones      resb    50  ; Direcciones de cada palabra
    longitud        resb    50  ; Numero de letras para cada palabra..
    simbolos        resb    100 ; Todavia no nos dice.
    palabras        resb    4   ; indica cuantas palabas tiene.
    temp            resb    8
    cad             resb    4

section .text
    global _start


_start:
    call    clrscr
    call    salto
    mov     edx, paso0
    call    new_puts
    mov     edx,    msjP1_0
    call    new_puts
    ; mov     edx,    msjP1_1
    ; call    new_puts
    ; mov     ecx, 254
    ; mov     edx, cadena
    ; mov     ecx, 254
    ; call    inputStr
    mov     edx, msjP1_2
    call    new_puts
    mov     edx, StrBin
    call    new_puts
    call    salto

    ; Despues de aqui.
    ; hex          6    F   1     8   h
    ; StrBin -> "0110 1111 0001 1000" b

    mov     edx, StrBin
    mov     esi, cad        ; Mover una cadena de 8 bytes
    call    cadBinToHex

    mov     edx, esi
    call    new_puts


;retunr 0
mov eax, 1
mov ebx, 0
int 80h

cadBinToHex:
    ; Entrada: edx -> dir de la cadena binaria a convertir.
    ; Salida:  esi -> cad de min 4 bytes para el resultado
    pusha
    mov ecx, 4          ; Para 4 dígitos hex
    mov ebx, 0          ; Acumulador para el valor actual
    
.procesar_grupo:
    mov edi, 4          ; 4 bits por grupo
    xor bl, bl          ; Limpiar acumulador
    
.procesar_bit:
    dec edi
    mov al, [edx]       ; Leer siguiente carácter
    cmp al, '1'
    jne .no_sumar
    
    ; Sumar según posición (1,2,4,8)
    cmp edi, 0
    je .sumar_1
    cmp edi, 1
    je .sumar_2
    cmp edi, 2
    je .sumar_4
    ; edi = 3
    add bl, 8
    jmp .no_sumar
    
.sumar_4:
    add bl, 4
    jmp .no_sumar
.sumar_2:
    add bl, 2
    jmp .no_sumar
.sumar_1:
    add bl, 1
    
.no_sumar:
    inc edx             ; Siguiente bit
    cmp edi, 0
    jg .procesar_bit    ; Procesar 4 bits
    
    ; Convertir nibble a carácter hex
    cmp bl, 9
    jg .letra_hex
    add bl, '0'
    jmp .guardar_car
    
.letra_hex:
    sub bl, 10
    add bl, 'A'
    
.guardar_car:
    mov [esi + ecx - 1], bl
    loop .procesar_grupo
    mov byte [esi + 4], 0  ; Terminar cadena
    popa
    ret