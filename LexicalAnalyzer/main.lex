%{
    #include <iostream>
    #include <cmath>
    #include <cstdlib>
%}

DIGIT         [0-9]

KEYWORD       if|then|elif|els|end|fun|for|to|end
TYPE          int|float|string
VAR_NAME      [a-zA-Z_][a-zA-Z_0-9!?]*
SYM    [+-/*=}{)(,:!?]

%option main
%option noyywrap
%option yylineno

%x STR
%x COMMENT
 /*comment line*/
%x COMMENT_LN
 /*comment block*/
%x COMMENT_BL

%%

<INITIAL>{
    {DIGIT}+                {
                                printf("Integer: \'%s\' (%d) \n", yytext, atoi(yytext));
                            }

    {DIGIT}*\.{DIGIT}*f?    {
                                printf("Float: \'%s\' (%f)\n", yytext, atof( yytext ) );
                            }


    {KEYWORD}               {
                                printf("Keyword: \'%s\' \n", yytext);
                            }

    {TYPE}                  {
                                printf("Type: \'%s\'\n", yytext);
                            }

    {VAR_NAME}              {
                                printf("Var: \'%s\'\n", yytext);
                            }

    {SYM}                   {
                                printf("Sym: \'%s\' \n", yytext);
                            }

    \"                      {
                                printf("String: \"");
                                BEGIN(STR);
                            }

    #\{                     {
                                printf("Block comment: \n\'");
                                BEGIN(COMMENT_BL);
                            }

    #                       {
                                BEGIN(COMMENT_LN);
                            }

    [ \t\n]                 ;

    .                       {
                                printf("Syntax error at line %d\n", yylineno);
                                exit(EXIT_FAILURE);
                            }
}

<COMMENT_BL>{
    [^}]+           {
                        printf("%s", yytext);
                    }

    \}#             {
                        printf("\'\n");
                        BEGIN(INITIAL);
                    }
}

<COMMENT_LN>{
    [^\n]+              {
                            printf("Stripped text: \'%s\'\n", yytext);
                        }

    \n                  {
                            BEGIN(INITIAL);
                        }
}

<STR>{
    \"                 {
                           BEGIN(INITIAL);
                           printf("\"\n");
                       }

    [^"\n\\]+          {
                           printf("%s", yytext);
                       }

    \\n                {
                           printf("\\n");
                       }

    \n                 {
                           printf("New line in string at line %d", yylineno);
                           exit(EXIT_FAILURE);
                       }
    /* only \n escape allowed */
    \\                 {
                           printf("Wrong escape in string at line %d", yylineno);
                           exit(EXIT_FAILURE);
                       }
}

%%

