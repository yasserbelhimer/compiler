/**
 * Verifier si une entite a un type
 * @param char nomEntite[] nom de l'entité
 * @return Element retourne l'element de la liste s'il n'a pas de type sinon retourne NULL
 */
Element *verifierexistetype(char nomEntite[])
{
    Element *element = rechercherIdf(nomEntite);
    if (element != NULL && (strcmp(element->typeEntite, "") != 0))
    {
        return NULL;
    }
    return element;
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
    strcpy(element->typeEntite, type);
    strcpy(element->typeDeclaration, typeDeclaration);
}
/**
* Verifier si un idf est une constante ou variable, Affiche une erreur semantique et sort de programme si l'entite est une constante
* @param char nomEntite[] nom de l'entité
*/
void verifierConstate(char nomEntite[])
{
    Element *element = rechercherIdf(nomEntite);
    if (element != NULL && (strcmp(element->typeDeclaration, "CONSTANTE") == 0))
        printError("Symantec error une constante ne peut pas etre changer", nomEntite);
}
/**
 * Verifier si un IDF est declarer, Affiche une erreur semantique et sort de programme si l'entite n'est pas declarer
 * @param char nomEntite[] nom de l'entité
*/
void idfNotDeclard(char nomEntite[])
{
    if (verifierexistetype(nomEntite) != NULL)
        printError("Symantec error variable non declarer", nomEntite);
}

/**
 * Verifier si deux type sont compatible, Affiche une erreur semantique et sort de programme si les deux types ne sont pas compatible
 * @param char nomEntite1[] nom de la premiere entité 
 * @param char nomEntite2[] nom de la deuxieme entité si l'entite est un IDF et le type si l'entite est une constante
 * @param int type type de la deuxieme entite. 1 si nomEntite2 est un IDF et 2 si nomEntite2 est une constante
*/
void compatibiliteType(char nomEntite1[], char nomEntite2[], int type)
{
    Element *element1 = rechercherIdf(nomEntite1);
    if (type == 1)
    {
        Element *element2 = rechercherIdf(nomEntite2);
        if (strcmp(element1->typeEntite, element2->typeEntite) != 0)
        {
            printIncompatibleTypeError(element1->typeEntite, element2->typeEntite);
        }
    }
    else if (type == 2)
    {
        if (strcmp(element1->typeEntite, nomEntite2) != 0)
        {
            printIncompatibleTypeError(element1->typeEntite, nomEntite2);
        }
    }
}