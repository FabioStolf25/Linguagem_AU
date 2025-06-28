%{
#include <stdio.h>
#include "t.tab.h"
%}

DIGITO        [0-9]
LETRA         [a-zA-Z]

%%

A                              { return BEGIN; }
UU                             { return END; }
AUU                            { return PONTOVIRGULA; }
Au                             { return INICIOBLOCO; }
AU                             { return FIMBLOCO; }
Auu                            { return DOISPONTOS; }

{LETRA}({LETRA}|{DIGITO})*     { return VARIAVEL; }
A(uA(u|U)|UAu)                 { return RESERVADA; }

(Auu|Au|AU)?{DIGITO}+          { return INTEIRO; }
(Auu|Au|AU)?{DIGITO}+\.[DIGITO]+ { return REAL; }

\'({LETRA}|{DIGITO})+\'        { return CARACTERE; }

A(uA(u|U)A(u|U)|UAuAu)         { return RELACIONAL; }
AuAuAu                         { return ATRIBUICAO; }

AuuAUU                         { return SE; }
AUUAuu                         { return SENAO; }
AuAuu                          { return ENTRADA; }
AUAuu                          { return SAIDA; }

A(uUAU(u|U)|UuAuU)             { return LOGICO; }

AuuAuAu                        { return SOMA; }
AuuAuAU                        { return SUB; }
AuuAUAu                        { return MULT; }
AuuAUAU                        { return DIV; }
AuuAuuAu                       { return MOD; }

AUUAUU                         { return REPETIR; }

[ \t\n]+                       { /* ignora espaços em branco */ }
.                              { printf("Caractere não reconhecido: %s\n", yytext); }

%%

int yywrap(void) { return 1; }






