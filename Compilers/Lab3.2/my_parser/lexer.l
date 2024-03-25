%option reentrant noyywrap bison-bridge bison-locations
%option extra-type="struct Extra *"

/* Подавление предупреждений для -Wall */
%option noinput nounput

%{

#include <stdio.h>
#include <stdlib.h>
#include "lexer.h"
#include "parser.tab.h"  /* файл генерируется Bison’ом */

#define YY_USER_ACTION \
  { \
    int i; \
    struct Extra *extra = yyextra; \
    if (! extra->continued ) { \
      yylloc->first_line = extra->cur_line; \
      yylloc->first_column = extra->cur_column; \
    } \
    extra->continued = false; \
    for (i = 0; i < yyleng; ++i) { \
      if (yytext[i] == '\n') { \
        extra->cur_line += 1; \
        extra->cur_column = 1; \
      } else { \
        extra->cur_column += 1; \
      } \
    } \
    yylloc->last_line = extra->cur_line; \
    yylloc->last_column = extra->cur_column; \
  }

void yyerror(YYLTYPE *loc, yyscan_t scanner, long env[26], const char *message) {
    printf("Error (%d,%d): %s\n", loc->first_line, loc->first_column, message);
}

%}

IDENTIFIER [A-Za-z][A-Za-z0-9_]*

%%

[\r\t ]+
\n|(\n[\r\t\n ]*\n) return NEWLINE;

class return CLASS_KEY;
struct return STRUCT_KEY;
\{  return LEFT_BRACE;
\}  return RIGHT_BRACE;
\(  return LEFT_PAREN;
\)  return RIGHT_PAREN;
;   return SEMICOLON;
,   return COMMA;
:   return COLON;
final return FINAL;
public return PUBLIC_MOD;
protected return PROTECTED_MOD;
private return PRIVATE_MOD;
char return CHAR_TYPE;
bool return BOOL_TYPE;
short return SHORT_TYPE;
int return INT_TYPE;
long return LONG_TYPE;
float return FLOAT_TYPE;
double return DOUBLE_TYPE;
void return VOID_TYPE;
auto return AUTO_TYPE;
\*   return POINTER;
\/\/ return COMMENT;

{IDENTIFIER} {
    yylval->identifier = yytext;
    return IDENTIFIER;
}

%%

void init_scanner(FILE *input, yyscan_t *scanner, struct Extra *extra) {
    extra->continued = false;
    extra->cur_line = 1;
    extra->cur_column = 1;

    yylex_init(scanner);
    yylex_init_extra(extra, scanner);
    yyset_in(input, *scanner);
}

void destroy_scanner(yyscan_t scanner) {
    yylex_destroy(scanner);
}