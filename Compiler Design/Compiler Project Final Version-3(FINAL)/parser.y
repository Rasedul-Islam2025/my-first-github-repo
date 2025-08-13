%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>

    extern int yylex();
    void yyerror(const char *s);

    int sym[30];  // Symbol table for variables (a=0, b=1,...)

    // Counters
    int variablenumber = 0;
    int expressionnumber = 0;
    int variableassignment = 0;
    int switchnumber = 0;
    int printnumber = 0;
    int fornumber = 0;
    int arraynumber = 0;
    int classnumber = 0;
    int trycatchnumber = 0;
    int functionnumber = 0;
    int whilenumber = 0;
    int mathexpressionnumber = 0;
    int ifelsenumber = 0;
%}

%token NUM VAR IF ELSE ARRAY MAIN INT FLOAT CHAR BRACKETSTART BRACKETEND FOR WHILE ODDEVEN PRINTFUNCTION SIN COS TAN LOG FACTORIAL CASE DEFAULT SWITCH CLASS TRY CATCH FUNCTION
%nonassoc IFX
%nonassoc ELSE

%left '<' '>'
%left '+' '-'
%left '*' '/'
%left '^'

%%

program : MAIN ':' BRACKETSTART line BRACKETEND
        { printf("Main function END\n"); }
        ;

line : /* empty */
     | line statement
     ;

statement : ';'
          | declaration ';'
            { printf("Declaration\n"); variablenumber++; }

          | expression ';'
            { printf("\nvalue of expression: %d\n", $1);
              printf("\n.........................................\n");
              expressionnumber++; }

          | VAR '=' expression ';'
            { printf("\nValue of the variable: %d\n", $3);
              sym[$1] = $3;
              variableassignment++;
              printf("\n.........................................\n"); }

          | WHILE '(' expression '<' expression ')' BRACKETSTART statement BRACKETEND
            { int i;
              printf("WHILE Loop execution\n");
              for(i = $3; i < $5; i++)
                  printf("value of the loop: %d, expression value: %d\n", i, $8);
              printf("\n.........................................\n");
              whilenumber++; }

          | IF '(' expression ')' BRACKETSTART statement BRACKETEND %prec IFX
            { if($3) printf("value of expression in IF: %d\n", $6);
              else printf("condition value zero in IF block\n");
              printf("\n.........................................\n");
              ifelsenumber++; }

          | IF '(' expression ')' BRACKETSTART statement BRACKETEND ELSE BRACKETSTART statement BRACKETEND
            { if($3) printf("value of expression in IF: %d\n", $6);
              else printf("value of expression in ELSE: %d\n", $11);
              printf("\n.........................................\n");
              ifelsenumber++; }

          | PRINTFUNCTION '(' expression ')' ';'
            { printf("\nPrint Expression %d\n", $3);
              printnumber++;
              printf("\n.........................................\n"); }

          | FACTORIAL '(' NUM ')' ';'
            { int f = 1;
              for(int i = 1; i <= $3; i++) f *= i;
              printf("\nFACTORIAL declaration\n");
              printf("FACTORIAL of %d is: %d\n", $3, f);
              printf("\n.........................................\n");
              functionnumber++; }

          | ODDEVEN '(' NUM ')' ';'
            { printf("Odd Even Number detection\n");
              if($3 % 2 == 0)
                  printf("Number: %d is -> Even\n", $3);
              else
                  printf("Number: %d is -> Odd\n", $3);
              printf("\n.........................................\n");
              functionnumber++; }

          | FUNCTION VAR '(' expression ')' BRACKETSTART statement BRACKETEND
            { printf("FUNCTION found:\n");
              printf("Function Parameter: %d\n", $4);
              printf("Function internal block statement: %d\n", $7);
              printf("\n.........................................\n");
              functionnumber++; }

          | ARRAY TYPE VAR '(' NUM ')' ';'
            { printf("ARRAY Declaration\n");
              printf("Size of the ARRAY is: %d\n", $5);
              arraynumber++;
              printf("\n.........................................\n"); }

          | SWITCH '(' NUM ')' BRACKETSTART SWITCHCASE BRACKETEND
            { printf("\nSWITCH CASE Declaration\n");
              printf("Finally Choose Case number:-> %d\n", $3);
              printf("\n.........................................\n");
              switchnumber++; }

          | CLASS VAR BRACKETSTART statement BRACKETEND
            { printf("Class Declaration\n");
              printf("Expression: %d\n", $4);
              classnumber++; }

          | CLASS VAR ':' VAR BRACKETSTART statement BRACKETEND
            { printf("Inheritance occur\n");
              printf("Expression value: %d\n", $6);
              classnumber++; }

          | TRY BRACKETSTART statement BRACKETEND CATCH '(' expression ')' BRACKETSTART statement BRACKETEND
            { printf("TRY CATCH block found\n");
              printf("TRY Block operation: %d\n", $3);
              printf("CATCH Value: %d\n", $7);
              printf("Catch Block operation: %d\n", $10);
              printf("\n.........................................\n");
              trycatchnumber++; }

          | FOR '(' expression ',' expression ',' expression ')' BRACKETSTART statement BRACKETEND
            { printf("FOR Loop execution\n");
              for(int i = $3; i < $5; i += $7)
                  printf("value of i: %d, expression value: %d\n", i, $10);
              printf("\n.........................................\n");
              fornumber++; }
          ;

