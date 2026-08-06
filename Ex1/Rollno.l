%{
#include<stdio.h>
int count = 0;
%}

%%
^[0-9][0-9](BCS|BEC|BIT)[0-9][0-9][0-9]$ {
    printf("Roll Number : %s\n", yytext);
    count++;
}

.*\n {
    /* Ignore invalid records */
}
%%

int main()
{
    FILE *fp;
    fp = fopen("roll.txt","r");
    if(fp == NULL)
    {
        printf("File not found\n");
        return 0;
    }
    yyin = fp;
    yylex();
    printf("\nTotal Student Records = %d\n", count);
    fclose(fp);
    return 0;
}

int yywrap()
{
    return 1;
}
