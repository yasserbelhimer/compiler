/**
 * Initialisation des des outils necessaire pour la compilation
 * @return void
 */
void initialisation()
{
    FILE *fichier = NULL;
    fichier = fopen("ts.log", "w");
    if (fichier == NULL)
        printf("Impossible d'initialiser le fichier ts.log\n");
    fclose(fichier);
}
/**
 * Recherche une entite dans la table des symboles des idfs
 * @param char nomEntite[] nom de l'entité
 * @param char code[] code de l'entité
 * @return Element retourne l'element de la liste s'il existe sinon retourne NULL
 */
Element *rechercherIdf(char nomEntite[])
{
    Element *p = listIdf;
    while (p != NULL)
    {
        if (strcmp(nomEntite, p->nomEntite) == 0)
            return p;
        p = p->svt;
    }
    return NULL;
}

/**
 * Inserer un idf a la fin de la table des symboles de idf s'il n'est pas encore inseré.
 * @param char nomEntite[] nom de l'entité
 * @param char codeEntite[] code de l'entité
 * @return void
 */
void insererIdfLex(char nomEntite[], char codeEntite[])
{
    if (rechercherIdf(nomEntite) == NULL)
    {
        Element *p = malloc(sizeof(Element));
        strcpy(p->nomEntite, nomEntite);
        strcpy(p->codeEntite, codeEntite);
        strcpy(p->typeEntite, "");
        strcpy(p->value, "");
        strcpy(p->typeDeclaration, "UNDEFINED");
        p->svt = NULL;
        if (listIdf == NULL)
        {
            listIdf = p;
        }
        else
        {
            Element *temp = listIdf;
            while (temp->svt != NULL)
                temp = temp->svt;
            temp->svt = p;
        }
    }
}
/**
 * Inserer un type d'une entite
 * @param Element *element l'element dans lequel on insert le type
 * @param char *type type de l'idf
 * @param char *typeDeclaration type de declaration de l'idf (Variable ou constante)
 * @return void
 */
void inserertype(Element *element, char type[], char typeDeclaration[],char value[])
{
    strcpy(element->typeEntite, type);
    strcpy(element->typeDeclaration, typeDeclaration);
    if(value!=NULL)
        strcpy(element->value, value);
}
/**
 * Afficher la table des symboles de idfs.
 * @return void
 */
void afficherIdf()
{
    FILE *fichier = NULL;
    fichier = fopen("ts.log", "a");
    if (fichier != NULL)
    {
        fprintf(fichier, "\n/*********************************   Table des symboles des Idfs/Consts   ******************************/\n\n");
        fprintf(fichier, "-----------------------------------------------------------------------------------------------------------------------------\n");
        fprintf(fichier, "|           Nom Entite            |     Code Entite    |    Type Entite     |      Type Declaration       |      Value      |\n");
        Element *p = listIdf;
        while (p != NULL)
        {
            fprintf(fichier, "|---------------------------------|--------------------|--------------------|-----------------------------|-----------------|\n");
            fprintf(fichier, "| %25s       | %13s      | %13s      | %21s       | %9s       |\n", p->nomEntite, p->codeEntite, p->typeEntite, p->typeDeclaration,p->value);
            p = p->svt;
        }
        fprintf(fichier, "-----------------------------------------------------------------------------------------------------------------------------\n\n");
    }
    else
        printf("Impossible d'ouvrir le fichier ts.log\n");

    fclose(fichier);
}

/**
 * Recherche un separateur dans la table des symboles des separateurs
 * @param char separateur[] le separateurs
 * @return Separateur retourne le separateur de la liste s'il existe sinon retourne NULL
 */
Separateur *rechercherSeparateur(char separateur[])
{
    Separateur *p = listSeparateurs;
    while (p != NULL)
    {
        if (strcmp(separateur, p->separateur) == 0)
            return p;
        p = p->svt;
    }
    return NULL;
}

/**
 * Inserer un separateur a la fin de la table des symboles des separateur s'il n'est pas encore inseré.
 * @param char separateur[] le separateur
 * @return void
 */
void insererSeparateurLex(char separateur[])
{
    if (rechercherSeparateur(separateur) == NULL)
    {
        Separateur *p = malloc(sizeof(Separateur));
        strcpy(p->separateur, separateur);
        strcpy(p->code, "SEP");
        p->svt = NULL;
        if (listSeparateurs == NULL)
        {
            listSeparateurs = p;
        }
        else
        {
            Separateur *temp = listSeparateurs;
            while (temp->svt != NULL)
                temp = temp->svt;
            temp->svt = p;
        }
    }
}

/**
 * Afficher la table des symboles de separateurs.
 * @return void
 */
void afficherSeparateurs()
{
    FILE *fichier = NULL;
    fichier = fopen("ts.log", "a");
    if (fichier != NULL)
    {
        fprintf(fichier, "\n/**   Table des symboles des Separateur  **/\n\n");
        fprintf(fichier, "-------------------------------------------\n");
        fprintf(fichier, "|        Code        |     Separateur     |\n");
        Separateur *p = listSeparateurs;
        while (p != NULL)
        {
            fprintf(fichier, "|--------------------|--------------------|\n");
            fprintf(fichier, "| %10s         | %10s         |\n", p->code, p->separateur);
            p = p->svt;
        }
        fprintf(fichier, "-------------------------------------------\n\n");
    }
    else
        printf("Impossible d'ouvrir le fichier ts.log\n");

    fclose(fichier);
}

/**
 * Recherche un mot cle dans la table des symboles des mots cles
 * @param char keyword[] le mot cle
 * @return Keyword keyword retourne le mot cle s'il existe sinon retourne NULL
 */
Keyword *rechercherKeyword(char keyword[])
{
    Keyword *p = listMotsCles;
    while (p != NULL)
    {
        if (strcmp(keyword, p->keyword) == 0)
            return p;
        p = p->svt;
    }
    return NULL;
}

/**
 * Inserer un mot cle a la fin de la table des symboles des separateur s'il n'est pas encore inseré.
 * @param char keyword[] le mot cle
 * @return void
 */
void insererMotCleLex(char keyword[])
{
    if (rechercherSeparateur(keyword) == NULL)
    {
        Keyword *p = malloc(sizeof(Keyword));
        strcpy(p->keyword, keyword);
        strcpy(p->code, "MOT_CLE");
        p->svt = NULL;
        if (listMotsCles == NULL)
        {
            listMotsCles = p;
        }
        else
        {
            Keyword *temp = listMotsCles;
            while (temp->svt != NULL)
                temp = temp->svt;
            temp->svt = p;
        }
    }
}

/**
 * Afficher la table des symboles des mots cles.
 * @return void
 */
void afficherKeywords()
{
    FILE *fichier = NULL;
    fichier = fopen("ts.log", "a");
    if (fichier != NULL)
    {
        fprintf(fichier, "\n/**   Table des symboles des mots cles  **/\n\n");
        fprintf(fichier, "-------------------------------------------\n");
        fprintf(fichier, "|        Code        |       Mot cle      |\n");
        Keyword *p = listMotsCles;
        while (p != NULL)
        {
            fprintf(fichier, "|--------------------|--------------------|\n");
            fprintf(fichier, "| %10s         | %10s         |\n", p->code, p->keyword);
            p = p->svt;
        }
        fprintf(fichier, "-------------------------------------------\n\n");
    }
    else
        printf("Impossible d'ouvrir le fichier ts.log\n");

    fclose(fichier);
}
