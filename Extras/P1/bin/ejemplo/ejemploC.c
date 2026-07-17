#include <stdio.h>
extern int sumaLista(int *arreglo, int tamanio);

int main(void)
{
    int arreglo[] = {1, 2, 3, 4, 5};
    int tamanio = 5;
    int suma = sumaLista(arreglo, tamanio);
    printf("Suma: %d\n", suma);
    return 0;
}