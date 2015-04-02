%{
    #ifdef __cplusplus
        #include <iostream>
        #include <cstdlib>
        extern "C" {
            int yylex();
        }
        #define YYSTYPE std::string
    #else
        extern int yylex();
        #include <stdio.h>
        #include <stdlib.h>
    #endif

    extern int yylineno;
    void yyerror(char *s) {
      std::cerr << s << "at line " << yylineno << std::endl;
      exit(EXIT_FAILURE);
    }
%}

%token IF THEN ELIF ELS END FU FOR TO END_BL EXIT
%token INT FLOAT STRING

%token EQ LE GE NE
%token STRING_LITER NUM ID


%%

primary_statement
        : statements
        ;

statements
        : statement
        | statements statement
        ;


statement
        : expression_statement
        | declaration
        ;

declaration
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
        | unary_expr '=' assignment_expression
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
        : NUM
        | STRING_LITER
        | postfix_expr
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

