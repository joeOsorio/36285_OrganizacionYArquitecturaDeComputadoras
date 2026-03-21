#!/bin/bash
# ============================================================
# build.sh
# Ejecutar desde la carpeta del lab: ./build.sh
# ============================================================
set -e  # Detiene el script si hay error

LIB="../LIB"   # ruta a 2_Laboratorio/LIB/

mkdir -p output bin


echo "Ensamblando main.asm..."
nasm -f elf32 -I"$LIB/" src/main.asm -o output/main.o || exit 1

echo "Enlazando..."
ld -m elf_i386 -s -o bin/main \
    output/main.o \
    "$LIB/libpc_io.a" || exit 1

echo "Ejecutando..."
./bin/main