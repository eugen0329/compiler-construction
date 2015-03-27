%{
#include <stdio.h>
#include <math.h>
%}

DIGIT         [0-9]

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

[ \t\r\n]               ;
.                       { printf("Syntax error at line %d\n", yylineno); exit(1); }
%%

