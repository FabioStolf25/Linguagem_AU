%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int yylex(void);
void yyerror(const char *s);
extern FILE *yyin;
extern int yylineno;

struct No {
    int token;
    double val;
    char nome[256];
    struct No *esq, *dir, *prox;
};

struct No *raiz = NULL;

struct Simbolo {
    char nome[256];
    double valor;
    struct Simbolo* proximo;
};

struct Simbolo* tabela_simbolos = NULL;

struct No* cria_no_op(int token, struct No* esq, struct No* dir);
struct No* cria_folha_num(double valor, int token_tipo);
struct No* cria_folha_var(const char* nome);
void executa_arvore(struct No* n);
double avalia_exp(struct No* n);
void insere_simbolo(const char* nome);
struct Simbolo* busca_simbolo(const char* nome);
void atualiza_simbolo(const char* nome, double valor);

%}

%union {
    struct No* no_ptr;
}
%token BEGINPROGRAMA ENDPROGRAMA PONTOVIRGULA
%token INICIOBLOCO FIMBLOCO REPETICAO SE SENAO
%token ENTRADA SAIDA DOISPONTOS
%token IGUAL MENOR MAIOR MENOR_IGUAL MAIOR_IGUAL
%token OU NAO E ATRIBUICAO
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
    | BEGINPROGRAMA ENDPROGRAMA                 { raiz = NULL; }
    ;
lista_comandos:
      comando                                   { $$ = $1; }
    | comando lista_comandos                    { $1->prox = $2; $$ = $1; }
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
      SAIDA exp                                 { $$ = cria_no_op(SAIDA, $2, NULL); }
    | ENTRADA VARIAVEL                          { $$ = cria_no_op(ENTRADA, $2, NULL); }
    ;
comando_se:
      SE exp DOISPONTOS comando_bloco
      { $$ = cria_no_op(SE, $2, $4); }
    | SE exp DOISPONTOS comando_bloco SENAO comando_bloco
      { $4->prox = $6; $$ = cria_no_op(SE, $2, $4); }
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
    | NAO exp                                   { $$ = cria_no_op(NAO, $2, NULL); }
    | SUB exp %prec UNEGATIVO                   { $$ = cria_no_op(UNEGATIVO, $2, NULL); }
    | '(' exp ')'                               { $$ = $2; }
    ;
%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro na linha %d: %s\n", yylineno, s);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) { perror(argv[1]); return 1; }
    }
    if (yyparse() != 0) {
        printf("Analise Sintatica Falhou.\n");
        return 1;
    }
    if (raiz) {
        printf("--- Iniciando Execucao ---\n");
        executa_arvore(raiz);
        printf("--- Fim da Execucao ---\n");
    }
    return 0;
}

struct No* cria_no_op(int token, struct No* esq, struct No* dir) {
    struct No* n = (struct No*) malloc(sizeof(struct No));
    n->token = token; n->esq = esq; n->dir = dir; n->prox = NULL; n->val = 0; strcpy(n->nome, "");
    return n;
}
struct No* cria_folha_num(double valor, int token_tipo) {
    struct No* n = (struct No*) malloc(sizeof(struct No));
    n->token = token_tipo; n->val = valor; n->esq = n->dir = n->prox = NULL; strcpy(n->nome, "");
    return n;
}
struct No* cria_folha_var(const char* nome) {
    struct No* n = (struct No*) malloc(sizeof(struct No));
    n->token = VARIAVEL; strncpy(n->nome, nome, 255); n->nome[255] = '\0';
    n->val = 0; n->esq = n->dir = n->prox = NULL;
    return n;
}


