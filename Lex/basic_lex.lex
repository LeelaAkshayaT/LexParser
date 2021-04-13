%option noyywrap

%{
   #include <stdio.h>
   #include <stdlib.h>
   #include <string.h>
   int lineno = 1; // initialize to 1
   int n=0; // to count total number of tokens
   int kn=0; 
   int on=0; 
   int sn=0; 
   int idn=0; 
   int iconstn=0; 
   int fconstn=0; 
   int cconstn=0; 
   int stringn=0;
   void ret_print(char *token_type);
   void yyerror();
   void total();
%}

%x ML_COMMENT

alpha      [a-zA-Z]
digit      [0-9]
alnum      {alpha}|{digit}
print      [ -~]

ID         {alpha}+{alnum}*
ICONST      "0"|[0-9]{digit}*
FCONST      "0"|{digit}*"."{digit}+
CCONST      (\'{print}\')|(\'\\[nftrbv]\')
STRING      \"{print}*\"

%%

"//".*		{ 
                FILE *p;
                p = fopen("out.txt", "a");
                fprintf(p,"Found comment at line %d\n", lineno); 
                fclose(p);
            } 

"/*"		{ 
                FILE *p;
                p = fopen("out.txt", "a");
                fprintf(p,"Found comment from line %d ", lineno); BEGIN(ML_COMMENT); 
                fclose(p);
            }
<ML_COMMENT>"*/" 	{ 
                        FILE *p;
                        p = fopen("out.txt", "a");
                        fprintf(p,"to line %d\n", lineno); BEGIN(INITIAL); 
                        fclose(p);
                    }
<ML_COMMENT>[^*\n]+		
<ML_COMMENT>"*"			
<ML_COMMENT>"\n"	{ lineno += 1; }

"#".*   { FILE *p;
          p = fopen("out.txt", "a"); 
          fprintf(p,"preprocessor directive at line %d \n", lineno);
          fclose(p);
}


"char"|"CHAR"          { ret_print("KEYWORD_CHAR"); kn++;}
"int"|"INT"            { ret_print("KEYWORD_INT"); kn++;}
"float"|"FLOAT"        { ret_print("KEYWORD_FLOAT"); kn++;}
"double"|"DOUBLE"      { ret_print("KEYWORD_DOUBLE");kn++; }
"if"|"IF"              { ret_print("KEYWORD_IF"); kn++;}
"else"|"ELSE"          { ret_print("KEYWORD_ELSE");kn++; }
"while"|"WHILE"	       { ret_print("KEYWORD_WHILE"); kn++; }
"for"|"FOR"	       { ret_print("KEYWORD_FOR"); kn++;}
"continue"|"CONTINUE"  { ret_print("KEYWORD_CONTINUE"); kn++;}
"break"|"BREAK"	       { ret_print("KEYWORD_BREAK");kn++; }
"void"|"VOID"	       { ret_print("KEYWORD_VOID");kn++; }
"return"|"RETURN"      { ret_print("KEYWORD_RETURN"); kn++;}
"switch"|"SWITCH"      { ret_print("KEYWORD_SWITCH"); kn++;}
"case"|"CASE"          { ret_print("KEYWORD_CASE"); kn++;}
"default"|"DEFAULT"    { ret_print("KEYWORD_DEFAULT"); kn++;}

"printf"|"scanf"|"gets"|"puts"|"getc"|"putc"  { ret_print("INBUILT_FUNCTIONS"); n++;}

"+"      { ret_print("ADDOP"); on++; }
"-"      { ret_print("SUBOP"); on++; }
"*"	     { ret_print("MULOP"); on++;}
"/"	     { ret_print("DIVOP"); on++;}
"++"     { ret_print("INCR"); on++;}
"--"     { ret_print("DECR"); on++;}
"||"     { ret_print("OROP"); on++;}
"&&"	 { ret_print("ANDOP"); on++;}
"!"	     { ret_print("NOTOP"); on++;}
"=="     { ret_print("EQUOP"); on++;}
"!="     { ret_print("NOTEQUOP"); on++;}
">"|"<"|">="|"<="      { ret_print("RELOP"); on++;}


"("      { ret_print("LPAREN"); sn++;}
")"      { ret_print("RPAREN"); sn++;}
"]"      { ret_print("LBRACK"); sn++;}
"["      { ret_print("RBRACK");sn++; }
"{"      { ret_print("LBRACE"); sn++;}
"}"      { ret_print("RBRACE");sn++; }
";"      { ret_print("SEMI"); sn++; }
":"      { ret_print("COLON");sn++; }
"."      { ret_print("DOT"); sn++;}
","      { ret_print("COMMA");sn++; }
"="      { ret_print("ASSIGN");sn++; }
"&"      { ret_print("REFER"); sn++;}


{ID}         { ret_print("ID"); idn++; }
{ICONST}     { ret_print("ICONST"); iconstn++;}
{FCONST}     { ret_print("FCONST"); fconstn++;}
{CCONST}     { ret_print("CCONST"); cconstn++;}
{STRING}     { ret_print("STRING"); stringn++; }


"\n"		   { lineno += 1; }
[ \t\r\f]+	   /* eat up whitespace */

.		   { yyerror("Unrecognized character"); }

%%

void ret_print(char *token_type){
   FILE *p;
   p = fopen("out.txt", "a");
   fprintf(p, "yytext: %s\ttoken: %s\tlineno: %d\n", yytext, token_type, lineno);

   fclose(p);
}

void yyerror(char *message){
   FILE *p;
   p = fopen("out.txt", "a");
   fprintf(p,"Error: \"%s\" in line %d. Token = %s\n", message, lineno, yytext);
   fclose(p);
}



void total(){
FILE *p;
   p = fopen("out.txt", "a");
   n = n + kn + idn + on + sn + iconstn + fconstn + cconstn + stringn;
   fprintf(p,"\n Total no. of Keywords = %d\n", kn);
   fprintf(p,"\n Total no. of Identifiers = %d\n", idn);
   fprintf(p,"\n Total no. of Operators = %d\n", on);
   fprintf(p,"\n Total no. of Separators = %d\n", sn);
   fprintf(p,"\n Total no. of Integer Constants = %d\n", iconstn);
   fprintf(p,"\n Total no. of Float Constant = %d\n", fconstn);
   fprintf(p,"\n Total no. of Character Constant = %d\n", cconstn);
   fprintf(p,"\n Total no. of Strings = %d\n", stringn);
   fprintf(p,"\n Total no. of Tokens = %d\n", n);
   fclose(p);
}

int main(int argc, char *argv[]){
   FILE *fil;
   fil= fopen("out.txt", "w");
   fclose(fil);
   yyin = fopen(argv[1], "r");
   yylex();
   fclose(yyin);
   total();

   return 0;
}