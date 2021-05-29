/**
 * Initialisation des des outils necessaire pour la compilation
 * @return void
 */
void initialisation()
{
    time_t seconds;
    seconds = time(NULL);
    mkdir("logs");
    sprintf(logFileName, "logs/logs-%d.log", seconds);
    FILE *fichier = NULL;
    fichier = fopen(logFileName, "w");
    if (fichier != NULL)
    {
        fprintf(fichier, "\n/******************************   logs de l'instance %d   ******************************/\n\n", seconds);
    }
    else
        printf("Impossible d'ouvrir le fichier %s\n", logFileName);
}
/**
 * Recherche une entite dans la table des symboles des idfs
 * @param char NomEntite[] nom de l'entité
 * @param char code[] code de l'entité
 * @return Element retourne l'element de la liste s'il existe sinon retourne NULL
 */
Element* rechercherIdf(char NomEntite[])
{
    Element* p = listIdf;
    while (p != NULL)
    {
        if (strcmp(NomEntite, p->NomEntite) == 0)
            return p;
        p = p->svt;
    }
    return NULL;
}

/**
 * Inserer un idf a la fin de la table des symboles de idf s'il n'est pas encore inseré.
 * @param char NomEntite[] nom de l'entité
 * @param char CodeEntite[] code de l'entité
 * @param int ligne la ligne ou se trouve l'entité
 * @param int col la collone ou se trouve l'entité
 * @return void
 */
void insererIdfLex(char NomEntite[], char CodeEntite[], int ligne, int col)
{
    FILE *fichier = NULL;
    fichier = fopen(logFileName, "a");
    if (fichier != NULL)
    {
        fprintf(fichier, "Insertion de l'idf %s dans la table des symboles: ligne %d collone %d-----------------\n", NomEntite, ligne, col);
        if (rechercherIdf(NomEntite) == NULL)
        {
            Element* p = malloc(sizeof(Element));
            strcpy(p->NomEntite, NomEntite);
            strcpy(p->CodeEntite, CodeEntite);
            strcpy(p->TypeEntite, "");
            strcpy(p->TypeDeclaration, "UNDEFINED");
            p->svt = NULL;
            if (listIdf == NULL)
            {
                listIdf = p;
            }
            else
            {
                Element* temp = listIdf;
                while (temp->svt != NULL)
                    temp = temp->svt;
                temp->svt = p;
            }
            fprintf(fichier, "Insertion de l'idf %s dans la table des symboles: ligne %d collone %d----------------- Ok\n\n", NomEntite, ligne, col);
        }
        else
        {
            fprintf(fichier, "%s existe deja dans la table des symboles!\n");
            fprintf(fichier, "Insertion de l'idf %s dans la table des symboles: ligne %d collone %d----------------- Failed\n\n", NomEntite, ligne, col);
        }
    }
    else
        printf("Impossible d'ouvrir le fichier %s\n", logFileName);
}

/**
 * Afficher la table des symboles de idfs.
 * @return void
 */
void afficherIdf()
{
    FILE *fichier = NULL;
    fichier = fopen("ts.log", "w");
    if (fichier != NULL)
    {
        fprintf(fichier, "\n/*********************************   Table des symboles des Idfs/Consts   ******************************/\n\n");
        fprintf(fichier, "--------------------------------------------------------------------------------------------------------\n");
        fprintf(fichier, "|            NomEntite            |     CodeEntite     |     CodeEntite     |       TypeDeclaration       |\n");
        Element* p = listIdf;
        while (p != NULL)
        {
            fprintf(fichier, "|---------------------------------|--------------------|--------------------|-----------------------|\n");
            fprintf(fichier, "| %25s       | %13s      | %13s      | %15s       |\n", p->NomEntite, p->CodeEntite,p->TypeEntite, p->TypeDeclaration);
            p = p->svt;
        }
        fprintf(fichier, "--------------------------------------------------------------------------------------------------------\n\n");
    }
    else
        printf("Impossible d'ouvrir le fichier ts.log\n");

    fclose(fichier);
}
// void afficherTs_IDF()
// {
//     printf("\n     /*********************************   Table des symboles des Idfs/Consts   ******************************/\n\n");
//     printf("      --------------------------------------------------------------------------------------------------------\n");
//     printf("     |         Entite         |     TypeLex     |       Val       |     TypeVar     |   Ligne    |    Col     |\n");

//     list p=ts_idf;
//     char *ch=(char*)malloc(100*sizeof(char));
//     while(p!=NULL)
//     {
//         strcpy(ch,"");
//         if(strcmp(p->info.TypeVar,"Entier")==0) sprintf(ch,"%d",(int)p->info.Val);
//         if(strcmp(p->info.TypeVar,"Reel")==0) sprintf(ch,"%.4f",p->info.Val);

//         printf("     |------------------------|-----------------|-----------------|-----------------|------------|------------|\n");
//         printf("     | %22s | %15s | %15s | %15s | %10d | %10d |\n",p->info.Entite,p->info.TypeLex,ch,p->info.TypeVar,p->info.ligne,p->info.col);
//         p=p->svt;
//     }
//     printf("      --------------------------------------------------------------------------------------------------------\n\n");
// }

// void afficherTs_MC_Sep(int cas)
// {
//     list p;
//     if(cas==2){
//       p=ts_mc;
//       printf("\n     /********* Table des symboles des Mots cles *********/\n\n");
//     }
//     if(cas==3){
//       p=ts_sep;
//       printf("\n     /********* Table des symboles des separateurs *******/\n\n");
//     }

//     printf("      ---------------------------------------------------\n");
//     printf("     |   Entite   |   TypeLex  |   Ligne    |    Col     |\n");

//     while(p!=NULL)
//     {
//         printf("     |------------|------------|------------|------------|\n");
//         printf("     | %10s | %10s | %10d | %10d |\n",p->info.Entite,p->info.TypeLex,p->info.ligne,p->info.col);
//         p=p->svt;
//     }
//     printf("      ---------------------------------------------------\n\n");
// }

