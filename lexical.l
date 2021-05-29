%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include<math.h>
    #include "syntax.tab.h"
    int nb_ligne=1;
    int col=1;
    extern YYSTYPE yylval;
    extern void insererIdfLex (char NomEntite[], char CodeEntite[],int ligne,int col);
    extern int printError(char* Type ,char* entite);
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
CONST_STRING "\"".*"\""
COMMENTAIRE "$"[^"$"]*"$"
%%
CODE {
    //  inserer(yytext,"MotCle","",nb_ligne,col,0,2); 
    col = col + strlen(yytext);
    return CODE;
}
START {
    //  inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    return START;
}
"END." {
    //  inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    return END;
}
INTEGER {
    //  inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    yylval.sval=strdup(yytext);
    col = col + strlen(yytext);
    return INTEGER;
}
REAL {
    //  inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    yylval.sval=strdup(yytext);
    col = col + strlen(yytext);
    return REAL;
}
CHAR {
    //  inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    yylval.sval=strdup(yytext);
    col = col + strlen(yytext);
    return CHAR;
}
STRING {
    //  inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    yylval.sval=strdup(yytext);
    col = col + strlen(yytext);
    return STRING;
}
CONST {
    //  inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    return CONST;
}
WHILE {
    //  inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    return WHILE;
}
EXECUTE {
    //  inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    return EXECUTE;
}
WHEN {
    //  inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    return WHEN;
}
DO {
    //  inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    return DO;
}
OTHERWISE {
    //  inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    return OTHERWISE;
}
PROD {
    //  inserer(yytext,"MotCle","",nb_ligne,col,0,2);
    col = col + strlen(yytext);
    return PROD;
}
= {
    //  inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return EGAL;
}
: {
    //  inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return DEUX_POINTS;
}
; {
    //  inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return POINT_VIRGULE;
}
, {
    //  inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return VIRGULE;
}
"." {
    //  inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return POINT;
}
"+" {
    //  inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return PLUS;
}
"-" {
    //  inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return MOINS;
}
"*" {
    //  inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return MULT;
}
"/" {
    //  inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return DIV;
}
EQ {
    //  inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return EQ;
}
LT {
    //  inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return LT;
}
GT {
    //  inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return GT;
}
LE {
    //  inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return LE;
}
GE {
    //  inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return GE;
}
NE {
    //  inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return NE;
}
"{" {
    //  inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return ACCOLADE_OUVRANTE;
}
"}" {
    //  inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return ACCOLADE_FERMANTE;
}
"(" {
    //  inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return PARENTHESE_OUVRANTE;
}
")" {
    //  inserer(yytext,"Sep","",nb_ligne,col,0,3);
    col = col + strlen(yytext);
    return PARENTHESE_FERMANTE;
}
{CONST_INT} {
    col = col + strlen(yytext);
    if(yyleng <= 6){
        //  inserer(yytext,"CONST_INT","Entier",nb_ligne,col-yyleng,atof(yytext),1);
        return CONST_INT;
    }
    else{
        printError("Lexical error",yytext);
    }
};
{CONST_REAL} {
    col = col + strlen(yytext);
    if(yyleng <= 8){
        //  inserer(yytext,"CONST_REAL","Reel",nb_ligne,col-yyleng,atof(yytext),1);
        return CONST_REAL;
    }
    else{
        printError("Lexical error",yytext);
    }
}
{CONST_CHAR} {
    //  inserer(yytext,"CONST_CHAR","",nb_ligne,col,0,1);
    col = col + strlen(yytext);
    return CONST_CHAR;
}
{CONST_STRING} {
    col = col + strlen(yytext);
    //  inserer(yytext,"CONST_STR","",nb_ligne,col-yyleng,0,1);
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
} 
{IDF} {
    col = col + strlen(yytext);
    if(yyleng <= 20){
        yylval.sval=strdup(yytext);
        insererIdfLex(yytext,"IDF",nb_ligne,col-yyleng);
        return  IDF;
    }
    else{
        printError("Lexical error",yytext);
    }
};
[ \t] {col = col + strlen(yytext);}
\n {nb_ligne++;col = 1;}
. printError("Lexical error",yytext);
%%