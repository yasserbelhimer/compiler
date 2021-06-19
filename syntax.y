  
%{
#include "headers.h"
%}
%union {
    int ival;
    float fval;
    char* sval;
}
%token EGAL DEUX_POINTS POINT_VIRGULE VIRGULE POINT 
%token <sval>EQ <sval>LT <sval>GT <sval>LE <sval>GE <sval>NE 
%token ACCOLADE_OUVRANTE ACCOLADE_FERMANTE PARENTHESE_OUVRANTE PARENTHESE_FERMANTE
%token CODE START END <sval>INTEGER <sval>REAL <sval>CHAR <sval>STRING CONST WHILE EXECUTE WHEN DO OTHERWISE PROD
%token <ival>CONST_INT
%token <fval>CONST_REAL 
%token <sval>CONST_CHAR <sval>CONST_STRING IDF
%type <sval>EA EXPRESSION OPERAND OPERATEUR_LOGIQUE
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
|                   CONST TYPE DECLARATION_CONSTANTE POINT_VIRGULE 
|                   CONST TYPE DECLARATION_CONSTANTE POINT_VIRGULE LISTE_DECLARATION
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
                sprintf(constValue,"%d",$1);
            }
|           CONST_REAL {
                strcpy(sauveType,"REAL");
                sprintf(constValue,"%f",$1);
            }
|           CONST_STRING {
                strcpy(sauveType,"STRING");
                sprintf(constValue,"%s",$1);
            }
|           CONST_CHAR {
                strcpy(sauveType,"CHAR");
                sprintf(constValue,"%s",$1);
            }
;
LISTE_IDF:  IDF VIRGULE LISTE_IDF {
        element = verifierexistetype($1);
        if(element!=NULL){
            inserertype(element,sauveType,"VARIABLE",NULL);
        }
        else{
            printError("Symantec error double declaration",$1);
        }
    }
|   IDF {
        element = verifierexistetype($1);
        if(element!=NULL){
            inserertype(element,sauveType,"VARIABLE",NULL);
        }
        else{
            printError("Symantec error double declaration",$1);
        }
    }
;
DECLARATION_CONSTANTE: IDF EGAL CONSTANTE {
        element = verifierexistetype($1);
        if(element!=NULL){
            inserertype(element,sauveType,"CONSTANTE",constValue);
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
INSTRUCTION:    AFFECTATION
|               BOUCLE
|               CONTROLE
;
AFFECTATION:        IDF DEUX_POINTS EGAL {
                        idfNotDeclard($1);  
                        verifierConstate($1);                          
                        strcpy(sauvIdf,$1);
                        typeInst = 1;
                        prod = 0;
                    } EXPRESSION  POINT_VIRGULE {typeInst = 0 ; if(!prod) insererQuadr(":=",$5,"",$1);}
;
BOUCLE: WHILE CONDITION EXECUTE ACCOLADE_OUVRANTE INSTRUCTIONS {
        sprintf(tmp,"%d",debutCondition);
        insererQuadr("BR",tmp,"","");
        miseAjour(debutCondition);
    } ACCOLADE_FERMANTE POINT_VIRGULE
;
CONTROLE: WHEN CONDITION DO  INSTRUCTION {
        finCondition = qc;
        insererQuadr("BR","fin","","");
        miseAjour(debutCondition);
    } OTHERWISE INSTRUCTION {
        miseAjour(finCondition);
    }
;
CONDITION: OPERAND OPERATEUR_LOGIQUE OPERAND {
        debutCondition = qc;
        sprintf(cond_tmp,"",cond_temp++);
        insererQuadr($2,cond_tmp,$1,$3);
    }
;
OPERAND: EA | CONST_STRING | CONST_CHAR
;
OPERATEUR_LOGIQUE: EQ {sprintf(operateurLogique,"%s");} | LT | GT | LE | GE | NE
;
EXPRESSION: CONST_CHAR {
                if(typeInst==1)
                    compatibiliteType(sauvIdf,"CHAR",2);
                $$=strdup($1);   
            }
|           CONST_STRING {
                if(typeInst==1)
                    compatibiliteType(sauvIdf,"STRING",2);
                $$=strdup($1);
            }
|           EA  {tmpQc=1; $$=strdup($1);}
|           PRO {$$=strdup(tmp);prod = 1;}
;
EA:     EA PLUS EA {sprintf(tmp,"t%d",tmpQc++); insererQuadr("+",$1,$3,tmp);$$=strdup(tmp);}
|       EA MOINS EA {sprintf(tmp,"t%d",tmpQc++);insererQuadr("-",$1,$3,tmp);$$=strdup(tmp);}
|       EA MULT EA {sprintf(tmp,"t%d",tmpQc++);insererQuadr("*",$1,$3,tmp);$$=strdup(tmp);}
|       EA DIV {
            if(!itIsDiv)
                debutDiv = qc;
            itIsDiv++;
        } EA {
            sprintf(tmp,"t%d",tmpQc++);
            insererQuadr("/",$1,$4,tmp);
            $$=strdup(tmp);
            itIsDiv--;
            if(!itIsDiv){
                if(!divPar0(debutDiv,qc-1))
                printError("Symantec error division par zero","0");
            }           
        }
|       PARENTHESE_OUVRANTE EA PARENTHESE_FERMANTE {$$= strdup($2);}
|       IDF {
            idfNotDeclard($1);
            if(typeInst==1)
                compatibiliteType(sauvIdf,$1,1);            
        }
|       CONST_INT {
            if(typeInst==1)
                compatibiliteType(sauvIdf,"INTEGER",2);   
            strcpy(sauvIdf2,"INTEGER");
            sprintf(tmp,"%d",$1);
            $$=strdup(tmp);
        }
|       CONST_REAL{
            if(typeInst==1)
                compatibiliteType(sauvIdf,"REAL",2); 
            strcpy(sauvIdf2,"REAL");
            sprintf(tmp,"%.2f",$1);
            $$=strdup(tmp);
        }
;
PRO:   PROD {insererQuadr(":=","1","",sauvIdf);} PARENTHESE_OUVRANTE LISTE_EXP PARENTHESE_FERMANTE
;      
LISTE_EXP:  EA { 
                sprintf(tmpQcStr,"%d",qc+3); 
                insererQuadr("BMZ",tmpQcStr,$1,"");
                sprintf(tmp,"t%d",tmpQc++);
                insererQuadr("*",sauvIdf,$1,tmp);
                insererQuadr(":=",tmp,"",sauvIdf);
            } VIRGULE  LISTE_EXP
|           EA { 
                sprintf(tmpQcStr,"%d",qc+3); 
                insererQuadr("BMZ",tmpQcStr,$1,"");
                sprintf(tmp,"t%d",tmpQc++);
                insererQuadr("*",sauvIdf,$1,tmp);
                insererQuadr(":=",tmp,"",sauvIdf);
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
    fclose(yyin);
    return 0;
}

int yywrap(){

}