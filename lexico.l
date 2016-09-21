%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include "y.tab.h"
#include <stdbool.h>
#include "ts.h"
#include "ts.c"

#define MAX_ENTERO "2147483647"

/* Funciones definidas mas abajo */
void verificar_cota_entera(char *lexema);
void verificar_cota_real(char *lexema);

FILE *yyin;
char *yyltext;
%}
%option noyywrap  
%option yylineno 

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
RESERVADA_DECVAR (D|d)(E|e)(C|c)(V|v)(A|a)(R|r)
RESERVADA_ENDDEC (E|e)(N|n)(D|d)(D|d)(E|e)(C|c)
RESERVADA_AVG (A|a)(V|v)(G|g)
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
{RESERVADA_WRITE} { return RESERVADA_WRITE; }
{RESERVADA_IF} { return RESERVADA_IF; }
{RESERVADA_WHILE} { return RESERVADA_WHILE; }
{RESERVADA_FLOAT} { yylval.stringValue="FLOAT"; return RESERVADA_FLOAT;}
{RESERVADA_INTEGER} { yylval.stringValue="INTEGER"; return RESERVADA_INTEGER; }
{RESERVADA_DECVAR} { return RESERVADA_DECVAR; }
{RESERVADA_ENDDEC} { return RESERVADA_ENDDEC; }
{RESERVADA_AVG} { return RESERVADA_AVG; }
{RESERVADA_NULL} { return RESERVADA_NULL; }
{RESERVADA_ELSE} { return RESERVADA_ELSE; }

{IDENTIFICADOR}	{  ts_guardar_simbolo("identificador", yytext);  return IDENTIFICADOR;}
{OP_ASIGNACION} { return  OP_ASIGNACION;}
{FIN_SENTENCIA} { return  FIN_SENTENCIA;}
{CONSTANTE_REAL}	{ verificar_cota_real(yytext); return  CONSTANTE_REAL; }
{CONSTANTE_ENTERA}	{ verificar_cota_entera(yytext); return  CONSTANTE_ENTERA;  }
{CONSTANTE_STRING}	{ ts_guardar_simbolo("const_string", yytext); return  CONSTANTE_STRING; }
{OP_IGUAL} { return  OP_IGUAL;}
{OP_DISTINTO} { return  OP_DISTINTO;}
{OP_MAYOR} { return  OP_MAYOR;}
{OP_MENOR} { return  OP_MENOR;}
{OP_MAYOR_IGUAL} { return  OP_MAYOR_IGUAL;}
{OP_MENOR_IGUAL} { return  OP_MENOR_IGUAL;}
{OP_SUMA} { return  OP_SUMA;}
{OP_RESTA} { return  OP_RESTA;}
{OP_MULTIPLICACION} { return  OP_MULTIPLICACION;}
{OP_DIVISION} { return  OP_DIVISION;}
{INICIO_PARENTESIS} { return  INICIO_PARENTESIS;}
{FIN_PARENTESIS} { return  FIN_PARENTESIS;}
{INICIO_CORCHETE} { return  INICIO_CORCHETE;}
{FIN_CORCHETE} { return  FIN_CORCHETE;}
{INICIO_BLOQUE} { return  INICIO_BLOQUE;}
{FIN_BLOQUE} { return  FIN_BLOQUE;}
{COMA} { return COMA; }
{INICIO_COMENTARIO} { }
{FIN_COMENTARIO} { }
{COMENTARIO} { }
" "
"\n"
"\t"
. { printf("\n Error, el siguiente simbolo no pertenece al lexico: %s\n", yytext); yyerror();}
%%



void verificar_cota_real(char *lexema){
	char *finalPtr;
	double valor;
    valor=strtod(lexema,&finalPtr);
	if (valor > 3.4E+38) {
		return;
    }else{
		ts_guardar_simbolo("const_real", lexema);
	}
}

void verificar_cota_entera(char *lexema){
	/* Eliminamos los 0 a la izquierda */
	char *lexema_trim = lexema;
	while (lexema_trim[0] == '0') {
		lexema_trim++;
	}

	int diferencia = strlen (MAX_ENTERO) - strlen(lexema_trim);
	int pos = 0;

	if (diferencia > 0) {
		ts_guardar_simbolo("const_entera", lexema_trim);
	} else if (diferencia < 0) {
	} else /* if (diferencia == 0) */ {
		pos = 0;
		int continuar = true;
		while (continuar && pos < strlen (lexema_trim)) {
			if (MAX_ENTERO[pos] > lexema_trim[pos]) {
				ts_guardar_simbolo("const_entera", lexema_trim);
				continuar = false;
			} else if (MAX_ENTERO[pos] < lexema_trim[pos]) {
				continuar = false;
			}
			pos++;
		}
		if (continuar) {
			ts_guardar_simbolo("const_entera", lexema_trim);
		}
	}

}

