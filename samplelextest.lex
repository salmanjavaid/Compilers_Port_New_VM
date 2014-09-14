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

char string_buf_dscp[256];
char *string_buf_dscp_ptr;
 int size = 0;
 int sizeOfTitle = 0;
 int sizeOfDescription = 0;
 int num = 0;
 int commentfeeds = 0;
 int flagTitle = 0;
 int flagComment = 0;
 int flagEnd = 0;
 int flagSwitch = 0;
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
%x Description
%%

\n      return NEWLINE;
\-- 	{ 
			  string_buf_ptr = string_buf;
			  string_buf_dscp_ptr = string_buf_dscp;
			  commentfeeds++;
			  BEGIN(comment);
	}
<comment>\--		{	
  			  if (flagTitle == 0 && flagComment == 1) {
			    if (flagSwitch == 0) {
					int i = 0;
       					*string_buf_ptr = '\0'; 
					string_buf_ptr-=sizeOfTitle;	    
					while(i < sizeOfTitle) { 
					  printf("%c", *(string_buf_ptr+i)); 
					  i++; 
					  }
					printf("\n");
					flagSwitch = 1;
			    }
			  }
			  else if (flagComment == 0 && flagEnd == 1) {
				    if (flagEnd == 1) {
					int i = 0;
       					*string_buf_dscp_ptr = '\0'; 
					string_buf_dscp_ptr-=sizeOfDescription;
					while(i < sizeOfDescription) { 
					  printf("%c", *(string_buf_dscp_ptr+i)); 
					  i++; 
				        }
       				    } 
			  }
			  commentfeeds++;
 }
<comment>[ ]+		;
<comment>\*		;
<comment>\n		{
  				if (flagTitle == 1) {
				    *string_buf_ptr++ = '\n';   
	   			    sizeOfTitle++;   
				}				
				else if (flagComment == 1) {
				    *string_buf_dscp_ptr++ = '\n';   		  
				    sizeOfDescription++;   
			       	}
 			}
<comment>"@type"	flagTitle = 1;
<comment>"@start"	flagTitle = 0; flagComment = 1;
<comment>"@end"         flagComment = 0; flagEnd = 1;
<comment>[a-zA-Z0-9][-]?[ ]?    {
  					if (flagTitle == 1) {
				  	  char *yptr = yytext; 
					  int i = 0; 
					  while ( *yptr ) {   
					  *string_buf_ptr++ = *yptr++;   
					  sizeOfTitle++;   
					  }				       
					}
					else if (flagComment == 1) {
				  	  char *yptr = yytext; 
					  int i = 0; 
					  while ( *yptr ) {   
					    *string_buf_dscp_ptr++ = *yptr++;   			                       sizeOfDescription++;   
					  }				        
					}
					else {  }
    }
%%

int yywrap(void){
  return 1;
}




 


