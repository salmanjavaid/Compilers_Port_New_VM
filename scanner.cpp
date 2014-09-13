#include "cool-parse.h"
#include <stdio.h>
#include "utilities.h"

extern int yylex();
extern char* yytext;
extern int num_lines;
YYSTYPE cool_yylval;

char *Database[] = {"CLASS", "INHERITS"};
int main(){
  int ntoken;
  ntoken = yylex();
  while(ntoken){   
    if (ntoken !=32){
      printf("%s:%s\n", yytext, cool_token_to_string(ntoken));
    }
    ntoken = yylex();
  }
  return 1;
}
