  
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
// #include "TS.h"
// #include "TSS.h"
// #include "pgm.h"

extern int yylex();
extern int yyparse();
extern FILE* yyin;
extern int nb_ligne;

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
int yyerror(char* msg);
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
%token CODE START END INTEGER REAL CHAR STRING CONST WHILE EXECUTE WHEN DO OTHERWISE
%token <ival>CONST_INT
%token <fval>CONST_REAL 
%token <cval>CONST_STRING 
%token <sval>CONST_CHAR IDF
%left PLUS MOINS
%left MULT DIV
%start axiom
%nonassoc MOINSU
%%
axiom: CODE IDF DECLARATION START INSTRUCTIONS END {printf("execute avec succes\n");}
;
DECLARATION:LISTE_DECLARATION
|
;
LISTE_DECLARATION:  TYPE LISTE_IDF POINT_VIRGULE
|                   TYPE LISTE_IDF POINT_VIRGULE LISTE_DECLARATION
|                   CONST IDF EGAL CONSTANTE POINT_VIRGULE
|                   CONST IDF EGAL CONSTANTE POINT_VIRGULE LISTE_DECLARATION
;
TYPE: INTEGER | REAL | CHAR | STRING
;
CONSTANTE: CONST_INT | CONST_REAL | CONST_STRING | CONST_CHAR
;
LISTE_IDF: IDF | IDF VIRGULE LISTE_IDF
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
AFFECTATION:        IDF DEUX_POINTS EGAL EXPRESSION  POINT_VIRGULE
;
BOUCLE: WHILE EXECUTE ACCOLADE_OUVRANTE INSTRUCTIONS ACCOLADE_FERMANTE
;
CONTROLE: WHEN DO AFFECTATION OTHERWISE AFFECTATION 
;
EXPRESSION: CONST_CHAR
|           CONST_STRING
|           EA
;
EA:     EA PLUS EA 
|       EA MOINS EA 
|       EA MULT EA
|       EA DIV EA
|       PARENTHESE_OUVRANTE EA PARENTHESE_FERMANTE
|       IDF
|       NOMBRE
;
NOMBRE:CONST_INT|CONST_REAL
;
%%
int main() {
    // initialisation();
    yyin = fopen( "programme.txt", "r" );
    if (yyin==NULL) 
        printf("ERROR \n");
    else 
        yyparse();
    // afficher();
    // afficher_qdr();
    fclose(yyin);
    return 0;
}

int yyerror (char* msg){

printf("%s : line %d \n",msg,nb_ligne);
return 1;
}