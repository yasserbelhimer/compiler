 #include <stdio.h>
 #include<stdlib.h>
 #include <string.h>

typedef struct pile{    
    int tabPile[1000];
    int indexPile;
    int nbelm;
}pile;


void initPile(pile *p){
   p->indexPile=-1;
   p->nbelm=0;
}
void empiler(pile *p,int k){
    p->indexPile++;
    p->tabPile[p->indexPile]=k;
    p->nbelm++;
}
int depiler(pile *p){
    int k=p->tabPile[p->indexPile];
    p->indexPile--;
    p->nbelm--;
    return k;
}

typedef struct qdr{

    char oper[100]; 
    char op1[100];   
    char op2[100];   
    char res[100];  
    
}qdr;
  qdr quad[1000];
int qc=0;
void InsererQuadr(char opr[],char op1[],char op2[],char res[])
{

    strcpy(quad[qc].oper,opr);
    strcpy(quad[qc].op1,op1);
    strcpy(quad[qc].op2,op2);
    strcpy(quad[qc].res,res);


    qc++;

}

void Maj_Quad(int num_quad, int colon_quad, char val [])
{
    switch (colon_quad)
    {
    case 0:{
            strcpy(quad[num_quad].oper,val);  
            break;
        } 
    case 1:{
            strcpy(quad[num_quad].op1,val);
            break;
        } 
    case 2:{
            strcpy(quad[num_quad].op2,val); 
            break;
        } 
    case 3:{
            strcpy(quad[num_quad].res,val);
            break;
        }               

    }

}
void initTab(Tab *a){
    a->nblemt=0;
    a->pos=-1;
}
void InsererChar(Tab *a,char b[],char c,int cas){
   a->pos++;
   if(cas==1)
    sprintf(a->t[a->pos],"%c",c);
   else
    sprintf(a->t[a->pos],"%s",b);
   a->nblemt++;
}
void afficherTab(Tab a){
   int i;
    if(a.nblemt!=0) 
     printf("\nexp: ");
     else 
       printf("\nexp vide ");
    for(i=0;i<a.nblemt;i++){
      printf(" %s ",a.t[i]);
    }   
    printf("\n");
}
int searchChar(Tab a,char k,char cas,int deb){
    int i;
    switch (cas)
    {
        case 'F':{
            for(i=deb;i<a.nblemt;i++){
                if(a.t[i][0]==k)
                    return i;
            }
            break;
        }
        case 'L':{
            for(i=a.nblemt-1;i>=0;i--){
                if(a.t[i][0]==k)
                    return i;
            }
            break;
        }    
    
    }
    return -1;

}
void deleteTab(Tab *a,int deb,int fin){
    int i;
    if(deb>=0 && fin<a->nblemt){
        for(i=1;i<=a->nblemt-fin;i++){
            strcpy(a->t[deb+i-1],a->t[fin+i]);   
        }
        a->nblemt=a->nblemt-(fin-deb+1);
        a->pos=a->pos-(fin-deb+1);
    }
}

