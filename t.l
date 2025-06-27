%{
    include <stdio.h>
    #include "t.tab.h"

%}

***** Expressões Regulares *****

dígito        [0-9]
letra         [a-zA-Z]

begin         A
end           UU
pontovirgula  AUU
iniciobloco   Au
fimbloco      AU
doispontos    Auu

variavel      [letra]+([dígito]*[letra]*)*
reservada     A((uA(u|U))|(UAu))

inteiro       ([AuuAuAU])?[dígito]+
real          ([AuuAuAU])?[dígito]+\.[dígito]+

caractere     \'(letra|dígito)+\'

relacional    A((uA(u|U)A(u|U))|(UAuAu))

atribuicao    AuAuAu

se            AuuAUU
senao         AUUAuu
entrada       AuAuu
saida         AUAuu

logico        A((uUAU(u|U))|(UuAuU))

soma          AuuAuAu
sub           AuuAuAU
mult          AuuAUAu
div           AuuAUAU
mod           AuuAuuAu

while         AUUAUU

%%
***** Tokens *****



%%
***** Funções *****


