void yyerror (char* msg){
    printf("%s : line %d  column %d ",msg,nb_ligne,col);
}

int printError(char* Type ,char* entite){
    yyerror(Type);
    printf(" entite: %s \n",entite);
    exit(-1);       
}
int printIncompatibleTypeError(char* type1,char* type2){
    yyerror("Symantec error incompatibilte de type");
    printf(" %s est incompatible avec %s \n",type1,type2);
    exit(-1);       
}