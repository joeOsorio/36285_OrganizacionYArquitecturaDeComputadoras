%include "./pc_io.inc"

section .text
    global _start:

_start:

;============================= EJERCICIO 2 =============================

;Crear el código que convierta un valor contenido en eax en un conjunto 
;de caracteres binarios que representen ese valor en binario, no se puede 
;utilizar memoria, pila o la instrucción loop.

AND AH, 0
SAHF

MOV EAX, 140d
MOV ESI, 10000000000000000000000000000000b

;Por ejemplo, si se usa la instrucción TEST para probar un único bit, 
;la bandera de cero Z será:
; Z = 1 si el bit era 0
; Z = 0 si el bit era 1

next:
    TEST EAX, ESI
    JE CERO

    MOV EDX, uno
    CALL newputs

    SHR ESI,1
    JC fin
    JMP next

    CERO: 
        MOV EDX, cero
        CALL newputs

        SHR ESI,1
        JC fin
        JMP next

    fin:
        CALL salto

    MOV EAX, 1
    MOV EBX, 0
    int 80h


;========================================================================


debug:
    PUSHAD
    MOV EDX, dos
    CALL newputs
    CALL salto

    POPAD
    RET

;EDX pasar direccion base
newputs:
    PUSHAD
    MOV ESI, 0              ;Se reinicia el valor de ESI
    captPuts:
        MOV AL, [EDX+ESI]   ;En AL se coloca el valor de la cadena en la posición ESI
        CMP AL, '%'         ;Se compara para ver si es '%' (final de cadena)
        JE end              ;Salta a end si se encontro el simbolo '%'

        INC ESI             ;Si no se encontro se incrementa ESI 
        CALL putchar        ;Se imprime el carácter que se encuentra en la posición actual
    JMP captPuts            ;Regresa al ciclo en la siguiente posición

    end:    
        POPAD
        RET

salto:
  pushad
  mov al,13
  call putchar
  mov al,10
  call putchar
  popad
  ret


section .data
    uno: db '1%'
    cero: db '0%'
    dos: db '2%'

section .bss

