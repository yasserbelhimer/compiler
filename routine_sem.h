
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
      printf("Erreur Sementique , Non Compatibilite de Type  : line %d  column %d  entite: %s\n",ligne,col-strlen(a),a);
    }
    
}
