#!/bin/bash
if flex samplelextest.lex; then
    if g++ -w lex.yy.c samplescanner.cpp -o a; then
	./a < input3.txt
    fi
fi