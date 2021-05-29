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