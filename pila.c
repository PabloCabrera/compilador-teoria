//es una libreria que esta en esta carpeta. definida por el usuario.
#include "pila.h"
//es una libreria del sistema
#include <stdlib.h>

ElementoPila desapilar(Pila pila){
    ElementoPila topecito =  pila -> tope;
    ElementoPila nuevo_topecito = topecito -> anterior;
    pila -> tope = nuevo_topecito;
    return topecito;
}

void apilar(Pila pila, ElementoPila elemento){
    elemento -> anterior = pila -> tope;
    pila -> tope = elemento;
}

Pila nueva_pila(){
    Pila pila = (Pila)malloc(sizeof(struct struct_pila));
    pila -> tope = NULL;
    return pila;
}

ElementoPila nuevo_elemento(PolacaInversa polaca){
    ElementoPila elementop = (ElementoPila) malloc(sizeof(struct struct_ElementoPila));
    elementop -> elemento = polaca;
    elementop -> anterior = NULL;
    return elementop;
}
