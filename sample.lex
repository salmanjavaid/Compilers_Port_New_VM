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
%}

%x str
%x comment

%%

\-- {string_buf_ptr_cmnt = string_buf_cmnt; BEGIN(comment);}
<comment>\--	{BEGIN(INITIAL); return COMMENT;}
<comment>\.  {printf("\n");};


\"     { string_buf_ptr = string_buf; BEGIN(str);}
<str>\"        { /* saw closing quote - all done */
  BEGIN(INITIAL);
  *string_buf_ptr = '\0';
  /* return string constant token type and
   * value to parser
   */
  int i = 0;
  string_buf_ptr-=size;  
  for (; i < size; i++){    
    /* printf("%c", *(string_buf_ptr+i)); */
  }
  return ID;
 }
<str>\n        {
  /* error - unterminated string constant */
  /* generate error message */
  //printf("error is here\n"); 
 }

<str>\\0 	    /* printf("here\n") */;
<str>\[0-7]{1,3} {
  /* octal escape sequence */
  int result;

  (void) sscanf( yytext + 1, "%o", &result );
  if (result == 0x00){
     *string_buf_ptr++ = '0';
  } else {
    if ( result > 0xff ){
      /* error, constant is out-of-bounds */}
    else{*string_buf_ptr++ = result;}
  }
       size++;
 }
<str>\[0-9]+ {
  /* generate error - bad escape sequence; something
   * like '\48' or '\0777777'
   */

  printf("Error\n");
 }

<str>\\n  *string_buf_ptr++ = '\n';  size++;
<str>\\t  *string_buf_ptr++ = '\t';  size++;
<str>\\r  *string_buf_ptr++ = '\r';  size++;
<str>\\b  *string_buf_ptr++ = '\b';  size++;
<str>\\f  *string_buf_ptr++ = '\f';  size++;

<str>\\(.|\n)  *string_buf_ptr++ = yytext[1];  size++;  

<str>[^\\\n\"]+        {
  /* printf("Word:  %s\n",yytext); */
  char *yptr = yytext;

  int i = 0;
  while ( *yptr )
    {
      *string_buf_ptr++ = *yptr++;
      size++;
      i++;
    }
}

[ ]+  ;   //printf("space\n");
%%


main(int argc, char **argv) {
  int res;
  int i = 0;
  yyin = stdin;

  while(res = yylex()) {  
    i = 0;
    /* printf("class: %d lexeme: %c line: %d\n", res, *string_buf_ptr, num_lines);  */
    /* for (; i < 4; i++){ */
    /*   printf("%c",*string_buf_ptr++); */
    /* } */
    printf("class: %d line: %d\n", res, num_lines);
    printf("\n");
  }
}

 


