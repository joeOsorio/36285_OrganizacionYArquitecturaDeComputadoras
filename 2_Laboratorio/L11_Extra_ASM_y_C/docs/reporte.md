# Práctica 11 — OAC (Organización y Arquitectura de Computadoras)

## Conclusiones y comentarios / Dificultades en el desarrollo

---

## Conclusiones y comentarios

### `atoi` — conversión de cadena a número decimal

La función recorre la cadena carácter por carácter usando `ESI` como puntero, y valida en cada iteración que el byte leído esté dentro del rango ASCII de un dígito (`'0'` a `'9'`). En cuanto encuentra un carácter fuera de ese rango (incluyendo el `0` de terminación), detiene la conversión.

El núcleo del algoritmo son dos instrucciones:

```asm
imul eax, eax, 10
add  eax, ebx
```

Se llegó a esta solución replicando el método manual de "correr" un número al agregar un nuevo dígito por la derecha:

- `imul eax, eax, 10` desplaza el valor acumulado un lugar decimal a la izquierda (equivalente a multiplicar por 10), dejando espacio para el nuevo dígito.
- `add eax, ebx` inserta el nuevo dígito (ya convertido de ASCII a valor numérico con `sub ebx, '0'`) en la posición de las unidades recién liberada.

Se evaluó por qué `imul` usa 3 operandos en vez de `mul`: la forma de tres operandos (`imul destino, origen, inmediato`) permite multiplicar directamente por una constante sin gastar un registro extra para guardarla, algo que `mul` no soporta (solo admite un operando y no acepta inmediatos). También se consideraron alternativas más rápidas en hardware antiguo (`shl`+`shl`+`add`, o `lea`+`shl` aprovechando que `x*10 = x*8 + x*2`), pero se descartaron por ser menos legibles y no aportar ganancia real en procesadores modernos.

### `gets` — captura de cadena por teclado

La versión inicial usaba `getche`, que solo alterna el bit `ICANON` de termios en cada carácter leído, dejando el bit `ECHO` siempre activo (el eco lo produce el driver de la terminal, no la subrutina). Esto se determinó desensamblando `libpc_io.a` con `objdump -d -Mintel`, ya que el código fuente de la librería no estaba disponible, solo el objeto compilado.

Al alternar `ICANON` carácter por carácter (en vez de una sola vez para toda la cadena), se generaba una condición de carrera entre el tecleo del usuario y el cambio de modo de la terminal, provocando que el carácter terminador `*` se mostrara duplicado en pantalla.

La solución se alcanzó sustituyendo `getche` por `getch` (que apaga tanto `ICANON` como `ECHO`, dando una lectura completamente silenciosa) y agregando un eco manual y explícito con `call putchar`, colocado **después** de la comparación contra `'*'`, de modo que el carácter terminador nunca se imprime.

### `printHex` / `printDec` — impresión de resultados

`printDec` se resolvió con el algoritmo clásico de "división sucesiva entre 10": se usa `div ebx` (con `ebx = 10`) para obtener cociente y residuo en cada paso, se convierte el residuo a ASCII (`add edx, '0'`), y se va llenando el buffer **de derecha a izquierda** (por eso el puntero `edi` empieza en `bufferDec + 11` y se decrementa), ya que el primer dígito obtenido es el de menor peso (unidades). El ciclo continúa mientras el cociente no sea cero.

`printHex` fue proporcionada por el profesor y solo se adaptó a la convención `cdecl` para poder invocarse directamente desde C (agregando el prólogo/epílogo de pila estándar). Su lógica extrae nibbles de 4 bits del valor de 32 bits usando `shr` con un contador que desciende de 28 a 0 en pasos de 4, convirtiendo cada nibble a su carácter hexadecimal correspondiente (dígito o letra `A-F` según corresponda).

### `mostrarCadena` — puente entre C y la `puts` de la librería

Esta función existe únicamente porque la `puts` real de `libpc_io.a` usa una convención de llamada por registro (`EDX` = puntero de cadena), incompatible con `cdecl` (la convención que usa GCC para llamar funciones desde C, donde los argumentos van en la pila). `mostrarCadena` actúa como _wrapper_: recibe el puntero vía `cdecl` (`[ebp+8]`), lo mueve a `EDX`, y llama a la `puts` real de la librería. Esta necesidad de un wrapper fue la pista clave que después ayudó a diagnosticar el error de colisión de nombres descrito abajo.

---

## Dificultades en el desarrollo

### 1. Eco duplicado del carácter terminador `*`

**Síntoma:** al capturar `159*`, la terminal mostraba `159**`.