declaration : TYPE ID1
            { printf("\nvariable Dection\n");
              printf("\n.........................................\n"); }
            ;

TYPE : INT    { printf("interger declaration\n"); }
     | FLOAT  { printf("float declaration\n"); }
     | CHAR   { printf("char declaration\n"); }
     ;

ID1 : ID1 ',' VAR
    | VAR
    ;

SWITCHCASE : casegrammer
           | casegrammer defaultgrammer
           ;

casegrammer : /* empty */
            | casegrammer casenumber
            ;

casenumber : CASE NUM ':' expression ';'
           { printf("Case No: %d & expression value: %d\n", $2, $4); }
           ;

defaultgrammer : DEFAULT ':' expression ';'
               { printf("Default case & expression value: %d\n", $3); }
               ;

expression : NUM
           { printf("Number: %d\n", $1); $$ = $1; }

         | VAR
           { $$ = sym[$1]; }

         | expression '+' expression
           { printf("Addition: %d + %d = %d\n", $1, $3, $1 + $3); $$ = $1 + $3; }

         | expression '-' expression
           { printf("Subtraction: %d - %d = %d\n", $1, $3, $1 - $3); $$ = $1 - $3; }

         | expression '*' expression
           { printf("Multiplication: %d * %d = %d\n", $1, $3, $1 * $3); $$ = $1 * $3; }

         | expression '/' expression
           { if($3 != 0) {
                 printf("Division: %d / %d = %d\n", $1, $3, $1 / $3);
                 $$ = $1 / $3;
             } else {
                 printf("division by zero\n");
                 $$ = 0;
             } }

         | expression '%' expression
           { if($3 != 0) {
                 printf("Mod: %d %% %d = %d\n", $1, $3, $1 % $3);
                 $$ = $1 % $3;
             } else {
                 printf("MOD by zero\n");
                 $$ = 0;
             } }

         | expression '^' expression
           { $$ = (int)pow($1, $3);
             printf("Power: %d ^ %d = %d\n", $1, $3, $$); }

         | expression '<' expression
           { $$ = ($1 < $3); }

         | expression '>' expression
           { $$ = ($1 > $3); }

         | '(' expression ')'
           { $$ = $2; }

         | SIN expression
           { double result = sin($2 * 3.1416 / 180);
             printf("Value of Sin(%d) = %.6f\n", $2, result);
             $$ = (int)result; }

         | COS expression
           { double result = cos($2 * 3.1416 / 180);
             printf("Value of Cos(%d) = %.6f\n", $2, result);
             $$ = (int)result; }

         | LOG expression
           { if($2 > 0) {
                 double result = log($2);
                 printf("Value of Log(%d) = %.6f\n", $2, result);
                 $$ = (int)result;
             } else {
                 printf("Log of non-positive number\n");
                 $$ = 0;
             } }
         ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int yywrap() {
    return 1;
}

int main() {
    printf("Starting parser...\n");
    yyparse();

    printf("\n**********************************\n");
    printf("All the input parsing complete\n");
    printf("**********************************\n");

    printf("Number of array: %d\n", arraynumber);
    printf("Number of if else: %d\n", ifelsenumber);
    printf("Number of while loop: %d\n", whilenumber);
    printf("Number of for loop: %d\n", fornumber);
    printf("Number of SWITCHCASE: %d\n", switchnumber);
    printf("Number of class: %d\n", classnumber);
    printf("Number of Print function: %d\n", printnumber);
    printf("Number of try catch: %d\n", trycatchnumber);
    printf("Number of variable declaration: %d\n", variablenumber);
    printf("Number of variable assignment: %d\n", variableassignment);
    printf("Number of expression: %d\n", expressionnumber);

    printf("\n**********************************\n");
    printf("Name: Rasedul, Sourav, Sifar, Tahsin, Toha\n");
    printf("Section: A2\n");
    printf("Department: CSE\n");
    printf("University: DIU\n");
    printf("**********************************\n");

    return 0;
}