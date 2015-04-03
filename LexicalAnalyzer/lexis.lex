%{
    #ifdef __cplusplus
        #include <string>
        #define YYSTYPE std::string
        extern "C" int yylex();
    #else
        extern int yylex();
    #endif

    #include "yccdefs.h"
    void yyerror(char *s);
%}

digit            [0-9]

identifier       [a-zA-Z_][a-zA-Z_0-9!?]*
symbol           [+-/*=}{)(,:!?]
float_literal    ({digit}+\.{digit}*|{digit}*\.{digit})f?

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
    {digit}+               {
                                yylval = yytext;
                                return NUM_LITER;
                            }

    {float_literal}         {
                                yylval = yytext;
                                return FLOAT_LITER;
                            }

    if                      { return IF;     }
    then                    { return THEN;   }
    elif                    { return ELIF;   }
    els                     { return ELS;    }
    fu                      { return FU;     }
    for                     { return FOR;    }
    in                      { return IN;     }
    end                     { return END_BL; }

    int                     { return INT;    }
    float                   { return FLOAT;  }
    string                  { return STRING; }
    [\n;]                   { return yytext[0]; }

    "<="                    { return LE; }
    ">="                    { return GE; }
    "=="                    { return EQ; }
    "!="                    { return NE; }
    "<"                     { return yytext[0]; }
    ">"                     { return yytext[0]; }

    {identifier}            {
                                yylval = yytext;
                                return ID;
                            }

    {symbol}                   { return yytext[0]; }

    \"                      {
                                yylval = "";
                                BEGIN(STR);
                            }

    #\{                     {
                                BEGIN(COMMENT_BL);
                            }

    #                       {
                                BEGIN(COMMENT_LN);
                            }

    [ \t]                   ;

    .                       {
                                exit(EXIT_FAILURE);
                            }
}

<COMMENT_BL>{
    [^}]+                   {
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
                        }

    \\n                 {
                            yylval += "\n";
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

