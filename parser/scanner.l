%option noyywrap
%option never-interactive

%{
#include <stdio.h>
#include "parser.tab.h"
%}

%%
#define										return DEFINE;
void										return VOID;

"+"|"-"										return ADD_OP;
\".*\"										return STR;
";"											return ';';

\n 		                 	   	 			{yylineno ++;}
\/\/.*|\/\*.*\*\/							/* ignore comments 	 */
[ \t]+   		               				/* ignore whitespace */

int                             return INT;
for                             return FOR;
if                              return IF;
continue                        return CONTI;
printf                          return ID;
"*"                             return MUL_OP;
"="                             return ASSIGN_OP;
"++"                            return INC_OP;
"+="                            return ADD_OP;
"=="|"!="                       return REL_OP;
"&&"|"||"                       return LOGIC_OP;
"<"|">"|"<="|">="               return REL_OP;
"{"|"}"|"("|")"|"["|"]"|","     return yytext[0];
[0-9]+                          return NUM;
[a-zA-Z_][a-zA-Z0-9_]*          return ID;


%%




