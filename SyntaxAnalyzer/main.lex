%{
#include <stdio.h>
#include <math.h>
%}

DIGIT         [0-9]
MATH_OP       "+"|"-"|"*"|"/"|"="

KEYWORD       if|then|elif|els|end|"->"
<<<<<<< HEAD
=======

COMMENT       #
>>>>>>> 74e7abc029898968fdaf066c43d454e914d4f3da

%option main
%option yylineno

%%

hello                   puts("hello");

{DIGIT}+                {
                            printf("Integer \'%s\' (%d) \n", yytext, atoi(yytext));
                        }

{DIGIT}*\.{DIGIT}*f?    {
                            printf( "A float: \'%s\' (%f)\n", yytext, atof( yytext ) );
                        }

{MATH_OP}*              {
                            printf( "Mathematical operator: \'%s\' \n", yytext);
                        }

{KEYWORD}*              {
                            printf( "Keyword: \'%s\' \n", yytext);
                        }

<<<<<<< HEAD
#\{([^}]|\}[^#])*\}+#   {
                            printf("Multiline commented text \n===\n%s\n===\n", yytext);
                        }

#.*\n                   {
                            printf("Commented text \'%s\'", yytext);
                        }

[ \t\n]                 ;
.                       {
                            printf("Syntax error at line %d\n", yylineno);
                            exit(1);
                        }
=======
{MATH_OP}*              {
                            printf( "Mathematical operator: \'%s\' \n", yytext);
                        }

{KEYWORD}*              {
                            printf( "Keyword: \'%s\' \n", yytext);
                        }
{COMMENT}.*$            /* ignore to end of line */

[ \t\n]                 ;
.                       { printf("Syntax error at line %d\n", yylineno); exit(1); }
>>>>>>> 74e7abc029898968fdaf066c43d454e914d4f3da
%%

