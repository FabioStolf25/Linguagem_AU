CC       = gcc
CFLAGS   = -Wall
LIBS     = -lm
FLEX     = flex
BISON    = bison

TARGET   = au_compiler

LEX_SRC  = au.l
YACC_SRC = au.y

LEX_C    = lex.yy.c
YACC_C   = au.tab.c
YACC_H   = au.tab.h

EXDIR    = exemplos
EXEMPLOS = $(EXDIR)/exemplo.txt $(EXDIR)/exemplo2.txt $(EXDIR)/exemplo3.txt

.PHONY: all run run1 run2 run3 clean

all: $(TARGET)

$(TARGET): $(LEX_C) $(YACC_C)
	$(CC) $(CFLAGS) -o $(TARGET) $(LEX_C) $(YACC_C) $(LIBS)

$(YACC_C) $(YACC_H): $(YACC_SRC)
	$(BISON) -d $(YACC_SRC)

$(LEX_C): $(LEX_SRC) $(YACC_H)
	$(FLEX) $(LEX_SRC)

# `make run` pede para escolher um dos exemplos interativamente.
# Para rodar direto sem prompt: `make run1`, `make run2` ou `make run3`.
run: $(TARGET)
	@echo "Selecione um exemplo para executar:"
	@echo "  1) $(EXDIR)/exemplo.txt  (condicional e repeticao)"
	@echo "  2) $(EXDIR)/exemplo2.txt (entrada e saida)"
	@echo "  3) $(EXDIR)/exemplo3.txt (fibonacci)"
	@read -p "Opcao [1-3]: " opt; \
	case $$opt in \
		1) ./$(TARGET) $(EXDIR)/exemplo.txt ;; \
		2) ./$(TARGET) $(EXDIR)/exemplo2.txt ;; \
		3) ./$(TARGET) $(EXDIR)/exemplo3.txt ;; \
		*) echo "Opcao invalida"; exit 1 ;; \
	esac

run1: $(TARGET)
	./$(TARGET) $(EXDIR)/exemplo.txt

run2: $(TARGET)
	./$(TARGET) $(EXDIR)/exemplo2.txt

run3: $(TARGET)
	./$(TARGET) $(EXDIR)/exemplo3.txt

clean:
	rm -f $(TARGET) $(TARGET).exe $(LEX_C) $(YACC_C) $(YACC_H) tokens.txt
