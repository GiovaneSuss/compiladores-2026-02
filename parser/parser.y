%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);

extern FILE *yyin;
extern int line;
extern char *yytext;
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

fun_declaracao.    : tipo_especificador ID PAR_ESQ params PAR_DIR composto_decl
                   ;

params             : param_lista
                   | VOID
                   ;

param_lista.       : param_lista VIR param
                   | param
                   ;

param              : tipo_especificador ID
                   | tipo_especificador ID COL_ESQ COL_DIR
                   ;

composto_decl      : CHV_ESQ local_declaracoes statement_lista CHV_DIR
                   ;

