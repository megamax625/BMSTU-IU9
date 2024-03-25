/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.5.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 1

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "parser.y"

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

#line 89 "parser.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Use api.header.include to #include this header
   instead of duplicating it here.  */
#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    CLASS_KEY = 258,
    STRUCT_KEY = 259,
    LEFT_BRACE = 260,
    RIGHT_BRACE = 261,
    LEFT_PAREN = 262,
    RIGHT_PAREN = 263,
    SEMICOLON = 264,
    COMMA = 265,
    COLON = 266,
    NEWLINE = 267,
    COMMENT = 268,
    FINAL = 269,
    PUBLIC_MOD = 270,
    PROTECTED_MOD = 271,
    PRIVATE_MOD = 272,
    CHAR_TYPE = 273,
    BOOL_TYPE = 274,
    SHORT_TYPE = 275,
    INT_TYPE = 276,
    LONG_TYPE = 277,
    FLOAT_TYPE = 278,
    DOUBLE_TYPE = 279,
    VOID_TYPE = 280,
    AUTO_TYPE = 281,
    POINTER = 282,
    IDENTIFIER = 283
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 27 "parser.y"

    char* identifier;

#line 174 "parser.tab.c"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif



int yyparse (yyscan_t scanner, long env[26]);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */

/* Second part of user prologue.  */
#line 44 "parser.y"

int yylex(YYSTYPE *yylval_param, YYLTYPE *yylloc_param, yyscan_t scanner);
void yyerror(YYLTYPE *loc, yyscan_t scanner, long env[26], const char *message);

#line 208 "parser.tab.c"


#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))

/* Stored state numbers (used for stacks). */
typedef yytype_uint8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                            \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL \
             && defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
  YYLTYPE yyls_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE) \
             + YYSIZEOF (YYLTYPE)) \
      + 2 * YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  7
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   216

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  29
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  31
/* YYNRULES -- Number of rules.  */
#define YYNRULES  75
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  137

#define YYUNDEFTOK  2
#define YYMAXUTOK   283


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,    52,    52,    55,    61,    66,    74,    81,    90,    95,
     103,   117,   130,   138,   143,   151,   159,   165,   174,   180,
     188,   196,   203,   211,   219,   228,   236,   244,   252,   262,
     267,   275,   281,   290,   298,   307,   312,   320,   325,   333,
     337,   344,   350,   356,   361,   368,   374,   381,   388,   395,
     401,   406,   413,   419,   427,   433,   441,   445,   449,   456,
     461,   466,   471,   476,   481,   486,   491,   496,   504,   508,
     515,   521,   529,   536,   544,   552
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "CLASS_KEY", "STRUCT_KEY", "LEFT_BRACE",
  "RIGHT_BRACE", "LEFT_PAREN", "RIGHT_PAREN", "SEMICOLON", "COMMA",
  "COLON", "NEWLINE", "COMMENT", "FINAL", "PUBLIC_MOD", "PROTECTED_MOD",
  "PRIVATE_MOD", "CHAR_TYPE", "BOOL_TYPE", "SHORT_TYPE", "INT_TYPE",
  "LONG_TYPE", "FLOAT_TYPE", "DOUBLE_TYPE", "VOID_TYPE", "AUTO_TYPE",
  "POINTER", "IDENTIFIER", "$accept", "start", "class", "class_sig",
  "class_name", "class_body", "class_inside_first", "class_inside",
  "comments", "class_FCMs", "class_FCM", "typespec", "method_decl",
  "method_decl_preparen", "method_decl_afterparen",
  "method_decl_beforeclose", "method_decl_braces", "method_decl_end",
  "method_params", "newline_idents", "method_params_tail", "variables",
  "variables_tail", "access_modifier", "type_specifier", "pointers",
  "idents", "ident", "addindent", "deindent", "newline", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_int16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283
};
# endif

#define YYPACT_NINF (-76)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-1)

