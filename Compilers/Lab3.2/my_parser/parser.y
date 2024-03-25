%{
#include <stdio.h>
#include "lexer.h"
#include <cstdlib>
#include <cstring>

#define MEM(size) ((char *)malloc( (size + 1) * sizeof(char)));
#define TAB 2

char* make_tabs(unsigned indent) {
  char *str = (char*)malloc(indent + 1);
  for (int i = 0; i < indent; i++) {
      str[i] = ' ';
  }
  str[indent] = '\0';
  return str;
}
%}

%define api.pure
%locations
%lex-param {yyscan_t scanner}  /* параметр для yylex() */
/* параметры для yyparse() */
%parse-param {yyscan_t scanner}
%parse-param {long env[26]}

%union {
    char* identifier;
}


%token CLASS_KEY STRUCT_KEY LEFT_BRACE RIGHT_BRACE LEFT_PAREN RIGHT_PAREN 
%token SEMICOLON COMMA COLON NEWLINE COMMENT FINAL PUBLIC_MOD PROTECTED_MOD PRIVATE_MOD
%token CHAR_TYPE BOOL_TYPE SHORT_TYPE INT_TYPE LONG_TYPE FLOAT_TYPE DOUBLE_TYPE VOID_TYPE AUTO_TYPE POINTER

%token <identifier> IDENTIFIER

%type <identifier> start class class_name ident idents class_sig class_body class_inside class_inside_first 
%type <identifier> access_modifier class_FCMs class_FCM method_decl method_params method_params_tail
%type <identifier> type_specifier variables variables_tail pointers addindent deindent comments newline
%type <identifier> method_decl_afterparen method_decl_preparen method_decl_beforeclose method_decl_braces
%type <identifier> method_decl_end typespec newline_idents

%{
int yylex(YYSTYPE *yylval_param, YYLTYPE *yylloc_param, yyscan_t scanner);
void yyerror(YYLTYPE *loc, yyscan_t scanner, long env[26], const char *message);
%}

%%

start:
  class newline {
    printf("%s\n", $1);
  }
  | class {
    printf("%s\n", $1);
  }
  ;

class:
      CLASS_KEY addindent class_sig deindent {
          $$ = MEM(strlen($3) + 6);
          sprintf($$, "class %s", $3);
          free($3);
        }
    | STRUCT_KEY addindent class_sig deindent {
          $$ = MEM(strlen($3) + 7);
          sprintf($$, "struct %s", $3);
          free($3);
    }
    ;

class_sig:
        class_name newline class_body {
          $$ = MEM(strlen($1) + strlen($3) + 2);
          sprintf($$, "%s\n%s", $1, $3);
          free($1);
          free($3);
        }
      |
        class_name class_body {
          $$ = MEM(strlen($1) + strlen($2) + 1);
          sprintf($$, "%s %s", $1, $2);
          free($1);
          free($2);
        }
    ;

class_name:
      ident FINAL {
        $$ = MEM(strlen($1) + 6);
        sprintf($$, "%s final", $1);
        free($1);
      }
    | ident {
        $$ = MEM(strlen($1));
        sprintf($$, "%s", $1);
        free($1);
      }
    ;

class_body:
      newline LEFT_BRACE newline class_inside_first RIGHT_BRACE SEMICOLON {
          if (env[0] > TAB) {
          char* less_indent = make_tabs(env[0] - TAB);
          $$ = MEM(strlen($4) + 5 + strlen(less_indent));
          sprintf($$, "{\n%s%s};", $4, less_indent);
          free($4);
          free(less_indent);
        } else {
          $$ = MEM(strlen($3) + 6);
          sprintf($$, "{\n%s};", $4);
          free($4);
        }
      }
      |
      LEFT_BRACE newline class_inside_first RIGHT_BRACE SEMICOLON {
        if (env[0] > TAB) {
          char* less_indent = make_tabs(env[0] - TAB);
          $$ = MEM(strlen($3) + 6 + strlen(less_indent));
          sprintf($$, "{\n%s%s};", $3, less_indent);
          free($3);
          free(less_indent);
        } else {
          $$ = MEM(strlen($3) + 6);
          sprintf($$, "{\n%s};", $3);
          free($3);
        }
      }
    | LEFT_BRACE class_inside_first RIGHT_BRACE SEMICOLON {
        $$ = MEM(strlen($2) + 5);
        sprintf($$, "{%s};", $2);
        free($2);
    }
    ;

