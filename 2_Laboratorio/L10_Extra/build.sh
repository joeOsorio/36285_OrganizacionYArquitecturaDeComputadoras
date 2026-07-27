#!/bin/bash
set -e  # Detiene el script si hay error

echo "Ensamblando P11_enASM..."
nasm -f elf32 -I../LIB src/P11_enASM.asm -o output/P11_enASM.o
echo "Compilando P11_enC..."
gcc -m32 -fno-pie -fno-builtin -c src/P11_enC.c -o output/P11_enC.o
 
echo "Enlazando P11_enASM, P11_enC y libpc_io.a..."

gcc -m32 -Wl,-z,noexecstack -o bin/Program_P11 output/P11_enASM.o output/P11_enC.o ../LIB/libpc_io.a
echo "Ejecutando..."
./bin/Program_P11