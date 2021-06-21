
 #include <stdio.h>
 #include <string.h> 

  //   TOUABTI Mohamed MASTER1 IV  groupe2  171732028255

  //   SEGUENI Seif Eddine MASTER1 IV  groupe2  171732028289  


void IdfNonDeclarer(char a[],int ligne,int col){
    list p=recherche(a,1);
    char err[200];
    if(strcmp(p->info.TypeVar,"")==0){
      sprintf(err,"Erreur Sementique , idf non declarer  : line %d  column %d entite: %s\n",ligne,col,a);
      insererErr(err,3);  
    }
}
void DoubleDeclaration(char a[],int ligne,int col){
    list p=recherche(a,1);
    char err[200];
    if(strcmp(p->info.TypeVar,"")!=0){
      sprintf(err,"Erreur Sementique , double declaration  : line %d  column %d  entite: %s\n",ligne,col,a);
      insererErr(err,3);     
    }
}

void CompatibiliteType(char a[],char b[],int ligne,int col){

    list p=recherche(a,1);
    list q=recherche(b,1);
    char err[200];
     if(strcmp(p->info.TypeVar,"")!=0 && strcmp(q->info.TypeVar,"")!=0 && strcmp(p->info.TypeVar,q->info.TypeVar)!=0){
      sprintf(err,"Erreur Sementique , Non Compatibilite de Type : %s n'a pas le meme type de %s  : line %d  column %d  \n",a,b,ligne,col);
      insererErr(err,3);  
    }   
}
void ModifierConst(char a[],int ligne,int col){
  list p=recherche(a,1);
  char err[200];
  if(strcmp(p->info.TypeLex,"CONST_IDF")==0){
      sprintf(err,"Erreur Sementique , Modification d'une Const  : line %d  column %d  entite: %s\n",ligne,col,a);
      insererErr(err,3);  
  }
}
void DivisionPar0(char a[],char b[],char c[],int div0,int cpt,int vr,int ligne,int col){

list p=recherche(a,1);
list q=recherche(b,1);
list u=recherche(c,1);
char err[200];

if(div0==0 && cpt==1 && vr==2){
  p->info.Val=q->info.Val;
}
if(div0==0 && cpt==1 && vr==1){
  p->info.Val=u->info.Val;
}
if(div0==1 && cpt==1)  {
    if(vr==2){    
        if(q->info.Val==0){
          sprintf(err,"Erreur Sementique , division par 0 : line %d  column %d  entite: %s\n",ligne,col,a);
          insererErr(err,3);  
        }
    }else{
        if(u->info.Val==0){
          sprintf(err,"Erreur Sementique , division par 0  : line %d  column %d  entite: %s\n",ligne,col,a);
          insererErr(err,3);  
        }
    }    

  }
}
