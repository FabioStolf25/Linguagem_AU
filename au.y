%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);
extern FILE *yyin;

typedef enum {
    TIPO_PROGRAMA, TIPO_LISTA_COMANDOS,
    TIPO_ATRIBUICAO, TIPO_DECLARACAO, TIPO_OPERADOR,
    TIPO_SE, TIPO_CORPO_SE, TIPO_REPETICAO, TIPO_IO,
    TIPO_VARIAVEL, TIPO_CONST_INT, TIPO_CONST_REAL, TIPO_CONST_CHAR,
    TIPO_UNARIO
} node_type;

typedef struct no {
    node_type tipo;
    int op_token;
    
    union {
        int val_int;
        double val_real;
        char val_char;
        char* nome_var;
    } valor;

    struct no *esquerda;
    struct no *direita;
} no;

struct no *raiz = NULL;

no* cria_no_op(int op, no* esq, no* dir);
no* cria_no_unario(int op, no* filho);
no* cria_folha_int(int valor);
no* cria_folha_real(double valor);
no* cria_folha_char(char valor);
no* cria_folha_var(char* nome);
void imprime_arvore(no *n, int nivel, char* galho);

%}

%union {
    struct no* no_ptr;
}

%token BEGINPROGRAMA ENDPROGRAMA PONTOVIRGULA
%token INICIOBLOCO FIMBLOCO
%token REPETICAO
%token SE SENAO
%token ENTRADA SAIDA

%token DOISPONTOS
%token IGUAL MENOR MAIOR MENOR_IGUAL MAIOR_IGUAL
%token OU NAO E
%token ATRIBUICAO
%token SOMA SUB MULT DIV MOD

%token TIPO_INT TIPO_REAL TIPO_CHAR

%token <no_ptr> INTEIRO REAL CARACTERE VARIAVEL

%type <no_ptr> programa lista_comandos comando comando_bloco
%type <no_ptr> declaracao_var atribuicao comando_se comando_repeticao comando_io
%type <no_ptr> exp

%right ATRIBUICAO
%left OU
%left E
%nonassoc IGUAL MENOR MAIOR MENOR_IGUAL MAIOR_IGUAL
%left SOMA SUB
%left MULT DIV MOD
%right NAO UNEGATIVO

%%

programa: 
      BEGINPROGRAMA lista_comandos ENDPROGRAMA  { raiz = $2; }
    ;

lista_comandos:
      comando                                   { $$ = $1; }
    | lista_comandos comando                    { $$ = cria_no_op(TIPO_LISTA_COMANDOS, $1, $2); }
    ;

comando:
      declaracao_var PONTOVIRGULA               { $$ = $1; }
    | atribuicao PONTOVIRGULA                   { $$ = $1; }
    | comando_se                                { $$ = $1; }
    | comando_repeticao                         { $$ = $1; }
    | comando_io PONTOVIRGULA                   { $$ = $1; }
    | comando_bloco                             { $$ = $1; }
    ;
    
comando_bloco:
      INICIOBLOCO lista_comandos FIMBLOCO       { $$ = $2; }
    ;

declaracao_var:
      TIPO_INT VARIAVEL                         { $$ = cria_no_op(TIPO_INT, $2, NULL); }
    | TIPO_REAL VARIAVEL                        { $$ = cria_no_op(TIPO_REAL, $2, NULL); }
    | TIPO_CHAR VARIAVEL                        { $$ = cria_no_op(TIPO_CHAR, $2, NULL); }
    ;

atribuicao:
      VARIAVEL ATRIBUICAO exp                   { $$ = cria_no_op(ATRIBUICAO, $1, $3); }
    ;

comando_io:
      SAIDA exp                                 { $$ = cria_no_unario(SAIDA, $2); }
    | ENTRADA VARIAVEL                          { $$ = cria_no_unario(ENTRADA, $2); }
    ;


comando_se:
      SE exp DOISPONTOS comando_bloco
      {
          no* corpo = cria_no_op(TIPO_CORPO_SE, $4, NULL);
          $$ = cria_no_op(SE, $2, corpo);
      }
    | SE exp DOISPONTOS comando_bloco SENAO comando_bloco
      {
          no* corpo = cria_no_op(TIPO_CORPO_SE, $4, $6);
          $$ = cria_no_op(SE, $2, corpo);
      }
    ;

comando_repeticao:
      REPETICAO exp DOISPONTOS comando_bloco    { $$ = cria_no_op(REPETICAO, $2, $4); }
    ;

exp:
      INTEIRO                                   { $$ = $1; }
    | REAL                                      { $$ = $1; }
    | CARACTERE                                 { $$ = $1; }
    | VARIAVEL                                  { $$ = $1; }
    | exp SOMA exp                              { $$ = cria_no_op(SOMA, $1, $3); }
    | exp SUB exp                               { $$ = cria_no_op(SUB, $1, $3); }
    | exp MULT exp                              { $$ = cria_no_op(MULT, $1, $3); }
    | exp DIV exp                               { $$ = cria_no_op(DIV, $1, $3); }
    | exp MOD exp                               { $$ = cria_no_op(MOD, $1, $3); }
    | exp IGUAL exp                             { $$ = cria_no_op(IGUAL, $1, $3); }
    | exp MENOR exp                             { $$ = cria_no_op(MENOR, $1, $3); }
    | exp MAIOR exp                             { $$ = cria_no_op(MAIOR, $1, $3); }
    | exp MENOR_IGUAL exp                       { $$ = cria_no_op(MENOR_IGUAL, $1, $3); }
    | exp MAIOR_IGUAL exp                       { $$ = cria_no_op(MAIOR_IGUAL, $1, $3); }
    | exp E exp                                 { $$ = cria_no_op(E, $1, $3); }
    | exp OU exp                                { $$ = cria_no_op(OU, $1, $3); }
    | NAO exp                                   { $$ = cria_no_unario(NAO, $2); }
    | SUB exp %prec UNEGATIVO                   { $$ = cria_no_unario(UNEGATIVO, $2); }
    | '(' exp ')'                               { $$ = $2; }
    ;
    
