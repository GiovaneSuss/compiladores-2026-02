#include "util.h"

/* o YYSTYPE tem que ser definido ANTES de incluir o parser.tab.h,
   senao o header assume que o yylval e int */
#define YYSTYPE TreeNode *
#include "parser.tab.h"

extern int line;

void printToken( TokenType token, const char* tokenString )
{
    switch (token)
    {
        /* palavras reservadas */
        case ELSE:
        case IF:
        case INT:
        case RETURN:
        case VOID:
        case WHILE:
            printf("palavra reservada: %s\n", tokenString);
            break;

        /* operadores aritmeticos */
        case SOM: printf("+\n"); break;
        case SUB: printf("-\n"); break;
        case MUL: printf("*\n"); break;
        case DIV: printf("/\n"); break;

        /* operadores relacionais */
        case MEN_Q:    printf("<\n");  break;
        case MEN_IG_Q: printf("<=\n"); break;
        case MAI_Q:    printf(">\n");  break;
        case MAI_IG_Q: printf(">=\n"); break;
        case IGL:      printf("==\n"); break;
        case DIF:      printf("!=\n"); break;

        /* atribuicao e pontuacao */
        case ATR:     printf("=\n"); break;
        case PEV:     printf(";\n"); break;
        case VIR:     printf(",\n"); break;
        case PAR_ESQ: printf("(\n"); break;
        case PAR_DIR: printf(")\n"); break;
        case COL_ESQ: printf("[\n"); break;
        case COL_DIR: printf("]\n"); break;
        case CHV_ESQ: printf("{\n"); break;
        case CHV_DIR: printf("}\n"); break;

        /* marcadores */
        case NUM:
            printf("NUM, val= %s\n", tokenString);
            break;
        case ID:
            printf("ID, name= %s\n", tokenString);
            break;

        case 0: /* o Bison usa 0 como fim de arquivo */
            printf("EOF\n");
            break;

        default: /* nao deveria acontecer */
            printf("Token desconhecido: %d\n", token);
    }
}

TreeNode * newStmtNode(StmtKind kind)
{
    TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
    int i;
    if (t == NULL)
        printf("Erro de memoria na linha %d\n", line);
    else
    {
        for (i = 0; i < MAXCHILDREN; i++)
            t->child[i] = NULL;
        t->sibling = NULL;
        t->nodekind = StmtK;
        t->kind.stmt = kind;
        t->lineno = line;
    }
    return t;
}

TreeNode * newExpNode(ExpKind kind)
{
    TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
    int i;
    if (t == NULL)
        printf("Erro de memoria na linha %d\n", line);
    else
    {
        for (i = 0; i < MAXCHILDREN; i++)
            t->child[i] = NULL;
        t->sibling = NULL;
        t->nodekind = ExpK;
        t->kind.exp = kind;
        t->lineno = line;
        t->type = Void;
    }
    return t;
}

TreeNode * newDeclNode(DeclKind kind)
{
    TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
    int i;
    if (t == NULL)
        printf("Erro de memoria na linha %d\n", line);
    else
    {
        for (i = 0; i < MAXCHILDREN; i++)
            t->child[i] = NULL;
        t->sibling = NULL;
        t->nodekind = DeclK;
        t->kind.decl = kind;
        t->lineno = line;
        t->type = Void;
    }
    return t;
}

char * copyString(char * s)
{
    int n;
    char * t;
    if (s == NULL)
        return NULL;
    n = strlen(s) + 1;
    t = malloc(n);
    if (t == NULL)
        printf("Erro de memoria na linha %d\n", line);
    else
        strcpy(t, s);
    return t;
}

static int indentno = 0;

#define INDENT indentno += 2
#define UNINDENT indentno -= 2

static void printSpaces(void)
{
    int i;
    for (i = 0; i < indentno; i++)
        printf(" ");
}

void printTree(TreeNode * tree)
{
    int i;
    INDENT;
    while (tree != NULL)
    {
        printSpaces();
        if (tree->nodekind == StmtK)
        {
            switch (tree->kind.stmt)
            {
            case IfK:
                printf("If\n");
                break;
            case WhileK:
                printf("While\n");
                break;
            case ReturnK:
                printf("Return\n");
                break;
            case CompostoK:
                printf("Composto\n");
                break;
            default:
                printf("Tipo de nó desconhecido\n");
                break;
            }
        }
        else if (tree->nodekind == ExpK)
        {
            switch (tree->kind.exp)
            {
            case OpK:
                printf("Op: ");
                printToken(tree->attr.op, "\0");
                break;
            case ConstK:
                printf("Const: %d\n", tree->attr.val);
                break;
            case IdK:
                printf("Id: %s\n", tree->attr.name);
                break;
            case AtribK:
                printf("Atribuição\n");
                break;
            case AtivacaoK:
                printf("Ativação de função\n");
                break;
            default:
                printf("Tipo de nó desconhecido\n");
                break;
            }
        }
        else if (tree->nodekind == DeclK)
        {
            switch (tree->kind.decl)
            {
            case VarK:
                printf("Declaração de variável: %s\n", tree->attr.name);
                break;
            case VetorK:
                printf("Declaração de vetor: %s\n", tree->attr.name);
                break;
            case FunK:
                printf("Declaração de função: %s\n", tree->attr.name);
                break;
            case ParamK:
                printf("Declaração de parâmetro: %s\n", tree->attr.name);
                break;
            case ParamVetorK:
                printf("Declaração de parâmetro vetor: %s\n", tree->attr.name);
                break;
            default:
                printf("Tipo de nó desconhecido\n");
                break;
            }
        }
        else
            printf("Tipo de nó desconhecido\n");
        for (i = 0; i < MAXCHILDREN; i++)
            printTree(tree->child[i]);
        tree = tree->sibling;
    }
    UNINDENT;
}