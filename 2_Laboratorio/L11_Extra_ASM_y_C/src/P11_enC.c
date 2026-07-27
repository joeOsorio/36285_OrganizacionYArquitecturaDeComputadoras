/* ============================================================
 * P11_enC.c
 * Practica 11 - OAC (Linux)
 * Captura una cadena numerica, la muestra, la convierte a
 * decimal y la imprime en hexadecimal y decimal usando
 * subrutinas escritas en ensamblador (P11_enASM.asm), las
 * cuales reutilizan puts/getche de la libreria compartida LIB.
 *
 * Nota: NO se incluye <stdlib.h> a proposito, para que el
 * "atoi" propio (con otra firma) no choque con el de la
 * libreria estandar de C.
 * ============================================================ */

#include <stdio.h>
/* Subrutinas implementadas en P11_enASM.asm (cdecl) */
extern void gets(char *direccion_donde_se_guarda_la_cadena_capturada);
extern unsigned int atoi(char *cadena_con_numero);
extern void printHex(unsigned int valor_a_imprimir);
extern void printDec(unsigned int valor_a_imprimir);
extern void mostrarCadena(char *cadena); /* reutiliza "puts" de la LIB */

extern void clrscr(void);

#define TAM_BUFFER 100

int main(void)
{
    // char cadena[TAM_BUFFER];
    // unsigned int valor;

    clrscr();
    // printf("\n=== Practica 11 - OAC ===\nIngresa una cadena de caracteres numericos terminada en '*'\nEjemplo: 12345*\nCadena: ");
    // fflush(stdout);

    char cadena[TAM_BUFFER];
    unsigned int valor;

    fflush(stdout);
    printf("=== Practica 11 - OAC ===\n");
    printf("Ingresa una cadena de caracteres numericos terminada en '*'\n");
    printf("Ejemplo: 12345*\n");
    printf("Cadena: ");
    fflush(stdout);

    gets(cadena);

    printf("\nSalida de puts:      ");
    fflush(stdout);
    mostrarCadena(cadena);

    valor = atoi(cadena);

    printf("\nSalida de printHex:  ");
    fflush(stdout);
    printHex(valor);

    printf("\nSalida de printDec:  ");
    fflush(stdout);
    printDec(valor);
    printf("\n");

    return 0;
}