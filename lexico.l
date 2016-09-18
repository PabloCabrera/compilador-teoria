%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include "y.tab.h"
#include <stdbool.h>


#define LONGITUD_NO_DEFINIDA -1
#define MAX_ENTERO "2147483647"

struct entrada {
		char nombre[100];
		char tipo[100];
		char valor[100];
		int longitud;
	};


FILE *yyin;
int yylval;
char *yyltext;
FILE *fp;
int i=0;
struct entrada mis_entradas[50];
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
RESERVADA_STRING (S|s)(T|t)(R|r)(I|i)(N|n)(G|g)
RESERVADA_DECVAR (D|d)(E|e)(C|c)(V|v)(A|a)(R|r)
RESERVADA_ENDDEC (E|e)(N|n)(D|d)(D|d)(E|e)(C|c)
RESERVADA_AVG (A|a)(V|v)(G|g)
RESERVADA_FALSE (F|f)(A|a)(L|l)(S|s)(E|e)
RESERVADA_TRUE (T|t)(R|r)(U|u)(E|e)
RESERVADA_NULL (N|n)(U|u)(L|l)(L|l)
RESERVADA_ELSE (E|e)(L|l)(S|s)(E|e)
RESERVADA_BOOLEAN (B|b)(O|o)(O|o)(L|l)(E|e)(A|a)(N|n)

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
{RESERVADA_FLOAT} { return RESERVADA_FLOAT;}
{RESERVADA_INTEGER} { return RESERVADA_INTEGER; }
{RESERVADA_STRING} { return RESERVADA_STRING; }
{RESERVADA_DECVAR} { return RESERVADA_DECVAR; }
{RESERVADA_ENDDEC} { return RESERVADA_ENDDEC; }
{RESERVADA_AVG} { return RESERVADA_AVG; }
{RESERVADA_FALSE} { return RESERVADA_FALSE; }
{RESERVADA_TRUE} { return RESERVADA_TRUE; }
{RESERVADA_NULL} { return RESERVADA_NULL; }
{RESERVADA_ELSE} { return RESERVADA_ELSE; }
{RESERVADA_BOOLEAN} { return RESERVADA_BOOLEAN; }

{IDENTIFICADOR}	{  guardar_en_ts("identificador", yytext);  return IDENTIFICADOR;}
{OP_ASIGNACION} { return  OP_ASIGNACION;}
{FIN_SENTENCIA} { return  FIN_SENTENCIA;}
{CONSTANTE_REAL}	{ verificar_cota_real(yytext); return  CONSTANTE_REAL; }
{CONSTANTE_ENTERA}	{ verificar_cota_entera(yytext); return  CONSTANTE_ENTERA;  }
{CONSTANTE_STRING}	{ guardar_en_ts("const_string", yytext); return  CONSTANTE_STRING; }
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

char verificar_existencia(char *lexema){
	int j;
	char destino1[500];
	strcpy(destino1,"_");
	strcat(destino1,lexema);
	for (j=0; j < i; j++) {
		if ((strcmp(lexema, mis_entradas[j].nombre) == 0)||(strcmp(destino1, mis_entradas[j].nombre) == 0)) {
			return 1;
		}
	}
	return 0;
}

void escribir_html(const char *nombre_archivo) {
	FILE *file;
	int j;

	file = fopen (nombre_archivo, "w");
	fprintf (file, 
		"<!DOCTYPE HTML>"
		"\n<html>"
		"\n\t<head>"
		"\n\t\t<title>Tabla de s&iacute;mbolos</title>"
		"\n\t\t<style type='text/css'>"
		"\n\t\t\ttable {border-collapse: collapse; text-align: left; border : 2px solid #4F81BD; color: black; margin: 24px auto}"
		"\n\t\t\tth {background:#4F81BD; color: #FFFFFF; text-align: center}"
		"\n\t\t\ttd {border: 1px solid #888888;}"
		"\n\t\t\ttd {padding: 3px;}"
		"\n\t\t</style>"
		"\n\t</head>"
		"\n\t<body>"
		"\n\t\t<table>"
		"\n\t\t\t<tr>"
		"\n\t\t\t\t<th>Nombre</th>"
		"\n\t\t\t\t<th>Tipo</th>"
		"\n\t\t\t\t<th>Valor</th>"
		"\n\t\t\t\t<th>Longitud</th>"
		"\n\t\t\t</tr>"
		"");

	for (j=0; j < i ;j++) {
		fprintf (file, "\n\t\t\t<tr>");
		fprintf (file, "\n\t\t\t\t<td>%s</td>", mis_entradas[j].nombre);
		fprintf (file, "\n\t\t\t\t<td>%s</td>", mis_entradas[j].tipo);
		fprintf (file, "\n\t\t\t\t<td>%s</td>", mis_entradas[j].valor);
		if (mis_entradas[j].longitud != LONGITUD_NO_DEFINIDA) {
			fprintf (file, "\n\t\t\t\t<td>%d</td>", mis_entradas[j].longitud);
		} else {
			fprintf (file, "\n\t\t\t\t<td>-</td>", mis_entradas[j].longitud);
		}
		fprintf (file, "\n\t\t\t<tr>");
	}
	
	fprintf (file, 
		"\n\t</body>"
		"\n</html>");
	fclose (file);
		
}