#define yytable_value_is_error(Yyn) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
      59,   -76,   -76,     9,     8,    -2,    -2,   -76,   -76,   -76,
     -76,   -76,     6,    28,   -76,   -76,   114,   -76,    12,   -76,
     -76,    -2,   -76,   -76,   -76,    31,    31,    31,    31,    31,
      31,    31,    31,    31,     8,    54,   -76,   -76,    40,   166,
      -2,     8,    53,     8,    36,   140,   114,   -76,    60,     8,
      -2,    31,   -76,   -76,   -76,   -76,   -76,   -76,   -76,   -76,
     -76,   -76,    57,   -76,   -76,     8,    58,    21,   -76,     8,
     -76,   181,   -76,    62,    65,   140,     8,   -76,   -76,   -76,
     -76,   -76,     8,    -2,   -76,   -76,   -76,    67,    13,   181,
     -76,    64,    70,   140,   -76,    71,   166,    17,   -76,   190,
     -76,   -76,    22,    13,   -76,   -76,    68,    74,   -76,   -76,
       2,   -76,    77,    13,   -76,    22,   -76,   -76,   -76,    75,
      40,    41,   -76,    82,   -76,   -76,    22,    13,   -76,   -76,
     -76,    80,   -76,   -76,    22,   -76,   -76
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       0,    73,    73,     0,     3,     0,     0,     1,    75,     2,
      72,    74,     0,     9,    74,     4,    16,     7,     0,     8,
       5,     0,    56,    57,    58,    69,    69,    69,    69,    69,
      69,    69,    69,    69,    21,     0,    14,    28,    16,    19,
       0,    23,     0,    30,     0,    16,    16,     6,     0,     0,
      71,    69,    59,    60,    61,    62,    63,    64,    65,    66,
      67,    20,     0,    13,    18,    25,     0,    53,    22,     0,
      29,    44,    31,     0,     0,    16,     0,    17,    70,    68,
      12,    24,    27,     0,    52,    73,    33,     0,    51,    44,
      32,     0,     0,    16,    26,    55,     0,     0,    34,     0,
      41,    42,    51,    51,    43,    11,     0,     0,    54,    74,
       0,    36,     0,    51,    45,    51,    46,    50,    10,     0,
      16,     0,    38,     0,    35,    49,    51,    51,    10,    15,
      40,     0,    37,    47,    51,    39,    48
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
     -76,   -76,    90,    87,   -76,    76,   -39,   -33,   -76,   -35,
     -76,   -76,    55,    23,   -76,   -76,   -13,   -22,    14,    -1,
     -75,   -76,    10,   -76,   -59,   145,   -11,    -5,     1,   -12,
       3
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,     3,    34,    11,    12,    17,    35,    36,    37,    38,
      39,    40,    41,    72,    86,    98,   111,   122,    87,   100,
     117,    66,    84,    42,    43,    52,   102,    44,     5,    15,
     115
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_uint8 yytable[] =
{
      13,    13,    20,     6,    64,    63,    74,     9,   121,     7,
      49,    16,    88,   101,     8,    18,    50,    46,     8,    45,
       8,    48,   110,    99,     8,     8,    10,   114,    71,     8,
      88,    83,    99,     8,     8,    67,    92,    61,   125,    78,
     113,    10,    19,    71,    68,    50,    70,    73,     8,    75,
     130,   133,    77,     8,   107,    22,    23,    24,    51,   136,
      62,   109,     1,     2,    69,    76,    80,    82,    81,    71,
      73,    91,    85,   105,    89,    97,   106,   118,    95,    93,
     119,    83,   110,    50,   128,    94,    96,   129,   121,   135,
       4,   103,    89,    14,    47,    65,    90,   120,    50,   124,
     112,   132,   116,   104,     0,   108,   103,     0,   126,     0,
       0,     0,     0,   123,     0,     0,   127,     1,     2,     0,
       0,     0,   134,     0,   131,     0,     8,    21,     0,    22,
      23,    24,    25,    26,    27,    28,    29,    30,    31,    32,
      33,     0,    10,     1,     2,     0,     0,     0,     0,     0,
       0,     0,     0,    21,     0,    22,    23,    24,    25,    26,
      27,    28,    29,    30,    31,    32,    33,     0,    10,     1,
       2,    53,    54,    55,    56,    57,    58,    59,    60,    21,
       0,     0,     0,     0,    25,    26,    27,    28,    29,    30,
      31,    32,    33,     8,    10,     0,    79,     0,     0,    25,
      26,    27,    28,    29,    30,    31,    32,    33,    25,    26,
      27,    28,    29,    30,    31,    32,    33
};

