#include "ts.h"
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include "y.tab.h"

int ts_num_simbolos=0;
// FILE *fp;

const char *TipoDato_names[4] = {
	"Undefined",
	"Integer",
	"Float",
	"String"
};

bool ts_verificar_existencia(char *lexema){
	int j;
	char destino1[500];
	strcpy(destino1,"_");
	strcat(destino1,lexema);
	for (j=0; j < ts_num_simbolos; j++) {
		if ((strcmp(lexema, ts_tabla_simbolos[j].nombre) == 0)||(strcmp(destino1, ts_tabla_simbolos[j].nombre) == 0)) {
			return true;
		}
	}
	return false;
}

void ts_escribir_html(const char *nombre_archivo) {
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

	for (j=0; j < ts_num_simbolos ;j++) {
		fprintf (file, "\n\t\t\t<tr>");
		fprintf (file, "\n\t\t\t\t<td>%s</td>", ts_tabla_simbolos[j].nombre);
		fprintf (file, "\n\t\t\t\t<td>%s</td>", TipoDato_toString(ts_tabla_simbolos[j].tipo));
		fprintf (file, "\n\t\t\t\t<td>%s</td>", ts_tabla_simbolos[j].valor);
		if (ts_tabla_simbolos[j].longitud != TS_LONGITUD_NO_DEFINIDA) {
			fprintf (file, "\n\t\t\t\t<td>%d</td>", ts_tabla_simbolos[j].longitud);
		} else {
			fprintf (file, "\n\t\t\t\t<td>-</td>", ts_tabla_simbolos[j].longitud);
		}
		fprintf (file, "\n\t\t\t<tr>");
	}
	
	fprintf (file, 
		"\n\t</body>"
		"\n</html>");
	fclose (file);
		
}


void ts_guardar_simbolo(char *token, char *lexema){
	char destino[500];
	if (!ts_verificar_existencia(lexema)) {
		//fp = fopen("tabla_simbolos.txt","w");
		/* Si es un identificador solo guardo el lexema */
		if (strcmp(token, "identificador") == 0) {
			strcpy(ts_tabla_simbolos[ts_num_simbolos].nombre,lexema);
			ts_tabla_simbolos[ts_num_simbolos].tipo = UNDEFINED;
			strcpy(ts_tabla_simbolos[ts_num_simbolos].valor,"-");
			yylval.stringValue = ts_tabla_simbolos[ts_num_simbolos].nombre; 
			ts_tabla_simbolos[ts_num_simbolos].longitud = TS_LONGITUD_NO_DEFINIDA;
		}
	
		/* Si es una constante real guardo lexema y valor*/
		if (strcmp(token, "const_real") == 0) {
			strcpy(destino,"_");
			strcat(destino,lexema);
			strcpy(ts_tabla_simbolos[ts_num_simbolos].nombre,destino);
			ts_tabla_simbolos[ts_num_simbolos].tipo = FLOAT;
			strcpy(ts_tabla_simbolos[ts_num_simbolos].valor,lexema);
			ts_tabla_simbolos[ts_num_simbolos].longitud = TS_LONGITUD_NO_DEFINIDA;
			
		}
	
		/* Si es una constante entera guardo lexema y valor*/
		if (strcmp(token, "const_entera") == 0) {
			strcpy(destino,"_");
			strcat(destino,lexema);
			strcpy(ts_tabla_simbolos[ts_num_simbolos].nombre,destino);
			ts_tabla_simbolos[ts_num_simbolos].tipo = INTEGER;
			strcpy(ts_tabla_simbolos[ts_num_simbolos].valor,lexema);
			ts_tabla_simbolos[ts_num_simbolos].longitud = TS_LONGITUD_NO_DEFINIDA;
		}
	
		/* Si es una constante string guardo lexema y longitud*/
		if (strcmp(token, "const_string") == 0) {
			strcpy(ts_tabla_simbolos[ts_num_simbolos].nombre,lexema);
			ts_tabla_simbolos[ts_num_simbolos].tipo=STRING;
			strcpy(ts_tabla_simbolos[ts_num_simbolos].valor,lexema);
			ts_tabla_simbolos[ts_num_simbolos].longitud = strlen(lexema)-2;
		}
	
		
		/*Guardo en el archivo
		fprintf(fp,ts_tabla_simbolos[ts_num_simbolos].nombre);
		fprintf(fp," ");
		fprintf(fp,ts_tabla_simbolos[ts_num_simbolos].tipo);
		fprintf(fp," ");
		fprintf(fp,ts_tabla_simbolos[ts_num_simbolos].valor);
		fprintf(fp," ");
		if (ts_tabla_simbolos[ts_num_simbolos].longitud != TS_LONGITUD_NO_DEFINIDA) {
			fprintf(fp,"%d",ts_tabla_simbolos[ts_num_simbolos].longitud);
		} else {
			fprintf(fp,"-");
		}
		fprintf(fp,"\n");
		*/

		ts_num_simbolos++;
		
	}
		//fclose(fp);
		return;
	
}

void ts_establecer_tipo (char* lista_ids, TipoDato tipo)
{
	/* en la variable lista_ids viene una lista de nombres de variables separadas por coma */
	char *inicio_actual, *siguiente_coma, *nombre_id;
	int longitud, pos_ts;

	inicio_actual = lista_ids;

	while (strlen (inicio_actual) > 0) { 
		siguiente_coma = strchr(inicio_actual, ',');
		if(siguiente_coma == NULL) {
			longitud = strlen(inicio_actual);
		} else {
			longitud = strlen(inicio_actual) - strlen(siguiente_coma);
		}

		/* Ahora buscamos la variable en la tabla de simbolos */
		int pos_ts = 0;
		while (pos_ts < TS_TAMANIO_TABLA_SIMBOLOS) {
			if (strncmp(inicio_actual, ts_tabla_simbolos[pos_ts].nombre, longitud) == 0) {
				ts_tabla_simbolos[pos_ts].tipo = tipo;
				break;
			}
			pos_ts++;
		}
		
		/* Pasamos al proximo registro */
		inicio_actual += longitud;
		if(inicio_actual == siguiente_coma) {
			inicio_actual++;
		}
	}
	
}

struct ts_entrada *ts_buscar_identificador (char *nombre) {
	int pos_ts = 0;
	struct ts_entrada *encontrado = NULL;

	while (encontrado == NULL && pos_ts < TS_TAMANIO_TABLA_SIMBOLOS) {
		if (strcmp (nombre, ts_tabla_simbolos[pos_ts].nombre) == 0) {
			encontrado = &(ts_tabla_simbolos[pos_ts]);
		}
		pos_ts++;
	}
	
	return encontrado;
}

struct ts_entrada *ts_buscar_constante (char *valor) {
	struct ts_entrada *encontrado = NULL;

	if (valor[0] == '"') {
	/* Si empieza con comilla es un string, en este caso el identificador es igual al valor */
		encontrado = ts_buscar_identificador (valor);
	} else {
		/* Sino es un Integer o Float, en ese caso tenemos que agregarle un _ al nombre */
		char *nombre = malloc (strlen (valor) + 2);
		nombre[0] = '_';
		nombre[1] = '\0';
		strcat (nombre, valor);
	}

	return encontrado;
}

const char *TipoDato_toString(TipoDato tipo) {
	return TipoDato_names[tipo];	
}