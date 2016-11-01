%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include "plci.c"
#include "ts.h"
#include "y.tab.h"
#include "pila.h"
#include "pila.c"

int yystopparser=0;
FILE *yyin;
char *yyltext;
char *yytext;
int contador_avg=0;
int contador_polacas;
PolacaInversa polaca_actual;
char *EspacioVacio = "nulo";
Pila pila_if;
Pila pila_while;
int contadorIF=0;

/* Funciones definidas mas adelante */
char* concat_ids(char* lista_ids, char* ultimo_id);
void insertar_operador_polaca(char *operador);
void insertar_simbolo_polaca (struct ts_entrada *simbolo);
void terminar_avg(int cantidad_elementos);
void terminar_polaca();
void comprobar_tipos_exp(TipoDato tipo1, TipoDato tipo2);
void comprobar_tipos_asignacion(TipoDato tipo1, TipoDato tipo2);
PolacaInversa obtener_subindice_polaca();
void agregar_elemento_pila_if(PolacaInversa subindice);
void insertar_condicion(char* dato);
void fin_if();
void fin_if_else();
void fin_else();
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
%token <stringValue> CONSTANTE_REAL
%token <stringValue> CONSTANTE_ENTERA
%token CONSTANTE_STRING
%token OP_IGUAL
%token OP_MAYOR_IGUAL
%token OP_MENOR_IGUAL
%token OP_DISTINTO

%union
{
    TipoDato typeValue;
    int intValue;
    float floatValue;
    char *stringValue;
}

%type <stringValue> list_identificadores;
%type <typeValue> tipo;
%type <typeValue> f;
%type <typeValue> exp_mat;
%type <typeValue> t;
%type <typeValue> condicion_mayor;
%type <typeValue> condicion_menor;
%type <typeValue> condicion_igual;
%type <typeValue> condicion_distinto;
%type <typeValue> condicion_mayor_igual;
%type <typeValue> condicion_menor_igual;
%%

//---------------------------- estructura general;
programa : prog {printf ("Polaca Inversa:"); PolacaInversa_print(polaca_actual); printf ("\n");};

prog : seccion_declaracion seccion_sentencias ;
prog :  list_write;

list_write : sent_write ;
list_write :  list_write sent_write;

seccion_sentencias : list_sentencias;

seccion_declaracion : RESERVADA_DECVAR list_declaraciones RESERVADA_ENDDEC;

//---------------------------- declaraciones y sentencias;
list_declaraciones : declaracion ;
list_declaraciones :  list_declaraciones declaracion;

declaracion : list_identificadores OP_ASIGNACION  tipo  FIN_SENTENCIA {ts_establecer_tipo ($1, $3);} ;

list_identificadores : IDENTIFICADOR {$$ = concat_ids(NULL, $1);};
list_identificadores :  list_identificadores COMA IDENTIFICADOR {$$ = concat_ids($1, $3);};

tipo : RESERVADA_FLOAT {$$ = FLOAT;};
tipo :  RESERVADA_INTEGER {$$ = INTEGER;} ;
tipo :  RESERVADA_STRING {$$ = STRING;};

list_sentencias : sent ;
list_sentencias :  list_sentencias sent ;

sent : sent_asignacion;
sent :  sent_write ;
sent :  sent_if_else ;
sent :  sent_if ;
sent :  sent_while;

// write "hola mundo" ;
sent_write : RESERVADA_WRITE CONSTANTE_STRING FIN_SENTENCIA ;
sent_write :  RESERVADA_WRITE IDENTIFICADOR FIN_SENTENCIA;

sent_if_else : RESERVADA_IF INICIO_PARENTESIS condicion FIN_PARENTESIS INICIO_BLOQUE list_sentencias FIN_BLOQUE {fin_if_else();} RESERVADA_ELSE INICIO_BLOQUE list_sentencias FIN_BLOQUE {fin_else();};
sent_if : RESERVADA_IF INICIO_PARENTESIS condicion FIN_PARENTESIS INICIO_BLOQUE list_sentencias FIN_BLOQUE {fin_if();};

sent_while :RESERVADA_WHILE INICIO_PARENTESIS condicion FIN_PARENTESIS INICIO_BLOQUE list_sentencias FIN_BLOQUE;

//------------------------------------ operaciones matematicas y asignaciones;
// palabra : 3*4 ;
sent_asignacion : IDENTIFICADOR OP_ASIGNACION  exp_mat FIN_SENTENCIA {
	struct ts_entrada *id;
	id=ts_buscar_identificador($1);
	comprobar_tipos_asignacion (id-> tipo, $3);
	insertar_simbolo_polaca(ts_buscar_identificador($1));
	insertar_operador_polaca(":");
} ;

exp_mat : exp_mat OP_SUMA t {
	$$=FLOAT;
	comprobar_tipos_exp($1,$3);
	insertar_operador_polaca("+");
}; 
exp_mat : exp_mat OP_RESTA t {
	$$=FLOAT;
	comprobar_tipos_exp($1,$3);
	insertar_operador_polaca("-");
};
exp_mat : t {
};

