%{
  #include "cool-parse.h"

  #include "utilities.h"


  int num_lines = 0;
  char string_buf[256];
  char *string_buf_ptr;
  int size = 0;

%}
%x str


%%





"class"	        {cool_yylval.symbol = idtable.add_string(strdup(yytext));
   		  return CLASS;}
"else"		{cool_yylval.symbol = idtable.add_string(strdup(yytext));
		  return ELSE;}
"fi"		{cool_yylval.symbol = idtable.add_string(strdup(yytext));
		  return FI;}
"if"		{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  		  return IF;}
"inherits"	{cool_yylval.symbol = idtable.add_string(strdup(yytext));
		  return INHERITS;}
"let"		{cool_yylval.symbol = idtable.add_string(strdup(yytext));
		  return LET;}
"loop"		{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return LOOP;}
"pool"		{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return POOL;}
"then"		{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return THEN;}
"while"		{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return WHILE;}
"case"		{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return CASE;}
"esac"		{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return ESAC;}
"of"		{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return OF;}
"<-"	{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return DARROW;}
"new"		{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return NEW;}
"isvoid"	{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return ISVOID;}
"assign"	{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return ASSIGN;}
"not"		{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return NOT;}
"{"             {cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return 123;}
"}"             {cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return 125;}
"("             {cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return 40;}
")"             {cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return 41;}
"in"		{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return IN;}
[ \t]+            ;

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
    yytext[i]=*(string_buf_ptr + i);
  }
  yytext[i]='\0';
  cool_yylval.symbol = stringtable.add_string(strdup(yytext));
  return STR_CONST;
 }

<str>\n        {
  /* error - unterminated string constant */
  /* generate error message */
  cool_yylval.error_msg = "Unterminated string constant";
  return ERROR;
 }
<str>\\[0-7]{1,3} {
  /* octal escape sequence */
  int result;
  (void) sscanf( yytext + 1, "%o", &result );
  if (result == 0x00){
     *string_buf_ptr++ = '0';
  } else {
	    if ( result > 0xff )
	      /* error, constant is out-of-bounds */

	      *string_buf_ptr++ = result;
  }
       size++;
 }

<str>\\[0-9]+ {
  /* generate error - bad escape sequence; something
   * like '\48' or '\0777777'
   */
 
 }
<str>\\n  *string_buf_ptr++ = '\n';  size++;
<str>\\t  *string_buf_ptr++ = '\t';  size++;
<str>\\r  *string_buf_ptr++ = '\r';  size++;
<str>\\b  *string_buf_ptr++ = '\b';  size++;
<str>\\f  *string_buf_ptr++ = '\f';  size++;
<str>\\a  *string_buf_ptr++ = '\a';  size++;
<str>\\(.|\n)  *string_buf_ptr++ = yytext[1];  size++;
<str>[^\\\n\"]+        {
  char *yptr = yytext;

  int i = 0;
  while ( *yptr )
    {
      *string_buf_ptr++ = *yptr++;
      yytext[i] = *(string_buf_ptr-1);
      size++;
      i++;
    }
  
 }
"SELF_TYPE"  		{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return TYPEID;}
"main" 			{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return OBJECTID;}
[A-Z][a-zA-Z0-9_]*	{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return TYPEID;}
[a-z][a-zA-Z0-9_]*      {cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return OBJECTID;}
";"             	{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return 59;}
[0-9]+			{cool_yylval.symbol = inttable.add_string(strdup(yytext));
  return INT_CONST;}
":"			{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return 58;}
"."			{cool_yylval.symbol = idtable.add_string(strdup(yytext));
  return 46;}

\n             		{num_lines++;};
%%

int yywrap(void){
  return 1;
}

#ifdef yylex
#   undef yylex
extern "C" int yylex() { return cool_yylex(); 
}
#endif






