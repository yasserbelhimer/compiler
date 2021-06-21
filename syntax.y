  
%{
    //   TOUABTI Mohamed MASTER1 IV  groupe2  171732028255

    //   SEGUENI Seif Eddine MASTER1 IV  groupe2  171732028289  

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include<math.h>
#include<time.h>
#include<io.h>
#include    "TS.h"
 #include "TB_Erreur.h" 
#include  "routine_sem.h"
#include  "quadr.h"
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
char curIDF[25];
char sauvIDF[25];
char sauvIDF2[25];
char tmp [20];
int type=0;
int div0=0;
int cpt=0,cpt2;
int vr=0;
int c1,c2;
char logFileName[200];
pile sauv_deb,sauv_bz,sauv_bz_controle,sauv_br;
int Lidf,Cidf,Lconst,Cconst;
Tab Exp;
char resExp[200];
Tab Cond;
char resCond[200];

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
%token CODE START <sval>idf END <sval>INTEGER <sval>REAL <sval>CHAR <sval>STRING CONST WHILE EXECUTE WHEN DO OTHERWISE PROD
%token <ival>CONST_INT
%token <sval>CONST_REAL 
%token <sval>CONST_STRING 
%token <cval>CONST_CHAR 
%left PLUS MOINS
%left MULT DIV
%start axiom
%nonassoc MOINSU
%%
axiom: CODE IDF DECLARATION START INSTRUCTIONS END {printf("\n\n\t\t execute avec succes\n");YYACCEPT;}
;
DECLARATION:LISTE_DECLARATION
|
;
LISTE_DECLARATION:  TYPE LISTE_IDF POINT_VIRGULE 
|                   TYPE LISTE_IDF POINT_VIRGULE LISTE_DECLARATION
|                   CONST TYPE IDF  EGAL CONSTANTE POINT_VIRGULE {DoubleDeclaration(curIDF,Lidf,Cidf);ModifierTS(curIDF,2,sauveType,"");ModifierTS(curIDF,1,sauveChar,sauveType);ModifierTS(curIDF,3,"","");CompatibiliteType(curIDF,sauveChar,Lidf,Cidf);}
|                   CONST TYPE IDF  EGAL CONSTANTE POINT_VIRGULE {DoubleDeclaration(curIDF,Lidf,Cidf);ModifierTS(curIDF,2,sauveType,"");ModifierTS(curIDF,1,sauveChar,sauveType);ModifierTS(curIDF,3,"","");CompatibiliteType(curIDF,sauveChar,Lidf,Cidf);} LISTE_DECLARATION 
;
IDF:idf {Lidf=nb_ligne;Cidf=col-strlen($1); strcpy(curIDF,$1);}
;
TYPE: INTEGER {strcpy(sauveType,$1);}
| REAL {strcpy(sauveType,$1);}
| CHAR {strcpy(sauveType,$1);}
| STRING {strcpy(sauveType,$1);}
;
CONSTANTE: CONST_INT {itoa($1,sauveChar,10);} 
| CONST_REAL  {strcpy(sauveChar,$1);}
| CONST_STRING {strcpy(sauveChar,$1);}
| CONST_CHAR  {sauveChar[0]='\'';sauveChar[1]=$1;sauveChar[2]='\'';sauveChar[3]='\0';}
;
LISTE_IDF: IDF {DoubleDeclaration(curIDF,Lidf,Cidf);ModifierTS(curIDF,2,sauveType,"");}
| IDF {DoubleDeclaration(curIDF,Lidf,Cidf);ModifierTS(curIDF,2,sauveType,"");} VIRGULE LISTE_IDF 
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
AFFECTATION:        IDF {cpt2=1;type=1;strcpy(sauvIDF,curIDF);IdfNonDeclarer(curIDF,Lidf,Cidf);ModifierConst(curIDF,Lidf,Cidf);} DEUX_POINTS EGAL EXPRESSION  POINT_VIRGULE{type=2;}
;


BOUCLE: BOUCLE_B EXECUTE ACCOLADE_OUVRANTE INSTRUCTIONS ACCOLADE_FERMANTE  POINT_VIRGULE 
 {
  itoa(depiler(&sauv_deb),tmp,10);
  InsererQuadr("BR",tmp,"","");
  itoa(qc,tmp,10);
  Maj_Quad(depiler(&sauv_bz),1,tmp);
 }
;
BOUCLE_B: BOUCLE_A CONDITION  {empiler(&sauv_bz,qc);InsererQuadr("BZ","","",resCond);}
;
BOUCLE_A: WHILE {empiler(&sauv_deb,qc);cpt2=1;}
;



CONTROLE: CONTROLE_B OTHERWISE BLOCK {itoa(qc,tmp,10);Maj_Quad(depiler(&sauv_br),1,tmp);}
;
CONTROLE_B: CONTROLE_A DO BLOCK 
 { 
    empiler(&sauv_br,qc);
    InsererQuadr("BR","","","");
    itoa(qc,tmp,10);
    Maj_Quad(depiler(&sauv_bz_controle),1,tmp);
 }
;
CONTROLE_A: WHEN {cpt2=1;} CONDITION {empiler(&sauv_bz_controle,qc);InsererQuadr("BZ","","",resCond);}
;


BLOCK:AFFECTATION|BOUCLE|CONTROLE
;

CONDITION: OPERAND {c2=c1;} OPERATEUR_LOGIQUE OPERAND {quadruplets_condition(&Cond,resCond,c1,c2,Lconst,Cconst);} 
;


OPERAND: EXPA {InsererChar(&Cond,resExp,' ',2);c1=1;}
| CONST_STRING {InsererChar(&Cond,$1,' ',2);c1=2;Lconst=nb_ligne;Cconst=col-strlen($1);}
| CONST_CHAR   {InsererChar(&Cond,"",$1,1);c1=3;Lconst=nb_ligne;Cconst=col-1;}
;
OPERATEUR_LOGIQUE: EQ  {InsererChar(&Cond,"EQ",' ',2);}
| LT  {InsererChar(&Cond,"LT",' ',2);}
| GT  {InsererChar(&Cond,"GT",' ',2);}
| LE  {InsererChar(&Cond,"LE",' ',2);}
| GE  {InsererChar(&Cond,"GE",' ',2);}
| NE  {InsererChar(&Cond,"NE",' ',2);}
;
EXPRESSION: CONST_CHAR {tmp[0]=$1;tmp[1]='\0';InsererQuadr(":=",tmp,"",sauvIDF);}
|           CONST_STRING  { InsererQuadr(":=",$1,"",sauvIDF);}
|           EXPA   
            {
                InsererQuadr(":=",resExp,"",sauvIDF);
                DivisionPar0(sauvIDF,sauveChar,sauvIDF2,div0,cpt,vr,Lidf,Cidf);
                 div0=0;
            }
|           PRO
;
EA:     EA PLUS {InsererChar(&Exp,"",'+',1);} EA 
|       EA MOINS {InsererChar(&Exp,"",'-',1);} EA 
|       EA MULT {InsererChar(&Exp,"",'*',1);} EA
|       EA DIV {InsererChar(&Exp,"",'/',1);div0=1;cpt=0;}EA 
|       PARENTHESE_OUVRANTE {InsererChar(&Exp,"",'(',1);} EA PARENTHESE_FERMANTE {InsererChar(&Exp,"",')',1);}
|       IDF {
              InsererChar(&Exp,curIDF,' ',2);
               vr=1;
               strcpy(sauvIDF2,curIDF);
               cpt++;
               IdfNonDeclarer(curIDF,Lidf,Cidf);
                if(type==1) {CompatibiliteType(sauvIDF,curIDF,Lidf,Cidf);}
            }
|       NOMBRE { 
                InsererChar(&Exp,sauveChar,' ',2);
                 vr=2;
                 cpt++;
                 if(type==1) {CompatibiliteType(sauvIDF,sauveChar,Lconst,Cconst);}
               }
;
EXPA: EA {quadruplets_expression(&Exp,resExp,&cpt2);}
;
NOMBRE:CONST_INT {itoa($1,sauveChar,10);Lconst=nb_ligne;Cconst=col-strlen(sauveChar);} 
|CONST_REAL {strcpy(sauveChar,$1);Lconst=nb_ligne;Cconst=col-strlen(sauveChar);}
;
PRO:   PROD {InsererQuadr(":=","1","",sauvIDF);} PARENTHESE_OUVRANTE LISTE_EXP PARENTHESE_FERMANTE
;      

LISTE_EXP:  EXPA  {quadrProd(sauvIDF,resExp);} VIRGULE  LISTE_EXP_A
;
LISTE_EXP_A:  LISTE_EXP
|              EXPA  {quadrProd(sauvIDF,resExp);}
;

%%
int main() {
    // initialisation();
    yyin = fopen( "programme.txt", "r" );
    if (yyin==NULL) 
        printf("ERROR \n");
    else 
         init();
         initLogFile();
         initTab(&Exp);
         initTab(&Cond);
         initPile(&sauv_deb);
         initPile(&sauv_bz);
         initPile(&sauv_br);         
         initPile(&sauv_bz_controle);
        yyparse();
    afficherErr();    
    afficherTs_IDF();
    afficherTs_MC_Sep(2);
    afficherTs_MC_Sep(3);
    afficher_qdr();
    fclose(yyin);
    return 0;
}

int yywrap(){

}


void yyerror (char* msg){
        char err[200];
        sprintf(err,"Erreur Syntaxique  : line %d  column %d  \n",nb_ligne,col);
        insererErr(err,2); 
        afficherErr();
        exit(-1);

}


