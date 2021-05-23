%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include<math.h>
    #include "syntax.tab.h"
    int nb_ligne=1;
    int col=1;
    extern void inserer(char a[],char b[]);
    extern int PrintError(char* Type ,char* entite);
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
    col = col + strlen(yytext);
    return CODE;
}
START {
    col = col + strlen(yytext);
    return START;
}
"END." {
    col = col + strlen(yytext);
    return END;
}
INTEGER {
    col = col + strlen(yytext);
    return INTEGER;
}
REAL {
    col = col + strlen(yytext);
    return REAL;
}
CHAR {
    col = col + strlen(yytext);
    return CHAR;
}
STRING {
    col = col + strlen(yytext);
    return STRING;
}
CONST {
    col = col + strlen(yytext);
    return CONST;
}
WHILE {
    col = col + strlen(yytext);
    return WHILE;
}
EXECUTE {
    col = col + strlen(yytext);
    return EXECUTE;
}
WHEN {
    col = col + strlen(yytext);
    return WHEN;
}
DO {
    col = col + strlen(yytext);
    return DO;
}
OTHERWISE {
    col = col + strlen(yytext);
    return OTHERWISE;
}
PROD {
    col = col + strlen(yytext);
    return PROD;
}
= {
    col = col + strlen(yytext);
    return EGAL;
}
: {
    col = col + strlen(yytext);
    return DEUX_POINTS;
}
; {
    col = col + strlen(yytext);
    return POINT_VIRGULE;
}
, {
    col = col + strlen(yytext);
    return VIRGULE;
}
"." {
    col = col + strlen(yytext);
    return POINT;
}
"+" {
    col = col + strlen(yytext);
    return PLUS;
}
"-" {
    col = col + strlen(yytext);
    return MOINS;
}
"*" {
    col = col + strlen(yytext);
    return MULT;
}
"/" {
    col = col + strlen(yytext);
    return DIV;
}
EQ {
    col = col + strlen(yytext);
    return EQ;
}
LT {
    col = col + strlen(yytext);
    return LT;
}
GT {
    col = col + strlen(yytext);
    return GT;
}
LE {
    col = col + strlen(yytext);
    return LE;
}
GE {
    col = col + strlen(yytext);
    return GE;
}
NE {
    col = col + strlen(yytext);
    return NE;
}
"{" {
    col = col + strlen(yytext);
    return ACCOLADE_OUVRANTE;
}
"}" {
    col = col + strlen(yytext);
    return ACCOLADE_FERMANTE;
}
"(" {
    col = col + strlen(yytext);
    return PARENTHESE_OUVRANTE;
}
")" {
    col = col + strlen(yytext);
    return PARENTHESE_FERMANTE;
}
{CONST_INT} {
    col = col + strlen(yytext);
    if(yyleng <= 6){
        inserer(yytext,"CONST_INT");
        return CONST_INT;
    }
    else{
        PrintError("Lexical error",yytext);
    }
};
{CONST_REAL} {
    col = col + strlen(yytext);
    if(yyleng <= 8){
        inserer(yytext,"CONST_REAL");
        return CONST_REAL;
    }
    else{
        PrintError("Lexical error",yytext);
    }
}
{CONST_CHAR} {
    inserer(yytext,"CONST_CHAR");
    col = col + strlen(yytext);
    return CONST_CHAR;
}
{CONST_STRING} {
    col = col + strlen(yytext);
    inserer(yytext,"CONST_STR");
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
        inserer(yytext,"IDF");
        return  IDF;
    }
    else{
        PrintError("Lexical error",yytext);
    }
};
[ \t] {col = col + strlen(yytext);}
\n {nb_ligne++;col = 1;}
. PrintError("Lexical error",yytext);
%%