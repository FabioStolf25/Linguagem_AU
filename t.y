%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);

%}

%union {
    int inteiro;
    float real;
    char caractere;
    char* ident;
}

%token BEGINPROGRAMA ENDPROGRAMA PONTOVIRGULA
%token SE SENAO IN OUT
%token RELACIONAL SOMA SUB MULT LOGICO ATRIBUICAO
%token <inteiro> INTEIRO
%token <real> REAL
%token <caractere> CARACTERE
%token <ident> ID

%type <inteiro> expressao

%%

programa:
    BEGINPROGRAMA comandos ENDPROGRAMA
;

comandos:
    comandos comando
    | comando
;

comando:
    declaracao PONTOVIRGULA
    | atribuicao PONTOVIRGULA
    | condicional
    | entrada PONTOVIRGULA
    | saida PONTOVIRGULA
;

declaracao:
    "int" ID
    | "float" ID
    | "char" ID
;

atribuicao:
    ID ATRIBUICAO expressao
;

entrada:
    IN ID
;

saida:
    OUT expressao
;

condicional:
    SE expressao comando
    | SE expressao comando SENAO comando
;

expressao:
    expressao SOMA expressao
    | expressao SUB expressao
    | expressao MULT expressao
    | expressao RELACIONAL expressao
    | INTEIRO
    | REAL
    | ID
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s\n", s);
}

int main(void) {
    printf("Iniciando o parser...\n");
    yyparse();
    return 0;
}
