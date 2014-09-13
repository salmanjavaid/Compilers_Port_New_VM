#!/bin/bash
if flex sample.lex; then
    if g++ lex.yy.c samplescanner.cpp -o a; then
	./a < input.txt
    fi
fi