static const yytype_int16 yycheck[] =
{
       5,     6,    14,     2,    39,    38,    45,     4,     6,     0,
      21,     5,    71,    88,    12,    12,    21,     5,    12,    16,
      12,    18,     5,    10,    12,    12,    28,   102,     7,    12,
      89,    10,    10,    12,    12,    40,    75,    34,   113,    50,
      99,    28,    14,     7,    41,    50,    43,    44,    12,    46,
       9,   126,    49,    12,    93,    15,    16,    17,    27,   134,
       6,    96,     3,     4,    11,     5,     9,     9,    65,     7,
      67,     6,    69,     9,    71,     8,     6,     9,    83,    76,
       6,    10,     5,    88,     9,    82,    85,   120,     6,     9,
       0,    88,    89,     6,    18,    40,    73,   109,   103,   112,
      97,   123,   103,    89,    -1,    95,   103,    -1,   113,    -1,
      -1,    -1,    -1,   110,    -1,    -1,   113,     3,     4,    -1,
      -1,    -1,   127,    -1,   121,    -1,    12,    13,    -1,    15,
      16,    17,    18,    19,    20,    21,    22,    23,    24,    25,
      26,    -1,    28,     3,     4,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    13,    -1,    15,    16,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    -1,    28,     3,
       4,    26,    27,    28,    29,    30,    31,    32,    33,    13,
      -1,    -1,    -1,    -1,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    12,    28,    -1,    51,    -1,    -1,    18,
      19,    20,    21,    22,    23,    24,    25,    26,    18,    19,
      20,    21,    22,    23,    24,    25,    26
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,     3,     4,    30,    31,    57,    57,     0,    12,    59,
      28,    32,    33,    56,    32,    58,     5,    34,    59,    14,
      58,    13,    15,    16,    17,    18,    19,    20,    21,    22,
      23,    24,    25,    26,    31,    35,    36,    37,    38,    39,
      40,    41,    52,    53,    56,    59,     5,    34,    59,    55,
      56,    27,    54,    54,    54,    54,    54,    54,    54,    54,
      54,    59,     6,    36,    38,    41,    50,    56,    59,    11,
      59,     7,    42,    59,    35,    59,     5,    59,    55,    54,
       9,    59,     9,    10,    51,    59,    43,    47,    53,    59,
      42,     6,    35,    59,    59,    56,    57,     8,    44,    10,
      48,    49,    55,    59,    47,     9,     6,    35,    51,    38,
       5,    45,    59,    53,    49,    59,    48,    49,     9,     6,
      58,     6,    46,    59,    45,    49,    56,    59,     9,    36,
       9,    59,    46,    49,    56,     9,    49
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_int8 yyr1[] =
{
       0,    29,    30,    30,    31,    31,    32,    32,    33,    33,
      34,    34,    34,    35,    35,    36,    36,    37,    38,    38,
      39,    39,    39,    39,    39,    39,    39,    39,    39,    40,
      40,    41,    41,    42,    43,    44,    44,    45,    45,    46,
      46,    47,    47,    47,    47,    48,    48,    49,    49,    49,
      49,    49,    50,    50,    51,    51,    52,    52,    52,    53,
      53,    53,    53,    53,    53,    53,    53,    53,    54,    54,
      55,    55,    56,    57,    58,    59
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     2,     1,     4,     4,     3,     2,     2,     1,
       6,     5,     4,     2,     1,     7,     0,     3,     2,     1,
       2,     1,     2,     1,     3,     2,     4,     3,     1,     2,
       1,     2,     3,     2,     2,     3,     2,     3,     2,     3,
       2,     2,     2,     2,     0,     2,     2,     4,     5,     3,
       2,     0,     2,     1,     3,     2,     1,     1,     1,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     0,
       2,     1,     1,     0,     0,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (&yylloc, scanner, env, YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)                                \
    do                                                                  \
      if (N)                                                            \
        {                                                               \
          (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;        \
          (Current).first_column = YYRHSLOC (Rhs, 1).first_column;      \
          (Current).last_line    = YYRHSLOC (Rhs, N).last_line;         \
          (Current).last_column  = YYRHSLOC (Rhs, N).last_column;       \
        }                                                               \
      else                                                              \
        {                                                               \
          (Current).first_line   = (Current).last_line   =              \
            YYRHSLOC (Rhs, 0).last_line;                                \
          (Current).first_column = (Current).last_column =              \
            YYRHSLOC (Rhs, 0).last_column;                              \
        }                                                               \
    while (0)
#endif

#define YYRHSLOC(Rhs, K) ((Rhs)[K])


/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL

/* Print *YYLOCP on YYO.  Private, do not rely on its existence. */

YY_ATTRIBUTE_UNUSED
static int
yy_location_print_ (FILE *yyo, YYLTYPE const * const yylocp)
{
  int res = 0;
  int end_col = 0 != yylocp->last_column ? yylocp->last_column - 1 : 0;
  if (0 <= yylocp->first_line)
    {
      res += YYFPRINTF (yyo, "%d", yylocp->first_line);
      if (0 <= yylocp->first_column)
        res += YYFPRINTF (yyo, ".%d", yylocp->first_column);
    }
  if (0 <= yylocp->last_line)
    {
      if (yylocp->first_line < yylocp->last_line)
        {
          res += YYFPRINTF (yyo, "-%d", yylocp->last_line);
          if (0 <= end_col)
            res += YYFPRINTF (yyo, ".%d", end_col);
        }
      else if (0 <= end_col && yylocp->first_column < end_col)
        res += YYFPRINTF (yyo, "-%d", end_col);
    }
  return res;
 }

#  define YY_LOCATION_PRINT(File, Loc)          \
  yy_location_print_ (File, &(Loc))

# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value, Location, scanner, env); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp, yyscan_t scanner, long env[26])
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  YYUSE (yylocationp);
  YYUSE (scanner);
  YYUSE (env);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yytype], *yyvaluep);
# endif
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp, yyscan_t scanner, long env[26])
{
  YYFPRINTF (yyo, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  YY_LOCATION_PRINT (yyo, *yylocationp);
  YYFPRINTF (yyo, ": ");
  yy_symbol_value_print (yyo, yytype, yyvaluep, yylocationp, scanner, env);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp, YYLTYPE *yylsp, int yyrule, yyscan_t scanner, long env[26])
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[+yyssp[yyi + 1 - yynrhs]],
                       &yyvsp[(yyi + 1) - (yynrhs)]
                       , &(yylsp[(yyi + 1) - (yynrhs)])                       , scanner, env);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, yylsp, Rule, scanner, env); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen(S) (YY_CAST (YYPTRDIFF_T, strlen (S)))
