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

RESERVADA_WRITE (W|w)(R|r)(I|i)(T|t)(E|e)
RESERVADA_IF (I|i)(F|f)
RESERVADA_WHILE (W|w)(H|h)(I|i)(L|l)(E|e)
RESERVADA_FLOAT (F|f)(L|l)(O|o)(A|a)(T|t)
RESERVADA_INTEGER (I|i)(N|n)(T|t)(E|e)(G|g)(E|e)(R|r)
RESERVADA_STRING (S|s)(T|t)(R|r)(I|i)(N|n)(G|g)
RESERVADA_DECVAR (D|d)(E|e)(C|c)(V|v)(A|a)(R|r)
RESERVADA_ENDDEC (E|e)(N|n)(D|d)(D|d)(E|e)(C|c)
RESERVADA_AVG (A|a)(V|v)(G|g)
RESERVADA_FALSE (F|f)(A|a)(L|l)(S|s)(E|e)
RESERVADA_TRUE (T|t)(R|r)(U|u)(E|e)
RESERVADA_NULL (N|n)(U|u)(L|l)(L|l)
RESERVADA_ELSE (E|e)(L|l)(S|s)(E|e)

IDENTIFICADOR ({LETRA}|{GUION_BAJO})({LETRA}|{DIGITO}|{GUION_BAJO})*

CONSTANTE_REAL	({DIGITO}+{PUNTO_DECIMAL}{DIGITO}*)|({PUNTO_DECIMAL}{DIGITO}+)
CONSTANTE_ENTERA	{DIGITO}+
CONSTANTE_STRING ({COMILLA_SIMPLE}([^'])*{COMILLA_SIMPLE})|({COMILLA_DOBLE}([^"])*{COMILLA_DOBLE})

OP_IGUAL ({SIMBOLO_IGUAL}{SIMBOLO_IGUAL})
OP_MAYOR_IGUAL ({OP_MAYOR}{SIMBOLO_IGUAL})
OP_MENOR_IGUAL ({OP_MENOR}{SIMBOLO_IGUAL})
OP_DISTINTO ({SIMBOLO_EXCLAMACION}{SIMBOLO_IGUAL})
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
{RESERVADA_ELSE} { printf("\n PALABRA RESERVADA: %s\n", yytext); }

{IDENTIFICADOR}	{ printf("\n identificador: %s\n", yytext); }
{OP_ASIGNACION} { printf("\n Operador asignacion: %s\n", yytext); }
{FIN_SENTENCIA} { printf("\n Fin de sentencia: %s\n", yytext); }

{CONSTANTE_REAL}	{ printf("\n Constante real: %s\n", yytext); }
{CONSTANTE_ENTERA}	{ printf("\n Constante entera: %s\n", yytext); }
{CONSTANTE_STRING}	{ printf("\n Constante string: %s\n", yytext); }

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
