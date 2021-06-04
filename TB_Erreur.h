 #include <stdio.h>
 #include<stdlib.h>
 #include <string.h> 

typedef struct
{
  int nblemt;  
  int pos;  
  char t[100][200];
}Tab;

Tab Lex;
Tab Syn;
Tab Sem;

void init(){
    Lex.pos=-1;
    Lex.nblemt=0;
    Syn.pos=-1;
    Syn.nblemt=0;
    Sem.pos=-1;
    Sem.nblemt=0;    
}

void insererErr(char *a,int cas){

switch (cas)
{
    case 1:{
      Lex.pos++;
      strcpy(Lex.t[Lex.pos],a);
      Lex.nblemt++;
      break;  
    }
    

    case 2:{
      Syn.pos++;
      strcpy(Syn.t[Syn.pos],a);
      Syn.nblemt++;
      break; 
    }
    

    case 3:{
      Sem.pos++;
      strcpy(Sem.t[Sem.pos],a);
      Sem.nblemt++;
      break; 
    }
    
}

}

void afficherErr(){
    int i,ct=1;
    printf("\n            *********    La liste des Erreurs      *********\n\n\n");
    for(i=0;i<Lex.nblemt;i++){
      printf(" %d).  %s",ct,Lex.t[i]);
      ct++;
    }
    printf("\n\n");
    for(i=0;i<Syn.nblemt;i++){
       printf(" %d).  %s",ct,Syn.t[i]);
       ct++;
    }
    printf("\n\n");
    for(i=0;i<Sem.nblemt;i++){
        printf(" %d).  %s",ct,Sem.t[i]);
        ct++;
    }
}
