#ifndef TS_H_INCLUDED
#define TS_H_INCLUDED

#include <stdbool.h>

#define TS_TAMANIO_TABLA_SIMBOLOS 512
#define TS_LONGITUD_NO_DEFINIDA -1

 
void ts_guardar_simbolo(char *token, char *lexema);
bool ts_verificar_existencia(char *lexema);
void ts_escribir_html(const char *nombre_archivo);
void ts_establecer_tipo(char* lista_ids, const char* tipo);

struct ts_entrada {
		char nombre[100];
		char tipo[100];
		char valor[100];
		int longitud;
	};

struct ts_entrada ts_tabla_simbolos[TS_TAMANIO_TABLA_SIMBOLOS];


#endif