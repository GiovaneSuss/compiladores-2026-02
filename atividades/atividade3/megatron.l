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

int token;
int erro;
void exp(); void soma(); void termo(); void mult(); void fator();

void mult() {
  if (token==MUL || token==DIV) {
    token=yylex();
  } else {
    erro=1;
  }
}

void soma() {
  if (token==SOM || token==SUB) {
    token=yylex();
  } else {
    erro=1;
  }
}

void exp() {
  termo(token);
  while (token==SOM || token==SUB) {
    soma(token);
    termo(token);
  }
}

void fator() {
  if (token==PAR_ESQ) {
    token=yylex();
    exp(token);
    if (token==PAR_DIR) {
      token=yylex();
    } else {
      erro=1;
    }
  } else if (token==NUM) {
    token=yylex();
  } else {
    erro=1;
  }
}

void termo() {
  fator(token);
  while (token==MUL || token==DIV) {
    mult(token);
    fator(token);
  }
}


int main(int argc, char *argv[])
{
  FILE *f_in;

  if (argc == 2)
  {
    if(f_in = fopen(argv[1],"r"))  yyin = f_in;
    else  perror(argv[0]);
  }
  else  yyin = stdin;
  
  token=yylex();
  erro=0;
  int linha = 1;

  while (1) {
    if (token==FIM) break;
    if (token==QBR_LIN) {
      linha++;
      token=yylex();
      continue;
    }
    erro=0;
    exp();
    if (erro==1 || (token != QBR_LIN && token != FIM)) {
      printf("Erro Sintático na linha %d\n",linha);
      while (token!= QBR_LIN && token != FIM) token=yylex();
    }
  }

  return(0);
}

