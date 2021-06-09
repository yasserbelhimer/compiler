/**
 * Verifier si une entite a un type
 * @param char NomEntite[] nom de l'entité
 * @return Element retourne l'element de la liste s'il n'a pas de type sinon retourne NULL
 */
Element *verifierexistetype(char NomEntite[])
{
    FILE *fichier = NULL;
    fichier = fopen(logFileName, "a");
    if (fichier != NULL)
    {
        fprintf(fichier, "Verification si l'idf %s a un type\n", NomEntite);
        Element *element = rechercherIdf(NomEntite);
        if (element != NULL && (strcmp(element->TypeEntite, "") != 0))
        {
            fprintf(fichier, "L'idf %s est de type %s\n\n", NomEntite, element->TypeEntite);
            return NULL;
        }
        fprintf(fichier, "L'idf %s n'a pas de type \n\n", NomEntite);
        return element;
    }
    else
        printf("Impossible d'ouvrir le fichier %s\n", logFileName);
}
/**
 * Inserer un type d'une entite
 * @param Element *element l'element dans lequel on insert le type
 * @param char *type type de l'idf
 * @param char *typeDeclaration type de declaration de l'idf (Variable ou constante)
 * @return void
 */
void inserertype(Element *element, char type[], char typeDeclaration[])
{
    strcpy(element->TypeEntite, type);
    strcpy(element->TypeDeclaration, typeDeclaration);
}
/**
* Verifier si un idf est une constante ou variable
* @param char NomEntite[] nom de l'entité
* @return int 1 si l'entité est une variable 0 sinon
*/
int verifierConstate(char NomEntite[])
{
    FILE *fichier = NULL;
    fichier = fopen(logFileName, "a");
    if (fichier != NULL)
    {
        fprintf(fichier, "Verification si l'idf %s est une constante\n", NomEntite);
        Element *element = rechercherIdf(NomEntite);
        if (element != NULL && (strcmp(element->TypeDeclaration, "CONSTANTE") == 0))
        {
            fprintf(fichier, "L'idf %s est une constante \n\n", NomEntite);
            return 1;
        }
        fprintf(fichier, "L'idf %s est une variable \n\n", NomEntite);
        return 0;
    }
    else
        printf("Impossible d'ouvrir le fichier %s\n", logFileName);
}