%{
#include <stdio.h>
#include <math.h>
%}

DIGIT         [0-9]
MATH_OP       "+"|"-"|"*"|"/"|"="

KEYWORD       if|then|elif|els|end|"->"

COMMENT       #

%option main
%option yylineno

%%

[/][/].*\n              ; // comment
hello                   puts("hello");

{DIGIT}+                {
                            printf("Integer %s (%d) \n", yytext, atoi(yytext));
                        }

{DIGIT}*"."{DIGIT}*f?   {
                            printf( "A float: %s (%f)\n", yytext, atof( yytext ) );
                        }

{MATH_OP}*              {
                            printf( "Mathematical operator: \'%s\' \n", yytext);
                        }

{KEYWORD}*              {
                            printf( "Keyword: \'%s\' \n", yytext);
                        }
{COMMENT}.*$            /* ignore to end of line */

[ \t\n]                 ;
.                       { printf("Syntax error at line %d\n", yylineno); exit(1); }
%%

