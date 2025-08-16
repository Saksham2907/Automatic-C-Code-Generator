CC=gcc
LEX=flex
YACC=bison
CFLAGS=-O2 -Wall

all: codegen

codegen: parser.tab.c lex.yy.c main.o
	$(CC) $(CFLAGS) -o codegen parser.tab.c lex.yy.c main.o

parser.tab.c: parser.y
	$(YACC) -d -o parser.tab.c parser.y

lex.yy.c: lexer.l
	$(LEX) -o lex.yy.c lexer.l

main.o: main.c runtime.h
	$(CC) $(CFLAGS) -c main.c

clean:
	rm -f codegen parser.tab.c parser.tab.h lex.yy.c *.o out.c program
