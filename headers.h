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