#  else
/* Return the length of YYSTR.  */
static YYPTRDIFF_T
yystrlen (const char *yystr)
{
  YYPTRDIFF_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYPTRDIFF_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYPTRDIFF_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (yyres)
    return yystpcpy (yyres, yystr) - yyres;
  else
    return yystrlen (yystr);
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYPTRDIFF_T *yymsg_alloc, char **yymsg,
                yy_state_t *yyssp, int yytoken)
{
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat: reported tokens (one for the "unexpected",
     one per "expected"). */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Actual size of YYARG. */
  int yycount = 0;
  /* Cumulated lengths of YYARG.  */
  YYPTRDIFF_T yysize = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[+*yyssp];
      YYPTRDIFF_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
      yysize = yysize0;
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYPTRDIFF_T yysize1
                    = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
                    yysize = yysize1;
                  else
                    return 2;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    /* Don't count the "%s"s in the final size, but reserve room for
       the terminator.  */
    YYPTRDIFF_T yysize1 = yysize + (yystrlen (yyformat) - 2 * yycount) + 1;
    if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
      yysize = yysize1;
    else
      return 2;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          ++yyp;
          ++yyformat;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, YYLTYPE *yylocationp, yyscan_t scanner, long env[26])
{
  YYUSE (yyvaluep);
  YYUSE (yylocationp);
  YYUSE (scanner);
  YYUSE (env);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/*----------.
| yyparse.  |
`----------*/

int
yyparse (yyscan_t scanner, long env[26])
{
/* The lookahead symbol.  */
int yychar;


/* The semantic value of the lookahead symbol.  */
/* Default value used for initialization, for pacifying older GCCs
   or non-GCC compilers.  */
YY_INITIAL_VALUE (static YYSTYPE yyval_default;)
YYSTYPE yylval YY_INITIAL_VALUE (= yyval_default);

/* Location data for the lookahead symbol.  */
static YYLTYPE yyloc_default
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
  = { 1, 1, 1, 1 }
# endif
;
YYLTYPE yylloc = yyloc_default;

    /* Number of syntax errors so far.  */
    int yynerrs;

    yy_state_fast_t yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.
       'yyls': related to locations.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss;
    yy_state_t *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    /* The location stack.  */
    YYLTYPE yylsa[YYINITDEPTH];
    YYLTYPE *yyls;
    YYLTYPE *yylsp;

    /* The locations where the error started and ended.  */
    YYLTYPE yyerror_range[3];

    YYPTRDIFF_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;
  YYLTYPE yyloc;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYPTRDIFF_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N), yylsp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yylsp = yyls = yylsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  yylsp[0] = yylloc;
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;
        YYLTYPE *yyls1 = yyls;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yyls1, yysize * YYSIZEOF (*yylsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
        yyls = yyls1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
        YYSTACK_RELOCATE (yyls_alloc, yyls);
# undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;
      yylsp = yyls + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex (&yylval, &yylloc, scanner);
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END
  *++yylsp = yylloc;

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];

  /* Default location. */
  YYLLOC_DEFAULT (yyloc, (yylsp - yylen), yylen);
  yyerror_range[1] = yyloc;
  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 2:
#line 52 "parser.y"
                {
    printf("%s\n", (yyvsp[-1].identifier));
  }
#line 1590 "parser.tab.c"
    break;

  case 3:
#line 55 "parser.y"
          {
    printf("%s\n", (yyvsp[0].identifier));
  }
#line 1598 "parser.tab.c"
    break;

  case 4:
#line 61 "parser.y"
                                             {
          (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)) + 6);
          sprintf((yyval.identifier), "class %s", (yyvsp[-1].identifier));
          free((yyvsp[-1].identifier));
        }
#line 1608 "parser.tab.c"
    break;

  case 5:
#line 66 "parser.y"
                                              {
          (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)) + 7);
          sprintf((yyval.identifier), "struct %s", (yyvsp[-1].identifier));
          free((yyvsp[-1].identifier));
    }
#line 1618 "parser.tab.c"
    break;

  case 6:
#line 74 "parser.y"
                                      {
          (yyval.identifier) = MEM(strlen((yyvsp[-2].identifier)) + strlen((yyvsp[0].identifier)) + 2);
          sprintf((yyval.identifier), "%s\n%s", (yyvsp[-2].identifier), (yyvsp[0].identifier));
          free((yyvsp[-2].identifier));
          free((yyvsp[0].identifier));
        }
#line 1629 "parser.tab.c"
    break;

  case 7:
#line 81 "parser.y"
                              {
          (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)) + strlen((yyvsp[0].identifier)) + 1);
          sprintf((yyval.identifier), "%s %s", (yyvsp[-1].identifier), (yyvsp[0].identifier));
          free((yyvsp[-1].identifier));
          free((yyvsp[0].identifier));
        }
#line 1640 "parser.tab.c"
    break;

  case 8:
#line 90 "parser.y"
                  {
        (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)) + 6);
        sprintf((yyval.identifier), "%s final", (yyvsp[-1].identifier));
        free((yyvsp[-1].identifier));
      }
#line 1650 "parser.tab.c"
    break;

  case 9:
