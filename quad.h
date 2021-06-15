void insererQuadr(char opr[],char op1[],char op2[],char res[])
{
    strcpy(quadruples[qc].oper,opr);
    strcpy(quadruples[qc].ope1,op1);
    strcpy(quadruples[qc].ope2,op2);
    strcpy(quadruples[qc].res,res);
    qc++;
}



void AfficherQuadruples(){
    FILE *fichier = NULL;
    fichier = fopen("quad.log", "w");
    if (fichier != NULL)
    {
        fprintf(fichier, "\n/**   les quadruples  **/\n\n");
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