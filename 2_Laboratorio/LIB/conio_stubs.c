// conio_stubs.c
#include <stdio.h>
#include <windows.h>

// Limpiar pantalla
void clrscr(void) {
    system("cls");
}

// Leer carácter sin eco (getch) - no muestra lo que se teclea
int getch(void) {
    HANDLE hStdin = GetStdHandle(STD_INPUT_HANDLE);
    DWORD mode, nRead;
    char c;
    
    GetConsoleMode(hStdin, &mode);
    SetConsoleMode(hStdin, mode & ~ENABLE_ECHO_INPUT & ~ENABLE_LINE_INPUT);
    ReadConsole(hStdin, &c, 1, &nRead, NULL);
    SetConsoleMode(hStdin, mode);
    return c;
}

// Leer carácter con eco (getche) - muestra lo que se teclea
int getche(void) {
    HANDLE hStdin = GetStdHandle(STD_INPUT_HANDLE);
    DWORD mode, nRead;
    char c;
    
    GetConsoleMode(hStdin, &mode);
    SetConsoleMode(hStdin, mode & ~ENABLE_LINE_INPUT);
    ReadConsole(hStdin, &c, 1, &nRead, NULL);
    SetConsoleMode(hStdin, mode);
    putchar(c);  // Mostrar el carácter
    return c;
}