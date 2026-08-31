# Linguagem de Programação AU

Projeto final da matéria de Compiladores. Implementação da linguagem esotérica **AU**, cujo alfabeto de tokens é formado apenas pelas letras `A` e `u` ("au au", o latido do cachorro). O projeto inclui o analisador léxico (Flex), o analisador sintático (Bison) e um interpretador que executa o programa diretamente a partir da árvore sintática gerada, sem passar por geração de código intermediário.

## O que a linguagem AU suporta

- Delimitação de programa (`A ... UU`) e de blocos (`Au ... AU`)
- Variáveis com tipos `int`, `real` e `char`, com tabela de símbolos própria
- Atribuição e expressões aritméticas (`+ - * / %`)
- Operadores relacionais (`== < > <= >=`) e lógicos (`E`, `OU`, `NAO`)
- Estruturas de controle `SE`/`SENAO` (if/else) e `REPETICAO` (while)
- Comandos de entrada (`ENTRADA`) e saída (`SAIDA`)

Como todos os tokens são combinações de `A` e `u`, o mapeamento completo de cada palavra reservada para seu token está definido nas regras de [`au.l`](au.l) e é registrado em tempo de execução em `tokens.txt` (gerado a cada execução, não versionado).

## Dependências

- [Flex](https://github.com/westes/flex) — gera o analisador léxico a partir de `au.l`
- [Bison](https://www.gnu.org/software/bison/) — gera o analisador sintático a partir de `au.y`
- [GCC](https://gcc.gnu.org/) (ou outro compilador C compatível)
- `make` — automatiza a geração e compilação (Makefile na raiz do projeto)

## Como compilar e executar

1. **Clone o repositório**
    ```bash
    git clone <URL-do-repositório>
    cd Linguagem_AU
    ```

2. **Compile**
    ```bash
    make
    ```
    Isso roda `bison -d au.y`, `flex au.l` e compila tudo com `gcc`, gerando o executável `au_compiler`.

3. **Execute**

    Escolhendo o exemplo interativamente:
    ```bash
    make run
    ```

    Ou rodando um exemplo específico direto:
    ```bash
    make run1   # exemplos/exemplo.txt  - condicional e repeticao
    make run2   # exemplos/exemplo2.txt - entrada e saida
    make run3   # exemplos/exemplo3.txt - fibonacci
    ```

    Também é possível rodar qualquer outro arquivo manualmente:
    ```bash
    ./au_compiler caminho/para/arquivo.txt
    ```

4. **Limpar artefatos gerados**
    ```bash
    make clean
    ```

## Estrutura dos arquivos

- `au.l` — analisador léxico (Flex): define os tokens da linguagem AU
- `au.y` — analisador sintático (Bison): define a gramática e o interpretador (construção da árvore sintática e sua execução)
- `Makefile` — automatiza geração (Flex/Bison), compilação e execução dos exemplos
- `exemplos/` — programas de exemplo escritos em AU
  - `exemplo.txt` — condicional e repetição
  - `exemplo2.txt` — entrada e saída (int, real e char)
  - `exemplo3.txt` — sequência de Fibonacci
- `README.md` — este arquivo

Arquivos gerados pela compilação (`au_compiler(.exe)`, `lex.yy.c`, `au.tab.c`, `au.tab.h`, `tokens.txt`) não são versionados — veja `.gitignore`.
