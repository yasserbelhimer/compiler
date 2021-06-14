  
%{
#include "headers.h"


int i = 0;
int typeInst = 0;
char sauveType[10];
char sauvIdfIcompatible[25];
char sauvIdfIcompatible2[25];
Element *element;

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
axiom: CODE IDF DECLARATION START INSTRUCTIONS END POINT {printf("Execute avec succes\n");YYACCEPT;}
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
CONSTANTE:  CONST_INT {
                strcpy(sauveType,"INTEGER");
            }
|           CONST_REAL {
                strcpy(sauveType,"REAL");
            }
|           CONST_STRING {
                strcpy(sauveType,"STRING");
            }
|           CONST_CHAR {
                strcpy(sauveType,"CHAR");
            }
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
DECLARATION_CONSTANTE: IDF EGAL CONSTANTE {
        element = verifierexistetype($1);
        if(element!=NULL){
            inserertype(element,sauveType,"CONSTANTE");
        }
        else{
            printError("Symantec error double declaration",$1);
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
AFFECTATION:        IDF DEUX_POINTS EGAL {
                        idfNotDeclard($1);  
                        verifierConstate($1);                          
                        strcpy(sauvIdfIcompatible,$1);
                        typeInst = 1;
                    } EXPRESSION  POINT_VIRGULE {typeInst = 0 ;}
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
            idfNotDeclard($1);
            if(typeInst==1)
                compatibiliteType(sauvIdfIcompatible,$1,1);            
        }
|       NOMBRE {
            if(typeInst==1)
                compatibiliteType(sauvIdfIcompatible,sauvIdfIcompatible2,2);
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
    afficherSeparateurs();
    afficherKeywords();
    
    // afficherTs_MC_Sep(2);
    // afficherTs_MC_Sep(3);
    fclose(yyin);
    return 0;
}

int yywrap(){

}