%{
#include <stdio.h>
#include <stdlib.h>
%}

%token BEGINPROGRAMA ENDPROGRAMA
%token INTEIRO REAL
%token SOMA SUB MULT DIV MOD
%token PONTOVIRGULA

%%

INICIO
    : BEGINPROGRAMA EXPRESSAO
    | BEGINPROGRAMA ENDPROGRAMA
    ;

EXPRESSAO
    : RESULTADO
    | INOUT
    | NOMEVAR
    | ATRIBUIR
    | RELACIONAR
    | CONDICAO
    | REPETIR
    | DESVIOCONDICAO
    | LOGIC
    ;

RESULTADO
    : EXP PONTOVIRGULA EXPRESSAO
    | EXP_REAL EXP_REAL PONTOVIRGULA EXPRESSAO
    | EXP_REAL EXP_REAL PONTOVIRGULA
    | EXP_INT EXP_INT PONTOVIRGULA EXPRESSAO
    | EXP_INT EXP_INT PONTOVIRGULA
    | EXP PONTOVIRGULA
    ;

EXP
    : EXP_INT
    | EXP_REAL
    ;

EXP_INT
    : EXP_INT
    | VAL_INT OPERATOR
    | OPERATOR VAL_INT
    ;

EXP_REAL
    : EXP_REAL
    | VAL_REAL OPERATOR VAL_REAL
    | OPERATOR VAL_REAL
    ;

VAL_INT
    : INTEIRO
    ;

VAL_REAL
    : REAL
    ;

OPERATOR
    : SOMA
    | SUB
    | MULT
    | DIV
    | MOD
    ;

%%

int main(void) {
    return yyparse();
}

int yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}
