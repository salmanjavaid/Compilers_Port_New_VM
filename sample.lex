/* sample simple scanner 
*/
%{
int num_lines = 0;

#define CLASS 10
#define LAMBDA 1
#define DOT    2
#define PLUS   3
#define OPEN   4
#define CLOSE  5
#define NUM    6
#define ID     7
#define INVALID 8
#define MAX_STR_CONST 256;
#define COMMENT 11;

char string_buf[256];
char *string_buf_ptr;

char string_buf_cmnt[256];
char *string_buf_ptr_cmnt;
 int size = 0;
 int num = 0;
 int commentfeeds = 0;
 char flag = 0;
%}

%x comment
%x readcomment
%%

"class"   return ID;
\-- { if (flag == 0){string_buf_ptr_cmnt = string_buf_cmnt;} BEGIN(comment);}
<comment>\--	{
  if (commentfeeds < 4){
    int i = 0; BEGIN(INITIAL); 
    *string_buf_ptr_cmnt = '\0'; 
    string_buf_ptr_cmnt-=18; 

    while(i < size){ 
         printf("%c", *(string_buf_ptr_cmnt+i)); 
      i++; 
    } 
    return COMMENT;
  }
  else {
    commentfeeds++;
  }
 }
<comment>[ ]+   ;
<comment>\n	;
<comment>"@start"   {BEGIN(readcomment);}
<readcomment>\n     {*string_buf_ptr_cmnt++ = '\n';size++;}
<readcomment>[a-zA-Z0-9]  {
  char *yptr = yytext;
  int i = 0;
  // printf("%s\n", yytext); 
  while ( *yptr ){  
        *string_buf_ptr_cmnt++ = *yptr++;  
        size++;  
        i++;  
  }  
}
<readcomment>"@end" {BEGIN(comment); flag = 1;}

%%

int yywrap(void){
  return 1;
}


 /*  main(int argc, char **argv) {  */
 /*   int res;  */
 /*   int i = 0;  */
 /*   yyin = stdin;  */
 /*   while(res = yylex()) {    */
 /*     i = 0;  */
 /*     printf("class: %d line: %d\n", res, num_lines);  */
 /*     printf("\n");  */
 /*   }  */
 /* } */

 


