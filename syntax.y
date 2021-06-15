  
%{
#include "headers.h"


int i = 0;
int typeInst = 0;
char sauveType[10];
char sauvIdfIcompatible[25];
char sauvIdfIcompatible2[25];
char tmp [20];
int tmpQc=1;
int finQc=0;
char tmpQcStr[20];
int prod = 0;
Element *element;
int itIsDiv = 0;
%}
%union {
    int ival;
    float fval;
    char* sval;
}
%token EGAL DEUX_POINTS POINT_VIRGULE VIRGULE POINT 
%token EQ LT GT LE GE NE 
%token ACCOLADE_OUVRANTE ACCOLADE_FERMANTE PARENTHESE_OUVRANTE PARENTHESE_FERMANTE
%token CODE START END <sval>INTEGER <sval>REAL <sval>CHAR <sval>STRING CONST WHILE EXECUTE WHEN DO OTHERWISE PROD
%token <ival>CONST_INT
%token <fval>CONST_REAL 
%token <sval>CONST_CHAR <sval>CONST_STRING IDF
%type <sval>EA EXPRESSION
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
                        prod = 0;
                    } EXPRESSION  POINT_VIRGULE {typeInst = 0 ; if(!prod) insererQuadr(":=",$5,"",$1);}
;
BOUCLE: WHILE CONDITION EXECUTE ACCOLADE_OUVRANTE INSTRUCTIONS ACCOLADE_FERMANTE POINT_VIRGULE
;
CONTROLE: WHEN CONDITION DO {
        finQc = qc;
        insererQuadr("BZ","","t_cond","");
    } AFFECTATION {
        miseAjour(finQc);
        finQc = qc;
        insererQuadr("BR","","","");
    } OTHERWISE AFFECTATION {
        miseAjour(finQc);
    }
;
CONDITION: OPERAND OPERATEUR_LOGIQUE OPERAND
;
OPERAND: EA | CONST_STRING | CONST_CHAR
;
OPERATEUR_LOGIQUE: EQ | LT | GT | LE | GE | NE
;
EXPRESSION: CONST_CHAR {$$=strdup($1);}
|           CONST_STRING {$$=strdup($1);}
|           EA  {tmpQc=1; $$=strdup($1);}
|           PRO {$$=strdup(tmp);prod = 1;}
;
EA:     EA PLUS EA {sprintf(tmp,"t%d",tmpQc++); insererQuadr("+",$1,$3,tmp);$$=strdup(tmp);}
|       EA MOINS EA {sprintf(tmp,"t%d",tmpQc++);insererQuadr("-",$1,$3,tmp);$$=strdup(tmp);}
|       EA MULT EA {sprintf(tmp,"t%d",tmpQc++);insererQuadr("*",$1,$3,tmp);$$=strdup(tmp);}
|       EA DIV {itIsDiv = 1;} EA {sprintf(tmp,"t%d",tmpQc++);insererQuadr("/",$1,$4,tmp);$$=strdup(tmp);itIsDiv = 0;}
|       PARENTHESE_OUVRANTE EA PARENTHESE_FERMANTE {$$= strdup($2);}
|       IDF {
            idfNotDeclard($1);
            if(typeInst==1)
                compatibiliteType(sauvIdfIcompatible,$1,1);            
        }
|       CONST_INT {
            if(itIsDiv && $1==0)
                printError("Symantec error division par zero","0");
            strcpy(sauvIdfIcompatible2,"INTEGER");
            sprintf(tmp,"%d",$1);
            $$=strdup(tmp);
        }
|       CONST_REAL{
            if(itIsDiv && $1==0.0)
                printError("Symantec error division par zero","0.0");
            strcpy(sauvIdfIcompatible2,"REAL");
            sprintf(tmp,"%.2f",$1);
            $$=strdup(tmp);
        }
;
PRO:   PROD {insererQuadr(":=","1","",sauvIdfIcompatible);} PARENTHESE_OUVRANTE LISTE_EXP PARENTHESE_FERMANTE
;      
LISTE_EXP:  EA { 
                sprintf(tmpQcStr,"%d",qc+3); 
                insererQuadr("BMZ",tmpQcStr,$1,"");
                sprintf(tmp,"t%d",tmpQc++);
                insererQuadr("*",sauvIdfIcompatible,$1,tmp);
                insererQuadr(":=",tmp,"",sauvIdfIcompatible);
            } VIRGULE  LISTE_EXP
|           EA { 
                sprintf(tmpQcStr,"%d",qc+3); 
                insererQuadr("BMZ",tmpQcStr,$1,"");
                sprintf(tmp,"t%d",tmpQc++);
                insererQuadr("*",sauvIdfIcompatible,$1,tmp);
                insererQuadr(":=",tmp,"",sauvIdfIcompatible);
            }
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
    AfficherQuadruples();
    
    // afficherTs_MC_Sep(2);
    // afficherTs_MC_Sep(3);
    fclose(yyin);
    return 0;
}

int yywrap(){

}