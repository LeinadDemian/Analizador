%{
#include <stdio.h>
#include <stdlib.h>
extern char* yytext;
extern FILE *yyin;
char *Lexema[100], *Token[100];
int SubIndice=0, SubIndiceMax, NumLineas=1, EstadoScanner=0;
int control;
int A;
extern int errorl;
%}

%token exprex apare cpare letter number atom_part empty NL
%start list

%%

list: apare aux empty NL 	               { printf("\n** Cadena valida. **\n"); DibujarTodo(1); return 0; }
   | apare aux letter atom_part NL		   { printf("\n** Cadena valida. **\n"); DibujarTodo(2); return 0; }
   | apare aux number atom_part NL 		   { printf("\n** Cadena valida. **\n"); DibujarTodo(3); return 0; }
   ;

aux : s_expression aux                     { printf("\n%s", yytext); }
    | s_expression cpare                   { printf("\n%s", yytext); }
;

s_expression: exprex                       { printf("\n%s", yytext); }	
;

%%

int yyerror(){
        if(A==1)/*Si el error proviene de un archivo de texto*/{
                if(errorl>0){
                        printf("\nError lexico en la cadena ingresada.\n");
                }else{
                        printf("\nError sintactico en la cadena ingresada.\n");
                }
                return 0;
        }
        if(errorl>0){
                printf("\nError lexico en la cadena ingresada.\n");
        }else{
                printf("\nError sintactico en la cadena ingresada.\n");
        }
        printf("\nPresione cualquier tecla para continuar!\n");
        getch();
        system("cls");/*Limpia la pantalla*/
        errorl=0;
        printf("\nIngrese una nueva cadena:\n");
        yyparse();
}

int main(){
        yyin=fopen("Cadena.txt","rt");
        if(yyin==NULL)/*Si no se detecto ningun archivo de texto*/{
                printf("No se encontro ningun archivo de texto para analizar!\n");
                printf("\nIngrese una cadena:\n");
        }else{
                A=1;
                printf("Analizando archivo de texto...\n");
        }
        yyparse();
        getch();
}

int DibujarTodo(int SubParam) {
	TablaTokens();
	ArbolDeDerivacion(SubParam);
	return 0;
}

int TablaTokens() {
	int ContAuxT, ContAuxK;
	int LargoToken, LargoIzq, LargoDer;

	printf("\n===============================TABLA DE SIMBOLOS===============================\n");
	printf("|                LEXEMAS               |                 TOKENS               |\n");
	printf("---------------------------------------+---------------------------------------\n");

	for (ContAuxK = 0; ContAuxK < SubIndiceMax; ContAuxK++) {
		LargoToken = 38 - strlen(Lexema[ContAuxK]);
		if ((LargoToken & 1) == 0) {
			LargoIzq = LargoToken / 2;
		} else {
			LargoIzq = (LargoToken + 1) / 2;
		}
		LargoDer = LargoToken - LargoIzq;
		printf("|");
		for (ContAuxT = 0; ContAuxT < LargoIzq; ContAuxT++) {
			printf(" ");
		}
		printf("%s", Lexema[ContAuxK]);
		for (ContAuxT = 0; ContAuxT < LargoDer; ContAuxT++) {
			printf(" ");
		}
		printf("|");
	
		LargoToken = 38 - strlen(Token[ContAuxK]);
		if ((LargoToken & 1) == 0) {
			LargoIzq = LargoToken / 2;
		} else {
			LargoIzq = (LargoToken + 1) / 2;
		}
		LargoDer = LargoToken - LargoIzq;
		for (ContAuxT = 0; ContAuxT < LargoIzq; ContAuxT++) {
			printf(" ");
		}
		printf("%s", Token[ContAuxK]);
		for (ContAuxT = 0; ContAuxT < LargoDer; ContAuxT++) {
			printf(" ");
		}
		printf("|\n");
	}
	printf("===============================================================================\n\n\n");
	return 0;
}

void ArbolDeDerivacion(int tipo) {
	printf("\n-------------------------ARBOL DE DERIVACION------------------------- \n");
	printf("\n                                 list                                 \n");
	printf("\n                                  |                                   \n");

	switch (tipo) {
	case 1:	
		printf("\n                                  |                                    \n");
		printf("\n                                  |                                   \n");
		printf("\n                 (s_expresion)           empty                                 \n");
		printf("\n                      |                    |                       \n");
		printf("\n                  (exprex)               vacio                      \n");
		printf("\n                                                                   \n");
		printf("\n                                                                      \n");
		printf("\n                                                                      \n");
		printf("\n                                                                      \n");
		break;
	
	case 2:
		
		printf("\n                                  |                                   \n");
		printf("\n                  (s_expression)           leter atom_part            \n");
		printf("\n                        |                           |                 \n");
		printf("\n           (s_expression s_expression)             part               \n");
		printf("\n                                                                      \n");
		printf("\n                                                                      \n");
		printf("\n                                                                      \n");	
		break;
		
	
	case 3:
		
		printf("\n                                  |                                   \n");
		printf("\n                  (s_expression)          number atom_part            \n");
		printf("\n                        |                                             \n");
		printf("\n           (s_expression s_expression)                                \n");
		printf("\n                                                                      \n");
		printf("\n                                                                      \n");
		printf("\n                                                                      \n");	
		break;
		
	}
	yyparse();
    getch();
}

int EscribirCentrado(int CenUno, char* CadUno, int CenDos, char* CadDos, int CenTres, char* CadTres) {
	int Longitud, MaxLineas, MaxEspacios, K;

	Longitud = strlen(CadUno);
	MaxEspacios = CenUno - (Longitud / 2) - 1;
	for (K = 0; K < MaxEspacios; K++) {
		printf(" ");
	}
	printf("%s", CadUno);

	if (CenDos == 0) {
		printf("\n");
		return 0;
	}

	MaxLineas = MaxEspacios + Longitud;

	Longitud = strlen(CadDos);
	MaxEspacios = CenDos - (Longitud / 2) - MaxLineas - 1;
	for (K = 0; K < MaxEspacios; K++) {
		printf(" ");
	}
	printf("%s", CadDos);

	if (CenTres == 0) {
		printf("\n");
		return 0;
	}

	MaxLineas += MaxEspacios + Longitud;

	Longitud = strlen(CadTres);
	MaxEspacios = CenTres - (Longitud / 2) - MaxLineas - 1;
	for (K = 0; K < MaxEspacios; K++) {
		printf(" ");
	}
	printf("%s\n", CadTres);

	return 0;
}
