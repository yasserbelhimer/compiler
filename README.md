# Compiler
## This is mini compiler using yacc and lex


### Setup
* gcc compiler
* flex library
* bison library

### Runing
* `flex .\lexical.l`
* `bison -d syntax.y`
* `gcc .\syntax.tab.c .\lex.yy.c -lfl -lm -o compiler`
* `./compiler`