#ifndef _GLOBALS_H_
#define _GLOBALS_H_

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#define MAXCHILDREN 3

typedef int TokenType; 

typedef enum {StmtK,ExpK,DeclK} NodeKind;
typedef enum {IfK,WhileK,ReturnK,CompostoK} StmtKind;
typedef enum {OpK,ConstK,IdK,AtribK,AtivacaoK} ExpKind;
typedef enum {VarK,VetorK,FunK,ParamK,ParamVetorK} DeclKind;

typedef enum {Void,Integer,Boolean} ExpType;

typedef struct treeNode
    {
        struct treeNode * child[MAXCHILDREN];
        struct treeNode * sibling;
        int lineno;
        NodeKind nodekind;
        union { StmtKind stmt; ExpKind exp; DeclKind decl;} kind;
        union { TokenType op;
                int val;
                char * name; } attr;
        ExpType type; /* for type checking of exps */

    } TreeNode;

#endif