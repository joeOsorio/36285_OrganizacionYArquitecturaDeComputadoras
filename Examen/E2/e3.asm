%include "./pc_io.inc"

section .text
    global _start:

_start:
    MOV EDX, msg1
    CALL newputs
    CALL salto
;=============== Capturar ===============
    MOV AX, 0
    MOV ESI, 0

    MOV EBX, cadenaB
    MOV byte[EBX], '0'

    capturarB:
        CALL getche
        
        CMP AL, '*'
        JE endCaptB

        MOV [EBX+ESI], AL
        INC ESI 
        JMP capturarB

        endCaptB:
            MOV byte[EBX+ESI], '%'
            CALL salto

    CALL getche
    SUB AL, '0'
    CALL salto
    CALL salto

;============================= EJERCICIO 3 =============================

;Crear un código que cuente el número de veces que aparece una palabra 
;en una oración ingresada por el usuario.

;Ejemplo:

;cadena: "Bola ggola holaa hola mundo mmudno hola%"

;palabra buscada: "hola"

;resultado impreso en terminal: 00000002

;el símbolo % representa el final de la cadena y no se cuenta.

;No se les pide que capturen nada, den por hecho que ya se capturó y esi 
;apunta a esa cadena, y edi apunta a la palabra buscada.

;Pueden utilizar todas las instrucciones vistas en clase y laboratorio, 
;memoria, pila, corrimientos, lo que gusten mientras se haya enseñado en clase.






    MOV EAX, 1
    MOV EBX, 0
    int 80h


;========================================================================

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
    tabla: db 1,2,4,8,16,32,64
    msg1: db 'Cadena binaria terminada en *%', 0h
section .bss
    corrimiento resb 20
    cadenaB resb 256
    conversionB resb 20
    carry resb 2
