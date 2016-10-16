%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include "y.tab.h"

int yystopparser=0;
FILE *yyin;
char *yyltext;
char *yytext;

/* Funciones definidas mas adelante */
char* concat_ids(char* lista_ids, char* ultimo_id);

%}
%token COMA
%token OP_MAYOR
%token OP_MENOR
%token SIMBOLO_IGUAL
%token OP_ASIGNACION
%token OP_SUMA
%token OP_RESTA
%token OP_MULTIPLICACION
%token OP_DIVISION
%token INICIO_PARENTESIS
%token FIN_PARENTESIS
%token INICIO_CORCHETE
%token FIN_CORCHETE
%token INICIO_BLOQUE
%token FIN_BLOQUE
%token FIN_SENTENCIA
%token COMILLA_SIMPLE
%token COMILLA_DOBLE
%token ESPACIO

%token RESERVADA_WRITE
%token RESERVADA_IF
%token RESERVADA_WHILE
%token <stringValue> RESERVADA_FLOAT
%token <stringValue> RESERVADA_INTEGER
%token <stringValue> RESERVADA_STRING
%token RESERVADA_DECVAR
%token RESERVADA_ENDDEC
%token RESERVADA_AVG
%token RESERVADA_NULL
%token RESERVADA_ELSE

%token <stringValue> IDENTIFICADOR
%token CONSTANTE_REAL
%token CONSTANTE_ENTERA
%token CONSTANTE_STRING
%token OP_IGUAL
%token OP_MAYOR_IGUAL
%token OP_MENOR_IGUAL
%token OP_DISTINTO

%union
{
    int intValue;
    float floatValue;
    char *stringValue;
}

%type <stringValue> list_identificadores;
%type <stringValue> tipo;

%%

//---------------------------- estructura general;
programa : prog {printf("\n FIN PROGRAMA \n");};

prog : seccion_declaracion seccion_sentencias | list_write;

list_write : sent_write | list_write sent_write;

seccion_sentencias : {printf("INICIO DE LA SECCION DE SENTENCIAS\n");} list_sentencias  {printf("FIN DE LA SECCION DE SENTENCIAS\n");};

seccion_declaracion : RESERVADA_DECVAR {printf("INICIO SECCION DE DECLARACIONES DECVAR\n");} list_declaraciones RESERVADA_ENDDEC {printf("FIN SECCION DE DECLARACIONES ENDDEC\n");};

//---------------------------- declaraciones y sentencias;
list_declaraciones : declaracion | list_declaraciones declaracion;
declaracion : list_identificadores OP_ASIGNACION  tipo {printf("Declaracion tipo %s\n",yytext);} FIN_SENTENCIA {ts_establecer_tipo ($1, $3);} ;

list_identificadores : IDENTIFICADOR {$$ = concat_ids(NULL, $1);}| list_identificadores COMA IDENTIFICADOR {$$ = concat_ids($1, $3);};

tipo : RESERVADA_FLOAT | RESERVADA_INTEGER | RESERVADA_STRING;


list_sentencias : sent | list_sentencias sent ;

sent : sent_asignacion | sent_write | sent_if | sent_if_else | sent_while | sent_avg;

// write "hola mundo" ;
sent_write : RESERVADA_WRITE CONSTANTE_STRING FIN_SENTENCIA {printf ("Sentencia Write\n");}| RESERVADA_WRITE IDENTIFICADOR FIN_SENTENCIA {printf ("Sentencia Write\n");};

sent_if : RESERVADA_IF {printf("INICIO IF\n");} INICIO_PARENTESIS condicion FIN_PARENTESIS INICIO_BLOQUE list_sentencias FIN_BLOQUE {printf("FIN IF\n");} ;
sent_if_else : sent_if RESERVADA_ELSE {printf("INICIO ELSE\n");} INICIO_BLOQUE list_sentencias FIN_BLOQUE {printf("FIN ELSE\n");};

sent_while :RESERVADA_WHILE {printf("INICIO WHILE\n");} INICIO_PARENTESIS condicion FIN_PARENTESIS INICIO_BLOQUE list_sentencias FIN_BLOQUE {printf("FIN WHILE\n");};

//------------------------------------ operaciones matematicas y asignaciones;
// palabra : 3*4 ;
sent_asignacion : IDENTIFICADOR {printf("Asignacion con identificador %s\n",yytext);} OP_ASIGNACION  exp_mat FIN_SENTENCIA ;


exp_mat : exp_mat OP_SUMA t {printf("Suma\n");} | exp_mat OP_RESTA t {printf("Resta\n");} | t;

t : t OP_MULTIPLICACION f {printf("Multiplicacion\n");}| t OP_DIVISION f {printf("Division\n");} | f;

f : CONSTANTE_REAL | CONSTANTE_ENTERA | IDENTIFICADOR | INICIO_PARENTESIS exp_mat FIN_PARENTESIS | sent_avg;

// avg([3,3*4,12]);
sent_avg :RESERVADA_AVG INICIO_PARENTESIS INICIO_CORCHETE lista_exp_matresiones FIN_CORCHETE FIN_PARENTESIS FIN_SENTENCIA {printf("Sentencia avg\n");} ;

lista_exp_matresiones : exp_mat | lista_exp_matresiones COMA exp_mat ;

// 3  5;
condicion : condicion_mayor {printf("Condicion mayor\n");} | condicion_igual {printf("Condicion igual\n");}| condicion_menor {printf("Condicion menor\n");} | condicion_distinto {printf("Condicion distinto\n");} | condicion_mayor_igual {printf("Condicion mayor igual\n");} | condicion_menor_igual {printf("Condicion menor igual\n");} ;
condicion_mayor : IDENTIFICADOR OP_MAYOR exp_mat;
condicion_igual : IDENTIFICADOR OP_IGUAL exp_mat;
condicion_menor : IDENTIFICADOR OP_MENOR exp_mat;
condicion_distinto : IDENTIFICADOR OP_DISTINTO exp_mat;
condicion_mayor_igual : IDENTIFICADOR OP_MAYOR_IGUAL exp_mat;
condicion_menor_igual : IDENTIFICADOR OP_MENOR_IGUAL exp_mat;

%%
int main (int argc, char *argv[]) 
{
	if ((yyin = fopen(argv[1], "rt")) == NULL)
	{
		printf("\n No se puede abrir el archivo: %s\n", argv[1]);
	}
	else
	{
		yyparse();
		ts_escribir_html("tabla_simbolos.html");
		}
	fclose(yyin);
	return(0);
}
int yyerror(void)
{
	printf("Syntax Error\n");
	system("Pause");
	exit(1);
}

char* concat_ids(char* lista_ids, char* ultimo_id){
	int longitud;
	char *nueva_lista;

	if (lista_ids != NULL) {
		longitud = strlen(lista_ids) + strlen(ultimo_id) + 2;
		nueva_lista = malloc(longitud);
		strcpy(nueva_lista, lista_ids);
		strcat(nueva_lista, ",");
		strcat(nueva_lista, ultimo_id);
		free(lista_ids); /* Borramos la lista anterior */
		return nueva_lista;
	} else {
		return strdup(ultimo_id);
	}
}