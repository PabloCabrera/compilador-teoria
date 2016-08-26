%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
FILE *yyin;
int yylval;
char *yyltext;
%}

DIGITO	[0-9]
MINUSCULA 	[a-z]
MAYUSCULA 	[A-Z]
COMA	[","]
PUNTO_DECIMAL ["."]
GUION_BAJO	[_]

IDENTIFICADOR ({LETRA}|{GUION_BAJO})({LETRA}|{DIGITO}|{GUION_BAJO})*
CONSTANTE_REAL	{DIGITO}+{PUNTO_DECIMAL}{DIGITO}
CONSTANTE_ENTERA	{DIGITO}+
LETRA	 {MINUSCULA}|{MAYUSCULA}


%%

{CONSTANTE_ENTERA}	{ printf("\n Constante entera: %s\n", yytext); }
{CONSTANTE_REAL}	{ printf("\n Constante real: %s\n", yytext); }
{IDENTIFICADOR}	{ printf("\n identificador: %s\n", yytext); }

"\n"
"\t"

%%

int main(int argc,char *argv[]){
	if ((yyin = fopen(argv[1], "rt")) == NULL)	{
		printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
	} else {
		yylex();
	}
	fclose(yyin);
	return 0;
}

int yyerror(void) {
	printf("Syntax Error\n");
	system ("Pause");
	exit (1);
}