class_inside_first:
      class_FCMs class_inside {
        $$ = MEM(strlen($1) + strlen($2));
        sprintf($$, "%s%s", $1, $2);
        free($1);
      }
    | class_inside {
        $$ = MEM(strlen($1));
        sprintf($$, "%s", $1);
        free($1);
    }
    ;

class_inside:
      access_modifier COLON newline addindent class_FCMs deindent class_inside {
        char* indent = make_tabs(env[0]);
        $$ = MEM(strlen($1) + strlen($5) + strlen($7) + 3 + strlen(indent));
        sprintf($$, "%s%s:\n%s%s", indent, $1, $5, $7);
        free($1);
        free($5);
        free(indent);
      }
    | %empty {
        $$ = "";
    }
    ;

comments:
      COMMENT idents newline {
        $$ = MEM(strlen($2) + 2);
        sprintf($$, "%s\n", $2);
        free($2);
        free($3);
      }
    ;

class_FCMs:
    class_FCM class_FCMs {
      $$ = MEM(strlen($1) + strlen($2));
      sprintf($$, "%s%s", $1, $2);
      free($1);
      free($2);
    }
  | class_FCM {
      $$ = MEM(strlen($1));
      sprintf($$, "%s", $1);
      free($1);
  }
  ;

class_FCM:
    class newline {
        char* indent = make_tabs(env[0]);
        $$ = MEM(strlen($1) + strlen(indent) + 2);
        sprintf($$, "%s%s\n", indent, $1);
        free($1);
        free(indent);
    }
    |
    class {
        char* indent = make_tabs(env[0]);
        $$ = MEM(strlen($1) + strlen(indent));
        sprintf($$, "%s%s", indent, $1);
        free($1);
        free(indent);
    }
    | method_decl newline {
        char* indent = make_tabs(env[0]);
        $$ = MEM(strlen($1) + strlen(indent) + 2);
        sprintf($$, "%s%s\n", indent, $1);
        free($1);
        free($2);
        free(indent);
    }
    |  method_decl {
        char* indent = make_tabs(env[0]);
        $$ = MEM(strlen($1) + strlen(indent));
        sprintf($$, "%s%s", indent, $1);
        free($1);
        free(indent);
    }
    |
    typespec method_decl newline {
        char* indent = make_tabs(env[0]);
        $$ = MEM(strlen($1) + strlen($2) + 3 + strlen(indent));
        sprintf($$, "%s%s%s\n", indent, $1, $2);
        free($1);
        free($2);
        free($3);
        free(indent);
    }
    |  typespec method_decl {
        char* indent = make_tabs(env[0]);
        $$ = MEM(strlen($1) + strlen($2) + 1 + strlen(indent));
        sprintf($$, "%s%s%s", indent, $1, $2);
        free($1);
        free($2);
        free(indent);
    }
    | typespec variables SEMICOLON newline {
        char* indent = make_tabs(env[0]);
        $$ = MEM(strlen($1) + strlen($2) + 4 + strlen(indent));
        sprintf($$, "%s%s%s;\n", indent, $1, $2);
        free($1);
        free($2);
        free(indent);
    }
    | typespec variables SEMICOLON {
        char* indent = make_tabs(env[0]);
        $$ = MEM(strlen($1) + strlen($2) + 1 + strlen(indent));
        sprintf($$, "%s%s%s;", indent, $1, $2);
        free($1);
        free($2);
        free(indent);
    }
    | comments {
        char* indent = make_tabs(env[0]);
        $$ = MEM(strlen($1) + 2 + strlen(indent));
        sprintf($$, "%s//%s", indent, $1);
        free($1);
        free(indent);
    }
    ;

