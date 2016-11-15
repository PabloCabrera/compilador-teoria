#define son_iguales(x, y) (strcmp(x,y)==0)
void escribir_asm (PolacaInversa polaca, FILE *file);
char* etiqueta_salto;
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
				
			} else if (son_iguales(polaca-> texto, "write")) {
				fprintf(file, "\tMOV AH, 9\n" );
				fprintf(file, "\tINT 21H\n" );
			
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
			if (polaca-> simbolo -> tipo == STRING){
				fprintf(file, "\tMOV DX,OFFSET %s\n", polaca-> simbolo-> nombre);	
			} else {
				fprintf(file, "\tFLD %s\n" , polaca -> simbolo -> nombre);
			}

			break;
	}

	if (polaca-> siguiente != NULL) {
		escribir_asm (polaca-> siguiente, file);
	}
	
}