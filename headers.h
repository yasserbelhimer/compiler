#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <io.h>


extern int yylex();
extern int yyparse();
extern FILE* yyin;
extern int nb_ligne;
extern int col;
int qc =0;
#include "structs.h"
#include "function.h"
#include "ts.h"
#include "quad.h"
#include "routines.h"
int typeInst = 0;
char sauveType[10];
char sauvIdf[25];
char sauvIdf2[25];
char tmp [20];
char cond_tmp [20];
char constValue[255];
int tmpQc=1;
int finQc=0;
int cond_temp = 1;
char tmpQcStr[20];
int prod = 0;
Element *element;
int itIsDiv = 0;
int beginWhile;
int beginWhileBZ;
float denominateur;
int debutDiv,finDiv;