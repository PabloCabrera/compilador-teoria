#ifndef TS_H_INCLUDED
#define TS_H_INCLUDED

#include <stdbool.h>

#define TS_TAMANIO_TABLA_SIMBOLOS 512
#define TS_LONGITUD_NO_DEFINIDA -1

/* Tipos de datos que pueden guardarse en la tabla de simbolos */
typedef enum enumTipoDato {
	UNDEFINED=0,
	INTEGER=1,
	FLOAT=2,
	STRING=3
} TipoDato;
 
struct ts_entrada {
        char nombre[512];
        TipoDato tipo;
        char valor[512];
        int longitud;
        bool constante;
};

void ts_guardar_simbolo(char *token, char *lexema);
bool ts_verificar_existencia(char *token, char *lexema);
void ts_escribir_html(const char *nombre_archivo);
void ts_establecer_tipo(char* lista_ids, TipoDato tipo);
const char *TipoDato_toString(TipoDato tipo);
struct ts_entrada *ts_buscar_identificador (char *nombre);
struct ts_entrada *ts_buscar_constante (char *valor);
struct ts_entrada ts_tabla_simbolos[TS_TAMANIO_TABLA_SIMBOLOS];

#endif