#line 95 "parser.y"
            {
        (yyval.identifier) = MEM(strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "%s", (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
      }
#line 1660 "parser.tab.c"
    break;

  case 10:
#line 103 "parser.y"
                                                                          {
          if (env[0] > TAB) {
          char* less_indent = make_tabs(env[0] - TAB);
          (yyval.identifier) = MEM(strlen((yyvsp[-2].identifier)) + 5 + strlen(less_indent));
          sprintf((yyval.identifier), "{\n%s%s};", (yyvsp[-2].identifier), less_indent);
          free((yyvsp[-2].identifier));
          free(less_indent);
        } else {
          (yyval.identifier) = MEM(strlen((yyvsp[-3].identifier)) + 6);
          sprintf((yyval.identifier), "{\n%s};", (yyvsp[-2].identifier));
          free((yyvsp[-2].identifier));
        }
      }
#line 1678 "parser.tab.c"
    break;

  case 11:
#line 117 "parser.y"
                                                                  {
        if (env[0] > TAB) {
          char* less_indent = make_tabs(env[0] - TAB);
          (yyval.identifier) = MEM(strlen((yyvsp[-2].identifier)) + 6 + strlen(less_indent));
          sprintf((yyval.identifier), "{\n%s%s};", (yyvsp[-2].identifier), less_indent);
          free((yyvsp[-2].identifier));
          free(less_indent);
        } else {
          (yyval.identifier) = MEM(strlen((yyvsp[-2].identifier)) + 6);
          sprintf((yyval.identifier), "{\n%s};", (yyvsp[-2].identifier));
          free((yyvsp[-2].identifier));
        }
      }
#line 1696 "parser.tab.c"
    break;

  case 12:
#line 130 "parser.y"
                                                          {
        (yyval.identifier) = MEM(strlen((yyvsp[-2].identifier)) + 5);
        sprintf((yyval.identifier), "{%s};", (yyvsp[-2].identifier));
        free((yyvsp[-2].identifier));
    }
#line 1706 "parser.tab.c"
    break;

  case 13:
#line 138 "parser.y"
                              {
        (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)) + strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "%s%s", (yyvsp[-1].identifier), (yyvsp[0].identifier));
        free((yyvsp[-1].identifier));
      }
#line 1716 "parser.tab.c"
    break;

  case 14:
#line 143 "parser.y"
                   {
        (yyval.identifier) = MEM(strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "%s", (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
    }
#line 1726 "parser.tab.c"
    break;

  case 15:
#line 151 "parser.y"
                                                                               {
        char* indent = make_tabs(env[0]);
        (yyval.identifier) = MEM(strlen((yyvsp[-6].identifier)) + strlen((yyvsp[-2].identifier)) + strlen((yyvsp[0].identifier)) + 3 + strlen(indent));
        sprintf((yyval.identifier), "%s%s:\n%s%s", indent, (yyvsp[-6].identifier), (yyvsp[-2].identifier), (yyvsp[0].identifier));
        free((yyvsp[-6].identifier));
        free((yyvsp[-2].identifier));
        free(indent);
      }
#line 1739 "parser.tab.c"
    break;

  case 16:
#line 159 "parser.y"
             {
        (yyval.identifier) = "";
    }
#line 1747 "parser.tab.c"
    break;

  case 17:
#line 165 "parser.y"
                             {
        (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)) + 2);
        sprintf((yyval.identifier), "%s\n", (yyvsp[-1].identifier));
        free((yyvsp[-1].identifier));
        free((yyvsp[0].identifier));
      }
#line 1758 "parser.tab.c"
    break;

  case 18:
#line 174 "parser.y"
                         {
      (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)) + strlen((yyvsp[0].identifier)));
      sprintf((yyval.identifier), "%s%s", (yyvsp[-1].identifier), (yyvsp[0].identifier));
      free((yyvsp[-1].identifier));
      free((yyvsp[0].identifier));
    }
#line 1769 "parser.tab.c"
    break;

  case 19:
#line 180 "parser.y"
              {
      (yyval.identifier) = MEM(strlen((yyvsp[0].identifier)));
      sprintf((yyval.identifier), "%s", (yyvsp[0].identifier));
      free((yyvsp[0].identifier));
  }
#line 1779 "parser.tab.c"
    break;

  case 20:
#line 188 "parser.y"
                  {
        char* indent = make_tabs(env[0]);
        (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)) + strlen(indent) + 2);
        sprintf((yyval.identifier), "%s%s\n", indent, (yyvsp[-1].identifier));
        free((yyvsp[-1].identifier));
        free(indent);
    }
#line 1791 "parser.tab.c"
    break;

  case 21:
#line 196 "parser.y"
          {
        char* indent = make_tabs(env[0]);
        (yyval.identifier) = MEM(strlen((yyvsp[0].identifier)) + strlen(indent));
        sprintf((yyval.identifier), "%s%s", indent, (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
        free(indent);
    }
#line 1803 "parser.tab.c"
    break;

  case 22:
#line 203 "parser.y"
                          {
        char* indent = make_tabs(env[0]);
        (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)) + strlen(indent) + 2);
        sprintf((yyval.identifier), "%s%s\n", indent, (yyvsp[-1].identifier));
        free((yyvsp[-1].identifier));
        free((yyvsp[0].identifier));
        free(indent);
    }
#line 1816 "parser.tab.c"
    break;

  case 23:
#line 211 "parser.y"
                   {
        char* indent = make_tabs(env[0]);
        (yyval.identifier) = MEM(strlen((yyvsp[0].identifier)) + strlen(indent));
        sprintf((yyval.identifier), "%s%s", indent, (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
        free(indent);
    }
#line 1828 "parser.tab.c"
    break;

  case 24:
#line 219 "parser.y"
                                 {
        char* indent = make_tabs(env[0]);
        (yyval.identifier) = MEM(strlen((yyvsp[-2].identifier)) + strlen((yyvsp[-1].identifier)) + 3 + strlen(indent));
        sprintf((yyval.identifier), "%s%s%s\n", indent, (yyvsp[-2].identifier), (yyvsp[-1].identifier));
        free((yyvsp[-2].identifier));
        free((yyvsp[-1].identifier));
        free((yyvsp[0].identifier));
        free(indent);
    }
#line 1842 "parser.tab.c"
    break;

  case 25:
#line 228 "parser.y"
                            {
        char* indent = make_tabs(env[0]);
        (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)) + strlen((yyvsp[0].identifier)) + 1 + strlen(indent));
        sprintf((yyval.identifier), "%s%s%s", indent, (yyvsp[-1].identifier), (yyvsp[0].identifier));
        free((yyvsp[-1].identifier));
        free((yyvsp[0].identifier));
        free(indent);
    }
