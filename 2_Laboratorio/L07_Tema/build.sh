#!/bin/bash

set -e  # Detiene el script si hay error

echo "Ensamblando..."
nasm -f elf32 -Isrc/LIB src/main.asm -o output/main.o

echo "Enlazando..."
ld -m elf_i386 -s -o bin/main output/main.o src/LIB/libpc_io.a

echo "Ejecutando..."
./bin/main