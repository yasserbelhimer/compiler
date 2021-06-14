flex .\lexical.l
bison -d syntax.y
gcc .\syntax.tab.c .\lex.yy.c -lfl -lm -o compiler