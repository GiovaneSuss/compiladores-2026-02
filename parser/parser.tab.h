/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

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
     ID = 258,
     NUM = 259,
     SOM = 260,
     SUB = 261,
     MUL = 262,
     DIV = 263,
     MEN_Q = 264,
     MEN_IG_Q = 265,
     MAI_Q = 266,
     MAI_IG_Q = 267,
     IGL = 268,
     DIF = 269,
     ATR = 270,
     PEV = 271,
     VIR = 272,
     PAR_ESQ = 273,
     PAR_DIR = 274,
     COL_ESQ = 275,
     COL_DIR = 276,
     CHV_ESQ = 277,
     CHV_DIR = 278,
     ELSE = 279,
     IF = 280,
     INT = 281,
     RETURN = 282,
     VOID = 283,
     WHILE = 284
   };
#endif
/* Tokens.  */
#define ID 258
#define NUM 259
#define SOM 260
#define SUB 261
#define MUL 262
#define DIV 263
#define MEN_Q 264
#define MEN_IG_Q 265
#define MAI_Q 266
#define MAI_IG_Q 267
#define IGL 268
#define DIF 269
#define ATR 270
#define PEV 271
#define VIR 272
#define PAR_ESQ 273
#define PAR_DIR 274
#define COL_ESQ 275
#define COL_DIR 276
#define CHV_ESQ 277
#define CHV_DIR 278
#define ELSE 279
#define IF 280
#define INT 281
#define RETURN 282
#define VOID 283
#define WHILE 284




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

