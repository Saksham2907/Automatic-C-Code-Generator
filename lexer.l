%option noyywrap
%x IFBLK LOOPBLK

%%

[ \t\r\n]+           ;
"SET"                return SET;
"PRINT"              return PRINT;
"ADD"                return ADD;
"IF"                 return IF;
"THEN"               return THEN;
"ENDIF"              return ENDIF;
"LOOP"               return LOOP;
"TIMES"              return TIMES;
"ENDLOOP"            return ENDLOOP;

[0-9]+               { yylval.num = atoi(yytext); return NUMBER; }
[A-Za-z_][A-Za-z0-9_]* { yylval.id = strdup(yytext); return IDENT; }

"="                  return ASSIGN;
","                  return COMMA;
">"                  return GT;
"<"                  return LT;
">="                 return GE;
"<="                 return LE;
"=="                 return EQ;
"!="                 return NE;

.                    ;   /* ignore unknown */

%%
