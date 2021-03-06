#include <stdlib.h>
#define son_iguales(x, y) (strcmp((x),(y))==0)
void escribir_asm (PolacaInversa polaca, FILE *file);
bool tipo_anterior_string, anterior_es_identificador;
char *etiqueta_salto, *variable_asignacion, *variable_write;
void escribir_asm (PolacaInversa polaca, FILE *file) {
	
	switch (polaca-> tipo) {
		case OPERADOR:
			if (son_iguales(polaca-> texto, "+")) {
				fprintf(file, "\tFADD\n" );
				
			} else if (son_iguales(polaca-> texto, "-")) {
				fprintf(file, "\tFSUB\n" );
				
			} else if (son_iguales(polaca-> texto, "*")) {
				fprintf(file, "\tFMUL\n" );
				
			} else if (son_iguales(polaca-> texto, "/")) {
				fprintf(file, "\tFDIV\n" );
				
			} else if (son_iguales(polaca-> texto, ":")) {
				if(tipo_anterior_string ==1){
					fprintf(file, "\tMOV %s, DX \n",variable_asignacion);
				}else{
					fprintf(file, "\tFSTP %s\n", variable_asignacion );
				}
								
			} else if (son_iguales(polaca-> texto, "write")) {
				if (tipo_anterior_string) {
					if (anterior_es_identificador) {
						/* Cuando el anterior es variable string */
						fprintf(file, "\tMOV DX, %s\n", variable_write);	
					} else {
						/* Cuando el anterior es constante string */
						fprintf(file, "\tMOV DX, OFFSET %s\n", variable_write);	
					}
					fprintf(file, "\tMOV AH, 9\n" );
					fprintf(file, "\tINT 21H\n" );
				} else {
					fprintf (file, "\tDisplayFloat %s,2\n", variable_write);
					fprintf (file, "\tNewLine\n", variable_write);
				}

			} else if (son_iguales(polaca-> texto, "BI")) {
				fprintf(file,"\tJMP %s\n",etiqueta_salto);
			

			} else if (son_iguales(polaca-> texto, "CMP")) {
				fprintf(file,"\tFCOMP\n");
				fprintf(file,"\tFSTSW AX\n");
				fprintf(file,"\tFWAIT\n");
				fprintf(file,"\tSAHF\n");
			
			} else if(son_iguales(polaca-> texto,"BLE")){
				fprintf(file,"\tJBE %s\n",etiqueta_salto);
				
			} else if(son_iguales(polaca-> texto,"BNE")){
				fprintf(file,"\tJNE %s\n",etiqueta_salto);
				
			} else if(son_iguales(polaca-> texto,"BGE")){
				fprintf(file,"\tJAE %s\n",etiqueta_salto);
			
			} else if(son_iguales(polaca-> texto,"BLT")){
				fprintf(file,"\tJB %s\n",etiqueta_salto);
			
			} else if(son_iguales(polaca-> texto,"BGT")){
				fprintf(file,"\tJA %s\n",etiqueta_salto);

			} else if(son_iguales(polaca-> texto,"BEQ")){
				fprintf(file,"\tJE %s\n",etiqueta_salto);
			}
			break;
		case ETIQUETA:
			fprintf(file, "%s:\n", polaca -> texto);
			break;
		case SALTO:
			etiqueta_salto = polaca -> texto;
			break;
		case SIMBOLO:
			if(polaca->simbolo != NULL && polaca-> simbolo ->tipo == STRING ){
				tipo_anterior_string= 1;
			}else{
				tipo_anterior_string=0;
			}

			if(polaca-> simbolo && polaca-> simbolo -> constante == false){
				anterior_es_identificador = 1;
			} else {
				anterior_es_identificador = 0;
			}
	
			if(
				/* Si el siguiente elemento es un operador de asignacion */
				(polaca-> siguiente != NULL)
				&& (polaca-> siguiente-> tipo == OPERADOR)
				&& (son_iguales(polaca-> siguiente->  texto, ":"))
			) {
				/* Guardamos el nombre del simbolo en una variable auxiliar */
				variable_asignacion = polaca-> simbolo-> nombre;
			} else if(
				/* Si el siguiente elemento es un operador write */
				(polaca-> siguiente != NULL)
				&& (polaca-> siguiente-> tipo == OPERADOR)
				&& (son_iguales(polaca-> siguiente->  texto, "write"))
			) {
				/* Guardamos el nombre del simbolo en una variable auxiliar */
				variable_write = polaca-> simbolo-> nombre;
			} else if(polaca-> simbolo-> tipo == STRING) {
				/* Si es un string, lo guardamos en DX */
				fprintf(file, "\tMOV DX, OFFSET %s\n" , polaca -> simbolo -> nombre);
			} else {
				/* Sino lo apilamos en el coprocesador */
				fprintf(file, "\tFLD %s\n" , polaca -> simbolo -> nombre);
			}

			break;
	}

	if (polaca-> siguiente != NULL) {
		escribir_asm (polaca-> siguiente, file);
	}
	
}


void crearDataAssembler(struct ts_entrada* tabla, FILE* fichero){
	//escribo toda la cabecera del assembler
	fprintf(fichero,"%s",".MODEL	LARGE \n.386 \n.STACK 200h \n \nMAXTEXTSIZE equ 50 \n \n.DATA \n \n");
	int i=0;
	for(i; i< TS_TAMANIO_TABLA_SIMBOLOS;i++){
		//si el elemento tiene de nombre 0 es
		if(strcmp(tabla[i].nombre,"")!=0){
			fprintf(fichero,"\t %s ", tabla[i].nombre);
			switch(tabla[i].tipo){
				case 1:	//si es integer
					fprintf(fichero,"dd ");
					if( strcmp(tabla[i].valor,"-")==0 ){
						//si no tiene valor
						fprintf(fichero,"? ");
					}else{
						fprintf(fichero,"%s.0 ",tabla[i].valor);
					}
					break;
				case 3:	//si es string
					
					if( strcmp(tabla[i].valor,"-")==0 ){
						//si no tiene valor
						fprintf(fichero,"dw ");
						fprintf(fichero,"? ");
					}else{
						fprintf(fichero,"db ");
						fprintf(fichero,"%s,10, 13, \"$\" ",tabla[i].valor);
					}
					break;
				default: //si es float u otra cosa
					fprintf(fichero,"dd ");
					if( strcmp(tabla[i].valor,"-")==0 ){
						//si no tiene valor
						fprintf(fichero,"? ");
					}else{
						fprintf(fichero,"%s ",tabla[i].valor);
					}
					break;
			}
			fprintf(fichero,"%s","\n");
		}
	}
	fprintf(fichero,"%s","\n.CODE\n\nSTART:\n\tMOV AX, @DATA\n\tMOV DS, AX\n\tMOV ES, AX\n");
}
