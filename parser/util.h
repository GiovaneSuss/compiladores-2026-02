#ifndef _UTIL_H_
#define _UTIL_H_

#include "globals.h"

TreeNode * newStmtNode(StmtKind kind);
TreeNode * newExpNode(ExpKind kind);
TreeNode * newDeclNode(DeclKind kind);

char * copyString(char * s);

void printTree(TreeNode * tree);

#endif