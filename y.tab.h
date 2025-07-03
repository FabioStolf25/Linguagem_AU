
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     BEGINPROGRAMA = 258,
     ENDPROGRAMA = 259,
     PONTOVIRGULA = 260,
     INICIOBLOCO = 261,
     FIMBLOCO = 262,
     REPETICAO = 263,
     SE = 264,
     SENAO = 265,
     ENTRADA = 266,
     SAIDA = 267,
     DOISPONTOS = 268,
     IGUAL = 269,
     MENOR = 270,
     MAIOR = 271,
     MENOR_IGUAL = 272,
     MAIOR_IGUAL = 273,
     OU = 274,
     NAO = 275,
     E = 276,
     ATRIBUICAO = 277,
     SOMA = 278,
     SUB = 279,
     MULT = 280,
     DIV = 281,
     MOD = 282,
     TIPO_INT = 283,
     TIPO_REAL = 284,
     TIPO_CHAR = 285,
     INTEIRO = 286,
     REAL = 287,
     CARACTERE = 288,
     VARIAVEL = 289,
     UNEGATIVO = 290
   };
#endif
/* Tokens.  */
#define BEGINPROGRAMA 258
#define ENDPROGRAMA 259
#define PONTOVIRGULA 260
#define INICIOBLOCO 261
#define FIMBLOCO 262
#define REPETICAO 263
#define SE 264
#define SENAO 265
#define ENTRADA 266
#define SAIDA 267
#define DOISPONTOS 268
#define IGUAL 269
#define MENOR 270
#define MAIOR 271
#define MENOR_IGUAL 272
#define MAIOR_IGUAL 273
#define OU 274
#define NAO 275
#define E 276
#define ATRIBUICAO 277
#define SOMA 278
#define SUB 279
#define MULT 280
#define DIV 281
#define MOD 282
#define TIPO_INT 283
#define TIPO_REAL 284
#define TIPO_CHAR 285
#define INTEIRO 286
#define REAL 287
#define CARACTERE 288
#define VARIAVEL 289
#define UNEGATIVO 290




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 41 "au.y"

    struct No* no_ptr;



/* Line 1676 of yacc.c  */
#line 128 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


