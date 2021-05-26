flex lexical.l
bison -d syntax.y
gcc syntax.tab.c lex.yy.c -lfl -ly -o test 
test.exe