#line 1855 "parser.tab.c"
    break;

  case 26:
#line 236 "parser.y"
                                           {
        char* indent = make_tabs(env[0]);
        (yyval.identifier) = MEM(strlen((yyvsp[-3].identifier)) + strlen((yyvsp[-2].identifier)) + 4 + strlen(indent));
        sprintf((yyval.identifier), "%s%s%s;\n", indent, (yyvsp[-3].identifier), (yyvsp[-2].identifier));
        free((yyvsp[-3].identifier));
        free((yyvsp[-2].identifier));
        free(indent);
    }
#line 1868 "parser.tab.c"
    break;

  case 27:
#line 244 "parser.y"
                                   {
        char* indent = make_tabs(env[0]);
        (yyval.identifier) = MEM(strlen((yyvsp[-2].identifier)) + strlen((yyvsp[-1].identifier)) + 1 + strlen(indent));
        sprintf((yyval.identifier), "%s%s%s;", indent, (yyvsp[-2].identifier), (yyvsp[-1].identifier));
        free((yyvsp[-2].identifier));
        free((yyvsp[-1].identifier));
        free(indent);
    }
#line 1881 "parser.tab.c"
    break;

  case 28:
#line 252 "parser.y"
               {
        char* indent = make_tabs(env[0]);
        (yyval.identifier) = MEM(strlen((yyvsp[0].identifier)) + 2 + strlen(indent));
        sprintf((yyval.identifier), "%s//%s", indent, (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
        free(indent);
    }
#line 1893 "parser.tab.c"
    break;

  case 29:
#line 262 "parser.y"
                           {
        (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)));
        sprintf((yyval.identifier), "%s ", (yyvsp[-1].identifier));
        free((yyvsp[-1].identifier));
    }
#line 1903 "parser.tab.c"
    break;

  case 30:
#line 267 "parser.y"
                   {
        (yyval.identifier) = MEM(strlen((yyvsp[0].identifier)) + 1);
        sprintf((yyval.identifier), "%s ", (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
  }
#line 1913 "parser.tab.c"
    break;

  case 31:
#line 275 "parser.y"
                                 {
        (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)) + strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "%s%s", (yyvsp[-1].identifier), (yyvsp[0].identifier));
        free((yyvsp[-1].identifier));
        free((yyvsp[0].identifier));
      }
#line 1924 "parser.tab.c"
    break;

  case 32:
#line 281 "parser.y"
                                         {
        (yyval.identifier) = MEM(strlen((yyvsp[-2].identifier)) + strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "%s%s", (yyvsp[-2].identifier), (yyvsp[0].identifier));
        free((yyvsp[-2].identifier));
        free((yyvsp[0].identifier));
    }
#line 1935 "parser.tab.c"
    break;

  case 33:
#line 290 "parser.y"
                                      {
        (yyval.identifier) = MEM(strlen((yyvsp[0].identifier)) + 1);
        sprintf((yyval.identifier), "(%s", (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
    }
#line 1945 "parser.tab.c"
    break;

  case 34:
#line 298 "parser.y"
                                          {
        (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)) + strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "%s%s", (yyvsp[-1].identifier), (yyvsp[0].identifier));
        free((yyvsp[-1].identifier));
        free((yyvsp[0].identifier));
      }
#line 1956 "parser.tab.c"
    break;

  case 35:
#line 307 "parser.y"
                                           {
       (yyval.identifier) = MEM(strlen((yyvsp[0].identifier)) + 1);
       sprintf((yyval.identifier), ")%s", (yyvsp[0].identifier));
       free((yyvsp[0].identifier));
    }
#line 1966 "parser.tab.c"
    break;

  case 36:
#line 312 "parser.y"
                                   {
       (yyval.identifier) = MEM(strlen((yyvsp[0].identifier)) + 1);
       sprintf((yyval.identifier), ")%s", (yyvsp[0].identifier));
       free((yyvsp[0].identifier));
  }
#line 1976 "parser.tab.c"
    break;

  case 37:
#line 320 "parser.y"
                                       {
       (yyval.identifier) = MEM(strlen((yyvsp[0].identifier)) + strlen("{"));
       sprintf((yyval.identifier), "{%s", (yyvsp[0].identifier));
       free((yyvsp[0].identifier));
    }
#line 1986 "parser.tab.c"
    break;

  case 38:
#line 325 "parser.y"
                               {
       (yyval.identifier) = MEM(strlen((yyvsp[0].identifier)) + strlen("{"));
       sprintf((yyval.identifier), "{%s", (yyvsp[0].identifier));
       free((yyvsp[0].identifier));
  }
#line 1996 "parser.tab.c"
    break;

  case 39:
#line 333 "parser.y"
                                  {
       (yyval.identifier) = MEM(strlen("}") + 1);
       sprintf((yyval.identifier), "};");
    }
