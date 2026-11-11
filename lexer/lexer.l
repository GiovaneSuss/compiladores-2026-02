%{
#include <stdlib.h>
#include <stdio.h>
#include "util.h"
#define YYSTYPE TreeNode *
#include "parser.tab.h"

int line = 1;

extern int erros_lexicos;
%}

DIGITO [0-9]
LETRA [a-zA-Z]

%%
"else"          return ELSE;
"if"            return IF;
"int"           return INT;
"return"        return RETURN;
"void"          return VOID;
"while"         return WHILE;

{LETRA}{LETRA}*	            { yylval = newExpNode(IdK);
                              yylval->attr.name = copyString(yytext);
                              return ID; }
{DIGITO}{DIGITO}*			{ yylval = newExpNode(ConstK);
                              yylval->attr.val = atoi(yytext);
                              return NUM; }

"/*"([^*]|\*+[^*/])*\*+"/"   { int i; for (i = 0; yytext[i]; i++) if (yytext[i] == '\n') line++; }
"/*"([^*]|\*+[^*/])*         { int i; printf("ERRO LÉXICO: comentário não fechado LINHA: %d\n", line); erros_lexicos++;
                               for (i = 0; yytext[i]; i++) if (yytext[i] == '\n') line++; }


"+"				return SOM;
"-"				return SUB;
"*"				return MUL;
"/"				return DIV;
"<"				return MEN_Q;
"<="            return MEN_IG_Q;
">"             return MAI_Q;
">="            return MAI_IG_Q;
"=="            return IGL;
"!="            return DIF;
"="             return ATR;
;   			return PEV;
","             return VIR;
"("				return PAR_ESQ;
")"				return PAR_DIR;
"["				return COL_ESQ;
"]"				return COL_DIR;
"{"				return CHV_ESQ;
"}"				return CHV_DIR;
\n              { line++; };
[ \t\r]+        /* ignora espacos e tabs */

.           { printf("ERRO LÉXICO: caractere inválido '%s' LINHA: %d\n", yytext, line); erros_lexicos++;};

%%

int yywrap(void) { return 1; }