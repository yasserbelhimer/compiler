  
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
  #include<math.h>
#include    "TS.h"
#include  "routine_sem.h"
// #include "TSS.h"
// #include "pgm.h"

extern int yylex();
extern int yyparse();
extern FILE* yyin;
extern int nb_ligne;
extern int col;

// values val;
// int tabPile[1000];
// int indexPile=-1;
// int qc=0,typeExp;
// int tmpQc = 1,optionIDF;
// int Fin_if=0;
// char tmp [20];
// char idf [20];
// int type,myIndex,mode;
// int TabOrIdf = 0;
char sauveType[10];
char sauveChar[10];
void yyerror(char* msg);
%}
%union {
    int ival;
    float fval;
    char cval;
    char* sval;
}
%token EGAL DEUX_POINTS POINT_VIRGULE VIRGULE POINT 
%token EQ LT GT LE GE NE 
%token ACCOLADE_OUVRANTE ACCOLADE_FERMANTE PARENTHESE_OUVRANTE PARENTHESE_FERMANTE
%token CODE START <sval>IDF END <sval>INTEGER <sval>REAL <sval>CHAR <sval>STRING CONST WHILE EXECUTE WHEN DO OTHERWISE PROD
%token <ival>CONST_INT
%token <fval>CONST_REAL 
%token <sval>CONST_STRING 
%token <cval>CONST_CHAR 
%left PLUS MOINS
%left MULT DIV
%start axiom
%nonassoc MOINSU
%%
axiom: CODE IDF DECLARATION START INSTRUCTIONS END {printf("execute avec succes\n");YYACCEPT;}
;
DECLARATION:LISTE_DECLARATION
|
;
LISTE_DECLARATION:  TYPE LISTE_IDF POINT_VIRGULE 
|                   TYPE LISTE_IDF POINT_VIRGULE LISTE_DECLARATION
|                   CONST TYPE IDF  EGAL CONSTANTE POINT_VIRGULE {DoubleDeclaration($3,nb_ligne,col);ModifierTS($3,2,sauveType,"");ModifierTS($3,1,sauveChar,sauveType);CompatibiliteType($3,sauveChar,nb_ligne,col);}
|                   CONST TYPE IDF  EGAL CONSTANTE POINT_VIRGULE {DoubleDeclaration($3,nb_ligne,col);ModifierTS($3,2,sauveType,"");ModifierTS($3,1,sauveChar,sauveType);CompatibiliteType($3,sauveChar,nb_ligne,col);} LISTE_DECLARATION 
;
TYPE: INTEGER {strcpy(sauveType,$1);}
| REAL {strcpy(sauveType,$1);}
| CHAR {strcpy(sauveType,$1);}
| STRING {strcpy(sauveType,$1);}
;
CONSTANTE: CONST_INT {itoa($1,sauveChar,10);} 
| CONST_REAL  {gcvt($1,6,sauveChar);}
| CONST_STRING {strcpy(sauveChar,$1);}
| CONST_CHAR  {sauveChar[0]='\'';sauveChar[1]=$1;sauveChar[2]='\'';sauveChar[3]='\0';}
;
LISTE_IDF: IDF {DoubleDeclaration($1,nb_ligne,col);ModifierTS($1,2,sauveType,"");}
| IDF {DoubleDeclaration($1,nb_ligne,col);ModifierTS($1,2,sauveType,"");} VIRGULE LISTE_IDF 
;
INSTRUCTIONS:       LISTE_INSTRUCTION
|
;
LISTE_INSTRUCTION:  AFFECTATION
|                   AFFECTATION LISTE_INSTRUCTION
|                   BOUCLE
|                   BOUCLE LISTE_INSTRUCTION
|                   CONTROLE
|                   CONTROLE LISTE_INSTRUCTION
;
AFFECTATION:        IDF {IdfNonDeclarer($1,nb_ligne,col);} DEUX_POINTS EGAL EXPRESSION  POINT_VIRGULE
;
BOUCLE: WHILE CONDITION EXECUTE ACCOLADE_OUVRANTE INSTRUCTIONS ACCOLADE_FERMANTE POINT_VIRGULE
;
CONTROLE: WHEN CONDITION DO AFFECTATION OTHERWISE AFFECTATION 
;
CONDITION: OPERAND OPERATEUR_LOGIQUE OPERAND
;
OPERAND: EA | CONST_STRING | CONST_CHAR
;
OPERATEUR_LOGIQUE: EQ | LT | GT | LE | GE | NE
;
EXPRESSION: CONST_CHAR
|           CONST_STRING
|           EA
|           PRO
;
EA:     EA PLUS EA 
|       EA MOINS EA 
|       EA MULT EA
|       EA DIV EA
|       PARENTHESE_OUVRANTE EA PARENTHESE_FERMANTE
|       IDF {IdfNonDeclarer($1,nb_ligne,col);}
|       NOMBRE
;
NOMBRE:CONST_INT|CONST_REAL
;
PRO:   PROD PARENTHESE_OUVRANTE LISTE_EXP PARENTHESE_FERMANTE
;      
LISTE_EXP:  EA  VIRGULE  LISTE_EXP
|           EA VIRGULE EA 
;
%%
int main() {
    // initialisation();
    yyin = fopen( "programme.txt", "r" );
    if (yyin==NULL) 
        printf("ERROR \n");
    else 
        yyparse();
    afficherTs_IDF();
    //afficherTs_MC_Sep(2);
    //afficherTs_MC_Sep(3);
    fclose(yyin);
    return 0;
}

int yywrap(){

}


void yyerror (char* msg){
    printf("%s : line %d  column %d ",msg,nb_ligne,col);
}

int PrintError(char* Type ,char* entite){
    yyerror(Type);
    printf(" entite: %s \n",entite);
    exit(-1);       
}
