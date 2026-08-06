%{
#include<stdio.h>
#include<stdlib.h>
int word_matches = 0;
%}

%%
\bis\b      {
                word_matches++;
                printf("was(occurrence %d)", word_matches);
            }

[0-9]+      {
                printf("%d", atoi(yytext) + 10);
            }

\n          {
                printf("\n");
            }

.           {
                putchar(yytext[0]);
            }
%%

int main() {
    printf("Please input your source text: \n");
    yylex();
    printf("\nTotal transformations completed for word \"is\": %d\n", word_matches);
    return 0;
}

int yywrap() {
    return 1;
}
