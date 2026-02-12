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
.
├── src
│   ├── main.asm
│   └── LIB
│       ├── pc_io.inc
│       └── libpc_io.a
├── out
└── bin


## Ensamblado

El archivo fuente se ensambla utilizando NASM.
Para que NASM pueda localizar correctamente los archivos incluidos (.inc), se especifica la ruta de búsqueda mediante la opción -I.

### codigo bash

nasm -f elf32 -Isrc/LIB src/main.asm -o out/main.o
