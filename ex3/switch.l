%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int case_count = 0;
int default_count = 0;
%}

%%
"switch" {
    printf("\n[SWITCH] switch statement found\n");
}
"case" {
    case_count++;
    printf("\n[CASE %d] case label found\n", case_count);
}
"default" {
    default_count++;
    printf("\n[DEFAULT] default label found\n");
}

"+" { printf("Arithmetic operator: +\n"); }
"-" { printf("Arithmetic operator: -\n"); }
"*" { printf("Arithmetic operator: *\n"); }
"/" { printf("Arithmetic operator: /\n"); }
"%" { printf("Arithmetic operator: %%\n"); }

"==" { printf("Relational operator: ==\n"); }
"!=" { printf("Relational operator: !=\n"); }
"<=" { printf("Relational operator: <=\n"); }
">=" { printf("Relational operator: >=\n"); }
"<"  { printf("Relational operator: <\n"); }
">"  { printf("Relational operator: >\n"); }

"&&" { printf("Logical operator: &&\n"); }
"||" { printf("Logical operator: ||\n"); }
"!"  { printf("Logical operator: !\n"); }

"+=" { printf("Assignment operator: +=\n"); }
"-=" { printf("Assignment operator: -=\n"); }
"*=" { printf("Assignment operator: *=\n"); }
"/=" { printf("Assignment operator: /=\n"); }
"%=" { printf("Assignment operator: %%=\n"); }
"="  { printf("Assignment operator: =\n"); }

"++"/[a-zA-Z_][a-zA-Z0-9_]* { printf("Prefix increment operator: ++\n"); }
"--"/[a-zA-Z_][a-zA-Z0-9_]* { printf("Prefix decrement operator: --\n"); }

[a-zA-Z_][a-zA-Z0-9_]*/"++" { printf("Postfix increment operator: ++\n"); }
[a-zA-Z_][a-zA-Z0-9_]*/"--" { printf("Postfix decrement operator: --\n"); }
"-[a-zA-Z_][a-zA-Z0-9_]*" {
    printf("Unary operator: -\n");
    // Print the identifier manually without the minus sign
    printf("Identifier: %s\n", yytext + 1);
}


"&"  { printf("Bitwise operator: &\n"); }
"|"  { printf("Bitwise operator: |\n"); }
"^"  { printf("Bitwise operator: ^\n"); }
"<<" { printf("Bitwise shift operator: <<\n"); }
">>" { printf("Bitwise shift operator: >>\n"); }
"~"  { printf("Bitwise complement operator: ~\n"); }

"("  { printf("Left parenthesis: (\n"); }
")"  { printf("Right parenthesis: )\n"); }
"{"  { printf("Left brace: {\n"); }
"}"  { printf("Right brace: }\n"); }
"["  { printf("Left bracket: [\n"); }
"]"  { printf("Right bracket: ]\n"); }
":"  { printf("Colon: :\n"); }
";"  { printf("Semicolon: ;\n"); }
","  { printf("Comma: ,\n"); }

"break"    { printf("Control statement: break\n"); }
"continue" { printf("Control statement: continue\n"); }
"return"   { printf("Control statement: return\n"); }

"if"   { printf("Conditional statement: if\n"); }
"else" { printf("Conditional statement: else\n"); }

"for"   { printf("Loop statement: for\n"); }
"while" { printf("Loop statement: while\n"); }
"do"    { printf("Loop statement: do\n"); }

"printf" { printf("Library function: printf()\n"); }
"scanf"  { printf("Library function: scanf()\n"); }

"int"    { printf("Data type: int\n"); }
"float"  { printf("Data type: float\n"); }
"char"   { printf("Data type: char\n"); }
"double" { printf("Data type: double\n"); }

[0-9]+ {
    printf("Integer constant: %s\n", yytext);
}

[0-9]+\.[0-9]+ {
    printf("Floating constant: %s\n", yytext);
}

\'[a-zA-Z0-9]\' {
    printf("Character constant: %s\n", yytext);
}

\"([^\"\\]|\\.)*\" {
    printf("String constant: %s\n", yytext);
}

[a-zA-Z_][a-zA-Z0-9_]* {
    printf("Identifier: %s\n", yytext);
}

[ \t\n]+ ;

. {
    printf("Unknown symbol: %s\n", yytext);
}
%%

int main()
{
    extern FILE *yyin;
    yyin = fopen("input.txt", "r");
    if(!yyin) {
        printf("Error: Could not open input.txt file.\n");
        return 1;
    }

    yylex();

    printf("\n-----------------------------\n");
    printf("Switch Analysis Completed\n");
    printf("-----------------------------\n");
    printf("Number of case labels : %d\n", case_count);
    printf("Number of default labels : %d\n", default_count);

    fclose(yyin);
    return 0;
}

int yywrap()
{
    return 1;
}
