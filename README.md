# TRABAJO PRÁCTICO: COMPILADOR

## CONSIDERACIONES GENERALES

Es necesario cumplir con las siguientes consideraciones para evaluar el TP.

1. Cada grupo deberá desarrollar el compilador teniendo en cuenta: 
  * Todos los temas comunes (Ver ANEXO TEMAS)
  * El tema especial asignado al grupo.

2. Se fijarán puntos de control con fechas y consignas determinadas


## PRIMERA ENTREGA

*OBJETIVO:* Realizar un analizador lexicografico utilizando la herramienta FLEX. El programa ejecutable deberá mostrar por pantalla los tokens que va analizando en base a un archivo de entrada (prueba.txt). Las impresiones deben ser claras. Las reglas que no realizan ninguna acción no deben generar salida. 

Se deberá entregar una carpeta con nombre: GrupoXX que incluirá:

* El archivo flex que se llamará Lexico.l
* El archivo ejecutable que se llamará Primera.exe

  De no ser posible el envío de un archivo ejecutable deberán renombrarse de la siguiente manera: Primera.exe como Primera.e
* Un archivo de pruebas generales que se  llamará prueba.txt y que dispondrá de un lote de pruebas generales que abarcará todos los temas especiales y comunes.(No deberán faltar selecciones y ciclos, temas especiales, verificación de cotas para las constantes, chequeo de longitud de los nombres de los identificadores, comentarios)
* Un archivo con la tabla de símbolos  ts.txt

Todo el material deberá ser enviado a: 
*Asunto : GrupoXX*
*Fecha de entrega:* 

## SEGUNDA ENTREGA

*OBJETIVO:* Realizar un analizador sintáctico utilizando las herramientas FLEX y BISON. El programa ejecutable deberá mostrar por pantalla las reglas sintácticas que va analizando el parser en base a un archivo de entrada (prueba.txt). Las impresiones deben ser claras. Las reglas que no realizan ninguna acción no deben generar salida. 

Se deberá entregar una carpeta con nombre: GrupoXX que incluirá:

* El archivo flex que se llamará Lexico.l
* El archivo bison que se llamará Sintactico.y
* El archivo ejecutable que se llamará Segunda.exe

  De no ser posible el envío de un archivo ejecutable deberán renombrarse de la siguiente manera: Segunda.exe como Segunda.e
* Un archivo de pruebas generales que se  llamará prueba.txt y que dispondrá de un lote de pruebas generales que abarcará todos los temas especiales y comunes.(No deberán faltar selecciones y ciclos anidados, temas especiales, verificación de cotas para las constantes, chequeo de longitud de los nombres de los identificadores, comentarios)
* Un archivo con la tabla de símbolos  ts.txt

Todo el material deberá ser enviado a: 
*Asunto : GrupoXX*
*Fecha de entrega:*

## TERCERA  ENTREGA

*OBJETIVO:* Realizar un generador de código intermedio utilizando el archivo BISON generado en la primera entrega. El programa ejecutable deberá procesar el archivo de entrada (prueba.txt) y devolver el código intermedio del mismo junto con la tabla de símbolos.

Se deberá entregar una carpeta con nombre: GrupoXX que incluirá:

* El archivo flex que se llamará Lexico.l
* El archivo bison que se llamará Sintactico.y
* El archivo ejecutable que se llamará Tercera.exe

  De no ser posible el envío de un archivo ejecutable deberán renombrarse de la siguiente manera: Tercera.exe como Tercera.e
*Un archivo de pruebas generales que se  llamará prueba.txt y que dispondrá de un lote de pruebas generales que abarcará todos los temas especiales y comunes.
* Un archivo con la tabla de símbolos  ts.txt
* Un archivo con la notación intermedia que se  llamará intermedia.txt y que contiene el código intermedio

Todo el material deberá ser enviado a: 
*Asunto : GrupoXX* 
*Fecha de entrega:*

## ENTREGA FINAL

*OBJETIVO:* Realizar un compilador  utilizando el archivo generado en la segunda entrega. El programa ejecutable deberá procesar el archivo de entrada (prueba.txt) , compilarlo y ejecutarlo.

Se deberá entregar una carpeta con nombre: GrupoXX que incluirá:

* El archivo flex que se llamará Lexico.l
* El archivo bison que se llamará Sintactico.y 
* El archivo ejecutable del compilador  que se  llamará Grupoxx.exe y que generará el código assembler final que se llamará Final.asm
  De no ser posible el envío de un archivo ejecutable deberán renombrarse de la siguiente manera: Grupoxx.exe como Grupoxx.e
* Un archivo de pruebas generales que se  llamará prueba.txt y que dispondrá de un lote de pruebas generales que abarcará :
  * Asignaciones
  * Selecciones
  * Impresiones
  * Un tema especial que se asignará por grupo

