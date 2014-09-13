#include <stdio.h>


extern int yylex();
extern char* yytext;
extern int num_lines;


char *Database[] = {"CLASS", "INHERITS"};
int main(){
  int ntoken;
  ntoken = yylex();
  while(ntoken){   
    if (ntoken !=32){
      //printf("%s: %d\n", yytext, ntoken);
    }
    ntoken = yylex();
  }
  return 1;
}
