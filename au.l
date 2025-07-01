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

"A"                 { printf("BEGINPROGRAMA "); return BEGINPROGRAMA; }
"UU"                { printf("ENDPROGRAMA "); return ENDPROGRAMA; }
"AUU"               { printf("PONTOVIRGULA "); return PONTOVIRGULA; }

"Au"                { printf("INICIOBLOCO "); return INICIOBLOCO; }
"AU"                { printf("FIMBLOCO "); return FIMBLOCO; }
"Auu"               { printf("DOISPONTOS "); return DOISPONTOS; }

"AUUAUU"            { printf("REPETICAO "); return REPETICAO; }
"AuuAUU"            { printf("SE "); return SE; }
"AUUAuu"            { printf("SENAO "); return SENAO; }


"AuAuu"             { printf("ENTRADA "); return ENTRADA; }
"AUAuu"             { printf("SAIDA "); return SAIDA; }

"Auuu"              { printf("ATRIBUICAO "); return ATRIBUICAO; }

"AuAu"              { printf("TIPO_INT "); return TIPO_INT; }
"AuAU"              { printf("TIPO_REAL "); return TIPO_REAL; }
"AUAu"              { printf("TIPO_CHAR "); return TIPO_CHAR; }

"AuAuAu"            { printf("IGUAL "); return IGUAL; }
"AuAuAU"            { printf("MENOR "); return MENOR; }
"AuAUAu"            { printf("MAIOR "); return MAIOR; }
"AuAUAU"            { printf("MENOR_IGUAL "); return MENOR_IGUAL; }
"AUAuAu"            { printf("MAIOR_IGUAL "); return MAIOR_IGUAL; }

"AuuAuAu"           { printf("SOMA "); return SOMA; }
"AuuAuAU"           { printf("SUB "); return SUB; }
"AuuAUAu"           { printf("MULT "); return MULT; }
"AuuAUAU"           { printf("DIV "); return DIV; }
"AuuAuuAu"          { printf("MOD "); return MOD; }

"AuUAUu"            { printf("OU "); return OU; }
"AuUAUU"            { printf("NAO "); return NAO; }  
"AUuAuU"            { printf("E "); return E; }

{digito}+           { yylval.no_ptr = cria_folha_int(atoi(yytext)); printf("INTEIRO "); return INTEIRO; }
{digito}+\.{digito}+ { yylval.no_ptr = cria_folha_real(atof(yytext)); printf("REAL "); return REAL; }
\'({letra}|{digito})\' { yylval.no_ptr = cria_folha_char(yytext[1]); printf("CARACTERE"); return CARACTERE; }
{letra}({letra}|{digito})* { yylval.no_ptr = cria_folha_var(strdup(yytext)); printf("VARIAVEL "); return VARIAVEL; }

[ \t\n\r]+          { /* ignorar espacos em branco */ }

.                   { printf("Erro lexico: Caractere invalido '%s'\n", yytext); exit(1); }

%%