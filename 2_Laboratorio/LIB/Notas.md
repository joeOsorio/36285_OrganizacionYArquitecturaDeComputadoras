# Laboratorio – Organización y Arquitectura de Computadoras

Esta carpeta contiene los **laboratorios prácticos** desarrollados durante la materia de **Organización y Arquitectura de Computadoras**, enfocados en la aplicación experimental de los conceptos teóricos vistos en clase.

Cada laboratorio se organiza de manera uniforme con la siguiente estructura:

- **docs/**  
  Documentación del laboratorio, incluyendo descripción, reportes, PDFs y recursos específicos.

- **src/**  
  Código fuente en lenguaje ensamblador x86.

- **bin/**  
  Archivos compilados o ejecutables generados a partir del código fuente.

- **out/**  
  Resultados de ejecución, salidas del programa y evidencias (capturas, logs).

Esta organización permite mantener claridad, orden y escalabilidad a lo largo del curso, facilitando la revisión y evaluación de cada laboratorio.

creacion de varias carpetas con la siguiente estructura:

2_Laboratorio
├── L03_Tema
│ ├── README.md
│ ├── docs
│ ├── src
│ ├── bin
│ └── out
├── L04_Tema
└── L05_Tema

usar script bash:
./create_labs.sh

## Compilación y ejecución

Para mantener una estructura ordenada del proyecto, el proceso de compilación se divide en dos etapas: **ensamblado** y **enlazado**.  
Los archivos intermedios se almacenan en la carpeta `out/` y el ejecutable final en `bin/`.

### Estructura relevante

```text

2_Laboratorio
├── L00_Tema
│ ├── README.md
│ ├── docs
│ ├── src
│ ├── bin
│ ├── out
│ └── build.sh
├── L01_Tema
├── L02_Tema
└── LIB
  ├── libpc_io.a
  ├── conio_stubs.c
  ├── my_routines.asm
  ├── pc_io.inc
  └── Notas.md
```

## Ensamblado

El archivo fuente se ensambla utilizando NASM.
Para que NASM pueda localizar correctamente los archivos incluidos (.inc), se especifica la ruta de búsqueda mediante la opción -I.

### codigo bash

```
nasm -f elf32 -Isrc/LIB src/main.asm -o out/main.o
```

Para derle perimisos a buil :

```
chmod +x build.sh
```

## Scrip para automatiar copilacion y ensamblado.

Para utilizar este script primero abre la terminhal y ubicate en la ruta del laboratorio que estes tabajando.
Ejemplo:

```
/Desktop/36285_OrganizacionYArquitecturaDeComputadoras/2_Laboratorio/L00
```

Posteriormete ejecuta el build.sh

```
./build.sh
```

## Notas de errores encontrados — Práctica 11 (OAC)

### 1. Eco duplicado del carácter terminador `*`

**Síntoma:** Al capturar la cadena con `gets` (ASM), el carácter `*` aparecía duplicado en pantalla (ej. `159**` en lugar de `159*`), aunque el buffer se guardaba correctamente.

**Causa:** La subrutina `getche` (de `libpc_io.a`) no imprime el eco por software; lo produce el driver de la terminal de Linux, porque `getche` solo alterna el bit `ICANON` de termios en cada llamada (carácter por carácter), dejando el bit `ECHO` siempre activo. Alternar `ICANON` por cada carácter, en vez de una sola vez para toda la cadena, genera una condición de carrera entre el tecleo del usuario y el cambio de modo de la terminal, provocando que el driver reprocese/duplique el eco del último carácter leído.

**Solución:** Sustituir `getche` por `getch` (apaga tanto `ICANON` como `ECHO`) dentro del ciclo de `gets`, y hacer el eco manualmente con `call putchar` justo después de verificar que el carácter no es el terminador `*`.

---

### 2. Texto "desaparecido" en `printf` (colisión de nombres con `puts`)

**Síntoma:** Varias llamadas consecutivas a `printf("texto\n")` no mostraban nada en pantalla; solo se veía el último `printf` (el que no terminaba en `\n`).

**Causa:** GCC optimiza automáticamente todo `printf("texto literal\n")` (sin especificadores `%`) convirtiéndolo en una llamada a `puts("texto literal")`. El problema es que `libpc_io.a` **también define un símbolo global `puts`**, pero con una convención de llamada distinta (espera el puntero de la cadena en el registro `EDX`, no en la pila). Al enlazar, el linker resuelve `puts` usando la versión de la librería ASM en vez de la de glibc. Como GCC pasa el argumento por la pila (convención estándar de `puts`), `EDX` queda con basura, la rutina lee un `0` de inmediato, y termina sin escribir nada — sin error ni crash visible.

**Verificación:** confirmado en el desensamblado — las llamadas a `printf("...\n")` se compilaban como `call <puts>` (símbolo local de `libpc_io.a`), no `call puts@plt` (glibc).

**Solución:** compilar con `-fno-builtin-printf -fno-builtin-puts` (o `-fno-builtin`) para evitar que GCC sustituya `printf` por `puts` silenciosamente. A futuro, lo más robusto sería renombrar los símbolos de la librería ASM (`puts` → `puts_lib`, etc.) para que nunca choquen con nombres estándar de C.

---

### 3. Warnings del linker

**a) `missing .note.GNU-stack section implies executable stack` (en `pc_io.o`)**
El objeto de la librería no declara si necesita pila ejecutable o no (sección `.note.GNU-stack` ausente, porque no se puede editar el `.asm` original, solo se tiene el `.o`/`.a`).
→ Solución: enlazar con `-Wl,-z,noexecstack` para forzar pila no-ejecutable sin necesidad de recompilar la librería.

**b) `relocation in read-only section .text` / `creating DT_TEXTREL in a PIE`**
GCC genera ejecutables PIE por defecto (código independiente de posición). El código ASM usa direccionamiento absoluto (no es PIC), por lo que el linker debe permitir reubicaciones sobre `.text` (de solo lectura), marcando el binario como `DT_TEXTREL`.
→ Solución: compilar/enlazar como no-PIE con `-no-pie` (y `-fno-pie` al compilar el `.c`).

**Build final recomendado:**

```bash
nasm -f elf32 src/P11_enASM.asm -o output/P11_enASM.o
gcc -m32 -fno-pie -fno-builtin -c src/P11_enC.c -o output/P11_enC.o
gcc -m32 -no-pie -Wl,-z,noexecstack -o output/prog \
    output/P11_enASM.o output/P11_enC.o libpc_io.a
```
