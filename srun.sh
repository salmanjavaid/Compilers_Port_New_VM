#!/bin/bash
if flex sample.lex; then
    if g++ -I/afs/ir/class/cs143/cool/include/PA2 -I/afs/ir/class/cs143/cool/src/PA2 lex.yy.c -lfl; then
	./a.out < input.txt
    fi
fi