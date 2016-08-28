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
GUION_BAJO	["_"]
OP_MAYOR [">"]
OP_MENOR	["<"]
SIMBOLO_IGUAL ["="]
SIMBOLO_EXCLAMACION ["!"]
OP_ASIGNACION [":"]
OP_SUMA ["+"]
OP_RESTA "-"
OP_MULTIPLICACION ["*"]
OP_DIVISION ["/"]
INICIO_PARENTESIS ["("]
FIN_PARENTESIS [")"]
INICIO_CORCHETE ["["]
FIN_CORCHETE ["]"]
INICIO_BLOQUE ["{"]
FIN_BLOQUE ["}"]
FIN_SENTENCIA [";"]
COMILLA_SIMPLE ["'"]
ESPACIO [" "]

RESERVADA_WRITE ["WRITE"]
RESERVADA_IF ["IF"]
RESERVADA_WHILE ["WHILE"]
RESERVADA_FLOAT ["FLOAT"]
RESERVADA_INTEGER ["INTEGER"]
RESERVADA_STRING ["STRING"]
RESERVADA_DECVAR ["DECVAR"]
RESERVADA_ENDDEC ["ENDDEC"]
RESERVADA_AVG ["AVG"]
RESERVADA_FALSE ["FALSE"]
RESERVADA_TRUE ["TRUE"]
RESERVADA_NULL ["NULL"]

IDENTIFICADOR ({LETRA}|{GUION_BAJO})({LETRA}|{DIGITO}|{GUION_BAJO})*
CONSTANTE_REAL	({DIGITO}+{PUNTO_DECIMAL}{DIGITO}*)|({PUNTO_DECIMAL}{DIGITO}+)
CONSTANTE_ENTERA	{DIGITO}+
LETRA	 ({MINUSCULA}|{MAYUSCULA})
OP_IGUAL ({SIMBOLO_IGUAL}{SIMBOLO_IGUAL})
OP_MAYOR_IGUAL ({OP_MAYOR}{SIMBOLO_IGUAL})
OP_MENOR_IGUAL ({OP_MENOR}{SIMBOLO_IGUAL})
OP_DISTINTO ({SIMBOLO_EXCLAMACION}{SIMBOLO_IGUAL})
CONSTANTE_STRING ({LETRA}|{DIGITO}|{ESPACIO})*
CONDICION_MAYOR ({IDENTIFICADOR}{OP_MAYOR}{IDENTIFICADOR} )
CONDICION_MAYOR_IGUAL ({IDENTIFICADOR}{OP_MAYOR_IGUAL}{IDENTIFICADOR})
CONDICION_MENOR ({IDENTIFICADOR}{OP_MENOR}{IDENTIFICADOR})
CONDICION_MENOR_IGUAL ({IDENTIFICADOR}{OP_MENOR_IGUAL}{IDENTIFICADOR})
CONDICION_IGUAL ({IDENTIFICADOR}{OP_IGUAL}{IDENTIFICADOR})
CONDICION_DISTINTO ({IDENTIFICADOR}{OP_DISTINTO}{IDENTIFICADOR})
INICIO_COMENTARIO ({OP_RESTA}{OP_DIVISION})
FIN_COMENTARIO ({OP_DIVISION}{OP_RESTA})
COMENTARIO ({INICIO_COMENTARIO}{CONSTANTE_STRING}{FIN_COMENTARIO})
%%

{CONSTANTE_ENTERA}	{ printf("\n Constante entera: %s\n", yytext); }
{CONSTANTE_REAL}	{ printf("\n Constante real: %s\n", yytext); }
{IDENTIFICADOR}	{ printf("\n identificador: %s\n", yytext); }
{CONSTANTE_STRING}	{ printf("\n Constante string: %s\n", yytext); }
{OP_MAYOR_IGUAL} { printf("\n Operador mayor igual: %s\n", yytext); }
{CONDICION_MAYOR_IGUAL} { printf("\n Condicion mayor igual: %s\n", yytext); }
{CONDICION_MENOR_IGUAL} { printf("\n Condicion menor igual: %s\n", yytext); }
{OP_SUMA} { printf("\n Operador suma: %s\n", yytext); }
{OP_RESTA} { printf("\n Operador resta: %s\n", yytext); }
{INICIO_COMENTARIO} { printf("\n Inicio comentario: %s\n", yytext); }
{FIN_COMENTARIO} { printf("\n Fin comentario: %s\n", yytext); }
{COMENTARIO} { printf("\n Comentario: %s\n", yytext); }
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