%%


void yyerror(const char *s) {
    fprintf(stderr, "Erro de sintaxe: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) { perror(argv[1]); return 1; }
    }
    yyparse();
    if (raiz) {
        printf("\n--- Arvore de Sintaxe Binaria ---\n");
        imprime_arvore(raiz, 0, "Raiz: ");
    }
    return 0;
}

no* cria_no_op(int op, no* esq, no* dir) {
    no* novo = malloc(sizeof(no));
    novo->tipo = TIPO_OPERADOR;
    novo->op_token = op;
    novo->esquerda = esq;
    novo->direita = dir;
    return novo;
}

no* cria_no_unario(int op, no* filho) {
    no* novo = malloc(sizeof(no));
    novo->tipo = TIPO_UNARIO;
    novo->op_token = op;
    novo->esquerda = filho;
    novo->direita = NULL;
    return novo;
}

no* cria_folha_int(int valor) {
    no* folha = malloc(sizeof(no));
    folha->tipo = TIPO_CONST_INT;
    folha->op_token = 0; // Sem op_token para folhas
    folha->valor.val_int = valor;
    folha->esquerda = folha->direita = NULL;
    return folha;
}
no* cria_folha_real(double valor) {
    no* folha = malloc(sizeof(no));
    folha->tipo = TIPO_CONST_REAL;
    folha->op_token = 0;
    folha->valor.val_real = valor;
    folha->esquerda = folha->direita = NULL;
    return folha;
}
no* cria_folha_char(char valor) {
    no* folha = malloc(sizeof(no));
    folha->tipo = TIPO_CONST_CHAR;
    folha->op_token = 0;
    folha->valor.val_char = valor;
    folha->esquerda = folha->direita = NULL;
    return folha;
}
no* cria_folha_var(char* nome) {
    no* folha = malloc(sizeof(no));
    folha->tipo = TIPO_VARIAVEL;
    folha->op_token = 0;
    folha->valor.nome_var = nome;
    folha->esquerda = folha->direita = NULL;
    return folha;
}

void imprime_arvore(no *n, int nivel, char* galho) {
    if (!n) return;

    for (int i = 0; i < nivel; i++) printf("    ");
    printf("%s", galho);

    switch(n->op_token) {
        case TIPO_LISTA_COMANDOS: printf("[Lista Comandos]\n"); break;
        case TIPO_INT: printf("[DECLARACAO INT]\n"); break;
        case TIPO_REAL: printf("[DECLARACAO REAL]\n"); break;
        case TIPO_CHAR: printf("[DECLARACAO CHAR]\n"); break;
        case ATRIBUICAO: printf("[ATRIBUICAO =]\n"); break;
        case SE: printf("[SE]\n"); break;
        case TIPO_CORPO_SE: printf("[CORPO IF]\n"); break;
        case REPETICAO: printf("[REPETICAO]\n"); break;
        case SAIDA: printf("[SAIDA]\n"); break;
        case ENTRADA: printf("[ENTRADA]\n"); break;
        case SOMA: printf("[OP: +]\n"); break;
        case SUB: printf("[OP: -]\n"); break;
        case MULT: printf("[OP: *]\n"); break;
        case DIV: printf("[OP: /]\n"); break;
        case MOD: printf("[OP: %%]\n"); break;
        case IGUAL: printf("[OP: ==]\n"); break;
        case MENOR: printf("[OP: <]\n"); break;
        case MAIOR: printf("[OP: >]\n"); break;
        case MENOR_IGUAL: printf("[OP: <=]\n"); break;
        case MAIOR_IGUAL: printf("[OP: >=]\n"); break;
        case E: printf("[OP: E]\n"); break;
        case OU: printf("[OP: OU]\n"); break;
        case NAO: printf("[OP: NAO]\n"); break;
        case UNEGATIVO: printf("[OP: NEGATIVO]\n"); break;
        default:
            switch(n->tipo){
                case TIPO_VARIAVEL: printf("[VAR: %s]\n", n->valor.nome_var); break;
                case TIPO_CONST_INT: printf("[INT: %d]\n", n->valor.val_int); break;
                case TIPO_CONST_REAL: printf("[REAL: %f]\n", n->valor.val_real); break;
                case TIPO_CONST_CHAR: printf("[CHAR: '%c']\n", n->valor.val_char); break;
                default: printf("[NO DESCONHECIDO, TIPO: %d]\n", n->tipo);
            }
    }
    
    imprime_arvore(n->esquerda, nivel + 1, "E: ");
    imprime_arvore(n->direita, nivel + 1, "D: ");
}