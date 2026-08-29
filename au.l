%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "au.tab.h"

FILE *token_log_file = NULL;

struct No* cria_folha_num(double valor, int token_tipo);
struct No* cria_folha_var(const char* nome);

void log_token(const char* token_name) {

    if (token_log_file == NULL) {
        token_log_file = fopen("tokens.txt", "w");
        if (token_log_file == NULL) {
            perror("Erro ao abrir tokens.txt");
            exit(1);
        }
    }
    fprintf(token_log_file, "%s => %s\n", yytext, token_name);
}

%}
%option yylineno
%option noyywrap

digito      [0-9]
letra       [a-zA-Z]

%%

"A"                 { log_token("BEGINPROGRAMA"); return BEGINPROGRAMA; }
"UU"                { log_token("ENDPROGRAMA"); return ENDPROGRAMA; }
"AUU"               { log_token("PONTOVIRGULA"); return PONTOVIRGULA; }

"Au"                { log_token("INICIOBLOCO"); return INICIOBLOCO; }
"AU"                { log_token("FIMBLOCO"); return FIMBLOCO; }
"Auu"               { log_token("DOISPONTOS"); return DOISPONTOS; }

"AUUAUU"            { log_token("REPETICAO"); return REPETICAO; }
"AuuAUU"            { log_token("SE"); return SE; }
"AUUAuu"            { log_token("SENAO"); return SENAO; }

"AuAuu"             { log_token("ENTRADA"); return ENTRADA; }
"AUAuu"             { log_token("SAIDA"); return SAIDA; }

"Auuu"              { log_token("ATRIBUICAO"); return ATRIBUICAO; }

"AuAu"              { log_token("TIPO_INT"); return TIPO_INT; }
"AuAU"              { log_token("TIPO_REAL"); return TIPO_REAL; }
"AUAu"              { log_token("TIPO_CHAR"); return TIPO_CHAR; }

"AuAuAu"            { log_token("IGUAL"); return IGUAL; }
"AuAuAU"            { log_token("MENOR"); return MENOR; }
"AuAUAu"            { log_token("MAIOR"); return MAIOR; }
"AuAUAU"            { log_token("MENOR_IGUAL"); return MENOR_IGUAL; }
"AUAuAu"            { log_token("MAIOR_IGUAL"); return MAIOR_IGUAL; }

"AuuAuAu"           { log_token("SOMA"); return SOMA; }
"AuuAuAU"           { log_token("SUB"); return SUB; }
"AuuAUAu"           { log_token("MULT"); return MULT; }
"AuuAUAU"           { log_token("DIV"); return DIV; }
"AuuAuuAu"          { log_token("MOD"); return MOD; }

"AuUAUu"            { log_token("OU"); return OU; }
"AuUAUU"            { log_token("NAO"); return NAO; }
"AUuAuU"            { log_token("E"); return E; }

{digito}+           { log_token("INTEIRO"); yylval.no_ptr = cria_folha_num(atof(yytext), INTEIRO); return INTEIRO; }
{digito}+\.{digito}+ { log_token("REAL"); yylval.no_ptr = cria_folha_num(atof(yytext), REAL); return REAL; }
\'({letra}|{digito})\' { log_token("CARACTERE"); yylval.no_ptr = cria_folha_num((double)yytext[1], CARACTERE); return CARACTERE; }
{letra}({letra}|{digito})* { log_token("VARIAVEL"); yylval.no_ptr = cria_folha_var(yytext); return VARIAVEL; }

[ \t\n\r]+          { /* ignorar espacos em branco */ }

.                   { printf("Erro lexico: Caractere invalido '%s'\n", yytext); exit(1); }

%%