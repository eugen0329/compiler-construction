%{
    #ifdef __cplusplus
        #include <string>
        #define YYSTYPE std::string
        extern "C" int yylex();
    #else
        extern int yylex();
    #endif

    #include "yccdefs.h"
    extern int yyerror(const char *s);
%}

digit           [0-9]
idetifier       [a-zA-Z_][a-zA-Z_0-9!?]*
symbol          [+-/*=}{)(,:!?]
float_literal   ({digit}+\.{digit}*|{digit}*\.{digit}+)f?

%option noyywrap
%option yylineno

%x STR
 /* comment line */
%x COMMENT_LN
 /* comment block */
%x COMMENT_BL

%%

<INITIAL>{
    {digit}+            {
                            yylval = yytext;
                            return NUM_LITER;
                        }

    {float_literal}     {
                            yylval = yytext;
                            return FLOAT_LITER;
                        }

    if                  { return IF;     }
    then                { return THEN;   }
    elif                { return ELIF;   }
    els                 { return ELS;    }
    fu                  { return FU;     }
    for                 { return FOR;    }
    in                  { return IN;     }
    end                 { return END_BL; }

    int                 { return INT;    }
    float               { return FLOAT;  }
    string              { return STRING; }
    [\n;]               { return yytext[0]; }

    "<="                { return LE; }
    ">="                { return GE; }
    "=="                { return EQ; }
    "!="                { return NE; }
    "<"                 { return yytext[0]; }
    ">"                 { return yytext[0]; }

    {idetifier}         {
                            yylval = yytext;
                            return ID;
                        }

    {symbol}            { return yytext[0]; }

    \"                  {
                            yylval = "";
                            BEGIN(STR);
                        }

    #\{                 { BEGIN(COMMENT_BL); }

    #                   { BEGIN(COMMENT_LN); }

    [ \t]               { /* eats tabs and spaces */ }

    .                   { yyerror("Invalid character"); }
}

<COMMENT_BL>{
    [^}]+               { /* eats everything that match any non '}' character */ }

    [}]+[^#]            { /* eats each '}' except that are before the '#' */}

    \}#                 { BEGIN(INITIAL); }
}

<COMMENT_LN>{
    [^\n]+              { /* nothing */ }

    \n                  { BEGIN(INITIAL); }
}

<STR>{
    \"                  {
                            BEGIN(INITIAL);
                            return STRING_LITER;
                        }

    [^"\n\\]+           { yylval += yytext; }

    \\n                 { yylval += "\n"; }

    \n                  { yyerror("Line break inside the string"); }

    /* only the \n escape allowed */
    \\                  { yyerror("Wrong escape inside the string"); }
}

%%

