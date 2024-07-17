%option noyywrap
%{
#include <string.h>
#include <stdio.h>
#include "sintactico.tab.h"
extern char *Lexema[100], *Token[100];
extern int SubIndice, SubIndiceMax, NumLineas, errorl=0;
%}

letter [A-Za-z]
number [0-9]+
exprex [A-Za-z]+
enter \n

%%

"("           { CargarTabla("apare"); return apare;}
")"           { CargarTabla("cpare"); return cpare;}
"part"        { CargarTabla("part"); return atom_part;}
"vacio"           { CargarTabla("empty"); return empty;}
{number}      { CargarTabla("number"); return number;}
{letter}      { CargarTabla("letter"); return letter;}
{exprex}      { CargarTabla("exprex"); return exprex;}

[ \t]+        { /* Ignorar espacios en blanco y tabulaciones */ }
{enter}       { 
    SubIndiceMax = SubIndice; 
    SubIndice = 0; 
    NumLineas++; 
    return NL; 
}
.             { errorl = 1; return yytext[0]; }
%%

int CargarTabla(char* NomToken) {
    Lexema[SubIndice] = (char*)malloc((strlen(yytext) + 1) * sizeof(char));
    strcpy(Lexema[SubIndice], yytext);
    Token[SubIndice] = (char*)malloc((strlen(NomToken) + 1) * sizeof(char));
    strcpy(Token[SubIndice], NomToken);
    SubIndice++;
    return 0;
}
