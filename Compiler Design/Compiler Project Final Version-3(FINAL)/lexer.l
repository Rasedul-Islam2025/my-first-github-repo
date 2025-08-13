%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include <math.h>
    #include "parser.tab.h"  // Note: Must match Bison output
%}

variable [a-zA-Z]
digit [0-9]+
header "import ".*
Comment "#".*

%%

"CASE"              { return CASE; }
"SWITCH"            { return SWITCH; }
"DEFAULT"           { return DEFAULT; }
{digit}             { yylval = atoi(yytext); return NUM; }
"PRINTFUNCTION"     { return PRINTFUNCTION; }
"IF"                { return IF; }
"ELSE"              { return ELSE; }
"{"                 { return BRACKETSTART; }
"}"                 { return BRACKETEND; }
"FOR"               { return FOR; }
"WHILE"             { return WHILE; }
"FACTORIAL"         { return FACTORIAL; }
"ODDEVEN"           { return ODDEVEN; }
"SIN"               { return SIN; }
"COS"               { return COS; }
"TAN"               { return TAN; }
"LOG"               { return LOG; }
"INTEGER"           { return INT; }
"CHAR"              { return CHAR; }
"FLOAT"             { return FLOAT; }
"ARRAY"             { return ARRAY; }
"TRY"               { return TRY; }
"CATCH"             { return CATCH; }
"FUNCTION"          { printf("FUNCTION "); return FUNCTION; }
"CLASS"             { printf("New Class  Name : "); return CLASS; }
"Main"              { printf("\nMain Function Start\n"); return MAIN; }

{Comment}           { printf("\nSingle line Comment found :: %s\n", yytext); }
{header}            { printf("\nHeader file found :\n%s\n", yytext); }

[-+/*<>=,():;%^]     { yylval = yytext[0]; return *yytext; }
{variable}          { yylval = *yytext - 'a'; ECHO; printf("\n"); return VAR; }

[ \t]+              ; /* Skip spaces and tabs */
[\n]                ; /* Skip newlines */
.                   { printf("\nUnknown Syntax: %s\n", yytext); }

%%