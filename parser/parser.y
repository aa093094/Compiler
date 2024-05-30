%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>


extern FILE *yyin;
extern char *yytext;
extern int yylineno;

char * filename;

int yylex(void);
void yyerror(const char *str, ...)
{
	va_list ap;
	va_start(ap, str);

	fprintf(stderr, "%s:%d: error: %s '%s' token \n", filename, yylineno, str, yytext);
	exit(1);
}
%}

%token DEFINE
%token VOID INT
%token IF FOR CONTI
%token ID NUM STR
%token ASSIGN_OP INC_OP ADD_OP MUL_OP LOGIC_OP REL_OP
%locations

%start c_code
%%
c_code:
	code
	| code c_code
	;

code:
	define_stmt
	|func_def stmt
	;

func_def:
	type id_postfix '(' decl_list ')' 
	;

stmt:
	| compound_stmt
	| for_stmt stmt
	| if_stmt stmt
	| expr_stmt
	| jump_stmt
	;

compound_stmt:
 	'{' '}'
 	|'{' blk_list '}'
 	;
 
blk_list:
 	blk
 	|blk_list blk
 	;
 
blk:
 	decl_list ';'
 	|stmt
 	;

jump_stmt:
	CONTI ';'
	|func_call ';'
	;

func_call:
	id_postfix '(' expr ')'
	;

define_stmt:
	DEFINE ID constants 
	;

for_stmt:
	/* your code here */
	FOR '(' expr ';' expr ';' expr ')'
	;

if_stmt:
	IF '(' expr ')' 
	;

expr_stmt:
	';'
	| expr ';'
	;

expr:
	id_postfix
	| assignment_expr
	;

assignment_expr:
	logical_expr
	| assignment_expr ASSIGN_OP logical_expr
	;

logical_expr:
	reltional_expr
	| logical_expr LOGIC_OP reltional_expr
	;

reltional_expr:
	additive_expr
	| reltional_expr REL_OP reltional_expr
	;

additive_expr:
	multiplication_expr
	| additive_expr ADD_OP multiplication_expr
	;

multiplication_expr:
	unary_expr
	| multiplication_expr MUL_OP unary_expr
	;

unary_expr:
	id_postfix
	| unary_expr INC_OP
	;

decl_list:
	decl_init
	| decl_list ',' decl_init
	| decl_list ',' id_postfix
	;

decl_init:
	type id_postfix
	;

id_postfix:
	id_primary
	| id_postfix '[' ']'
	| id_postfix '[' NUM ']'
	| id_postfix '[' ID ']'
	;

id_primary:
	ID
	| constants
	;

constants:
	NUM
	| STR
	;

type:
	VOID
	| INT
	;
%%

int main( int argc, char **argv )
{
	++argv, --argc;  /* skip over program name */
	if ( argc > 0 )
		yyin = fopen( argv[0],"r");
	else
		yyin = stdin;

	filename = argv[0];

	yyparse();

	fprintf(stderr, "%s:done: no error found\n", filename);

	return 0;
}
