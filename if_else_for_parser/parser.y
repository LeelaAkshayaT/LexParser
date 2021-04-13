/* Definition section */


%{ 

    #include <stdio.h> 
    #include <string.h>    
    #include <stdlib.h> 
    extern int yylex(void);
    int yyerror(const char *msg);
    int success = 1; 
    int errors = 0;
    int yycolumn = 0;
    FILE *yyin;
      
%} 

%union 
{ 
   char* f; 
} 
%token IF FOR ID UNARY_OP OP NUM
%left '+''-'  
%left '*''/'  
%right '^'  
%right '='
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
 
/* Rules Section */

%%
   STMTS :   STMTS STMT
         |   /* %empty */
         ;

   STMT  :   ';'
         |   EXPR ';'
         |   IF '('EXPR')' STMT  %prec LOWER_THAN_ELSE
         |   IF '('EXPR')' STMT ELSE STMT
         |   FOR '('EXPR';'EXPR';'EXPR')' STMT
         |   '{'STMTS'}'
         ;
   
   EXPR  :  TERM
         |  ID UNARY_OP
         |  UNARY_OP ID
         |  TERM OP EXPR
         |  ID '=' EXPR
         |  error
         ;
   
   TERM  :  ID
         |  NUM
         ;
%% 
  

/* Auxiliary Routines */



int main(int argc, char *argv[]) {
    extern int yylineno;
    yyin = fopen(argv[1], "r");
    yyparse();
    fclose(yyin);
    if(success) {
        printf("OK\n");
    }
    else {
        printf("\nParsing failed due to %d error(s)\n", errors);
    }
    return 0;
}

int yyerror(const char *msg) {
    extern char* yytext;
    extern int yylineno;
    extern int yycolumn;
    printf("\nProblem occured at line number %d, column number %d, near '%s'\nError: %s\n", yylineno, yycolumn, yytext, msg);
    errors++;
    success = 0;
    return 1;
}

