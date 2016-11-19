#include <stdlib.h>
#include "ts.h" 
#include "plci.h" 
#include "y.tab.h"

PolacaInversa PolacaInversa_nueva (struct ts_entrada *simbolo) {
	PolacaInversa polaca;

	polaca = (PolacaInversa) malloc (sizeof (struct plci_elemento));
	polaca-> tipo = SIMBOLO;
	polaca-> simbolo = simbolo;
	polaca-> texto = NULL; 	//texto puede ser un operador o una etiqueta de salto
	polaca-> siguiente = NULL;
	
	return polaca;
}

void PolacaInversa_append_simbolo (PolacaInversa polaca, struct ts_entrada *simbolo) {
	PolacaInversa tail;
	if (polaca-> siguiente) {
		PolacaInversa_append_simbolo (polaca-> siguiente, simbolo);
	} else {
		tail = PolacaInversa_nueva (simbolo);
		polaca-> siguiente = tail;
	}
}

void PolacaInversa_append_operador (PolacaInversa polaca, char *operador) {
	PolacaInversa tail;
	if (polaca-> siguiente) {
		PolacaInversa_append_operador (polaca-> siguiente, operador);
	} else {
		tail = (PolacaInversa) malloc (sizeof (struct plci_elemento));
		tail-> tipo = OPERADOR;
		tail-> simbolo = NULL;
		tail-> texto = operador;
		tail-> siguiente = NULL;
		polaca-> siguiente = tail;
	}	
}

void PolacaInversa_append_etiqueta (PolacaInversa polaca, char *etiqueta) {
	PolacaInversa tail;
	if (polaca-> siguiente) {
		PolacaInversa_append_etiqueta (polaca-> siguiente, etiqueta);
	} else {
		tail = (PolacaInversa) malloc (sizeof (struct plci_elemento));
		tail-> tipo = ETIQUETA;
		tail-> simbolo = NULL;
		tail-> texto = etiqueta;
		tail-> siguiente = NULL;
		polaca-> siguiente = tail;
	}	
}

void PolacaInversa_append_salto (PolacaInversa polaca, char *etiqueta) {
	PolacaInversa tail;
	if (polaca-> siguiente) {
		PolacaInversa_append_salto (polaca-> siguiente, etiqueta);
	} else {
		tail = (PolacaInversa) malloc (sizeof (struct plci_elemento));
		tail-> tipo = SALTO;
		tail-> simbolo = NULL;
		tail-> texto = etiqueta;
		tail-> siguiente = NULL;
		polaca-> siguiente = tail;
	}	
}

void PolacaInversa_print (PolacaInversa polaca){

	switch (polaca-> tipo) {
		case OPERADOR:
			printf("[%s] ", polaca -> texto);
			break;
		case ETIQUETA:
			printf("<%s> ", polaca -> texto);
			break;
		case SALTO:
			printf("[%s] ", polaca -> texto);
			break;
		case SIMBOLO:
			printf("[%s] ", polaca -> simbolo -> nombre);
			break;
	}

	if (polaca-> siguiente != NULL) {
		PolacaInversa_print (polaca-> siguiente);
	} else {
		printf ("\n");
	}
}

void PolacaInversa_free(PolacaInversa polaca) {
	if (polaca-> siguiente != NULL) {
		PolacaInversa_free(polaca-> siguiente);
	}
	free (polaca);
}
