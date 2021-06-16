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

int divPar0(int debut, int fin)
{
    float denominateur;
    float tempo1, tempo2;
    float oper1, oper2;
    int first = 0;
    Element *element1 = NULL;
    Element *element2 = NULL;
    if (debut == fin)
    {
        element1 = rechercherIdf(quadruples[debut].ope2);
        if (element1 != NULL && element1->typeDeclaration == "VARIABLE")
            return 1;
        if (element1 != NULL && (strcmp(element1->typeEntite, "INTEGER") == 0 || strcmp(element1->typeEntite, "REAL") == 0))
            denominateur = atof(element1->value);
        else
            denominateur = atof(quadruples[debut].ope2);
        if (denominateur == 0.0)
            return 0;
        else
            return 1;
    }
    for (int i = debut; i < fin; i++)
    {
        if (quadruples[i].ope1[0] != 't' && quadruples[i].ope2[0] != 't')
        {
            first++;
            element1 = rechercherIdf(quadruples[i].ope1);
            element2 = rechercherIdf(quadruples[i].ope2);
            if ((element1 != NULL && element1->typeDeclaration == "VARIABLE") || (element2 != NULL && element2->typeDeclaration == "VARIABLE"))
                return 1;
            if (element1 != NULL && (strcmp(element1->typeEntite, "INTEGER") == 0 || strcmp(element1->typeEntite, "REAL") == 0))
                oper1 = atof(element1->value);
            else
                oper1 = atof(quadruples[i].ope1);
            if (element2 != NULL && (strcmp(element2->typeEntite, "INTEGER") == 0 || strcmp(element2->typeEntite, "REAL") == 0))
                oper2 = atof(element2->value);
            else
                oper2 = atof(quadruples[i].ope2);
        }
        else if (quadruples[i].ope1[0] == 't' && quadruples[i].ope2[0] != 't')
        {
            if (first % 2)
                oper1 = tempo1;
            else
                oper1 = tempo2;
            element2 = rechercherIdf(quadruples[i].ope2);
            if (element2 != NULL && element2->typeDeclaration == "VARIABLE")
                return 1;
            if (element2 != NULL && (strcmp(element2->typeEntite, "INTEGER") == 0 || strcmp(element2->typeEntite, "REAL") == 0))
                oper2 = atof(element2->value);
            else
                oper2 = atof(quadruples[i].ope2);
        }
        else if (quadruples[i].ope1[0] != 't' && quadruples[i].ope2[0] == 't')
        {
            element1 = rechercherIdf(quadruples[i].ope1);
            if (element1 != NULL && element1->typeDeclaration == "VARIABLE")
                return 1;
            if (element1 != NULL && (strcmp(element1->typeEntite, "INTEGER") == 0 || strcmp(element1->typeEntite, "REAL") == 0))
                oper1 = atof(element1->value);
            else
                oper1 = atof(quadruples[i].ope1);
            if (first % 2)
                oper2 = tempo1;
            else
                oper2 = tempo2;
        }
        else
        {
            first--;
            oper1 = tempo1;
            oper2 = tempo2;
        }
        if (strcmp(quadruples[i].oper, "+") == 0)
        {
            if (first % 2)
            {
                tempo1 = oper1 + oper2;
            }
            else
                tempo2 = oper1 + oper2;
        }
        if (strcmp(quadruples[i].oper, "-") == 0)
        {
            if (first % 2)
            {
                tempo1 = oper1 - oper2;
            }
            else
                tempo2 = oper1 - oper2;
        }
        if (strcmp(quadruples[i].oper, "*") == 0)
        {
            if (first % 2)
            {
                tempo1 = oper1 * oper2;
            }
            else
                tempo2 = oper1 * oper2;
        }
        if (strcmp(quadruples[i].oper, "/") == 0)
        {

            if (oper2 == 0)
                break;
            if (first % 2)
            {
                tempo1 = oper1 / oper2;
            }
            else
                tempo2 = oper1 / oper2;
        }
    }
    if (first % 2)
        denominateur = tempo1;
    else
        denominateur = tempo2;
    if (denominateur == 0.0)
        return 0;
    else
        return 1;
}