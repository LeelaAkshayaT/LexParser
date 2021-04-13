# LexParser

To run Lex file

place basic.l and input.c file in same folder and excute these commands


flex basic_lex.lex

gcc lex.yy.c

./a.out input.c


Tokens are generated in out.txt file

Parser

lex lexer.l

yacc -d parser.y

gcc lex.yy.c y.tab.c

./a.out input.c


This parser works for 'if' 'else' and 'for' grammar
