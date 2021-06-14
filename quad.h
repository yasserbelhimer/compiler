void insererQuadr(char opr[],char op1[],char op2[],char res[])
{
    strcpy(quadruples[qc].oper,opr);
    strcpy(quadruples[qc].ope1,op1);
    strcpy(quadruples[qc].ope2,op2);
    strcpy(quadruples[qc].res,res);
    qc++;
}



void AfficherQuadruples(){
    printf("**   les quadruples **\n\n");
    printf("-------------------------------------------\n");
    for (int i = 0; i < qc; i++)
    {
        printf("%d - (%5s,%5s,%5s,%5s)\n",i,quadruples[i].oper,quadruples[i].ope1,quadruples[i].ope2,quadruples[i].res);
    }
    printf("-------------------------------------------\n");
    
}