#line 2005 "parser.tab.c"
    break;

  case 40:
#line 337 "parser.y"
                          {
       (yyval.identifier) = MEM(strlen("}") + 1);
       sprintf((yyval.identifier), "};");
  }
#line 2014 "parser.tab.c"
    break;

  case 41:
#line 344 "parser.y"
                                    {
        (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)) + strlen((yyvsp[0].identifier)) + 1);
        sprintf((yyval.identifier), "%s %s", (yyvsp[-1].identifier), (yyvsp[0].identifier));
        free((yyvsp[-1].identifier));
        free((yyvsp[0].identifier));
      }
#line 2025 "parser.tab.c"
    break;

  case 42:
#line 350 "parser.y"
                                        {
        (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)) + strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "%s%s", (yyvsp[-1].identifier), (yyvsp[0].identifier));
        free((yyvsp[-1].identifier));
        free((yyvsp[0].identifier));
      }
#line 2036 "parser.tab.c"
    break;

  case 43:
#line 356 "parser.y"
                            {
        (yyval.identifier) = MEM(0);
        (yyval.identifier)[0] = '\0';
        free((yyvsp[0].identifier));
    }
#line 2046 "parser.tab.c"
    break;

  case 44:
#line 361 "parser.y"
             {
        (yyval.identifier) = MEM(0);
        (yyval.identifier)[0] = '\0';
    }
#line 2055 "parser.tab.c"
    break;

  case 45:
#line 368 "parser.y"
                                {
        (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)) + strlen((yyvsp[0].identifier)) + 1);
        sprintf((yyval.identifier), "%s%s", (yyvsp[-1].identifier), (yyvsp[0].identifier));
        free((yyvsp[-1].identifier));
        free((yyvsp[0].identifier));
      }
#line 2066 "parser.tab.c"
    break;

  case 46:
#line 374 "parser.y"
                             {
        (yyval.identifier) = MEM(strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "%s", (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
    }
#line 2076 "parser.tab.c"
    break;

  case 47:
#line 381 "parser.y"
                                                    {
        (yyval.identifier) = MEM(strlen((yyvsp[-2].identifier)) + strlen((yyvsp[-1].identifier)) + strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), ", %s %s%s", (yyvsp[-2].identifier), (yyvsp[-1].identifier), (yyvsp[0].identifier));
        free((yyvsp[-2].identifier));
        free((yyvsp[-1].identifier));
        free((yyvsp[0].identifier));
      }
#line 2088 "parser.tab.c"
    break;

  case 48:
#line 388 "parser.y"
                                                             {
        (yyval.identifier) = MEM(strlen((yyvsp[-3].identifier)) + strlen((yyvsp[-1].identifier)) + strlen((yyvsp[0].identifier)) + 3);
        sprintf((yyval.identifier), ", %s %s%s", (yyvsp[-3].identifier), (yyvsp[-1].identifier), (yyvsp[0].identifier));
        free((yyvsp[-3].identifier));
        free((yyvsp[-1].identifier));
        free((yyvsp[0].identifier));
      }
#line 2100 "parser.tab.c"
    break;

  case 49:
#line 395 "parser.y"
                                              {
        (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)) + strlen((yyvsp[0].identifier)) + 2);
        sprintf((yyval.identifier), ", %s%s", (yyvsp[-1].identifier), (yyvsp[0].identifier));
        free((yyvsp[-1].identifier));
        free((yyvsp[0].identifier));
      }
#line 2111 "parser.tab.c"
    break;

  case 50:
#line 401 "parser.y"
                                 {
        (yyval.identifier) = MEM(strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "%s", (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
    }
#line 2121 "parser.tab.c"
    break;

  case 51:
#line 406 "parser.y"
             {
        (yyval.identifier) = MEM(0);
        (yyval.identifier)[0] = '\0';
      }
#line 2130 "parser.tab.c"
    break;

  case 52:
#line 413 "parser.y"
                           {
        (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)) + strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "%s%s", (yyvsp[-1].identifier), (yyvsp[0].identifier));
        free((yyvsp[-1].identifier));
        free((yyvsp[0].identifier));
      }
#line 2141 "parser.tab.c"
    break;

  case 53:
#line 419 "parser.y"
            {
        (yyval.identifier) = MEM(strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "%s", (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
    }
#line 2151 "parser.tab.c"
    break;

  case 54:
#line 427 "parser.y"
                                 {
        (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)) + 2 + strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), ", %s%s", (yyvsp[-1].identifier), (yyvsp[0].identifier));
        free((yyvsp[-1].identifier));
        free((yyvsp[0].identifier));
      }
#line 2162 "parser.tab.c"
    break;

  case 55:
