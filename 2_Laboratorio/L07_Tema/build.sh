#!/bin/bash

# Ensamblar
nasm -f elf32 -Isrc/LIB src/main.asm -o output/main.o

# Enlazar
ld -m elf_i386 -s -o bin/main output/main.o src/LIB/libpc_io.a

# Ejecutar
./bin/main