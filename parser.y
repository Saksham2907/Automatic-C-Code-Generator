%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "runtime.h"

int yylex(void);
void yyerror(const char *s);

typedef struct Node { char *code; } Node;
static Node* mk(const char* fmt, ...) {
    va_list ap; va_start(ap, fmt);
    char buf[4096]; vsnprintf(buf, sizeof(buf), fmt, ap); va_end(ap);
    Node* n = malloc(sizeof(Node));
    n->code = strdup(buf);
    return n;
}

%}

%union {
    int num;
    char* id;
    struct Node* node;
}

%token SET PRINT ADD IF THEN ENDIF LOOP TIMES ENDLOOP
%token ASSIGN COMMA
%token GT LT GE LE EQ NE
%token <num> NUMBER
%token <id>  IDENT

%type <node> program stmt stmts expr cmp

%%

program:
    stmts     { printf("#include \"runtime.h\"\nint main(){\n%s\nreturn 0;}\n", $1->code); }
;

stmts:
      stmt                 { $$ = mk("%s", $1->code); }
    | stmts stmt           { $$ = mk("%s%s", $1->code, $2->code); }
;

stmt:
      SET IDENT ASSIGN expr        { $$ = mk("int %s = %s;\n", $2, $4->code); }
    | PRINT IDENT                  { $$ = mk("printf(\"%%d\\n\", %s);\n", $2); }
    | ADD IDENT COMMA IDENT        { $$ = mk("%s = %s + %s;\n", $2, $2, $4); }
    | IF cmp THEN stmts ENDIF      { $$ = mk("if(%s){\n%s}\n", $2->code, $4->code); }
    | LOOP NUMBER TIMES stmts ENDLOOP { $$ = mk("for(int __i=0; __i<%d; ++__i){\n%s}\n", $2, $4->code); }
;

expr:
      NUMBER               { $$ = mk("%d", $1); }
    | IDENT                { $$ = mk("%s", $1); }
;

cmp:
      IDENT GT NUMBER      { $$ = mk("%s > %d", $1, $3); }
    | IDENT LT NUMBER      { $$ = mk("%s < %d", $1, $3); }
    | IDENT GE NUMBER      { $$ = mk("%s >= %d", $1, $3); }
    | IDENT LE NUMBER      { $$ = mk("%s <= %d", $1, $3); }
    | IDENT EQ NUMBER      { $$ = mk("%s == %d", $1, $3); }
    | IDENT NE NUMBER      { $$ = mk("%s != %d", $1, $3); }
;

%%

void yyerror(const char *s){ fprintf(stderr, "Parse error: %s\n", s); }