#line 433 "parser.y"
                  {
        (yyval.identifier) = MEM(strlen((yyvsp[0].identifier)) + 2);
        sprintf((yyval.identifier), ", %s", (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
      }
#line 2172 "parser.tab.c"
    break;

  case 56:
#line 441 "parser.y"
                 {
        (yyval.identifier) = MEM(strlen("public"));
        sprintf((yyval.identifier), "public");
      }
#line 2181 "parser.tab.c"
    break;

  case 57:
#line 445 "parser.y"
                    {
        (yyval.identifier) = MEM(strlen("protected"));
        sprintf((yyval.identifier), "protected");
      }
#line 2190 "parser.tab.c"
    break;

  case 58:
#line 449 "parser.y"
                  {
        (yyval.identifier) = MEM(strlen("private "));
        sprintf((yyval.identifier), "private");
      }
#line 2199 "parser.tab.c"
    break;

  case 59:
#line 456 "parser.y"
                         {
        (yyval.identifier) = MEM(strlen("char") + strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "char%s", (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
      }
#line 2209 "parser.tab.c"
    break;

  case 60:
#line 461 "parser.y"
                         {
        (yyval.identifier) = MEM(strlen("bool") + strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "bool%s", (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
      }
#line 2219 "parser.tab.c"
    break;

  case 61:
#line 466 "parser.y"
                          {
        (yyval.identifier) = MEM(strlen("short") + strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "short%s", (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
      }
#line 2229 "parser.tab.c"
    break;

  case 62:
#line 471 "parser.y"
                        {
        (yyval.identifier) = MEM(strlen("int") + strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "int%s", (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
      }
#line 2239 "parser.tab.c"
    break;

  case 63:
#line 476 "parser.y"
                         {
        (yyval.identifier) = MEM(strlen("long") + strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "long%s", (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
      }
#line 2249 "parser.tab.c"
    break;

  case 64:
#line 481 "parser.y"
                          {
        (yyval.identifier) = MEM(strlen("float") + strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "float%s", (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
      }
#line 2259 "parser.tab.c"
    break;

  case 65:
#line 486 "parser.y"
                           {
        (yyval.identifier) = MEM(strlen("double") + strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "double%s", (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
      }
#line 2269 "parser.tab.c"
    break;

  case 66:
#line 491 "parser.y"
                         {
        (yyval.identifier) = MEM(strlen("void") + strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "void%s", (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
      }
#line 2279 "parser.tab.c"
    break;

  case 67:
#line 496 "parser.y"
                         {
        (yyval.identifier) = MEM(strlen("auto") + strlen((yyvsp[0].identifier)));
        sprintf((yyval.identifier), "auto%s", (yyvsp[0].identifier));
        free((yyvsp[0].identifier));
      }
#line 2289 "parser.tab.c"
    break;

  case 68:
#line 504 "parser.y"
                       {
        (yyval.identifier) = MEM(1);
        sprintf((yyval.identifier), "*");
      }
#line 2298 "parser.tab.c"
    break;

  case 69:
#line 508 "parser.y"
             {
        (yyval.identifier) = MEM(0);
        (yyval.identifier)[0] = '\0';
      }
#line 2307 "parser.tab.c"
    break;

  case 70:
#line 515 "parser.y"
                   {
        (yyval.identifier) = MEM(strlen((yyvsp[-1].identifier)) + strlen((yyvsp[0].identifier)) + 1);
        sprintf((yyval.identifier), "%s %s", (yyvsp[-1].identifier), (yyvsp[0].identifier));
        free((yyvsp[-1].identifier));
        free((yyvsp[0].identifier));
      }
#line 2318 "parser.tab.c"
    break;

  case 71:
#line 521 "parser.y"
            {
      (yyval.identifier) = MEM(strlen((yyvsp[0].identifier)));
      sprintf((yyval.identifier), "%s", (yyvsp[0].identifier));
      free((yyvsp[0].identifier));
    }
#line 2328 "parser.tab.c"
    break;

  case 72:
#line 529 "parser.y"
                 {
        (yyval.identifier) = MEM(strlen(yylval.identifier));
        sprintf((yyval.identifier), "%s", yylval.identifier);
      }
#line 2337 "parser.tab.c"
    break;

  case 73:
#line 536 "parser.y"
           {
      (yyval.identifier) = MEM(0);
      (yyval.identifier)[0] = '\0';
      env[0] += TAB;
    }
#line 2347 "parser.tab.c"
    break;

  case 74:
#line 544 "parser.y"
           {
      (yyval.identifier) = MEM(0);
      (yyval.identifier)[0] = '\0';
      env[0] -= TAB;
    }
#line 2357 "parser.tab.c"
    break;

  case 75:
#line 552 "parser.y"
              {
        (yyval.identifier) = MEM(2);
        sprintf((yyval.identifier), "\n");
      }
#line 2366 "parser.tab.c"
    break;


#line 2370 "parser.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;
  *++yylsp = yyloc;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (&yylloc, scanner, env, YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = YY_CAST (char *, YYSTACK_ALLOC (YY_CAST (YYSIZE_T, yymsg_alloc)));
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (&yylloc, scanner, env, yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }

  yyerror_range[1] = yylloc;

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval, &yylloc, scanner, env);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;

      yyerror_range[1] = *yylsp;
      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp, yylsp, scanner, env);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  yyerror_range[2] = yylloc;
  /* Using YYLLOC is tempting, but would change the location of
     the lookahead.  YYLOC is available though.  */
  YYLLOC_DEFAULT (yyloc, yyerror_range, 2);
  *++yylsp = yyloc;

  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;


#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (&yylloc, scanner, env, YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif


/*-----------------------------------------------------.
| yyreturn -- parsing is finished, return the result.  |
`-----------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval, &yylloc, scanner, env);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[+*yyssp], yyvsp, yylsp, scanner, env);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 558 "parser.y"


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
