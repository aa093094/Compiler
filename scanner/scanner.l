%{
#include <stdio.h>
#include <string.h>

char keywords[1024] = {0, };
char identifiers[1024] = {0, };
char operators[1024] = {0, };
char numbers[1024] = {0, };
char strings[1024] = {0, };
char delimiters[1024] = {0, };

void append(char *buf, const char *text) 
{
    if (buf[0] != '\0') 
	{
		strcat(buf, " ");
	}
    strcat(buf, text);
}

void print(char *buf, const char *category) 
{
    if (buf[0] != '\0') 
	{
        printf("%s: %s\n", category, buf);
        buf[0] = '\0';
    }
}
%}

%%

#define                                  { append(keywords, yytext); }
void                                     { append(keywords, yytext); }

"+"|"-"                                  { append(operators, yytext); }
\"[^"]*\"                                { append(strings, yytext); }
";"                                      { append(delimiters, yytext); }

\/\/.*|\/\*.*\*\/							/* ignore comments 	 */
[ \t\n]+   		               				/* ignore whitespace */


 /* your code here */

int		{ append(keywords, yytext); }
for		{ append(keywords, yytext); }
if		{ append(keywords, yytext); }
continue	{ append(keywords, yytext); }
printf		{ append(identifiers, yytext); }

"="|"*"|"++"|"+="                          { append(operators, yytext); }
"=="                                       { append(operators, yytext); }
"!="                                       { append(operators, yytext); }
"&&"|"||"                                  { append(operators, yytext); }
"<"|">"|"<="|">="                          { append(operators, yytext); }
"{"|"}"|"("|")"|"["|"]"|","                { append(delimiters, yytext); }

[0-9]+                                     { append(numbers, yytext); }

[a-zA-Z_][a-zA-Z0-9_]*                     { append(identifiers, yytext); }

.                                           /* ignore unknown characters */

%%

int main() {
    yylex();
	printf("\n");
    print(keywords, "keywords");
    print(identifiers, "identifiers");
    print(operators, "operators");
    print(numbers, "numbers");
    print(strings, "strings");
    print(delimiters, "delimiters");
    return 0;
}

