%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
%}

%%

"<a"[ ]+"href"[ ]*"="[ ]*"\""[^\"]*"\"" {
        char *start = strstr(yytext, "href");
        if(start){
                start = strstr(start, "\"") + 1;
                char *end = strchr(start , '"');
                if(end){
                        *end = '\0';
                        printf("Found : %s\n", start);
                }
        }
}

\n      ;
.       ;

%%

int main(){
        FILE *fp;
        fp = fopen("test.html", "r");
        if(fp == NULL){
                printf("File not found\n");
                return 0;
        }
        yyin = fp;
        yylex();
        fclose(fp);
        return 0;
}

int yywrap(){
        return 1;
}
