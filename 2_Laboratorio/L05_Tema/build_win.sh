#!/bin/bash
set -e

LIB="../LIB"

# Crear solo la implementación de clrscr
cat > clrscr_stub.c << 'EOF'
#include <stdlib.h>

void clrscr(void) {
    system("cls");
}
EOF

echo "=== Compilando clrscr stub ==="
gcc -m32 -c clrscr_stub.c -o clrscr_stub.o

echo "=== Compilando main ==="
mkdir -p output bin
nasm -f win32 -I"$LIB/" src/main.asm -o output/main.o

echo "=== Enlazando ==="
# Enlazar con la biblioteca estándar de consola
gcc -m32 output/main.o clrscr_stub.o -o bin/main.exe -lmsvcrt

echo "=== Ejecutando ==="
./bin/main.exe