t : t OP_MULTIPLICACION f {
	$$=FLOAT;
	comprobar_tipos_exp($1,$3);
	insertar_operador_polaca("*");
};
t : t OP_DIVISION f {
	$$=FLOAT;
	comprobar_tipos_exp($1,$3);
	insertar_operador_polaca("/");
};
t : f;

f : CONSTANTE_REAL {
	$$=FLOAT;
	insertar_simbolo_polaca(ts_buscar_constante(yytext));
};
f : CONSTANTE_ENTERA{
	$$=INTEGER;
	insertar_simbolo_polaca(ts_buscar_constante(yytext));
};
f : IDENTIFICADOR {
	struct ts_entrada *id = ts_buscar_identificador(yytext);
	$$=id-> tipo;
	insertar_simbolo_polaca(id);
};
f : INICIO_PARENTESIS exp_mat FIN_PARENTESIS {
	$$=$2;
};

f : sent_avg {
	$$=FLOAT;
};

f : CONSTANTE_STRING {
	$$=STRING;
	insertar_simbolo_polaca(ts_buscar_constante(yytext));
}

// avg([3,3*4,12]);
sent_avg : RESERVADA_AVG INICIO_PARENTESIS INICIO_CORCHETE lista_exp_matresiones FIN_CORCHETE FIN_PARENTESIS {terminar_avg(contador_avg);} ;

lista_exp_matresiones : exp_mat {contador_avg++;};
lista_exp_matresiones : lista_exp_matresiones COMA exp_mat {contador_avg++; insertar_operador_polaca("+"); };

// 3  5;
condicion : condicion_mayor ;
condicion :  condicion_igual ;
condicion :  condicion_menor  ;
condicion :  condicion_distinto  ;
condicion :  condicion_mayor_igual  ;
condicion :  condicion_menor_igual;

condicion_mayor : IDENTIFICADOR OP_MAYOR exp_mat {
	struct ts_entrada *id = ts_buscar_identificador($1);
	$$=id-> tipo;
	insertar_simbolo_polaca(id);
	insertar_condicion("BLE");
};
condicion_igual : IDENTIFICADOR OP_IGUAL exp_mat {
	struct ts_entrada *id = ts_buscar_identificador($1);
	$$=id-> tipo;
	insertar_simbolo_polaca(id);
	insertar_condicion("BNE");
};
condicion_menor : IDENTIFICADOR OP_MENOR exp_mat {
	struct ts_entrada *id = ts_buscar_identificador($1);
	$$=id-> tipo;
	insertar_simbolo_polaca(id);
	insertar_condicion("BGE");
};
condicion_distinto : IDENTIFICADOR OP_DISTINTO exp_mat {
	struct ts_entrada *id = ts_buscar_identificador($1);
	$$=id-> tipo;
	insertar_simbolo_polaca(id);
	insertar_condicion("BEQ");
};
condicion_mayor_igual : IDENTIFICADOR  OP_MAYOR_IGUAL exp_mat {
	struct ts_entrada *id = ts_buscar_identificador($1);
	$$=id-> tipo;
	insertar_simbolo_polaca(id);
	insertar_condicion("BLT");
};
condicion_menor_igual : IDENTIFICADOR OP_MENOR_IGUAL exp_mat {
	struct ts_entrada *id = ts_buscar_identificador($1);
	$$=id-> tipo;
	insertar_simbolo_polaca(id);
	insertar_condicion("BGT");
};

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

void insertar_simbolo_polaca(struct ts_entrada *simbolo){
	if (polaca_actual == NULL) {
		polaca_actual = PolacaInversa_nueva (simbolo);
	} else {
		PolacaInversa_append_simbolo (polaca_actual, simbolo);
	}
}


void insertar_operador_polaca(char *operador){
	if (polaca_actual == NULL) {
		printf ("ERROR: Polaca inversa no puede empezar con un operador\n");
		exit (1);
	} else {
		PolacaInversa_append_operador (polaca_actual, operador);
	}
}

void insertar_etiqueta_polaca(char *etiqueta){
	if (polaca_actual == NULL) {
		printf ("ERROR: Polaca inversa no puede empezar con un etiqueta\n");
		exit (1);
	} else {
		PolacaInversa_append_etiqueta (polaca_actual, etiqueta);
	}
}

void insertar_salto_polaca(char *salto){
	if (polaca_actual == NULL) {
		printf ("ERROR: Polaca inversa no puede empezar con un salto\n");
		exit (1);
	} else {
		PolacaInversa_append_salto (polaca_actual, salto);
	}
}