typespec:
    type_specifier newline {
        $$ = MEM(strlen($1));
        sprintf($$, "%s ", $1);
        free($1);
    }
  | type_specifier {
        $$ = MEM(strlen($1) + 1);
        sprintf($$, "%s ", $1);
        free($1);
  }
  ;

method_decl:
      ident method_decl_preparen {
        $$ = MEM(strlen($1) + strlen($2));
        sprintf($$, "%s%s", $1, $2);
        free($1);
        free($2);
      }
    | ident newline method_decl_preparen {
        $$ = MEM(strlen($1) + strlen($3));
        sprintf($$, "%s%s", $1, $3);
        free($1);
        free($3);
    }
    ;

method_decl_preparen:
    LEFT_PAREN method_decl_afterparen {
        $$ = MEM(strlen($2) + 1);
        sprintf($$, "(%s", $2);
        free($2);
    }
    ;

method_decl_afterparen:
    method_params method_decl_beforeclose {
        $$ = MEM(strlen($1) + strlen($2));
        sprintf($$, "%s%s", $1, $2);
        free($1);
        free($2);
      }
    ;

method_decl_beforeclose:
    RIGHT_PAREN newline method_decl_braces {
       $$ = MEM(strlen($3) + 1);
       sprintf($$, ")%s", $3);
       free($3);
    }
  | RIGHT_PAREN method_decl_braces {
       $$ = MEM(strlen($2) + 1);
       sprintf($$, ")%s", $2);
       free($2);
  }
  ;

method_decl_braces:
    LEFT_BRACE newline method_decl_end {
       $$ = MEM(strlen($3) + strlen("{"));
       sprintf($$, "{%s", $3);
       free($3);
    }
  | LEFT_BRACE method_decl_end {
       $$ = MEM(strlen($2) + strlen("{"));
       sprintf($$, "{%s", $2);
       free($2);
  }
  ;

method_decl_end:
    RIGHT_BRACE newline SEMICOLON {
       $$ = MEM(strlen("}") + 1);
       sprintf($$, "};");
    }
  | RIGHT_BRACE SEMICOLON {
       $$ = MEM(strlen("}") + 1);
       sprintf($$, "};");
  }
  ;

method_params:
      type_specifier newline_idents {
        $$ = MEM(strlen($1) + strlen($2) + 1);
        sprintf($$, "%s %s", $1, $2);
        free($1);
        free($2);
      }
    | type_specifier method_params_tail {
        $$ = MEM(strlen($1) + strlen($2));
        sprintf($$, "%s%s", $1, $2);
        free($1);
        free($2);
      }
    | newline method_params {
        $$ = MEM(0);
        $$[0] = '\0';
        free($2);
    }
    | %empty {
        $$ = MEM(0);
        $$[0] = '\0';
    }
    ;

newline_idents:
      idents method_params_tail {
        $$ = MEM(strlen($1) + strlen($2) + 1);
        sprintf($$, "%s%s", $1, $2);
        free($1);
        free($2);
      }
    | newline newline_idents {
        $$ = MEM(strlen($2));
        sprintf($$, "%s", $2);
        free($2);
    }

method_params_tail:
      COMMA type_specifier ident method_params_tail {
        $$ = MEM(strlen($2) + strlen($3) + strlen($4));
        sprintf($$, ", %s %s%s", $2, $3, $4);
        free($2);
        free($3);
        free($4);
      }
    |  COMMA type_specifier newline ident method_params_tail {
        $$ = MEM(strlen($2) + strlen($4) + strlen($5) + 3);
        sprintf($$, ", %s %s%s", $2, $4, $5);
        free($2);
        free($4);
        free($5);
      }
    | COMMA type_specifier method_params_tail {
        $$ = MEM(strlen($2) + strlen($3) + 2);
        sprintf($$, ", %s%s", $2, $3);
        free($2);
        free($3);
      }
    | newline method_params_tail {
        $$ = MEM(strlen($2));
        sprintf($$, "%s", $2);
        free($2);
    }
    | %empty {
        $$ = MEM(0);
        $$[0] = '\0';
      }
    ;

