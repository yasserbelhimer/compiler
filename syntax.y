  
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
%token CODE START END INTEGER REAL CHAR STRING CONST WHILE EXECUTE WHEN DO OTHERWISE PROD
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
|                   CONST TYPE IDF EGAL CONSTANTE POINT_VIRGULE
|                   CONST TYPE IDF EGAL CONSTANTE POINT_VIRGULE LISTE_DECLARATION
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
BOUCLE: WHILE CONDITION EXECUTE ACCOLADE_OUVRANTE INSTRUCTIONS ACCOLADE_FERMANTE POINT_VIRGULE
;
CONTROLE: WHEN CONDITION DO AFFECTATION OTHERWISE AFFECTATION 
;
CONDITION: OPERAND OPERATEUR_LOGIQUE OPERAND
;
OPERAND: IDF | CONSTANTE
;
OPERATEUR_LOGIQUE: EQ | LT | GT | LE | GE | NE
;
EXPRESSION: CONST_CHAR
|           CONST_STRING
|           EA
|           PRODUIT
;
EA:     EA PLUS EA 
|       EA MOINS EA 
|       EA MULT EA
|       EA DIV EA
|       PARENTHESE_OUVRANTE EA PARENTHESE_FERMANTE
|       IDF
|       NOMBRE
;
NOMBRE: CONST_INT|CONST_REAL
;
PRODUIT:    PROD PARENTHESE_OUVRANTE EA VIRGULE EA LISTE_EXPRESSION PARENTHESE_FERMANTE
;
LISTE_EXPRESSION: VIRGULE EA LISTE_EXPRESSION
|
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
int yywrap(){

}
int yyerror (char* msg){
    printf("%s : line %d column %d\n",msg,nb_ligne,col);
    exit(-1);
}