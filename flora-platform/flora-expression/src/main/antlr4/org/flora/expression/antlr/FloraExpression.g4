grammar FloraExpression;

import FloraExpressionCommonLexer;


calculations : 
    (arithmetic_expression|string_expression|date_expression|bool_expression|native_expression) ';'
    |comment_expression
;

arithmetic_expression : 
    <assoc=right> arithmetic_expression '^' arithmetic_expression
    |arithmetic_expression ('*'|'/'|'%') arithmetic_expression
    | arithmetic_expression ('+'|'-') arithmetic_expression
    | ('-')? (numeric_literal|field|functions_returning_numerics|native_expression|'(' arithmetic_expression ')')
;

functions_returning_numerics :
    abs|div
;

abs :
    'ABS' '(' arithmetic_expression ')'
;

div :
    'DIV' '(' arithmetic_expression ',' arithmetic_expression ')'
;

numeric_literal : NUMBER;

string_expression :
    string_expression ('+') string_expression
    | string_literal
    | functions_returning_strings
    | field
    | native_expression
    | '(' string_expression ')'
;

functions_returning_strings :
    lower
;

lower : 'LOWER' '(' string_expression ')';

string_literal : STRING;

date_expression :
    date_expression ( '+'|'-' ) arithmetic_expression
    | date_expression ( '+'|'-' ) field
    | date_literal
    | field
    | native_expression
    | '(' date_expression ')'
;

date_literal : DATE;

bool_expression :
    arithmetic_expression ( COMPARISON_OPERATOR ) ( arithmetic_expression|field|native_expression )
    | string_expression ( COMPARISON_OPERATOR ) ( string_expression|field|native_expression )
    | date_expression ( COMPARISON_OPERATOR ) ( date_expression|field|native_expression )
    | field ( COMPARISON_OPERATOR ) ( arithmetic_expression|string_expression|date_expression|native_expression )
    | bool_expression ( 'AND'|'OR' ) bool_expression
    | '(' bool_expression ')'
;

native_expression: 'NATIVE' '(' string_expression (','(arithmetic_expression|string_expression|date_expression))* ')';


comment_expression : COMMENT | LINE_COMMENT;

field : '[' FIELD ']';
