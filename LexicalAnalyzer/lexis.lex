%{
    #ifdef __cplusplus
        #include <string>
        #define YYSTYPE std::string
        extern "C" int yylex();
    #endif

    #include "yccdefs.h"
    void yyerror(char *s);
%}

DIGIT         [0-9]

KEYWORD     if|then|elif|els|end|fu|for|to|end
TYPE        int|float|string
IDENTIFIER    [a-zA-Z_][a-zA-Z_0-9!?]*
SYM         [+-/*=}{)(,:!?]

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
                                //printf("Integer: \'%s\' (%d) \n", yytext, atoi(yytext));
                                //printf("Integer: \'%s\' (%d) \n", yytext, atoi(yytext));
                                yylval = yytext;
                                return NUM;
                            }

    ({DIGIT}+\.{DIGIT}*|{DIGIT}*\.{DIGIT})f? {
                                //printf("Float: \'%s\' (%f)\n", yytext, atof( yytext ) );
                            }
    if                      return IF;
    then                    return THEN;
    elif                    return ELIF;
    els                     return ELS;
    fu                      return FU;
    for                     return FOR;
    to                      return TO;
    'end'                   return END_BL;

    int                     return INT;
    float                   return FLOAT;
    string                  return STRING;
    [\n;]                    return yytext[0];


    {IDENTIFIER}            {
                                yylval = yytext;
                                return ID;
                            }

    {SYM}                   { return yytext[0]; }

    \"                      {
                                //printf("String: \"");
                                yylval = "";
                                BEGIN(STR);
                            }

    #\{                     {
                                //printf("Block comment: \n\'");
                                BEGIN(COMMENT_BL);
                            }

    #                       {
                                BEGIN(COMMENT_LN);
                            }

    [ \t]                   ;

    .                       {
                                //printf("Syntax error at line %d\n", yylineno);
                                exit(EXIT_FAILURE);
                            }
}

<COMMENT_BL>{
    [^}]+                   {
                                //printf("%s", yytext);
                            }

    \}#                     {
                                BEGIN(INITIAL);
                            }
}

<COMMENT_LN>{
    [^\n]+              {
                        }

    \n                  {
                            BEGIN(INITIAL);
                        }
}

<STR>{
    \"                  {
                            BEGIN(INITIAL);
                            return STRING_LITER;
                        }

    [^"\n\\]+           {
                            yylval += yytext;
                            //printf("%s", yytext);
                        }

    \\n                 {
                            yylval += "\n";
                            //printf("\\n");
                        }

    \n                  {
                            printf("New line in string at line %d", yylineno);
                            exit(EXIT_FAILURE);
                        }
    /* only the \n escape allowed */
    \\                  {
                            printf("Wrong escape in string at line %d", yylineno);
                            exit(EXIT_FAILURE);
                        }
}

%%

