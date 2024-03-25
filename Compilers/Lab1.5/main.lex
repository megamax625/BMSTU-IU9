%option noyywrap bison-bridge bison-locations


%{
#include <stdio.h>
#include <stdlib.h>

#define TAG_CHEMICAL_ELEMENT 1
#define TAG_COEFFICIENT 2
#define TAG_SEPARATED_NUMBER 3
#define TAG_OPERATOR 4
#define TAG_ERROR 5

char *tag_names[] = {
    "END_OF_PROGRAM", "CHEMICAL_ELEMENT", "COEFFICIENT", "SEPARATED_NUMBER", "OPERATOR", "ERROR"
};

typedef struct Position Position; 

struct Position {
    int line, pos, index;
};

void print_pos(Position * p) {
    printf("(%d,%d)", p->line, p->pos);
}

struct Fragment {
    Position starting, following;
};

typedef struct Fragment YYLTYPE;
typedef struct Fragment Fragment; 

void print_frag(Fragment *f) {
    print_pos(&(f->starting));
    printf("-");
    print_pos(&(f->following));
}

union Token {
    int coefficient;
    char *chemical_element;
    char *operator;
};

typedef union Token YYSTYPE;

int continued;
struct Position cur;

#define YY_USER_ACTION           \
{                                \
    int i;                       \
    if (!continued)              \
        yylloc->starting = cur;  \
    continued = 0;               \
    for (i = 0; i < yyleng; i++) \
    {                            \
        if (yytext[i] == '\n')   \
        {                        \
            cur.line++;          \
            cur.pos = 1;         \
        }                        \
        else                     \
            cur.pos++;           \
        cur.index++;             \
    }                            \
    yylloc->following = cur;     \
}


void init_scanner(const char* file) {
    continued = 0;
    cur.line = 1;
    cur.pos = 1;
    cur.index = 0;
    yyin = fopen(file, "r");
}

void err(char *msg) {
    printf("ERROR ");
    print_pos(&cur);
    printf(": %s\n", msg);
}
%}

/*Химические вещества: последовательности латинских букв и цифр, начинающиеся с заглавной буквы,
    при этом после цифры не может следовать строчная буква (атрибут: строка). Примеры: «CuSO4», «CH3CH2OH», «Fe2O3».
Коэффициенты: последовательности десятичных цифр. Между коэффициентом и веществом пробел может отсутствовать. 
Операторы: «+», «->». */

CHEMICAL_ELEMENT       ([A-Z][a-zA-Z]*[2-9]*)+
COEFFICIENT            ([0-9]+)
OPERATOR               (\+|->)

%% 

[\n\t ]+

{CHEMICAL_ELEMENT} {
                yylval->chemical_element = yytext;
                return TAG_CHEMICAL_ELEMENT;
            }

{COEFFICIENT}/(([[:space:]])*{CHEMICAL_ELEMENT})  {
                yylval->coefficient = atoi(yytext);
                return TAG_COEFFICIENT;
            }

{COEFFICIENT}  {
                yylval->coefficient = atoi(yytext);
                return TAG_SEPARATED_NUMBER;
            }

{OPERATOR}  {
                yylval->operator = yytext;
                return TAG_OPERATOR;
}

<<EOF>>     return 0;

.           {
                err("unexpected character");
                return TAG_ERROR;
            }

%%

int main(int argc, const char **argv) {
    int tag;
    YYSTYPE value;
    YYLTYPE coords;
    init_scanner(argv[1]);
    while ((tag = yylex(&value, &coords)) != 0) {
        if (tag != 0 && tag != TAG_ERROR) {
            printf("%s ", tag_names[tag]);
            print_frag(&coords);
            if (strcmp(tag_names[tag], "CHEMICAL_ELEMENT") == 0) {
                printf(": %s\n", value.chemical_element);
            } else if (strcmp(tag_names[tag], "COEFFICIENT") == 0) {
                printf(": %d\n", value.coefficient);
            } else if (strcmp(tag_names[tag], "SEPARATED_NUMBER") == 0) {
                printf(": %d\n", value.coefficient);
            } else if (strcmp(tag_names[tag], "OPERATOR") == 0) {
                printf(": %s\n", value.operator);
            }
        }
    }
    return 0;
}