* Un archivo por lotes (Grupoxx.bat) que incluirá las sentencias necesarias para compilar con TASM y TLINK el archivo Final.asm generado por el compilador

De no ser posible el envío de los archivos ejecutables deberán renombrarse de la siguiente manera:
Grupoxx.bat como Grupoxx.b

En todos los casos el compilador Grupoxx.exe deberá generar los archivos intermedia.txt y Final.asm


Todo el material deberá ser enviado a: 
*Asunto : GrupoXX*
*Fecha de entrega:*

## ANEXO TEMAS

### TEMAS COMUNES

#### WHILE
Implementación de While

#### DECISIONES
Implementación de IF

#### ASIGNACIONES
Asignaciones simples A:=B

#### TIPO DE DATOS
Constantes numéricas
 
reales (32 bits)

El separador decimal será el punto “.”

Ejemplo:

a = 99999.99
a = 99.
a = .9999

Constantes string
Constantes de 30 caracteres alfanuméricos como máximo, limitada por comillas (“ “) ,de la forma “XXXX”

Ejemplo:

b = “@sdADaSjfla%dfg”
b = “asldk  fh sjf”


Las constantes deben ser reconocidas y validadas en el analizador léxico, de acuerdo a su tipo.

#### VARIABLES

Variables numéricas
Estas variables reciben valores numéricos tales como constantes numéricas, variables numéricas u operaciones que arrojen un valor numérico, del lado derecho de una asignación.

Variables string
Estas variables pueden recibir una constante string


Las variables no guardan su valor en tabla de símbolos.
Las asignaciones deben ser permitidas, solo en los casos en los que los tipos son compatibles, caso contrario deberá desplegarse un error.


#### COMENTARIOS
Deberán estar delimitados por “-/” y “/-“  y podrán estar anidados en un solo nivel.

Ejemplo1:
 	-/ Realizo una selección /-			
			IF (a <= 30) 
				b = ”correcto” -/ asignación string /-			ENDIF

Ejemplo2:  

      -/ Así son los comentarios  /-

Los comentarios se ignoran de manera que  no generan un componente léxico o token

#### SALIDA
Las salidas se implementaran como se muestra en el siguiente ejemplo:

Ejemplo:

WRITE “ewr”    --/ donde “ewr” debe ser una cte o variable string 

CONDICIONES
Las condiciones para un constructor de ciclos o de selección serán simples ( a < b )  

#### DECLARACIONES

Todas las variables deberán ser declaradas dentro de un bloque especial para ese fin, delimitado por las palabras reservadas DECVAR y ENDDEC, siguiendo el siguiente formato: 
DECVAR
Línea_de_Declaración_de_Tipos 
		ENDDEC

 Cada Línea_de_Declaración_de_Tipos tendrá la forma: < Lista de Variables> :  Tipo de Dato 

 La Lista de Variables debe ser una lista de variables separadas por comas.
Pueden existir varias líneas de declaración de tipos, incluso utilizando más de una línea para el mismo tipo.

Ejemplos de formato:    DEFVAR
a1, b1 : FLOAT
         					variable1 : STRING
					p1, p2, p3 : FLOAT

	            			ENDDEF

### TEMAS ESPECIALES


#### 1. Average
Esta función del lenguaje, tomará como entrada una lista de expresiones numéricas y devolverá el promedio calculado a partir de la evaluación de los componentes de dicha lista.
Esta función será utilizada en cualquier expresión del lenguaje.

AVG([lista de expresiones])

donde lista de expresiones será una secuencia de expresiones numéricas  separadas por coma (,) y delimitada por corchetes

Ejemplo: 
		AVG ([2 , a+b , c*(d+e) , 48])
AVG ([2.3 , 1.22])

#### 2. Factorial
La función especial Factorial tendrá el siguiente formato:

		FACT (Expresion)

Tomará como entrada una expresión y devolverá el número factorial de la misma.


#### 3. Longitud
Esta función calculará  la longitud de una lista de expresiones separadas por comas y encerrada entre corchetes

LONG ([exp1,exp2,exp3,…….,exp4]) = 4









### TABLA DE SIMBOLOS

La tabla de símbolos tiene la capacidad de guardar las variables y constantes con sus atributos. 
Los atributos portan información necesaria para operar con constantes, variables .
Ejemplo

| NOMBRE     | TIPO      | VALOR     | LONGITUD |
| ---------- | --------- | --------- | -------- |
| a1         | Float     | -         |          |
| b1         | Float     | -         |          |
| _variable1 | CteString | variable1 | 9        |
| _30.5      | CteReal   | 30.5      |          |

		

