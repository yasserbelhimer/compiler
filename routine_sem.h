
 #include <stdio.h>
 #include <string.h> 
void IdfNonDeclarer(char a[],int ligne,int col){
    list p=recherche(a,1);
    if(strcmp(p->info.TypeVar,"")==0){
      printf("Erreur Sementique , idf non declarer  : line %d  column %d entite: %s\n",ligne,col-strlen(a),a);
    }
}
void DoubleDeclaration(char a[],int ligne,int col){
    list p=recherche(a,1);
    if(strcmp(p->info.TypeVar,"")!=0){
      printf("Erreur Sementique , double declaration  : line %d  column %d  entite: %s\n",ligne,col-strlen(a)-1,a);
    }
}

void CompatibiliteType(char a[],char b[],int ligne,int col){
    list p=recherche(a,1);
    list q=recherche(b,1);
     if(strcmp(p->info.TypeVar,q->info.TypeVar)!=0){
      printf("Erreur Sementique , Non Compatibilite de Type : %s n'a pas le meme type de %s  : line %d  column %d  \n",a,b,ligne,col-strlen(a));
    }   
}
void ModifierConst(char a[],int ligne,int col){
  list p=recherche(a,1);
  if(strcmp(p->info.TypeLex,"CONST_IDF")==0){
    printf("Erreur Sementique , Modification d'une Const  : line %d  column %d  entite: %s\n",ligne,col-strlen(a)-1,a);
  }
}
void DivisionPar0(char a[],char b[],char c[],int div0,int cpt,int vr,int ligne,int col){

list p=recherche(a,1);
list q=recherche(b,1);
list u=recherche(c,1);

if(div0==0 && cpt==1 && vr==2){
  p->info.Val=q->info.Val;
}
if(div0==0 && cpt==1 && vr==1){
  p->info.Val=u->info.Val;
}
if(div0==1 && cpt==1)  {
    if(vr==2){    
        if(q->info.Val==0){
            printf("Erreur Sementique , division par 0 : line %d  column %d  entite: %s\n",ligne,col-strlen(a)-1,a);
        }
    }else{
        if(u->info.Val==0){
            printf("Erreur Sementique , division par 0  : line %d  column %d  entite: %s\n",ligne,col-strlen(a)-1,a);
        }
    }    

  }
}
