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

#include "structs.h"
#include "function.h"
#include "ts.h"
#include "routines.h"
