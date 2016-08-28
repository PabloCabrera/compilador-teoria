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
LETRA	 ({MINUSCULA}|{MAYUSCULA})
COMA	","
PUNTO_DECIMAL "."
GUION_BAJO	"_"
OP_MAYOR ">"
OP_MENOR	"<"
SIMBOLO_IGUAL "="
SIMBOLO_EXCLAMACION "!"
OP_ASIGNACION ":"
OP_SUMA "+"
OP_RESTA "-"
OP_MULTIPLICACION "*"
OP_DIVISION "/"
INICIO_PARENTESIS "("
FIN_PARENTESIS ")"
INICIO_CORCHETE "["
FIN_CORCHETE "]"
INICIO_BLOQUE "{"
FIN_BLOQUE "}"
FIN_SENTENCIA ";"
COMILLA_SIMPLE "'"
COMILLA_DOBLE "\""
ESPACIO [ \t\n]
INICIO_COMENTARIO "-/"
FIN_COMENTARIO "/-"

RESERVADA_WRITE "(?i:WRITE)"
RESERVADA_IF "(?i:IF)"
RESERVADA_WHILE "(?i:WHILE)"
RESERVADA_FLOAT "(?i:FLOAT)"
RESERVADA_INTEGER "(?i:INTEGER)"
RESERVADA_STRING "(?i:STRING)"
RESERVADA_DECVAR "(?i:DECVAR)"
RESERVADA_ENDDEC "(?i:ENDDEC)"
RESERVADA_AVG "(?i:AVG)"
RESERVADA_FALSE "(?i:FALSE)"
RESERVADA_TRUE "(?i:TRUE)"
RESERVADA_NULL "(?i:NULL)"

IDENTIFICADOR ({LETRA}|{GUION_BAJO})({LETRA}|{DIGITO}|{GUION_BAJO})*

CONSTANTE_REAL	({DIGITO}+{PUNTO_DECIMAL}{DIGITO}*)|({PUNTO_DECIMAL}{DIGITO}+)
CONSTANTE_ENTERA	{DIGITO}+
CONSTANTE_STRING ({COMILLA_SIMPLE}([^'])*{COMILLA_SIMPLE})|({COMILLA_DOBLE}([^"])*{COMILLA_DOBLE})

OP_IGUAL ({SIMBOLO_IGUAL}{SIMBOLO_IGUAL})
OP_MAYOR_IGUAL ({OP_MAYOR}{SIMBOLO_IGUAL})
OP_MENOR_IGUAL ({OP_MENOR}{SIMBOLO_IGUAL})
OP_DISTINTO ({SIMBOLO_EXCLAMACION}{SIMBOLO_IGUAL})
CONDICION_MAYOR ({IDENTIFICADOR}{OP_MAYOR}{IDENTIFICADOR} )
CONDICION_MAYOR_IGUAL ({IDENTIFICADOR}{OP_MAYOR_IGUAL}{IDENTIFICADOR})
CONDICION_MENOR ({IDENTIFICADOR}{OP_MENOR}{IDENTIFICADOR})
CONDICION_MENOR_IGUAL ({IDENTIFICADOR}{OP_MENOR_IGUAL}{IDENTIFICADOR})
CONDICION_IGUAL ({IDENTIFICADOR}{OP_IGUAL}{IDENTIFICADOR})
CONDICION_DISTINTO ({IDENTIFICADOR}{OP_DISTINTO}{IDENTIFICADOR})
COMENTARIO ({INICIO_COMENTARIO}({LETRA}|{ESPACIO}|{DIGITO})*{FIN_COMENTARIO})
%%

{RESERVADA_WRITE} { printf("\n PALABRA RESERVADA: %s\n", yytext); }
{RESERVADA_IF} { printf("\n PALABRA RESERVADA: %s\n", yytext); }
{RESERVADA_WHILE} { printf("\n PALABRA RESERVADA: %s\n", yytext); }
{RESERVADA_FLOAT} { printf("\n PALABRA RESERVADA: %s\n", yytext); }
{RESERVADA_INTEGER} { printf("\n PALABRA RESERVADA: %s\n", yytext); }
{RESERVADA_STRING} { printf("\n PALABRA RESERVADA: %s\n", yytext); }
{RESERVADA_DECVAR} { printf("\n PALABRA RESERVADA: %s\n", yytext); }
{RESERVADA_ENDDEC} { printf("\n PALABRA RESERVADA: %s\n", yytext); }
{RESERVADA_AVG} { printf("\n PALABRA RESERVADA: %s\n", yytext); }
{RESERVADA_FALSE} { printf("\n PALABRA RESERVADA: %s\n", yytext); }
{RESERVADA_TRUE} { printf("\n PALABRA RESERVADA: %s\n", yytext); }
{RESERVADA_NULL} { printf("\n PALABRA RESERVADA: %s\n", yytext); }

{IDENTIFICADOR}	{ printf("\n identificador: %s\n", yytext); }

{CONSTANTE_REAL}	{ printf("\n Constante real: %s\n", yytext); }
{CONSTANTE_ENTERA}	{ printf("\n Constante entera: %s\n", yytext); }
{CONSTANTE_STRING}	{ printf("\n Constante string: %s\n", yytext); }

{CONDICION_MAYOR_IGUAL} { printf("\n Condicion mayor igual: %s\n", yytext); }
{CONDICION_MENOR_IGUAL} { printf("\n Condicion menor igual: %s\n", yytext); }

{OP_IGUAL} { printf("\n Operador igual: %s\n", yytext); }
{OP_DISTINTO} { printf("\n Operador distinto: %s\n", yytext); }
{OP_MAYOR} { printf("\n Operador mayor: %s\n", yytext); }
{OP_MAYOR_IGUAL} { printf("\n Operador mayor igual: %s\n", yytext); }
{OP_MENOR_IGUAL} { printf("\n Operador menor igual: %s\n", yytext); }
{OP_SUMA} { printf("\n Operador suma: %s\n", yytext); }
{OP_RESTA} { printf("\n Operador resta: %s\n", yytext); }
{OP_MULTIPLICACION} { printf("\n Operador multiplicacion: %s\n", yytext); }
{OP_DIVISION} { printf("\n Operador division: %s\n", yytext); }

{INICIO_PARENTESIS} { printf("\n Inicio parentesis: %s\n", yytext); }
{FIN_PARENTESIS} { printf("\n Fin parentesis: %s\n", yytext); }
{INICIO_CORCHETE} { printf("\n Inicio corchete: %s\n", yytext); }
{FIN_CORCHETE} { printf("\n Fin corchete: %s\n", yytext); }
{INICIO_BLOQUE} { printf("\n Inicio bloque: %s\n", yytext); }
{FIN_BLOQUE} { printf("\n Fin bloque: %s\n", yytext); }

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
