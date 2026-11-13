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
                        { savedTree = $1;}
                   ;

declaracao_lista   : declaracao_lista declaracao
                        { TreeNode * t = $1;
                          if (t != NULL) {
                              while (t->sibling != NULL) t = t->sibling;
                              t->sibling = $2;
                              $$ = $1;
                          }
                          else
                              $$ = $2;
                        }
                   | declaracao
                        { $$ = $1; }
                   ;

declaracao         : var_declaracao
                        { $$ = $1; }
                   | fun_declaracao
                        { $$ = $1; }
                   ;

var_declaracao     : tipo_especificador ID PEV
                        { $$ = newDeclNode(VarK);
                          $$->type = $1->type;
                          $$->attr.name = $2->attr.name;
                        }
                   | tipo_especificador ID COL_ESQ NUM COL_DIR PEV
                        { $$ = newDeclNode(VetorK);
                          $$->type = $1->type;
                          $$->attr.name = $2->attr.name;
                          $$->child[0] = $4;
                        }
                   ;

tipo_especificador : INT
                        { $$ = newDeclNode(VarK);
                          $$->type = Integer; }
                   | VOID
                        { $$ = newDeclNode(VarK);
                          $$->type = Void;}
                   ;

fun_declaracao    : tipo_especificador ID PAR_ESQ params PAR_DIR composto_decl
                        { $$ = newDeclNode(FunK);
                          $$->type = $1->type;
                          $$->attr.name = $2->attr.name;
                          $$->child[0] = $4;
                          $$->child[1] = $6;
                        }
                   ;

params             : param_lista
                        { $$ = $1; }
                   | VOID
                        { $$ = NULL; }
                   ;

param_lista        : param_lista VIR param
                        { TreeNode * t = $1;
                          if (t != NULL) {
                              while (t->sibling != NULL) t = t->sibling;
                              t->sibling = $3;
                              $$ = $1;
                          }
                          else
                              $$ = $3;
                        }
                   | param
                        { $$ = $1;}
                   ;

param              : tipo_especificador ID
                        { $$ = newDeclNode(ParamK);
                          $$->type = $1->type;
                          $$->attr.name = $2->attr.name;
                        }
                   | tipo_especificador ID COL_ESQ COL_DIR
                        { $$ = newDeclNode(ParamVetorK);
                          $$->type = $1->type;
                          $$->attr.name = $2->attr.name;
                        }
                   ;

composto_decl      : CHV_ESQ local_declaracoes statement_lista CHV_DIR
                        { $$ = newStmtNode(CompostoK);
                          $$->child[0] = $2;
                          $$->child[1] = $3;
                        }
                   ;

local_declaracoes  : local_declaracoes var_declaracao
                        { TreeNode * t = $1;
                          if (t != NULL) {
                            while (t->sibling != NULL) t = t->sibling;
                            t->sibling = $2;
                            $$ = $1;
                          }
                          else
                              $$ = $2;
                        }
                   |    
                        { $$ = NULL; }
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