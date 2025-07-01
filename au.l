%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

struct no* cria_folha_int(int valor);
struct no* cria_folha_real(double valor);
struct no* cria_folha_char(char valor);
struct no* cria_folha_var(char* nome);
%}

%option noyywrap

digito      [0-9]
letra       [a-zA-Z]

%%

"A"                 { return BEGINPROGRAMA; }
"UU"                { return ENDPROGRAMA; }
"AUU"               { return PONTOVIRGULA; }

"Au"                { return INICIOBLOCO; }
"AU"                { return FIMBLOCO; }
"Auu"               { return DOISPONTOS; }

"AUUAUU"            { return REPETICAO; }
"AuuAUU"            { return SE; }
"AUUAuu"            { return SENAO; }


"AuAuu"             { return ENTRADA; }
"AUAuu"             { return SAIDA; }

"Auuu"              { return ATRIBUICAO; }

"AuAu"              { return TIPO_INT; }
"AuAU"              { return TIPO_REAL; }
"AUAu"              { return TIPO_CHAR; }

"AuAuAu"            { return IGUAL; }
"AuAuAU"            { return MENOR; }
"AuAUAu"            { return MAIOR; }
"AuAUAU"            { return MENOR_IGUAL; }
"AUAuAu"            { return MAIOR_IGUAL; }

"AuuAuAu"           { return SOMA; }
"AuuAuAU"           { return SUB; }
"AuuAUAu"           { return MULT; }
"AuuAUAU"           { return DIV; }
"AuuAuuAu"          { return MOD; }

"AuUAUu"            { return OU; }
"AuUAUU"            { return NAO; }  
"AUuAuU"            {return E; }

{digito}+           { yylval.no_ptr = cria_folha_int(atoi(yytext)); return INTEIRO; }
{digito}+\.{digito}+ { yylval.no_ptr = cria_folha_real(atof(yytext)); return REAL; }
\'({letra}|{digito})\' { yylval.no_ptr = cria_folha_char(yytext[1]); return CARACTERE; }
{letra}({letra}|{digito})* { yylval.no_ptr = cria_folha_var(strdup(yytext)); return VARIAVEL; }

[ \t\n\r]+          { /* ignorar espacos em branco */ }

.                   { printf("Erro lexico: Caractere invalido '%s'\n", yytext); exit(1); }

%%