# Compiler
## This is mini compiler using yacc and lex


### Setup
* gcc compiler
* flex library
* bison library

### Runing
* `bison -d syntax.y`
* `flex .\lexical.l`
* `gcc .\syntax.tab.c .\lex.yy.c -lfl -lm -o compiler`
* `./compiler`