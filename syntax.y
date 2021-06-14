  
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <io.h>

#include "structs.h"
#include "ts.h"
#include "routines.h"
// #include "TSS.h"
// #include "pgm.h"

extern int yylex();
extern int yyparse();
extern FILE* yyin;
extern int nb_ligne;
extern int col;
int i = 0;
char sauveType[10];
char sauvIdfIcompatible[25];
char sauvIdfIcompatible2[25];
Element *element;
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
void yyerror(char* msg);
int printError(char* Type ,char* entite);
int printIncompatibleTypeError(char* type1,char* type2);
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
%token CODE START END <sval>INTEGER <sval>REAL <sval>CHAR <sval>STRING CONST WHILE EXECUTE WHEN DO OTHERWISE PROD
%token <ival>CONST_INT
%token <fval>CONST_REAL 
%token <cval>CONST_STRING 
%token <sval>CONST_CHAR IDF
%left PLUS MOINS
%left MULT DIV
%start axiom
%nonassoc MOINSU
%%
axiom: CODE IDF DECLARATION START INSTRUCTIONS END {printf("Execute avec succes\n");YYACCEPT;}
;
DECLARATION:LISTE_DECLARATION
|
;
LISTE_DECLARATION:  TYPE LISTE_IDF POINT_VIRGULE
|                   TYPE LISTE_IDF POINT_VIRGULE LISTE_DECLARATION
|                   CONST DECLARATION_CONSTANTE POINT_VIRGULE 
|                   CONST DECLARATION_CONSTANTE POINT_VIRGULE LISTE_DECLARATION
;
TYPE: INTEGER {
        strcpy(sauveType,$1);
    }
|   REAL {
        strcpy(sauveType,$1);
    }
|   CHAR {
        strcpy(sauveType,$1);
    }
|   STRING {
        strcpy(sauveType,$1);
    }
;
CONSTANTE: CONST_INT | CONST_REAL | CONST_STRING | CONST_CHAR
;
LISTE_IDF:  IDF VIRGULE LISTE_IDF {
        element = verifierexistetype($1);
        if(element!=NULL){
            inserertype(element,sauveType,"VARIABLE");
        }
        else{
            printError("Symantec error double declaration",$1);
        }
    }
|   IDF {
        element = verifierexistetype($1);
        if(element!=NULL){
            inserertype(element,sauveType,"VARIABLE");
        }
        else{
            printError("Symantec error double declaration",$1);
        }
    }
;
DECLARATION_CONSTANTE: TYPE IDF EGAL CONSTANTE {
        element = verifierexistetype($2);
        if(element!=NULL){
            inserertype(element,sauveType,"CONSTANTE");
        }
        else{
            printError("Symantec error double declaration",$2);
        }
    }
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
AFFECTATION:        IDF DEUX_POINTS EGAL EXPRESSION  POINT_VIRGULE {
    element = verifierexistetype($1);
    if(element!=NULL)
        printError("Symantec error variable non declarer",$1);
    if(verifierConstate($1)==1)
        printError("Symantec error une constante ne peut pas etre changer",$1);
    strcpy(sauvIdfIcompatible,$1);
    
    
}
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
|       IDF {
            Element *element1 = rechercherIdf($1);
            if (element1 != NULL && (strcmp(element1->TypeEntite, "") == 0))
                printError("Symantec error variable non declarer",$1);
            Element *element2 = rechercherIdf(sauvIdfIcompatible);

            if(element1 != NULL && element2 != NULL && strcmp(element1->TypeEntite,element2->TypeEntite)!=0)
                printIncompatibleTypeError(element1->TypeEntite,element2->TypeEntite);
            
        }
|       NOMBRE {
            Element *element = rechercherIdf(sauvIdfIcompatible);
            if(element != NULL && sauvIdfIcompatible2 != NULL && strcmp(element->TypeEntite,sauvIdfIcompatible2)!=0)
                printIncompatibleTypeError(element->TypeEntite,sauvIdfIcompatible2);
}
;
NOMBRE:CONST_INT {
    strcpy(sauvIdfIcompatible2,"INTEGER");
}
|   CONST_REAL{
    strcpy(sauvIdfIcompatible2,"REAL");
}
;
PRO:   PROD PARENTHESE_OUVRANTE LISTE_EXP PARENTHESE_FERMANTE
;      
LISTE_EXP:  EA  VIRGULE  LISTE_EXP
|           EA VIRGULE EA 
;
%%
int main() {
    initialisation();
    yyin = fopen( "programme.txt", "r" );
    if (yyin==NULL) 
        printf("ERROR \n");
    else 
        yyparse();
    afficherIdf();
    
    // afficherTs_MC_Sep(2);
    // afficherTs_MC_Sep(3);
    fclose(yyin);
    return 0;
}

int yywrap(){

}


void yyerror (char* msg){
    printf("%s : line %d  column %d ",msg,nb_ligne,col);
}

int printError(char* Type ,char* entite){
    yyerror(Type);
    printf(" entite: %s \n",entite);
    exit(-1);       
}
int printIncompatibleTypeError(char* type1,char* type2){
    yyerror("Symantec error incompatibilte de type");
    printf(" %s est incompatible avec %s \n",type1,type2);
    exit(-1);       
}