void terminar_avg(int cantidad_elementos) {
	char contador_str[11];
	sprintf(contador_str, "%d", cantidad_elementos);
	ts_guardar_simbolo ("const_entera", contador_str);
	insertar_simbolo_polaca(ts_buscar_constante(contador_str));
	insertar_operador_polaca("/");
	contador_avg = 0; /* Esta variable es global en el archivo */
}
void terminar_polaca(){
	/*Generar codigo ASM */
}

void comprobar_tipos_exp(TipoDato tipo1, TipoDato tipo2){
	if( (tipo1==STRING) || (tipo2==STRING) ){
		printf("No se pueden realizar operaciones con string.\n");
		exit(1);
	}
}

void comprobar_tipos_asignacion(TipoDato tipo1, TipoDato tipo2){
	if ( (tipo1==STRING) && (tipo2!=STRING) ) {
		printf("No se puede asignar a un string otro tipo de valor distinto a este. \n");
		exit(1);
	}else{
		if((tipo1!=STRING) && (tipo2==STRING)){
			printf("No se puede asignar un string a otro tipo de dato. \n");
			exit(1);
		}
	}
}

void insertar_condicion(char* dato) {
	insertar_operador_polaca("CMP");
	//insertamos un lugar vacio, este va a tener q apuntar a el principio del ELSE o el FIN del IF
	insertar_operador_polaca(EspacioVacio); //constante global

	//ahora tendriamos que obtener el subindice de la lista polaca en este momento
	//y guardarlo en otra lista, para q cuando lleguemos al FIN/ELSE pongamos el valor q esta en la lista en el espacio vacio
	PolacaInversa subindice = obtener_subindice_polaca();
	//agregar este nuevo elemento a la pila de indices de IF
	agregar_elemento_pila_if(subindice);

	//insertamos el operador de comparacion (si a esta func la llamo OP_MAYOR, el dato q recibimos es "BLE" = menor igual)
	insertar_operador_polaca(dato);

	
}

PolacaInversa obtener_subindice_polaca(){
	//printf("DEBUG: buscando ultimo elemento en la polaca");
	int encontrado=0;
	PolacaInversa polaca_para_buscar = polaca_actual;
	while(encontrado==0){
		if(polaca_para_buscar-> siguiente){
			//pasa al siguiente
			polaca_para_buscar = polaca_para_buscar-> siguiente;
		}else{
			//si este es el ultimo
			encontrado=1;
		}
	}
	//printf("DEBUG: encontramos el ultimo subindice");
	return polaca_para_buscar;
}

void agregar_elemento_pila_if(PolacaInversa subindice){
	if(pila_if==NULL){
		pila_if = nueva_pila();
	}
	ElementoPila e = nuevo_elemento(subindice);
	apilar(pila_if,e);
}

void fin_if(){
	char *etiqueta = (char*) malloc (9);
	//sprintf guarda en el primer parametro el resto de las cosas
	//%3.d significa que va a poner un entero de 3 digitos. Ej:001, 002...
	sprintf(etiqueta,"etqif%03.d",contadorIF);
	contadorIF++;
	insertar_salto_polaca(etiqueta);

	//recupero el topecito de la pila	
	ElementoPila elementito = desapilar(pila_if);
	//el elemento al que apunta el tope es:
	PolacaInversa elemento_apuntado = elementito -> elemento;
	//el elemento apuntando tiene que apuntar al ultimo elemento agregado en la polaca
	elemento_apuntado -> operador = etiqueta;
}

void fin_if_else(){
	char *etiqueta = (char*) malloc(9);
	//recupero el tope de la pila	
	ElementoPila tope = desapilar(pila_if);
	//creo la etiqueta
	sprintf(etiqueta,"etqif%03.d",contadorIF);
	contadorIF++;
	//la inserto en la polaca
	insertar_salto_polaca(etiqueta);
	//la apilo
	ElementoPila e = nuevo_elemento(obtener_subindice_polaca());
	apilar(pila_if,e);
	//inserto BI
	insertar_operador_polaca("BI");
	
	//Creo una nueva etiqueta
	sprintf(etiqueta,"etqif%03.d",contadorIF);
	contadorIF++;
	insertar_etiqueta_polaca(etiqueta);
	//Uso el tope que guarde en la variable tope :P
	PolacaInversa elemento_apuntado = tope -> elemento;
	//el elemento apuntando tiene que apuntar al ultimo elemento agregado en la polaca
	elemento_apuntado -> operador = etiqueta;
}

void fin_else(){
	//creo etiqueta
	char *etiqueta = (char*) malloc(9);
	sprintf(etiqueta,"etqif%03.d",contadorIF);
	contadorIF++;
	insertar_etiqueta_polaca (etiqueta);

	//recupero el tope de la pila	
	ElementoPila tope = desapilar(pila_if);
	//el elemento al que apunta el tope es:
	PolacaInversa elemento_apuntado = tope -> elemento;
	//el elemento apuntando tiene que apuntar al ultimo elemento agregado en la polaca
	elemento_apuntado -> operador = etiqueta;
}