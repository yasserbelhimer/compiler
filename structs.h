typedef struct Element Element;
struct Element
{
    char NomEntite[20];
    char CodeEntite[20];
    char TypeEntite[20];
    char TypeDeclaration[20];
    Element *svt;
};
Element *listIdf = NULL;
char logFileName[100];
