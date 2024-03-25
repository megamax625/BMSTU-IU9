#!/bin/bash

flex lexer.l
bison -d --debug -t -v parser.y
g++ -o test lex.yy.c parser.tab.c
