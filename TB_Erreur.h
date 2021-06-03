 #include <stdio.h>
 #include <string.h> 

typedef struct
{
  int nblemt;  
  int pos;  
  char *t[100];
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

void inserer(char *a,int cas){
switch (cas)
{
    case 1:Lex.pos++;strcpy(Lex.t[Lex.pos],a);Lex.nblemt++;
    break;

    case 2:Syn.pos++;strcpy(Syn.t[Syn.pos],a);Syn.nblemt++;
    break;

    case 3:Sem.pos++;strcpy(Sem.t[Sem.pos],a);Sem.nblemt++;
    break;
}

}

void afficher(){
    int i;
    for(i=0;i<Lex.nblemt;i++){
      printf("Lex[%d]: %s",i,Lex.t[i]);
    }
    for(i=0;i<Syn.nblemt;i++){
       printf("Syn[%d]: %s",i,Syn.t[i]);
    }
    for(i=0;i<Sem.nblemt;i++){
        printf("Sem[%d]: %s",i,Sem.t[i]);
    }
}
