# Código de ordenamiento



Cree una subrutina que será declarada desde el lenguaje c de la siguiente manera.

extern int ordenar(char \*lista, int tam, char orden);

Las variables serán las siguientes:

char hexList\[] = {0x3A, 0x1F, 0xFF, 0x75, 0x10, 0xAB};

int tam = 6;

char orden = 0; //será 0 para orden del menor al mayor, y 1 para orden del mayor al menor.

Implemente el código de la subrutina en asm 386, como recibe los parámetros, cómo ordena

los elementos y los muestra con printHex (se supone que ya está esa subrutina y funciona

como en las prácticas), al finalizar debe retornar un 1.





## \## Solución



ordenar:

&#x20; push ebp

&#x20; mov  ebp, esp

&#x20; push esi

&#x20; push edi

&#x20; push ebx





&#x20; mov esi, \[ebp + 8] ;ESI = \&lista\[0]

&#x20; mov ecx, \[ebp + 12] ; ECX = tam

&#x20; mov dl, \[ebp + 12]  ; DL = orden (0 = asc , 1 = dec)





&#x20; ; --------------- Buble sort : for i = 0 tam -2 ---------------



&#x20; mov ebx, ecx

&#x20; dec ebx       : EBX = tam - 1 (pasadas)

ext\_loop:

&#x20; cmp ebx, 0

&#x20; jle fin\_sort



&#x20; mov edi, 0

int\_loop:

&#x20; mov eax, edi

&#x20; inc eax

&#x20; cmp eax, ebx

&#x20; jge fin\_int



&#x20; mov al, \[asi + edi]     ; while j < tam -1 -i ( se usa EBX como límite)

&#x20; mov ah, \[asi + edi + 1]

&#x20; ; comparación sin signo ()

&#x20; cmp al, ah

&#x20; je no\_swap



&#x20; test dl, dl   ; orden == 0 ?

&#x20; jz ascendente



desendente:   ; Queremos mayor primero: swap si AL < AH

&#x20; jb do\_swap  ; AL < AH (sin signo)

&#x20; jmp no\_swap

asendenteL:   ; queremos menor primero: swap si AL > AH

&#x20; ja do\_swap  ; AL > AH (sin signo)

&#x20; jmp no\_swap



do\_swap:

&#x20; mov \[esi + edi], ah

&#x20; mov \[esi + edi + 1], al

no\_swap:

&#x20; inc edi

&#x20; jmp int\_loop

fin\_int:

&#x20; dec ebx

&#x20; jmp ext\_loop

fin\_sort:





; ------- Mostrar lista ordenada con printHex -------



&#x20; mov edi, 0

print\_loop:

&#x20; cmp edi, \[ebp + 12]

&#x20; jge fin\_print

&#x20; movzx eax, byte\[esi + edi]   ; extiende el byte a 32 bits

&#x20; push eax                     ; pasa el elemento a printHex

&#x20; call printHex

&#x20; add esp, 4

&#x20; inc edi

&#x20; jmp print\_loop

fin\_print:



&#x20; mov eax, 1                  ; valor de retorno = 1



&#x20; pop ebx

&#x20; pop edi

&#x20; pop esi

&#x20; pop ebp

ret


## Explicación


Recepción de parámetros. Con cdecl, C empuja los argumentos de derecha a izquierda y luego el call mete la dirección de retorno. Tras push ebp; mov ebp,esp, quedan en \[ebp+8] el puntero lista, en \[ebp+12] el tam, y en \[ebp+16] el orden. Solo leo el byte bajo de orden (DL).

Ordenamiento. Uso burbuja sobre el arreglo apuntado por ESI. Comparo cada par lista\[j] y lista\[j+1] con cmp y salto sin signo (ja/jb), porque los valores son bytes 0x00–0xFF; si usara saltos con signo, 0xFF se trataría como −1. Según orden: si es 0, intercambio cuando el primero es mayor (asc); si es 1, cuando el primero es menor (desc).

Impresión. Recorro el arreglo, extiendo cada byte con movzx, lo empujo a la pila, llamo printHex y limpio el parámetro con add esp,4 (responsabilidad del llamador en cdecl).

Retorno. Restauro los registros preservados, dejo EAX = 1 y ret.



&#x20; 





