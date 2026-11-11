%{
#include <stdio.h>
#include <stdlib.h>

#include "util.h"

int yylex(void);
void yyerror(const char *s);

extern FILE *yyin;
extern int line;
extern char *yytext;

int erros_lexicos=0;
int erros_sintaticos=0;

#define YYSTYPE TreeNode *
static TreeNode * finalTree;
%}

%token ID NUM
%token SOM SUB MUL DIV MEN_Q MEN_IG_Q MAI_Q MAI_IG_Q IGL DIF ATR
%token PEV VIR PAR_ESQ PAR_DIR COL_ESQ COL_DIR CHV_ESQ CHV_DIR
%token ELSE IF INT RETURN VOID WHILE

%start programa

%%

programa           : declaracao_lista
                   ;

declaracao_lista   : declaracao_lista declaracao
                   | declaracao
                   ;

declaracao         : var_declaracao
                   | fun_declaracao
                   ;

var_declaracao     : tipo_especificador ID PEV
                   | tipo_especificador ID COL_ESQ NUM COL_DIR PEV
                   ;

tipo_especificador : INT
                   | VOID
                   ;

fun_declaracao    : tipo_especificador ID PAR_ESQ params PAR_DIR composto_decl
                   ;

params             : param_lista
                   | VOID
                   ;

param_lista       : param_lista VIR param
                   | param
                   ;

param              : tipo_especificador ID
                   | tipo_especificador ID COL_ESQ COL_DIR
                   ;

composto_decl      : CHV_ESQ local_declaracoes statement_lista CHV_DIR
                   ;

local_declaracoes  : local_declaracoes var_declaracao
                   |
                   ;

statement_lista    : statement_lista statement
                   | /* vazio */
                   ;

statement          : stmt_fechado
                   | stmt_aberto
                   ;

expressao_decl     : expressao PEV
                   | PEV
                   ;

stmt_fechado       : expressao_decl
                   | composto_decl
                   | retorno_decl
                   | IF PAR_ESQ expressao PAR_DIR stmt_fechado ELSE stmt_fechado
                   | WHILE PAR_ESQ expressao PAR_DIR stmt_fechado
                   ;

stmt_aberto        : IF PAR_ESQ expressao PAR_DIR statement
                   | IF PAR_ESQ expressao PAR_DIR stmt_fechado ELSE stmt_aberto
                   | WHILE PAR_ESQ expressao PAR_DIR stmt_aberto
                   ;

retorno_decl       : RETURN PEV
                   | RETURN expressao PEV
                   ;

expressao          : var ATR expressao
                   | simples_expressao
                   ;

var                : ID
                   | ID COL_ESQ expressao COL_DIR
                   ;

simples_expressao  : soma_expressao relacional soma_expressao
                   | soma_expressao
                   ;

relacional         : MEN_IG_Q
                   | MEN_Q
                   | MAI_Q
                   | MAI_IG_Q
                   | IGL
                   | DIF
                   ;

soma_expressao     : soma_expressao soma termo
                   | termo
                   ;

soma               : SOM
                   | SUB
                   ;

termo              : termo mult fator
                   | fator
                   ;

mult               : MUL
                   | DIV
                   ;

fator              : PAR_ESQ expressao PAR_DIR
                   | var
                   | ativacao
                   | NUM
                   ;

ativacao           : ID PAR_ESQ args PAR_DIR
                   ;

args               : arg_lista
                   |
                   ;

arg_lista          : arg_lista VIR expressao
                   | expressao
                   ;

%%

void yyerror(const char *s){
  printf("ERRO SINTÁTICO: '%s' LINHA: %d\n", yytext, line);
  erros_sintaticos++;
}

int main(int argc, char *argv[]){
  FILE *f_in;

  if (argc == 2){
    if (f_in = fopen(argv[1], "r"))  yyin = f_in;
    else { perror(argv[0]); return 1; }
  }else{
    yyin = stdin;
  }

  if (yyparse() == 0 && erros_lexicos == 0 && erros_sintaticos == 0) {
    printf("Analise sintatica concluida com sucesso.\n");
    printTree(finalTree);
  } else {
    printf("Analise sintatica finalizou com %d erros lexicos e %d erros sintaticos.\n",erros_lexicos, erros_sintaticos);
  }

  return 0;
}