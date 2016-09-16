%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
#include "compartido.h"

int yylval;
int yystopparser=0;
FILE *yyin;
char *yyltext;
char *yytext;

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
%token RESERVADA_FLOAT
%token RESERVADA_INTEGER
%token RESERVADA_STRING
%token RESERVADA_DECVAR
%token RESERVADA_ENDDEC
%token RESERVADA_AVG
%token RESERVADA_FALSE
%token RESERVADA_TRUE
%token RESERVADA_NULL
%token RESERVADA_ELSE
%token RESERVADA_BOOLEAN

%token IDENTIFICADOR
%token CONSTANTE_REAL
%token CONSTANTE_ENTERA
%token CONSTANTE_STRING
%token OP_IGUAL
%token OP_MAYOR_IGUAL
%token OP_MENOR_IGUAL
%token OP_DISTINTO

%%

//---------------------------- estructura general;
programa : prog {printf("\n fin programa :D \n");};

prog : seccion_declaracion seccion_sentencias | list_write;

list_write : sent_write | list_write sent_write;

seccion_sentencias : {printf("inicio seccion_sentencias\n");} list_sentencias  {printf("fin seccion_sentencias\n");};

seccion_declaracion : RESERVADA_DECVAR {printf("RESERVADA_DECVAR\n");} list_declaraciones RESERVADA_ENDDEC {printf("RESERVADA_ENDDEC\n");};

//---------------------------- declaraciones y sentencias;
list_declaraciones : declaracion | list_declaraciones declaracion;
declaracion : list_identificadores {printf("declaracion %s ",yytext);} OP_ASIGNACION {printf("op_asig %s ",yytext);} tipo {printf(" tipo %s ",yytext);} FIN_SENTENCIA {printf("fin sentencias %s\n",yytext);};

list_identificadores : IDENTIFICADOR | list_identificadores COMA IDENTIFICADOR;

tipo : RESERVADA_STRING | RESERVADA_FLOAT | RESERVADA_INTEGER | RESERVADA_BOOLEAN;

list_sentencias : sent | list_sentencias sent ;

sent : sent_asignacion | sent_write | sent_if |  sent_while | sent_avg;

// write "hola mundo" ;     o write palabra ;
sent_write : RESERVADA_WRITE CONSTANTE_STRING FIN_SENTENCIA {printf ("Sentencia Write\n");}| RESERVADA_WRITE IDENTIFICADOR FIN_SENTENCIA {printf ("Sentencia Write\n");};

sent_if : RESERVADA_IF INICIO_PARENTESIS condicion FIN_PARENTESIS INICIO_BLOQUE list_sentencias FIN_BLOQUE;
sent_if : RESERVADA_IF INICIO_PARENTESIS condicion FIN_PARENTESIS INICIO_BLOQUE list_sentencias FIN_BLOQUE RESERVADA_ELSE INICIO_BLOQUE list_sentencias FIN_BLOQUE;

sent_while :RESERVADA_WHILE INICIO_PARENTESIS condicion FIN_PARENTESIS INICIO_BLOQUE list_sentencias FIN_BLOQUE {printf("fin del while \n");};

//------------------------------------ operaciones matematicas y asignaciones;
// palabra : 3*4 ;
sent_asignacion : IDENTIFICADOR {printf("ID %s ",yytext);} OP_ASIGNACION  exp_mat {printf("valor %s \n",yytext);} FIN_SENTENCIA ;
//sent_asignacion : IDENTIFICADOR {printf("ID %s ",yytext);} OP_ASIGNACION  exp_string {printf("valor %s \n",yytext);} FIN_SENTENCIA ;
//sent_asignacion : IDENTIFICADOR {printf("ID %s ",yytext);} OP_ASIGNACION  exp_boolean {printf("valor %s \n",yytext);} FIN_SENTENCIA ;

exp_mat : exp_mat OP_SUMA t | exp_mat OP_RESTA t | t;

t : t OP_MULTIPLICACION f | t OP_DIVISION f | f;

f : CONSTANTE_STRING | RESERVADA_FALSE | RESERVADA_TRUE | CONSTANTE_REAL | CONSTANTE_ENTERA | IDENTIFICADOR | INICIO_PARENTESIS exp_mat FIN_PARENTESIS | sent_avg;

//exp_string : CONSTANTE_STRING | IDENTIFICADOR; 

//exp_boolean : RESERVADA_FALSE | RESERVADA_TRUE | IDENTIFICADOR;

// avg([3,3*4,12]);
sent_avg :RESERVADA_AVG INICIO_PARENTESIS INICIO_CORCHETE lista_exp_matresiones FIN_CORCHETE FIN_PARENTESIS FIN_SENTENCIA {printf("sentencia avg\n");} ;

lista_exp_matresiones : exp_mat | lista_exp_matresiones COMA exp_mat ;

// 3  5;
condicion : condicion_mayor | condicion_igual | condicion_menor | condicion_distinto | condicion_mayor_igual | condicion_menor_igual ;
condicion_mayor : IDENTIFICADOR OP_MAYOR exp_mat {printf("SOY MAYOR A %s \n",yytext);};
condicion_igual : IDENTIFICADOR OP_IGUAL exp_mat {printf("SOY IGUAL A %s \n",yytext);};
//condicion_igual : IDENTIFICADOR OP_IGUAL exp_boolean {printf("SOY IGUAL A BOOLEANO %s \n",yytext);};
condicion_menor : IDENTIFICADOR OP_MENOR exp_mat {printf("SOY MENOR A %s \n",yytext);};
condicion_distinto : IDENTIFICADOR OP_DISTINTO exp_mat {printf("SOY != A %s \n",yytext);};
//condicion_distinto : IDENTIFICADOR OP_DISTINTO exp_boolean {printf("SOY != A BOOLEANO %s \n",yytext);};
condicion_mayor_igual : IDENTIFICADOR OP_MAYOR_IGUAL exp_mat {printf("SOY >= A %s \n",yytext);};
condicion_menor_igual : IDENTIFICADOR OP_MENOR_IGUAL exp_mat {printf("SOY <= A %s \n",yytext);};

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
	}
	fclose(yyin);
	return(0);
}
int yyerror(void)
{
	printf("Sintax Error\n");
	system("Pause");
	exit(1);
}
