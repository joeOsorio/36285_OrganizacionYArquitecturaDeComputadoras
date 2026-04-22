%include "./pc_io.inc"

%include "my_routines.asm"

section .data
    paso0: db "Laboratorio",10,0
    msjP1_0:   db "Capturar Cadena",10,0
    msjP1_1:   db  "Ingrese cadena: ", 0
    msjP1_2:    db "La cadena es: ", 0

section .bss
    cadena          resb    254
    direciones      resb    50  ; Direcciones de cada palabra
    longitud        resb    50  ; Numero de letras para cada palabra.
    simbolos        resb    100 ; Todavia no nos dice.
    temp            resb    8
    palabra         resb    8

section .text
    global _start


_start:
    call    clrscr
    call    salto
    mov     edx, paso0
    call    new_puts
    mov     edx,    msjP1_0
    call    new_puts
    mov     edx,    msjP1_1
    call    new_puts
    mov     ecx, 254
    mov     edx, cadena
    mov     ecx, 254
    call    inputStr
    mov     edx, msjP1_2
    call    new_puts
    mov     edx, cadena
    call    new_puts
    call    salto
    ; mov     eax, cadena
    ; mov     esi, temp
    ; call    printHex
    ; push    ebx
    ; mov     ebx,  cadena
    ; add     ebx, 5
    ; mov     edx, ebx 
    ; mov     edi, 5
    ; call    outputStr
    ; call    salto

    mov ebx, cadena
    call contar_palabas

    call salto
    





    



mov eax, 1
mov ebx, 0
int 80h





; ------------------------------
; Laboratorio 6
; ------------------------------

contar_palabas:
	; Entrada:	EBX -> Direccion de la cadena a evaluar. 
	;			EDI -> Longitud de cadena sin contemplar 0
	; Utiliza:	Al
	; Salida:   Ninguna
	push	edi
	push 	eax
	mov		edi, 	0
	.ciclo_contar_palabras:
		mov al, 	[ebx + edi]
		cmp al, 	"0"
        je  .fin_cadena
        cmp     al, " "
        je 	.fin_palaba
		inc	edi
		jmp .ciclo_contar_palabras
	.fin_palaba:
        push eax
        mov [longitud], edi
        mov esi, temp
        mov eax, longitud
        call printHex	
        call salto
        pop eax
        inc	edi
        jmp .ciclo_contar_palabras
    .fin_cadena:
    pop edi
    pop eax
ret