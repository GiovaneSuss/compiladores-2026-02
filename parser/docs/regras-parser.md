# Gramática do C- (Louden, Apêndice A.2)

As 29 regras do PDF do projeto, reescritas com os tokens do `lexer.l` / `parser.y`.

- **MAIÚSCULO** = token (terminal), vem do lexer
- **minúsculo** = não-terminal (regra da gramática)
- **ε** = vazio

## Tokens usados

| Token | Lexema | Token | Lexema |
|---|---|---|---|
| `ID` | identificador | `NUM` | número |
| `ELSE` | `else` | `IF` | `if` |
| `INT` | `int` | `RETURN` | `return` |
| `VOID` | `void` | `WHILE` | `while` |
| `SOM` | `+` | `SUB` | `-` |
| `MUL` | `*` | `DIV` | `/` |
| `MEN_Q` | `<` | `MEN_IG_Q` | `<=` |
| `MAI_Q` | `>` | `MAI_IG_Q` | `>=` |
| `IGL` | `==` | `DIF` | `!=` |
| `ATR` | `=` | `PEV` | `;` |
| `VIR` | `,` | | |
| `PAR_ESQ` | `(` | `PAR_DIR` | `)` |
| `COL_ESQ` | `[` | `COL_DIR` | `]` |
| `CHV_ESQ` | `{` | `CHV_DIR` | `}` |

## Regras

```
 1. programa           → declaracao_lista

 2. declaracao_lista   → declaracao_lista declaracao
                       | declaracao

 3. declaracao         → var_declaracao
                       | fun_declaracao

 4. var_declaracao     → tipo_especificador ID PEV
                       | tipo_especificador ID COL_ESQ NUM COL_DIR PEV

 5. tipo_especificador → INT
                       | VOID

 6. fun_declaracao     → tipo_especificador ID PAR_ESQ params PAR_DIR composto_decl

 7. params             → param_lista
                       | VOID

 8. param_lista        → param_lista VIR param
                       | param

 9. param              → tipo_especificador ID
                       | tipo_especificador ID COL_ESQ COL_DIR

10. composto_decl      → CHV_ESQ local_declaracoes statement_lista CHV_DIR

11. local_declaracoes  → local_declaracoes var_declaracao
                       | ε

12. statement_lista    → statement_lista statement
                       | ε

13. statement          → stmt_fechado
                       | stmt_aberto

14. expressao_decl     → expressao PEV
                       | PEV

15. stmt_fechado       → expressao_decl
                       | composto_decl
                       | retorno_decl
                       | IF PAR_ESQ expressao PAR_DIR stmt_fechado ELSE stmt_fechado
                       | WHILE PAR_ESQ expressao PAR_DIR stmt_fechado

16. stmt_aberto        → IF PAR_ESQ expressao PAR_DIR statement
                       | IF PAR_ESQ expressao PAR_DIR stmt_fechado ELSE stmt_aberto
                       | WHILE PAR_ESQ expressao PAR_DIR stmt_aberto

17. retorno_decl       → RETURN PEV
                       | RETURN expressao PEV

18. expressao          → var ATR expressao
                       | simples_expressao

19. var                → ID
                       | ID COL_ESQ expressao COL_DIR

20. simples_expressao  → soma_expressao relacional soma_expressao
                       | soma_expressao

21. relacional         → MEN_IG_Q | MEN_Q | MAI_Q | MAI_IG_Q | IGL | DIF

22. soma_expressao     → soma_expressao soma termo
                       | termo

23. soma               → SOM | SUB

24. termo              → termo mult fator
                       | fator

25. mult               → MUL | DIV

26. fator              → PAR_ESQ expressao PAR_DIR
                       | var
                       | ativacao
                       | NUM

27. ativacao           → ID PAR_ESQ args PAR_DIR

28. args               → arg_lista
                       | ε

29. arg_lista          → arg_lista VIR expressao
                       | expressao
```
