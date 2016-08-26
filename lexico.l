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
INICIO_COMENTARIO ["-/"]
FIN_COMENTARIO ["/-"]
OP_MAYOR [">"]
OP_MENOR	["<"]
OP_IGUAL ["=="]
OP_MAYOR_IGUAL [">="]
OP_MENOR_IGUAL ["<="]
OP_DISTINTO ["!="]
OP_ASIGNACION [":"]
OP_SUMA ["+"]
OP_RESTA ["-"]
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
CONSTANTE_STRING
LETRA	 {MINUSCULA}|{MAYUSCULA}
COMENTARIOS 
ESTRUCTURA_CONDICIONAL_IF
ESTRUCTURA_CICLO_WHILE
SENTENCIA
BLOQUE
DECLARACION_VARIABLE
SALIDA_WRITE
FUNCION_AVG
OPERACION_MATEMATICA_INTEGER
OPERACION_MATEMATICA_FLOAT
CONDICION



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
