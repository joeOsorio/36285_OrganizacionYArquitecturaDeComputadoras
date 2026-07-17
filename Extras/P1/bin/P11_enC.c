/* ============================================================
 * P11_enC.c
 * Practica 11 - OAC
 * Captura una cadena numerica, la muestra, la convierte a
 * decimal y la imprime en hexadecimal y decimal usando
 * subrutinas escritas en ensamblador (P11_enASM.asm)
 * ============================================================ */

#include <stdio.h>

/* Subrutinas implementadas en P11_enASM.asm */
extern void gets(int *direccion_donde_se_guarda_la_cadena_capturada);
extern unsigned int atoi(int *cadena_con_numero);
extern void printHex(unsigned int valor_a_imprimir);
extern void printDec(unsigned int valor_a_imprimir);

#define TAM_BUFFER 100

int main(void)
{
    char cadena[TAM_BUFFER];
    unsigned int valor;

    printf("=== Practica 11 - OAC ===\n");
    printf("Ingresa una cadena de caracteres numericos terminada en '*'\n");
    printf("Ejemplo: 12345*\n");
    printf("Cadena: ");

    gets((int *)cadena);

    printf("\nSalida de puts:      ");
    puts(cadena);

    valor = atoi((int *)cadena);

    printf("Salida de printHex:  ");
    printHex(valor);

    printf("Salida de printDec:  ");
    printDec(valor);

    return 0;
}