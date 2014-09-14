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

//char string_buf_cmnt[256];
//char *string_buf_ptr_cmnt;
 int size = 0;
 int sizeOfDescription = 0;
 int num = 0;
 int commentfeeds = 0;
 char flag = 0;
 int flagcomment = 0;
%}
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


%x comment
%%

\n      return NEWLINE;
\-- 	{ 
			  string_buf_ptr = string_buf;
			  commentfeeds++;
			  BEGIN(comment);
	}
<comment>\--		{	
  if (commentfeeds > 3)
    {
      BEGIN(INITIAL);
    }
  else
    {
      commentfeeds++;
    }
 }
<comment>[ ]+		;
<comment>\*		;
<comment>\n		;
<comment>"@type"	;
<comment>[a-zA-Z0-9][-]?    {
					  char *yptr = yytext; 
					  int i = 0; 
					  while ( *yptr ){   
				          *string_buf_ptr++ = *yptr++;   
				          size++;   
					  }				       
 }

%%

int yywrap(void){
  return 1;
}




 


