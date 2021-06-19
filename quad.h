/**
 * Inserer un quadruple dans la table des quads
 * @param char opr[] l'operateur
 * @param char op1[] l'operand 1
 * @param char op2[] l'operand 2
 * @param char res[] le resultat
 * @return void
*/
void insererQuadr(char opr[],char op1[],char op2[],char res[])
{
    strcpy(quadruples[qc].oper,opr);
    strcpy(quadruples[qc].ope1,op1);
    strcpy(quadruples[qc].ope2,op2);
    strcpy(quadruples[qc].res,res);
    qc++;
}

/**
 * Pour faire la mise a jour d'un quadruple dans la table des quads
 * @param int tempQc l'indecx du quad que on var le faire la mise a jour
 * @return void
*/
void miseAjour(int tempQc){
    char cast[10];
    sprintf(cast,"%d",qc);
    strcpy(quadruples[tempQc].ope1,cast);
}

/**
 * Afficher l'ensemble des quadruples dans le fichier quad.log
 * @return void
*/
void AfficherQuadruples(){
    FILE *fichier = NULL;
    fichier = fopen("quad.log", "w");
    if (fichier != NULL)
    {
        fprintf(fichier, "\n/************************  les quadruples  ************************/\n\n");
        fprintf(fichier, "-------------------------------------------------------------------\n");
        fprintf(fichier, "|  N  |  Operateur   |   Operand 1  |   Operand 2  |   Resultat   |\n");
        for (int i = 0; i < qc; i++)
        {
            char tempo[5];
            sprintf(tempo,"%d",i);
            fprintf(fichier, "|-----|--------------|--------------|--------------|--------------|\n");
            fprintf(fichier, "|%3s  | %7s      | %7s      | %7s      | %7s      |\n",tempo,quadruples[i].oper,quadruples[i].ope1,quadruples[i].ope2,quadruples[i].res);
        }
        fprintf(fichier, "-------------------------------------------------------------------\n\n");
    }
    else
        printf("Impossible d'ouvrir le fichier ts.log\n");

    fclose(fichier);
}

