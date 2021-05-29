typedef struct Element Element;
struct Element
{
    char NomEntite[20];
    char CodeEntite[20];
    char TypeEntite[20];
    char TypeDeclaration[20];
    Element *svt;
};
// typedef struct
// {
//     char NomEntite[20];
//     char CodeEntite[20];
//     char TypeEntite[20];
//     char Constante[20];
// }Element;


// typedef struct cellule
// {
//     TypeTS info;
//    struct cellule *svt;
// }elmlist;



// typedef elmlist *list;

Element *listIdf = NULL;
char logFileName[100];
// typedef struct listIdf *Element;