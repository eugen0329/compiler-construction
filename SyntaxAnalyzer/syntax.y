%{
    #ifdef __cplusplus
        #include <iostream>
        #include <cstdlib>
        extern "C" int yylex();
        #define YYSTYPE std::string
    #else
        #include <stdio.h>
        #include <stdlib.h>
        extern int yylex();
    #endif

    extern int yylineno;

    void yyerror(char *s) {
      std::cerr << s << " on line " << yylineno << std::endl;
      exit(EXIT_FAILURE);
    }
%}

%token IF THEN ELIF ELS END FU FOR IN END_BL EXIT
%token INT FLOAT STRING

%token EQ LE GE NE
%token STRING_LITER FLOAT_LITER NUM_LITER ID

%start statements

%%

statements
        : statements statement
        | /* emtpy */
        ;


statement
        : expression_statement
        | declaration_statement
        | selection_statement
        | loop_statement
        ;


selection_statement
        : IF  expression_statement statements END_BL
        | IF  expression_statement statements ELS statements END_BL
        ;

loop_statement
        : FOR expression IN expression_statement statements END_BL
        ;

declaration_statement
        : type_spec declaration_list delimiter
        ;

type_spec
        : INT
        | FLOAT
        | STRING
        ;

declaration_list
        : declarator
        | declarator ',' declaration_list
        ;

declarator
        : ID
        | ID '=' initializer
        ;

initializer
        : expression
        ;


expression_statement
        : delimiter
        | expression delimiter
        ;

expression
        : assignment_expression
        ;

assignment_expression
        : logical_expression
        | ID '=' assignment_expression
        ;

logical_expression
        : additive_expr
        | logical_expression EQ additive_expr
        | logical_expression LE additive_expr
        | logical_expression GE additive_expr
        | logical_expression NE additive_expr
        | logical_expression '>' additive_expr
        | logical_expression '<' additive_expr
        ;

additive_expr
        : multiplicative_expr
        | additive_expr '+' multiplicative_expr
        | additive_expr '-' multiplicative_expr
        ;

multiplicative_expr
        : unary_expr
        | multiplicative_expr '*' unary_expr
        | multiplicative_expr '/' unary_expr
        ;

unary_expr
        : postfix_expr
        | STRING_LITER
        | NUM_LITER
        | FLOAT_LITER
        | '-' unary_expr
        | '!' unary_expr
        | '(' expression ')'
        ;

postfix_expr
        : postfix_expr '[' expression ']'
        | postfix_expr '.' ID
        | ID
        | postfix_expr '(' arg_expr_list ')'
        ;


arg_expr_list
        : assignment_expression
        | arg_expr_list ',' assignment_expression
        | /* nothing */
        ;

delimiter
        : '\n'
        | ';'
        ;
%%

int main()
{
#ifdef DEBUG
    yydebug = 1;
#endif
    return yyparse();
}

