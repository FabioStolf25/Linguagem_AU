%{
#include "au.tab.h"
#include <stdio.h>
#include <stdlib.h>
%}

digito        [0-9]
letra         [a-zA-Z]


%%

"A"                { return BEGINPROGRAMA; }
"UU"               { return ENDPROGRAMA; }
"AUU"              { return PONTOVIRGULA; }

"Au"               { return INICIOBLOCO; }
"AU"               { return FIMBLOCO; }
"Auu"              { return DOISPONTOS; }

"AUUAUU"           { return REPETICAO; }
"AuuAUU"           { return SE; }
"AUUAuu"           { return SENAO; }

"AuAuu"            { return IN; }
"AUAuu"            { return OUT; }

"Auuu"           { return ATRIBUICAO; }

A((uA(u|U))|(UAu)) { return RESERVADA; }
A((uA(u|U)A(u|U))|(UAuAu)) { return RELACIONAL; }

"AuuAuAu"          { return SOMA; }
"AuuAuAU"          { return SUB; }
"AuuAUAu"          { return MULT; }
"AuuAUAU"          { return DIV; }
"AuuAuuAu"         { return MOD; }

A((uUAU(u|U))|(UuAuU)) { return LOGICO; }

"AuuAuAU"?{digito}+   { yylval.inteiro = atoi(yytext); return INTEIRO; }

"AuuAuAU"?{digito}+\.{digito}+ { yylval.real = atof(yytext); return REAL; }

\'([a-zA-Z0-9])+\' { yylval.caractere = yytext[1]; return CARACTERE; }

{letra}({letra}|{digit})*   { yylval.ident = strdup(yytext); return VARIAVEL; }

[ \t\n\r]+          { /* ignorar espaços */ }
.                   { printf("Caractere inválido: %s\n", yytext); exit(1); }
%%

int yywrap(void) {
    return 1;
}