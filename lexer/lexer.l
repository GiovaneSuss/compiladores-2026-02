%{
#include <stdlib.h>
#include <stdio.h>

#define ID  300
#define NUM 301

#define SOM 302
#define SUB 303
#define MUL 304
#define DIV 305
#define MEN_Q 306
#define MEN_IG_Q 307
#define MAI_Q 308
#define MAI_IG_Q 309
#define IGL 310
#define DIF 311
#define ATR 312
#define PEV 313
#define VIR 314
#define PAR_ESQ 315
#define PAR_DIR 316
#define COL_ESQ 317
#define COL_DIR 318
#define CHV_ESQ 319
#define CHV_DIR 320

#define FIM 323
#define ERR 324

#define ELSE 325
#define IF 326
#define INT 327
#define RETURN 328
#define VOID 329
#define WHILE 330

#define QBR_LIN 331

int line = 1;
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

{LETRA}{LETRA}*	            return ID;
{DIGITO}{DIGITO}*			return NUM;

"/*"([^*]|\*+[^*/])*\*+"/"   { int i; for (i = 0; yytext[i]; i++) if (yytext[i] == '\n') line++; }
"/*"([^*]|\*+[^*/])*         { printf("ERRO lexico na linha %d: comentario nao fechado\n", line); }


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
\n              return QBR_LIN;
[ \t\r]+        /* ignora espacos e tabs */

<<EOF>>         return FIM;
.           return ERR;
%%

int main(int argc, char *argv[])
{
  int token;
  FILE *f_in;

  if (argc == 2)
  {
    if(f_in = fopen(argv[1],"r"))  yyin = f_in;
    else  perror(argv[0]);
  }
  else  yyin = stdin;
  while ((token=yylex())!=FIM)
  {
    switch(token)
    {
      case QBR_LIN:   line++;    break;

      case ERR:       printf("ERRO lexico na linha %d: caractere invalido '%s'\n", line, yytext);    break;

      default:        break;
    }
  }
  return(0);
}

