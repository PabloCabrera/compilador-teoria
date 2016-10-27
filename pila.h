//si no esta incluida la libreria
#ifndef _PILA_H_INCLUDED 
//se incluye
#define _PILA_H_INCLUDED
#include "plci.h"

//para que no tengo problema en la definicio al ser recursiva
//ponemos que un elemento de la pila tiene un apuntador a struct_ElemetoPila, que es lo mismo a ElementoPila
typedef struct struct_ElementoPila{
    PolacaInversa elemento;
    struct_ElementoPila* anterior;
} *ElementoPila;

//typedef define el tipo de "*Pila"
typedef struct struct_pila {
    int num_elementos;
    ElementoPila tope;
} *Pila;

ElementoPila desapilar(Pila pila);
void apilar(Pila pila, ElementoPila elemento);

#endif