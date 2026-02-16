# Guía para ensamblar, enlazar y ejecutar (NASM x86 32 bits)

Este documento explica **cómo ensamblar, enlazar y ejecutar** el programa en ensamblador x86 de 32 bits (Linux), así como una **explicación detallada de cada sección e instrucción** del código.

---

## 1. Requisitos previos

Antes de comenzar, asegúrate de contar con:

* **Linux** (codeSpace)
* **NASM** (Netwide Assembler)
* Arquitectura **x86 de 32 bits** habilitada

Instalación en Debian/Ubuntu:

```bash
sudo apt update
sudo apt install nasm gcc-multilib
```

---

## 2. Estructura del proyecto

Se recomienda la siguiente estructura de carpetas:

```
L02_Introduccion 
├── src 
│ ├── main.asm
│ └── LIB
│      └── libpc_io.a 
├── out 
│ └── main.o 
└── bin 
     └── main
```

El archivo `pc_io.inc` contiene macros o rutinas auxiliares para entrada/salida como `puts` y `getche`.

---

## 3. Código fuente analizado

```asm
%include "./pc_io.inc"

section .data	; Datos inicializados
    msg1: db "Ingresa tu nombre",10,0
    msg2: db "Hola ",0
    msj:  db 'Ingrese un digito (0-9)',0x0A
    len:  equ $-msj

section .bss	; Datos no inicializados
    num1    resb 1
    nombre  resb 256

section .text
    global _start:

_start:
    mov edx, msg1
    call puts

    mov ebx, nombre

capturar:
    call getche
    mov byte [ebx], al
    inc ebx
    cmp al, 10
    jne capturar
    mov byte [ebx], 0

    mov edx, msg2
    call puts

    mov edx, nombre
    call puts

    mov eax, 1
    mov ebx, 0
    int 80h
```

---

## 4. Explicación por secciones

### 4.1 Inclusión de librerías

```asm
%include "./pc_io.inc"
```

Incluye un archivo externo con macros/rutinas de entrada y salida. Permite usar funciones como:

* `puts` → imprime una cadena
* `getche` → lee un carácter del teclado y lo muestra en pantalla

---

### 4.2 Sección `.data` (datos inicializados)

```asm
section .data
```

Contiene datos conocidos en tiempo de compilación.

```asm
msg1: db "Ingresa tu nombre",10,0
```

* Cadena de texto
* `10` → salto de línea (LF)
* `0` → fin de cadena (null-terminated)

```asm
msg2: db "Hola ",0
```

Mensaje de saludo.

```asm
msj: db 'Ingrese un digito (0-9)',0x0A
len: equ $-msj
```

* `len` calcula la longitud del mensaje usando el contador de ubicación `$`.

---

### 4.3 Sección `.bss` (datos no inicializados)

```asm
section .bss
```

Reserva espacio en memoria sin inicializar.

```asm
num1 resb 1
```

Reserva 1 byte.

```asm
nombre resb 256
```

Reserva un buffer de 256 bytes para almacenar el nombre ingresado.

---

### 4.4 Sección `.text` (código)

```asm
section .text
global _start
```

* `.text` contiene instrucciones ejecutables.
* `_start` es el punto de entrada del programa en Linux.

---

## 5. Explicación instrucción por instrucción

```asm
mov edx, msg1
call puts
```

* `edx` apunta a la dirección del mensaje
* `puts` imprime la cadena

---

```asm
mov ebx, nombre
```

* `ebx` se usa como puntero al buffer `nombre`

---

### Bucle de captura de caracteres

```asm
capturar:
    call getche
```

* Lee un carácter del teclado
* El carácter queda en el registro `AL`

```asm
mov byte [ebx], al
```

* Guarda el carácter en el buffer

```asm
inc ebx
```

* Avanza el puntero al siguiente byte

```asm
cmp al, 10
jne capturar
```

* Compara el carácter con `10` (Enter)
* Si no es Enter, continúa el bucle

```asm
mov byte [ebx], 0
```

* Agrega el terminador nulo al final de la cadena

---

### Impresión del saludo

```asm
mov edx, msg2
call puts
```

Imprime "Hola ".

```asm
mov edx, nombre
call puts
```

Imprime el nombre capturado.

---

### Finalización del programa

```asm
mov eax, 1
mov ebx, 0
int 80h
```

* `eax = 1` → syscall `exit`
* `ebx = 0` → código de salida
* `int 80h` → llamada al sistema

---

## 6. Ensamblado del programa

Desde la carpeta del proyecto: "L02_Introduccion "

```bash
nasm -f elf32 -Isrc/LIB src/main.asm -o out/main.o
```

* `-f elf32` → formato ELF de 32 bits
* `main.o` → archivo objeto
* '-I src/LIB' → le dice a NASM: “si ves un %include, búscalo aquí”

---

## 7. Enlazado

```bash
ld -m elf_i386 -o bin/main out/main.o src/LIB/libpc_io.a
```

* `-m elf_i386` → enlazado para arquitectura de 32 bits
* `main` → ejecutable final

---

## 8. Ejecución

```bash
./main
```

Salida esperada:

```
Ingresa tu nombre
Joshua
Hola Joshua
```

---

## 9. Observaciones técnicas

* El programa utiliza **syscalls Linux clásicas (int 80h)**
* Es compatible con sistemas modernos solo si soportan binarios de 32 bits
* El manejo de cadenas se basa en buffers terminados en `0`

---

## 10. Posibles mejoras

* Validar longitud máxima del nombre
* Manejar backspace
* Usar `sys_read` en lugar de `getche`
* Migrar a `x86_64` con `syscall`

---

> Documento pensado para **prácticas académicas de Ensamblador x86 (IA-32)**.