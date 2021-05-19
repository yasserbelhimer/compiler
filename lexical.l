%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include<math.h>
    #include "syntax.tab.h"
    int nb_ligne=0;
    extern void yyerror(const char* s);
%}
lettre_maj [A-Z]
lettre_min [a-z]
lettre [a-zA-Z]
chiffre [0-9]
IDF {lettre_maj}({lettre}|{chiffre}){0,19}
CONST_INT ("-"|"+")?{chiffre}+
CONST_REAL ("-"|"+")?{chiffre}+"."{chiffre}+
CONST_CHAR "'"."'"
CONST_STRING "\"".*"\""
COMMENTAIRE "$"[^"$"]*"$"
%%
CODE {
    return CODE;
}
START {
    return START;
}
END {
    return END;
}
INTEGER {
    return INTEGER;
}
REAL {
    return REAL;
}
CHAR {
    return CHAR;
}
STRING {
    return STRING;
}
CONST {
    return CONST;
}
WHILE {
    return WHILE;
}
EXECUTE {
    return EXECUTE;
}
WHEN {
    return WHEN;
}
DO {
    return DO;
}
OTHERWISE {
    return OTHERWISE;
}

= {
    return EGAL;
}
: {
    return DEUX_POINTS;
}
; {
    return POINT_VIRGULE;
}
, {
    return VIRGULE;
}
"." {
    return POINT;
}
"+" {
    return PLUS;
}
"-" {
    return MOINS;
}
"*" {
    return MULT;
}
"/" {
    return DIV;
}
EQ {
    return EQ;
}
LT {
    return LT;
}
GT {
    return GT;
}
LE {
    return LE;
}
GE {
    return GE;
}
NE {
    return NE;
}
"{" {
    return ACCOLADE_OUVRANTE;
}
"}" {
    return ACCOLADE_FERMANTE;
}
"(" {
    return PARENTHESE_OUVRANTE;
}
")" {
    return PARENTHESE_FERMANTE;
}
{CONST_INT} {
    if(yyleng>8)
        yyerror("erreur lexecal");
    return CONST_INT;
};
{CONST_REAL} {
    // printf("len = %d",yyleng);
    if(yyleng>8)
        yyerror("erreur lexecal");
    return CONST_REAL;
}
{CONST_CHAR} {
    return CONST_CHAR;
}
{CONST_STRING} {
    return CONST_STRING;
}
{COMMENTAIRE} 
{IDF} {
    return  IDF;
};
[ \t]
\n {nb_ligne++; }
. yyerror("erreur lexecal");
%%