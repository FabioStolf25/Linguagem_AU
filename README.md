# ECOM06A_Auauau

Projeto final da matéria Compiladores. Desenvolvimento da Linguagem AU utilizando Flex e Bison.

## Como compilar o projeto

1. **Pré-requisitos**  
    - [Flex](https://github.com/westes/flex)
    - [Bison](https://www.gnu.org/software/bison/)
    - [GCC](https://gcc.gnu.org/) ou outro compilador C

2. **Clone o repositório**
    ```bash
    git clone <URL-do-repositório>
    cd ECOM06A_Auauau
    ```

3. **Compile o analisador léxico e sintático**
    ```bash
    flex au.l
    bison -d au.y
    gcc -o au_compiler y.tab.c lex.yy.c -lfl
    ```

4. **Execute o compilador**
    ```bash
    ./au_compiler arquivo_de_entrada.txt
    ```

## Estrutura dos arquivos

- `au.l`: Arquivo do analisador léxico (Flex)
- `au.y`: Arquivo do analisador sintático (Bison)
- `README.md`: Este arquivo
- `exemplo.txt`: Exemplo teste de condicional e repetição
- `exemplo2.txt`: Exemplo teste de entrada e saída
- `exemplo3.txt`: Exemplo Fibonacci
- `tokens.txt`: Arquivo log com tokens
