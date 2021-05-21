typedef struct
{
char Entite[20];
char TypeLex[20];
char TypeSym[20];
char TypeVar[20];
}TypeTS;


typedef struct cellule
{
    TypeTS info;
   struct cellule *svt;
}elmlist;

typedef elmlist *list;

list ts=NULL;

list recherche(char entite[])
{
int i=0;
list p=ts;
while(p!=NULL)
{	
  if (strcmp(entite,p->info.Entite)==0) return p;
  p=p->svt;
}

return NULL;
}


void inserer(char a[],char b[]){

    if(recherche(a)==NULL){
	
        list p=(elmlist*)malloc(sizeof(elmlist));

        strcpy(p->info.Entite,a);
        strcpy(p->info.TypeLex,b);
        strcpy(p->info.TypeSym,"");
        strcpy(p->info.TypeVar,"");
        p->svt=NULL;

        if(ts==NULL){

            ts=p;
        }else{
            list q=ts;
            while(q->svt!=NULL){
            q=q->svt;
            }
            q->svt=p;
                
        }
    }
}



void afficher ()
{
    printf("\n     /*************************** Table des symboles ************************/\n\n");
    printf("      -----------------------------------------------------------------------\n");
    printf("     |      Entite     |     TypeLex     |     TypeVar     |  TypeSimentique |\n");

    list p=ts;
    while(p!=NULL)
    {
        printf("     |-----------------|-----------------|-----------------|-----------------|\n");
        printf("     | %15s | %15s | %15s | %15s |\n",p->info.Entite,p->info.TypeLex,p->info.TypeVar,p->info.TypeSym);
        p=p->svt;
    }
    printf("      -----------------------------------------------------------------------\n\n");
}
