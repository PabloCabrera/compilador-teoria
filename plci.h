#ifndef PLCI_H_INCLUDED
#define PLCI_H_INCLUDED

#include <string.h>
#include <stdlib.h>
#include "ts.h"

typedef enum {
	SIMBOLO,
	OPERADOR
} PolacaInversaTipoElemento;

/* Polaca sera una lista enlazada */
typedef struct plci_elemento {
	PolacaInversaTipoElemento tipo;
	struct ts_entrada *simbolo;
	char *operador;
	struct plci_elemento *siguiente;
} *PolacaInversa;


PolacaInversa polaca_nueva (struct ts_entrada *simbolo);
void PolacaInversa_append_simbolo (PolacaInversa polaca, struct ts_entrada *simbolo);
void PolacaInversa_append_operador (PolacaInversa polaca, char *operador);
void PolacaInversa_print (PolacaInversa polaca);
void PolacaInversa_escribir_html (PolacaInversa polaca, const char* nombre_archivo);
void PolacaInversa_free(PolacaInversa polaca);

#endif