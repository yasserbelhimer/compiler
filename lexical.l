%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include<math.h>
    #include<limits.h>
    #include "syntax.tab.h"
    int nb_ligne=1;
    int col=1;
    extern void inserer(char a[],char b[],char c[],int li,int cl,float val,int cas);
    extern void yyerror(const char* s);
%}
lettre_maj [A-Z]
lettre_min [a-z]
lettre [a-zA-Z]
chiffre [0-9]
IDF {lettre_maj}({lettre}|{chiffre})*
CONST_INT ("-"|"+")?{chiffre}+
CONST_REAL ("-"|"+")?{chiffre}+"."{chiffre}+
CONST_CHAR "'".?"'"
CONST_STRING "\""[^"\""]*"\""
COMMENTAIRE "$"[^$]*"$"
%%
CODE {
    inserer(yytext,"MotCle","",nb_ligne,col,0,2); 
    col = col + strlen(yytext);
    return CODE;
}
START {
    inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    return START;
}
"END." {
    inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    return END;
}
INTEGER {
    inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    yylval.sval=strdup(yytext);
    return INTEGER;
}
REAL {
    inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    yylval.sval=strdup(yytext);
    return REAL;
}
CHAR {
    inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    yylval.sval=strdup(yytext);
    return CHAR;
}
STRING {
    inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    yylval.sval=strdup(yytext);
    return STRING;
}
CONST {
    inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    return CONST;
}
WHILE {
    inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    return WHILE;
}
EXECUTE {
    inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    return EXECUTE;
}
WHEN {
    inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    return WHEN;
}
DO {
    inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    return DO;
}
OTHERWISE {
    inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    return OTHERWISE;
}
PROD {
    inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    return PROD;
}
= {
    inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return EGAL;
}
: {
    inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return DEUX_POINTS;
}
; {
    inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return POINT_VIRGULE;
}
, {
    inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return VIRGULE;
}
"." {
    inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return POINT;
}
"+" {
    inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return PLUS;
}
"-" {
    inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return MOINS;
}
"*" {
    inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return MULT;
}
"/" {
    inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return DIV;
}
EQ {
    inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return EQ;
}
LT {
    inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return LT;
}
GT {
    inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return GT;
}
LE {
    inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return LE;
}
GE {
    inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return GE;
}
NE {
    inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return NE;
}
"{" {
    inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return ACCOLADE_OUVRANTE;
}
"}" {
    inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return ACCOLADE_FERMANTE;
}
"(" {
    inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return PARENTHESE_OUVRANTE;
}
")" {
    inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return PARENTHESE_FERMANTE;
}
{CONST_INT} {
    col = col + strlen(yytext);
    if(yyleng <= 6){
        inserer(yytext,"CONST_INT","INTEGER",nb_ligne,col-yyleng,atof(yytext),1);
        yylval.ival=atoi(yytext);
        return CONST_INT;
    }
    else{
        char err[200];
        sprintf(err,"Erreur Lexicale , la taille  de la constante entiere  %s   a  depasse 6  : line %d  column %d  \n",yytext,nb_ligne,col-yyleng);
        insererErr(err,1);     
        afficherErr();
        exit(-1);

    }
};
{CONST_REAL} {
    col = col + strlen(yytext);
    if(yyleng <= 8){
        inserer(yytext,"CONST_REAL","REAL",nb_ligne,col-yyleng,atof(yytext),1);
        yylval.sval=yytext;
        return CONST_REAL;
    }
    else{
        char err[200];
        sprintf(err,"Erreur Lexicale , la taille de la constante reel  %s   a  depasse 8  : line %d  column %d  \n",yytext,nb_ligne,col-yyleng);
        insererErr(err,1); 
        afficherErr();
        exit(-1);

    }
}
{CONST_CHAR} {
    inserer(yytext,"CONST_CHAR","CHAR",nb_ligne,col,0,1);
    col = col + strlen(yytext);
    yylval.cval=yytext[1];
    return CONST_CHAR;
}
{CONST_STRING} {
    col = col + strlen(yytext);
    inserer(yytext,"CONST_STR","STRING",nb_ligne,col-yyleng,0,1);
    yylval.sval=strdup(yytext);
    return CONST_STRING;
}
{COMMENTAIRE} {
    int i=0;
    while(i<yyleng) { 
      if(yytext[i]=='\n'){
          nb_ligne++;col=1;
        }
       i=i+1;
    }
    col++;
} 
{IDF} {
    col = col + strlen(yytext);
    if(yyleng <= 20){
        inserer(yytext,"IDF","",nb_ligne,col-yyleng,100008000,1);
        yylval.sval=strdup(yytext); 
        return  idf;
    }
    else{
        char err[200];
        sprintf(err,"Erreur Lexicale , la taille de l'identificateur   %s   a  depasse 20  : line %d  column %d  entite: %s\n",yytext,nb_ligne,col-yyleng);
        insererErr(err,1); 
        afficherErr();
        exit(-1);

    }
};
[ \t] {col = col + strlen(yytext);}
\n {nb_ligne++;col = 1;}
. {
        
        char err[200];
        sprintf(err,"Erreur Lexicale , entite inconnu    : line %d  column %d  entite: %s\n",nb_ligne,col,yytext);
        insererErr(err,1); 
        afficherErr();
        exit(-1);
}
%%