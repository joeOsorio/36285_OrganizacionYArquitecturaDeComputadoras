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

;============================= EJERCICIO 1 =============================

;Crear un código que implemente el funcionamiento de la instrucción rcl 
;pero utilizando memoria y obviamente sin utilizar alguna instrucción de 
;corrimientos o rotación, y utilizando únicamente las instrucciones vistas 
;en clase y laboratorio.


    MOV EDX, cadenaB               ;Se pone la dirección de la cadena en EDX
    MOV CL, AL                     ;El valor de AL(num rotaciones) se coloca en CL
    MOV EDI, 0                     ;Se pone en 0 EDI
    ADD AH, 0                      ;Se le suma 0 a AH 
    SAHF                           ;Se ponen los bits de AH (0000 0001) en el carry flag

    rotacionesRCL:
        LAHF                       ;Se saca lo que hay en el CF y lo pone en AH
        AND AH, 1                  ;Se le hace AND con uno para quitar valores extras que pudieron quedarse
        ADD AH, '0'                ;Se le suma un '0' para hacer el valor numerico a ASCII
        PUSH AX                    ;Se guarda AX, donde en AH se encuentra el caracter '1' o '0'

        MOV AL, [EDX+0]            ;Lo que hay al inicio de la cadena se pone en AL
        PUSH EDI                   ;Se hace push a edi para guardar el valor de inicio del contador
        
        mover:
            MOV BL, [EDX+EDI+1]    ;Ahora el valor de [EDX+EDI+1] se coloca en BL
            MOV [EDX+EDI], BL      ;Lo que se puso en BL se coloca en [EDX+EDI] para mover los valores por su indice(EDI)

            CMP EDI, 6             ;Se compara EDI para ver si ya no se debe hacer el corrimiento
            JE finM                ;Salta al fin de mover si EDI fue igual a 6

            INC EDI                ;Se incrementa EDI para mover la siguiente posición
            JMP mover              ;Regresa al inicio de la subrutina de mover

        finM:            
            SUB AL, '0'            ;Se le resta a AL(valor de inicio) '0' para ponerlo en su valor numerico
            MOV EBX, carry         ;La dirección de carry se pone en EBX
            MOV byte[EBX], AL      ;El bit más significativo de la cadena se mueve a EBX para guardarlo de momento

            POP EDI                ;Se regresa al valor original de EDI (0)
            POP AX                 ;Se regresa al valor de AX que era el valor '0' o '1' del CF
            MOV byte[EDX+7], AH    ;El valor que había en el CF se coloca en el bit menos significativo de la cadena
            MOV byte [EDX+8], '%'  ;Se coloca el carácter % para indicar final de línea
            MOV AH, byte[EBX]      ;El bit menos significativo se coloca en AH
            AND AH, 1              ;Se le hace AND al valor para evitar errores
            SAHF                   ;Se usa SAHF para colocar los bits de AH en los menos significativos del EFLAGS
        loop rotacionesRCL         ;Se hace loop dependiendo de la cantidad de rotaciones que se hayan ingresado

    CALL newputs                   ;Se imprime la cadena con las rotaciones ya hechas 
    CALL salto  


;Recibe en eax un valor de 32 bits, debe pasarlo a cadena binaria, y a la 
;cadena binaria que represente ese número se le deben aplicar el número de 
;corrimientos que se reciban en ecx.

;Ejemplo:

;mov eax, 65h

;código

; imprime en terminal 0000 0000 0000 0000 0000 0000 0110 0101









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
    msg1: db 'Cadena binaria terminada en *%', 0h
section .bss
    corrimiento resb 20
    cadenaB resb 256
    carry resb 2
