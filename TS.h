
  //   TOUABTI Mohamed MASTER1 IV  groupe2  171732028255

  //   SEGUENI Seif Eddine MASTER1 IV  groupe2  171732028289  

typedef struct
{
    char Entite[20];
    char TypeLex[20];
    float Val;
    char TypeVar[20];
    int ligne;
    int col;
}TypeTS;


typedef struct cellule
{
    TypeTS info;
   struct cellule *svt;
}elmlist;



typedef elmlist *list;

list ts_idf=NULL;
list ts_mc=NULL;
list ts_sep=NULL;

char logFileName[200];
char logFileName2[200];
char logFileName3[200];
void initLogFile()
{

    mkdir("logs");
    strcpy(logFileName, "logs/TS.log");
    FILE *fichier = NULL;
    fichier = fopen(logFileName, "w");    
    if (fichier == NULL)
    {
        printf("Impossible d'ouvrir le fichier %s\n", logFileName);   
    }
    strcpy(logFileName2, "logs/Erreurs.log");
    FILE *fichier2 = NULL;
    fichier2 = fopen(logFileName2, "w");    
    if (fichier2 == NULL)
    {
        printf("Impossible d'ouvrir le fichier %s\n", logFileName2);   
    }
    strcpy(logFileName3, "logs/Quadr.log");
    FILE *fichier3 = NULL;
    fichier3 = fopen(logFileName3, "w");    
    if (fichier3 == NULL)
    {
        printf("Impossible d'ouvrir le fichier %s\n", logFileName3);   
    }

     
}

list recherche(char entite[],int cas)
{
int i=0;
list p;

switch (cas)
{
 case 1 :
    p=ts_idf;
    break;
 case 2 :
    p=ts_mc;
    break;
 case 3 :
    p=ts_sep;
    break;
}

while(p!=NULL)
{	
  if (strcmp(entite,p->info.Entite)==0) return p;
  p=p->svt;
}

return NULL;
}


void inserer(char a[],char b[],char c[],int li,int cl,float val,int cas){
    
    if(recherche(a,cas)==NULL){
	
        list p=(elmlist*)malloc(sizeof(elmlist));
        list temp=NULL; 
        strcpy(p->info.Entite,a);
        strcpy(p->info.TypeLex,b);
        strcpy(p->info.TypeVar,c);
        p->info.Val=val;
        p->info.ligne=li;
        p->info.col=cl;
        p->svt=NULL;

        switch (cas)
        {
        case 1:
            temp=ts_idf;
            break;
        case 2:
            temp=ts_mc;
            break;
        case 3:
            temp=ts_sep;
            break;    
        } 

        if(temp==NULL){

            temp=p;
        }else{
            list q=temp;
            while(q->svt!=NULL){
            q=q->svt;
            }
            q->svt=p;
                
        }

        switch (cas)
        {
        case 1:
            ts_idf=temp;
            break;
        case 2:
            ts_mc=temp;
            break;
        case 3:
            ts_sep=temp;
            break;    
        }



    }
}



void afficherTs_IDF()
{
    FILE *fichier = NULL;
    fichier = fopen(logFileName, "a");

    printf("\n\n     /*********************************   Table des symboles des Idfs/Consts   ******************************/\n\n");
    printf("      --------------------------------------------------------------------------------------------------------\n");
    printf("     |         Entite         |     TypeLex     |       Val       |     TypeVar     |   Ligne    |    Col     |\n");
    fprintf(fichier,"\n     /*********************************   Table des symboles des Idfs/Consts   ******************************/\n\n");
    fprintf(fichier,"      --------------------------------------------------------------------------------------------------------\n");
    fprintf(fichier,"     |         Entite         |     TypeLex     |       Val       |     TypeVar     |   Ligne    |    Col     |\n");
    list p=ts_idf;
    char *ch=(char*)malloc(100*sizeof(char)); 
    while(p!=NULL)
    {
        strcpy(ch,"");
        if(strcmp(p->info.TypeVar,"INTEGER")==0 && p->info.Val<100000000) sprintf(ch,"%d",(int)p->info.Val);
        if(strcmp(p->info.TypeVar,"REAL")==0 && p->info.Val<100000000) sprintf(ch,"%.4f",p->info.Val);
        

        printf("     |------------------------|-----------------|-----------------|-----------------|------------|------------|\n");
        printf("     | %22s | %15s | %15s | %15s | %10d | %10d |\n",p->info.Entite,p->info.TypeLex,ch,p->info.TypeVar,p->info.ligne,p->info.col);
        fprintf(fichier,"     |------------------------|-----------------|-----------------|-----------------|------------|------------|\n");
        fprintf(fichier,"     | %22s | %15s | %15s | %15s | %10d | %10d |\n",p->info.Entite,p->info.TypeLex,ch,p->info.TypeVar,p->info.ligne,p->info.col);

        p=p->svt;
    }
    printf("      --------------------------------------------------------------------------------------------------------\n\n");
    fprintf(fichier,"      --------------------------------------------------------------------------------------------------------\n\n");    
}

void afficherTs_MC_Sep(int cas)
{
    FILE *fichier = NULL;
    fichier = fopen(logFileName, "a");

    list p;
    if(cas==2){
      p=ts_mc;
      printf("\n     /********* Table des symboles des Mots cles *********/\n\n");
      fprintf(fichier,"\n     /********* Table des symboles des Mots cles *********/\n\n");      
    }
    if(cas==3){
      p=ts_sep;
      printf("\n     /********* Table des symboles des separateurs *******/\n\n");
      fprintf(fichier,"\n     /********* Table des symboles des separateurs *******/\n\n");   
    }
    
    printf("      ---------------------------------------------------\n");
    printf("     |   Entite   |   TypeLex  |   Ligne    |    Col     |\n");
    fprintf(fichier,"      ---------------------------------------------------\n");
    fprintf(fichier,"     |   Entite   |   TypeLex  |   Ligne    |    Col     |\n");

    
    while(p!=NULL)
    {
        printf("     |------------|------------|------------|------------|\n");
        printf("     | %10s | %10s | %10d | %10d |\n",p->info.Entite,p->info.TypeLex,p->info.ligne,p->info.col);
        fprintf(fichier,"     |------------|------------|------------|------------|\n");
        fprintf(fichier,"     | %10s | %10s | %10d | %10d |\n",p->info.Entite,p->info.TypeLex,p->info.ligne,p->info.col);

        p=p->svt;
    }
    printf("      ---------------------------------------------------\n\n");
    fprintf(fichier,"      ---------------------------------------------------\n\n");    
}

void ModifierTS(char Entite[], int cas,char b[],char type[]){
    list p=recherche(Entite,1);
    if(p!=NULL)
    {
        
       switch (cas)
       {
            case 1:{
                
                if(strcmp(type,"INTEGER")==0){
                    p->info.Val=atof(b);   
                }
                if(strcmp(type,"REAL")==0){
                 p->info.Val=atof(b);   
                }
                break;

            }
            case 2:{
                strcpy(p->info.TypeVar,b);     
                break;

            }            
        
            default:{
            strcpy(p->info.TypeLex,"CONST_IDF");  
            break;
            }
        }
    }
}