**Cómo se llegó a la causa:** como la librería solo se tenía compilada (`libpc_io.a`), se extrajo el objeto (`ar x libpc_io.a`) y se desensambló con `objdump -d -Mintel pc_io.o`. Esto mostró que `getche` no llama a ninguna rutina de impresión — el eco lo genera el kernel/driver de la tty porque el bit `ECHO` de termios nunca se apaga, solo se alterna `ICANON` en cada llamada. Esa alternancia por carácter, en vez de una sola vez para toda la cadena, es lo que genera la condición de carrera que duplica el eco del último carácter.

**Solución:** cambiar `getche` por `getch` (apaga `ICANON` **y** `ECHO`) y hacer el eco manual con `putchar`, después de descartar que el carácter sea `'*'`.

### 2. Texto "desaparecido" al usar varios `printf`

**Síntoma:** con varias llamadas seguidas a `printf("texto\n")`, solo se mostraba en pantalla la última (la única que no terminaba en `\n`); las demás no aparecían, sin ningún error visible.

**Cómo se llegó a la causa:** se reprodujo el problema compilando y ejecutando ambas versiones del programa con entrada canalizada por _pipe_, y se usó `strace -e trace=write,read` para ver exactamente qué se escribía a `stdout`. Solo aparecía **un** `write()` con el contenido del último `printf`. Al desensamblar el binario final (`objdump -d -Mintel`), se confirmó que GCC había convertido automáticamente cada `printf("texto\n")` (cadena constante, sin especificadores `%`, terminada en `\n`) en una llamada a `puts("texto")` — una optimización estándar del compilador. El problema es que `libpc_io.a` **también define un símbolo global `puts`**, con una convención de llamada distinta (espera el puntero en `EDX`, no en la pila). El enlazador resolvió el símbolo `puts` usando la versión de la librería ASM en lugar de la de glibc, así que cada `printf` convertido llamaba a la `puts` equivocada, la cual leía basura desde `EDX` y terminaba sin escribir nada.

**Solución:** compilar con `-fno-builtin-printf -fno-builtin-puts` (o `-fno-builtin`) para impedir que GCC sustituya `printf` por `puts`. Como mejora a futuro, se identificó que lo más robusto sería renombrar los símbolos de la librería ASM (por ejemplo `puts` → `puts_lib`) para evitar cualquier colisión con nombres reservados de la librería estándar de C.

### 3. Warnings del enlazador (`ld`)

**a) `missing .note.GNU-stack section implies executable stack`**
El objeto `pc_io.o` (dentro de `libpc_io.a`) no declara la sección `.note.GNU-stack`, y al no tener el `.asm` original de la librería, no se puede recompilar para agregarla.
→ Se solucionó indicándole al enlazador explícitamente que la pila no debe ser ejecutable, con `-Wl,-z,noexecstack`.

**b) `relocation in read-only section .text` / `creating DT_TEXTREL in a PIE`**
GCC genera ejecutables PIE (posición independiente) por defecto, pero el código ASM usa direccionamiento absoluto (no es _Position Independent Code_), obligando al enlazador a permitir reubicaciones sobre una sección de solo lectura.
→ Se solucionó compilando y enlazando como ejecutable no-PIE, con `-fno-pie` (al compilar) y `-no-pie` (al enlazar).

**Comando de build final, integrando las tres soluciones:**

```bash
nasm -f elf32 src/P11_enASM.asm -o output/P11_enASM.o
gcc -m32 -fno-pie -fno-builtin -c src/P11_enC.c -o output/P11_enC.o
gcc -m32 -no-pie -Wl,-z,noexecstack -o output/prog \
    output/P11_enASM.o output/P11_enC.o libpc_io.a
```

### 4. Ausencia del código fuente de la librería (`libpc_io.a`)

Al no contar con el `.asm` original de `libpc_io.a`, fue necesario reconstruir su lógica a partir del binario:

```bash
ar x libpc_io.a               # extraer el .o del archivo .a
objdump -d -Mintel pc_io.o    # desensamblar en sintaxis Intel
objdump -t pc_io.o            # tabla de simbolos (nombres de variables/etiquetas)
objdump -r pc_io.o            # reubicaciones (referencias a .data/.bss)
```

Como el objeto no estaba _stripped_, la tabla de símbolos conservó los nombres reales de las variables internas (`termios`, `c_iflag`, `c_oflag`, `c_cflag`, `c_lflag`, `c_line`, `c_cc`, `cls_cmd`), lo que permitió reconocer que la librería manipula directamente el `struct termios` de Linux vía `ioctl` (`TCGETS`/`TCSETS`), y entender con precisión cómo `getche`/`getch` controlan el eco y el modo de la terminal.
