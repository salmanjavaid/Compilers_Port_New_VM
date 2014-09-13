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
#define NEWLINE 13;

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

/*
 * The logic is once you find --, you start comment state machine
 * and keep on updating the commentfeeds variable which counts the
 * number of --. Once you encounter @start, you start a new state machine
 * readcomment, which looks for alpha-numeric characters, and space
 * while storing them in string_buf_ptr_cmnt. You also keep the size of string
 * in size variable. Once you encounter @end, you move back to comment state
 * machine and start it again while updating commentfeeds. Once you encounter
 * more than 4 commentfeeds, you terminate the comment state machine and print
 * the result. flag variable is used to make sure that when we enter the comment
 * state machine second time, we don't reassign string_buf_ptr_cmnt to
 * string_buf_cmnt.
*/


"class"   return ID;
\n        return NEWLINE;
\-- { if (flag == 0){ string_buf_ptr_cmnt = string_buf_cmnt;} BEGIN(comment);commentfeeds++;}
<comment>\--	{
  if (commentfeeds > 3){
    int i = 0;
    BEGIN(INITIAL); 
    *string_buf_ptr_cmnt = '\0'; 
    string_buf_ptr_cmnt-=size; 

    while(i < size){ 
         printf("%c", *(string_buf_ptr_cmnt+i)); 
      i++; 
    } 
    commentfeeds = 0; size = 0; string_buf_ptr_cmnt-=size;
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

  while ( *yptr ){  
        *string_buf_ptr_cmnt++ = *yptr++;  
        size++;  
        i++;  
  }  
}
<readcomment>"@end" {BEGIN(comment); flag = 1; commentfeeds++;}

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

 