void guardar_en_ts(char *token, char *lexema){
	char destino[500];
	if (!verificar_existencia(lexema)) {
		fp = fopen("tabla_simbolos.txt","w");
		/* Si es un identificador solo guardo el lexema */
		if (strcmp(token, "identificador") == 0) {
			strcpy(mis_entradas[i].nombre,lexema);
			strcpy(mis_entradas[i].tipo,"-");
			strcpy(mis_entradas[i].valor,"-");
			mis_entradas[i].longitud = LONGITUD_NO_DEFINIDA;
		}
	
		/* Si es una constante real guardo lexema y valor*/
		if (strcmp(token, "const_real") == 0) {
			strcpy(destino,"_");
			strcat(destino,lexema);
			strcpy(mis_entradas[i].nombre,destino);
			strcpy(mis_entradas[i].tipo,"FLOAT");
			strcpy(mis_entradas[i].valor,lexema);
			mis_entradas[i].longitud = LONGITUD_NO_DEFINIDA;
			
		}
	
		/* Si es una constante entera guardo lexema y valor*/
		if (strcmp(token, "const_entera") == 0) {
			strcpy(destino,"_");
			strcat(destino,lexema);
			strcpy(mis_entradas[i].nombre,destino);
			strcpy(mis_entradas[i].tipo,"INTEGER");
			strcpy(mis_entradas[i].valor,lexema);
			mis_entradas[i].longitud = LONGITUD_NO_DEFINIDA;
		}
	
		/* Si es una constante string guardo lexema y longitud*/
		if (strcmp(token, "const_string") == 0) {
			strcpy(mis_entradas[i].nombre,lexema);
			strcpy(mis_entradas[i].tipo,"STRING");
			strcpy(mis_entradas[i].valor,lexema);
			mis_entradas[i].longitud = strlen(lexema)-2;
		}
	
		
		/*Guardo en el archivo*/
		fprintf(fp,mis_entradas[i].nombre);
		fprintf(fp," ");
		fprintf(fp,mis_entradas[i].tipo);
		fprintf(fp," ");
		fprintf(fp,mis_entradas[i].valor);
		fprintf(fp," ");
		if (mis_entradas[i].longitud != LONGITUD_NO_DEFINIDA) {
			fprintf(fp,"%d",mis_entradas[i].longitud);
		} else {
			fprintf(fp,"-");
		}
		fprintf(fp,"\n");

		i++;
		
	}
		fclose(fp);
		escribir_html("tabla_simbolos.html");
		return;
	
}

void verificar_cota_real(char *lexema){
	char *finalPtr;
	double valor;
    valor=strtod(lexema,&finalPtr);
	if (valor > 3.4E+38) {
		return;
    }else{
		guardar_en_ts("const_real", lexema);
	}
}

/*
void verificar_cota_entera(char *lexema){
	int valor;
	valor= atoi(lexema);
	if ((valor > 2147483647) || (valor < 0)) {
		return;
    }else{
		guardar_en_ts("const_entera", lexema);
	}
}
*/
void verificar_cota_entera(char *lexema){
	/* Eliminamos los 0 a la izquierda */
	char *lexema_trim = lexema;
	while (lexema_trim[0] == '0') {
		lexema_trim++;
	}

	int diferencia = strlen (MAX_ENTERO) - strlen(lexema_trim);
	int pos = 0;

	if (diferencia > 0) {
		guardar_en_ts("const_entera", lexema_trim);
	} else if (diferencia < 0) {
	} else /* if (diferencia == 0) */ {
		pos = 0;
		int continuar = true;
		while (continuar && pos < strlen (lexema_trim)) {
			if (MAX_ENTERO[pos] > lexema_trim[pos]) {
				guardar_en_ts("const_entera", lexema_trim);
				continuar = false;
			} else if (MAX_ENTERO[pos] < lexema_trim[pos]) {
				continuar = false;
			}
			pos++;
		}
		if (continuar) {
			guardar_en_ts("const_entera", lexema_trim);
		}
	}

}

