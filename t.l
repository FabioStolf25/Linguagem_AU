%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
%}

digit      [0-9]
letra      [a-zA-Z]

%%

"programa"          { return BEGINPROGRAMA; }
"fim"               { return ENDPROGRAMA; }
";"                 { return PONTOVIRGULA; }

"se"                { return SE; }
"senao"             { return SENAO; }

"in"                { return IN; }
"out"               { return OUT; }

"="                 { return ATRIBUICAO; }
"=="|"!="|">"|"<"   { return RELACIONAL; }

"+"                 { return SOMA; }
"-"                 { return SUB; }
"*"                 { return MULT; }

"e"|"ou"            { return LOGICO; }

{digit}+            { yylval.inteiro = atoi(yytext); return INTEIRO; }
{digit}+"."{digit}+ { yylval.real = atof(yytext); return REAL; }

\'[a-zA-Z0-9]\'      { yylval.caractere = yytext[1]; return CARACTERE; }

{letra}({letra}|{digit})*   { yylval.ident = strdup(yytext); return ID; }

[ \t\n\r]+          { /* ignorar espaços */ }

.                   { printf("Caractere inválido: %s\n", yytext); exit(1); }

%%

int yywrap() {
    return 1;
}
