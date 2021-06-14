typedef struct Element Element;
struct Element
{
    char nomEntite[20];
    char codeEntite[20];
    char typeEntite[20];
    char typeDeclaration[20];
    Element *svt;
};
Element *listIdf = NULL;

typedef struct Separateur Separateur;
struct Separateur
{
    char separateur[20];
    char code[20];
    Separateur *svt;
};
Separateur *listSeparateurs = NULL;


typedef struct Keyword Keyword;
struct Keyword
{
    char keyword[20];
    char code[20];
    Keyword *svt;
};
Keyword *listMotsCles = NULL;