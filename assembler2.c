#define son_iguales(x, y) (strcmp((x),(y))==0)
void escribir_asm (PolacaInversa polaca, FILE *file);
char *etiqueta_salto, *variable_asignacion;
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
				fprintf(file, "\tFSTP %s\n", variable_asignacion );
				
			} else if (son_iguales(polaca-> texto, "write")) {
				fprintf(file, "\tMOV AH, 9\n" );
				fprintf(file, "\tINT 21H\n" );

			} else if (son_iguales(polaca-> texto, "BI")) {
				fprintf(file,"\tJMP %s\n",etiqueta_salto);
			

			} else if (son_iguales(polaca-> texto, "CMP")) {
				fprintf(file,"\tFCOMP\n");
				fprintf(file,"\tFSTSW AX\n");
				fprintf(file,"\tFWAIT\n");
				fprintf(file,"\tSAHF\n");
			
			} else if(son_iguales(polaca-> texto,"BLE")){
				fprintf(file,"\tJLE %s\n",etiqueta_salto);
				
			} else if(son_iguales(polaca-> texto,"BNE")){
				fprintf(file,"\tJNE %s\n",etiqueta_salto);
				
			} else if(son_iguales(polaca-> texto,"BGE")){
				fprintf(file,"\tJGE %s\n",etiqueta_salto);
			
			} else if(son_iguales(polaca-> texto,"BLT")){
				fprintf(file,"\tJLT %s\n",etiqueta_salto);
			
			} else if(son_iguales(polaca-> texto,"BGT")){
				fprintf(file,"\tJGT %s\n",etiqueta_salto);
			}
			break;
		case ETIQUETA:
			fprintf(file, "%s:\n", polaca -> texto);
			break;
		case SALTO:
			etiqueta_salto = polaca -> texto;
			break;
		case SIMBOLO:
			if(
				/* Si el siguiente elemento es un operador de asignacion */
				(polaca-> siguiente != NULL)
				&& (polaca-> siguiente-> tipo == OPERADOR)
				&& (son_iguales(polaca-> siguiente->  texto, ":"))
			) {
				/* Guardamos el nombre del simbolo en una variable auxiliar */
				variable_asignacion = polaca-> simbolo-> nombre;
			} else {
				/* Sino lo apilamos en el coprocesador */
				if (polaca-> simbolo -> tipo == STRING){
					fprintf(file, "\tMOV DX,OFFSET %s\n", polaca-> simbolo-> nombre);	
				} else {
					fprintf(file, "\tFLD %s\n" , polaca -> simbolo -> nombre);
				}
			}

			break;
	}

	if (polaca-> siguiente != NULL) {
		escribir_asm (polaca-> siguiente, file);
	}
	
}


void crearDataAssembler(struct ts_entrada* tabla, FILE* fichero){
	//escribo toda la cabecera del assembler
	fprintf(fichero,"%s","include macros2.asm \ninclude number.asm \n \n.MODEL	LARGE \n.386 \n.STACK 200h \n \nMAXTEXTSIZE equ 50 \n \n.DATA \n \n");
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
					fprintf(fichero,"db ");
					if( strcmp(tabla[i].valor,"-")==0 ){
						//si no tiene valor
						fprintf(fichero,"? ");
					}else{
						fprintf(fichero,"%s ",tabla[i].valor);
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