int isOptArt(char a[]){
    if(!strcmp(a,"+") || !strcmp(a,"*") || !strcmp(a,"-") || !strcmp(a,"/"))
          return 1;
    return 0;       
}
int isOptLog(char a[]){
    if(!strcmp(a,"GT") || !strcmp(a,"GE") || !strcmp(a,"EQ") || !strcmp(a,"NE")|| !strcmp(a,"LE") || !strcmp(a,"LT"))
          return 1;
    return 0;       
}
void devideOpOpr(Tab a,Tab *b,Tab *c,int deb,int fin,int cas){
    int i;
    initTab(b);
    initTab(c);
    switch (cas)
    {
        case 1:{
            if(deb>=0 && fin<a.nblemt){
                for(i=deb;i<=fin;i++){
                    if(isOptArt(a.t[i]))
                        InsererChar(c,a.t[i],' ',2);
                    else
                        InsererChar(b,a.t[i],' ',2);
                }
            }
            break;
        }
        case 2:{
            if(deb>=0 && fin<a.nblemt){
                for(i=deb;i<=fin;i++){
                    if(isOptLog(a.t[i]))
                        InsererChar(c,a.t[i],' ',2);
                    else
                        InsererChar(b,a.t[i],' ',2);
                }
            }
            break;
        }

    }


}
void evaluationExp(Tab *opr,Tab *opt,int *cpt){
    int i;
    char ch[20];
    i=0;
    while(i<opt->nblemt){
        if(!strcmp(opt->t[i],"*") || !strcmp(opt->t[i],"/")){
            sprintf(ch,"T%d",*cpt);
            InsererQuadr(opt->t[i],opr->t[i],opr->t[i+1],ch);
            deleteTab(opt,i,i);
            deleteTab(opr,i+1,i+1);
            strcpy(opr->t[i],ch);
            (*cpt)++;
        }else{
            i++;
        }
    }
    i=0;
    while(i<opt->nblemt){
        if(!strcmp(opt->t[i],"+") || !strcmp(opt->t[i],"-")){
            sprintf(ch,"T%d",*cpt);
            InsererQuadr(opt->t[i],opr->t[i],opr->t[i+1],ch);
            deleteTab(opt,i,i);
            deleteTab(opr,i+1,i+1);
            strcpy(opr->t[i],ch);
            (*cpt)++;
        }else{
            i++;
        }
    }    
}

void quadruplets_condition(Tab *a,char res[],int c1,int c2,int ligne,int col){

char err[200];
char ch[200];
char ch2[200];
if(c1!=c2){
    if(c1==1) strcpy(ch," une expression ");
    else strcpy(ch,a->t[2]);
    if(c2==1) strcpy(ch2," une expression ");
    else strcpy(ch2,a->t[0]);
    sprintf(err,"Erreur Sementique , Non Compatibilite de Type  : on ne peux pas comparer %s avec %s: line %d  column %d  \n",ch,ch2,ligne,col);
    insererErr(err,3);  
}
InsererQuadr(a->t[1],a->t[0],a->t[2],"TC");
strcpy(res,"TC");
initTab(a);

}   


void quadruplets_expression(Tab *a,char res[], int *cpt){
int i,j;
Tab b,c;

while(searchChar(*a,'(','L',0)!=-1){
 i=searchChar(*a,'(','L',0);i++;
 j=searchChar(*a,')','F',i);
 devideOpOpr(*a,&b,&c,i,j-1,1);
 deleteTab(a,i,j);
 evaluationExp(&b,&c,cpt);
 strcpy(a->t[i-1],b.t[0]);
}

devideOpOpr(*a,&b,&c,0,a->nblemt-1,1);
deleteTab(a,1,a->nblemt-1);
evaluationExp(&b,&c,cpt);
strcpy(a->t[0],b.t[0]);

strcpy(res,a->t[0]);

 initTab(a);

}

void quadrProd(char idf[],char resexp[]){
    char ch[200];
    sprintf(ch,"%d",qc+2);
    InsererQuadr("BMZ",ch,"",resexp);
    InsererQuadr("*",resexp,idf,idf);
}

void afficher_qdr()
{
    FILE *fichier = NULL;
    fichier = fopen(logFileName, "a");

    printf("\n\n\n      ***********   Les Quadruplets   ***********\n\n");
    fprintf(fichier,"\n\n\n      ***********   Les Quadruplets   ***********\n\n");

    int i;

    for(i=0;i<qc;i++)
    {

        printf("\n %d - ( %s  ,  %s  ,  %s  ,  %s )",i,quad[i].oper,quad[i].op1,quad[i].op2,quad[i].res); 
        printf("\n--------------------------------------------------------\n");
        fprintf(fichier,"\n %d - ( %s  ,  %s  ,  %s  ,  %s )",i,quad[i].oper,quad[i].op1,quad[i].op2,quad[i].res); 
        fprintf(fichier,"\n--------------------------------------------------------\n");


    }
}