variables:
      ident variables_tail {
        $$ = MEM(strlen($1) + strlen($2));
        sprintf($$, "%s%s", $1, $2);
        free($1);
        free($2);
      }
    | ident {
        $$ = MEM(strlen($1));
        sprintf($$, "%s", $1);
        free($1);
    }
    ;

variables_tail:
      COMMA ident variables_tail {
        $$ = MEM(strlen($2) + 2 + strlen($3));
        sprintf($$, ", %s%s", $2, $3);
        free($2);
        free($3);
      }
    | COMMA ident {
        $$ = MEM(strlen($2) + 2);
        sprintf($$, ", %s", $2);
        free($2);
      }
    ;

access_modifier:
      PUBLIC_MOD {
        $$ = MEM(strlen("public"));
        sprintf($$, "public");
      }
    | PROTECTED_MOD {
        $$ = MEM(strlen("protected"));
        sprintf($$, "protected");
      }
    | PRIVATE_MOD {
        $$ = MEM(strlen("private "));
        sprintf($$, "private");
      }
    ;

type_specifier:
      CHAR_TYPE pointers {
        $$ = MEM(strlen("char") + strlen($2));
        sprintf($$, "char%s", $2);
        free($2);
      } 
    | BOOL_TYPE pointers {
        $$ = MEM(strlen("bool") + strlen($2));
        sprintf($$, "bool%s", $2);
        free($2);
      } 
    | SHORT_TYPE pointers {
        $$ = MEM(strlen("short") + strlen($2));
        sprintf($$, "short%s", $2);
        free($2);
      } 
    | INT_TYPE pointers {
        $$ = MEM(strlen("int") + strlen($2));
        sprintf($$, "int%s", $2);
        free($2);
      } 
    | LONG_TYPE pointers {
        $$ = MEM(strlen("long") + strlen($2));
        sprintf($$, "long%s", $2);
        free($2);
      } 
    | FLOAT_TYPE pointers {
        $$ = MEM(strlen("float") + strlen($2));
        sprintf($$, "float%s", $2);
        free($2);
      } 
    | DOUBLE_TYPE pointers {
        $$ = MEM(strlen("double") + strlen($2));
        sprintf($$, "double%s", $2);
        free($2);
      }
    | VOID_TYPE pointers {
        $$ = MEM(strlen("void") + strlen($2));
        sprintf($$, "void%s", $2);
        free($2);
      } 
    | AUTO_TYPE pointers {
        $$ = MEM(strlen("auto") + strlen($2));
        sprintf($$, "auto%s", $2);
        free($2);
      }
    ;

pointers:
      POINTER pointers {
        $$ = MEM(1);
        sprintf($$, "*");
      }
    | %empty {
        $$ = MEM(0);
        $$[0] = '\0';
      }
    ;

idents:
      ident idents {
        $$ = MEM(strlen($1) + strlen($2) + 1);
        sprintf($$, "%s %s", $1, $2);
        free($1);
        free($2);
      }
    | ident {
      $$ = MEM(strlen($1));
      sprintf($$, "%s", $1);
      free($1);
    }
    ;

ident:
      IDENTIFIER {
        $$ = MEM(strlen(yylval.identifier));
        sprintf($$, "%s", yylval.identifier);
      }
    ;

addindent:
    %empty {
      $$ = MEM(0);
      $$[0] = '\0';
      env[0] += TAB;
    }
    ;

deindent:
    %empty {
      $$ = MEM(0);
      $$[0] = '\0';
      env[0] -= TAB;
    }
    ;

newline:
      NEWLINE {
        $$ = MEM(2);
        sprintf($$, "\n");
      }
    ;

%%

int main(int argc, char *argv[]) {
    FILE *input = 0;
    long env[26] = { 0 };
    yydebug = 0;
    yyscan_t scanner;
    struct Extra extra;

    if (argc > 1) {
        printf("//Read file %s\n", argv[1]);
        input = fopen(argv[1], "r");
    } else {
        printf("No file in command line, use stdin\n");
        input = stdin;
    }

    init_scanner(input, &scanner, &extra);
    yyparse(scanner, env);
    destroy_scanner(scanner);

    if (input != stdin) {
        fclose(input);
    }

    return 0;
}