void executa_arvore(struct No* n) {
    for (struct No* cmd = n; cmd != NULL; cmd = cmd->prox) {
        if(!cmd) continue;
        switch(cmd->token) {
            case TIPO_INT: case TIPO_REAL: case TIPO_CHAR:
                insere_simbolo(cmd->esq->nome); break;
            case ATRIBUICAO:
                atualiza_simbolo(cmd->esq->nome, avalia_exp(cmd->dir)); break;
            case SAIDA: {
                struct Simbolo* s = NULL;
                if (cmd->esq && cmd->esq->token == VARIAVEL)
                    s = busca_simbolo(cmd->esq->nome);
                if (s) {
                    printf("Saida (%s): ", s->nome);
                } else {
                    printf("Saida: ");
                }
                switch(cmd->esq->token) {
                    case INTEIRO:
                        printf("%d\n", (int)avalia_exp(cmd->esq));
                        break;
                    case REAL:
                        printf("%g\n", avalia_exp(cmd->esq));
                        break;
                    case CARACTERE:
                        printf("%c\n", (char)avalia_exp(cmd->esq));
                        break;
                    case VARIAVEL:
                        printf("%g\n", avalia_exp(cmd->esq));
                        break;
                    default:
                        printf("%g\n", avalia_exp(cmd->esq));
                        break;
                }
                break;
            }
            case ENTRADA: {
                struct Simbolo* s = busca_simbolo(cmd->esq->nome);
                if (!s) {
                    yyerror("Variavel nao declarada para entrada.");
                    break;
                }
                printf("Entrada para %s: ", cmd->esq->nome);

                switch(cmd->esq->token) {
                    case INTEIRO: {
                        int val_int = 0;
                        scanf("%d", &val_int);
                        s->valor = val_int;
                        break;
                    }
                    case REAL: {
                        double val_real = 0;
                        scanf("%lf", &val_real);
                        s->valor = val_real;
                        break;
                    }
                    case CARACTERE: {
                        char val_char = 0;
                        scanf(" %c", &val_char);
                        s->valor = (char)val_char;
                        break;
                    }
                    case VARIAVEL: {
                        double val = 0;
                        scanf("%lf", &val);
                        s->valor = val;
                        break;
                    }
                    default: {
                        double val = 0;
                        scanf("%lf", &val);
                        s->valor = val;
                        break;
                    }
                }
                break;
            }
            case REPETICAO:
                while(avalia_exp(cmd->esq) != 0) executa_arvore(cmd->dir);
                break;
            case SE:
                if (avalia_exp(cmd->esq) != 0) executa_arvore(cmd->dir);
                else if (cmd->dir->prox != NULL) executa_arvore(cmd->dir->prox);
                break;
            default:
                if (cmd->esq) executa_arvore(cmd->esq);
                if (cmd->dir) executa_arvore(cmd->dir);
                break;
        }
    }
}

double avalia_exp(struct No* n) {
    if (!n) { yyerror("Erro: expressao nula na avaliacao."); return 0; }
    switch(n->token) {
        case INTEIRO: case REAL: case CARACTERE: return n->val;
        case VARIAVEL: {
            struct Simbolo* s = busca_simbolo(n->nome);
            if (!s) {
                char msg[256];
                sprintf(msg, "Variavel '%s' nao declarada.", n->nome);
                yyerror(msg);
                exit(1);
            }
            return s->valor;
        }
        case SOMA:      return avalia_exp(n->esq) + avalia_exp(n->dir);
        case SUB:       return avalia_exp(n->esq) - avalia_exp(n->dir);
        case MULT:      return avalia_exp(n->esq) * avalia_exp(n->dir);
        case DIV:       return avalia_exp(n->esq) / avalia_exp(n->dir);
        case MOD:       return fmod(avalia_exp(n->esq), avalia_exp(n->dir));
        case MENOR:     return avalia_exp(n->esq) < avalia_exp(n->dir);
        case MAIOR:     return avalia_exp(n->esq) > avalia_exp(n->dir);
        case IGUAL:     return avalia_exp(n->esq) == avalia_exp(n->dir);
        case MENOR_IGUAL: return avalia_exp(n->esq) <= avalia_exp(n->dir);
        case MAIOR_IGUAL: return avalia_exp(n->esq) >= avalia_exp(n->dir);
        case E:         return avalia_exp(n->esq) && avalia_exp(n->dir);
        case OU:        return avalia_exp(n->esq) || avalia_exp(n->dir);
        case NAO:       return !avalia_exp(n->esq);
        case UNEGATIVO: return -avalia_exp(n->esq);
        default: yyerror("Operador desconhecido na avaliacao."); return 0;
    }
}

void insere_simbolo(const char* nome) {
    if (busca_simbolo(nome) != NULL) {
        char msg[256];
        sprintf(msg, "Variavel '%s' ja declarada.", nome);
        yyerror(msg);
        return;
    }
    struct Simbolo* s = (struct Simbolo*) malloc(sizeof(struct Simbolo));
    strncpy(s->nome, nome, 255);
    s->nome[255] = '\0';
    s->valor = 0;
    s->proximo = tabela_simbolos;
    tabela_simbolos = s;
}

struct Simbolo* busca_simbolo(const char* nome) {
    for (struct Simbolo* s = tabela_simbolos; s != NULL; s = s->proximo) {
        if (strcmp(s->nome, nome) == 0) {
            return s;
        }
    }
    return NULL;
}

void atualiza_simbolo(const char* nome, double valor) {
    struct Simbolo* s = busca_simbolo(nome);
    if (!s) {
        char msg[256];
        sprintf(msg, "Variavel '%s' nao declarada.", nome);
        yyerror(msg);
        exit(1);
    }
    s->valor = valor;
}