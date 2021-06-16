%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include<math.h>
    #include "syntax.tab.h"
    int nb_ligne=1;
    int col=1;
    extern YYSTYPE yylval;
    extern void insererIdfLex (char NomEntite[], char CodeEntite[]);
    extern void insererSeparateurLex (char separateur[]);
    extern void insererMotCleLex(char keyword[]);
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
    insererMotCleLex(yytext); 
    col = col + strlen(yytext);
    return CODE;
}
START {
    insererMotCleLex(yytext);
    col = col + strlen(yytext);
    return START;
}
END {
    insererMotCleLex(yytext);
    col = col + strlen(yytext);
    return END;
}
INTEGER {
    insererMotCleLex(yytext);
    yylval.sval=strdup(yytext);
    col = col + strlen(yytext);
    return INTEGER;
}
REAL {
    insererMotCleLex(yytext);
    yylval.sval=strdup(yytext);
    col = col + strlen(yytext);
    return REAL;
}
CHAR {
    insererMotCleLex(yytext);
    yylval.sval=strdup(yytext);
    col = col + strlen(yytext);
    return CHAR;
}
STRING {
    insererMotCleLex(yytext);
    yylval.sval=strdup(yytext);
    col = col + strlen(yytext);
    return STRING;
}
CONST {
    insererMotCleLex(yytext);
    col = col + strlen(yytext);
    return CONST;
}
WHILE {
    insererMotCleLex(yytext);
    col = col + strlen(yytext);
    return WHILE;
}
EXECUTE {
    insererMotCleLex(yytext);
    col = col + strlen(yytext);
    return EXECUTE;
}
WHEN {
    insererMotCleLex(yytext);
    col = col + strlen(yytext);
    return WHEN;
}
DO {
    insererMotCleLex(yytext);
    col = col + strlen(yytext);
    return DO;
}
OTHERWISE {
    insererMotCleLex(yytext);
    col = col + strlen(yytext);
    return OTHERWISE;
}
PROD {
    insererMotCleLex(yytext);
    col = col + strlen(yytext);
    return PROD;
}
= {
    insererSeparateurLex(yytext);
    col = col + strlen(yytext);
    return EGAL;
}
: {
    insererSeparateurLex(yytext);
    col = col + strlen(yytext);
    return DEUX_POINTS;
}
; {
    insererSeparateurLex(yytext);
    col = col + strlen(yytext);
    return POINT_VIRGULE;
}
, {
    insererSeparateurLex(yytext);
    col = col + strlen(yytext);
    return VIRGULE;
}
"." {
    insererSeparateurLex(yytext);
    col = col + strlen(yytext);
    return POINT;
}
"+" {
    insererSeparateurLex(yytext);
    col = col + strlen(yytext);
    return PLUS;
}
"-" {
    insererSeparateurLex(yytext);
    col = col + strlen(yytext);
    return MOINS;
}
"*" {
    insererSeparateurLex(yytext);
    col = col + strlen(yytext);
    return MULT;
}
"/" {
    insererSeparateurLex(yytext);
    col = col + strlen(yytext);
    return DIV;
}
EQ {
    insererSeparateurLex(yytext);
    yylval.sval=strdup(yytext);
    col = col + strlen(yytext);
    return EQ;
}
LT {
    insererSeparateurLex(yytext);
    yylval.sval=strdup(yytext);
    col = col + strlen(yytext);
    return LT;
}
GT {
    insererSeparateurLex(yytext);
    yylval.sval=strdup(yytext);
    col = col + strlen(yytext);
    return GT;
}
LE {
    insererSeparateurLex(yytext);
    yylval.sval=strdup(yytext);
    col = col + strlen(yytext);
    return LE;
}
GE {
    insererSeparateurLex(yytext);
    yylval.sval=strdup(yytext);
    col = col + strlen(yytext);
    return GE;
}
NE {
    insererSeparateurLex(yytext);
    yylval.sval=strdup(yytext);
    col = col + strlen(yytext);
    return NE;
}
"{" {
    insererSeparateurLex(yytext);
    col = col + strlen(yytext);
    return ACCOLADE_OUVRANTE;
}
"}" {
    insererSeparateurLex(yytext);
    col = col + strlen(yytext);
    return ACCOLADE_FERMANTE;
}
"(" {
    insererSeparateurLex(yytext);
    col = col + strlen(yytext);
    return PARENTHESE_OUVRANTE;
}
")" {
    insererSeparateurLex(yytext);
    col = col + strlen(yytext);
    return PARENTHESE_FERMANTE;
}
{CONST_INT} {
    col = col + strlen(yytext);
    if(yyleng <= 6){
        yylval.ival=atoi(yytext);
        return CONST_INT;
    }
    else{
        printError("Lexical error",yytext);
    }
};
{CONST_REAL} {
    col = col + strlen(yytext);
    if(yyleng <= 8){
         yylval.fval=atof(yytext);
        return CONST_REAL;
    }
    else{
        printError("Lexical error",yytext);
    }
}
{CONST_CHAR} {
    yylval.sval=strdup(yytext);
    col = col + strlen(yytext);
    return CONST_CHAR;
}
{CONST_STRING} {
    col = col + strlen(yytext);
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
} 
{IDF} {
    col = col + strlen(yytext);
    if(yyleng <= 20){
        yylval.sval=strdup(yytext);
        insererIdfLex(yytext,"IDF");
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