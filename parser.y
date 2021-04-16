%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "helpers.h"
	FILE *f;
	char *curFileName;
	int yylex();
	void yyrestart(FILE *);
	int yylineno;
%}

%token PLUS MINUS STAR SLASH ASSIGN STARASSIGN MINUSASSIGN PLUSASSIGN SLASHASSIGN EQUAL
%token NEQUAL BANG PIPE DPIPE AMP DAMP GT LT LE GE QUEST TILDE SEMI COLON BREAK INT CHARCONST
%token FLOAT STRCONST WHILE FOR VOID INTCONST REALCONST CHAR IDENT IF ELSE CONTINUE RET LBRACE RBRACE
%left COMMA
%right ASSIGN PLUSASSIGN MINUSASSIGN STARASSIGN SLASHASSIGN
%right QUEST COLON
%left DPIPE
%left DAMP
%left PIPE
%left AMP
%left EQUAL NEQUAL
%left LT LE GT GE
%left PLUS MINUS 
%left STAR SLASH MOD
%right BANG TILDE UMINUS DECR INCR UAMP
%left LPAR RPAR LBRACKET RBRACKET
%nonassoc MISSINGELSE
%nonassoc ELSE

%% 

prgm : expr SEMI
	| vardecl
	;
	
	
vardecl: type varlst SEMI
	;
	
varlst: varlst COMMA IDENT
	| IDENT
	;

expr: expr ASSIGN expr 
	| expr SLASH expr
	| expr STAR expr
	| expr PLUS expr
	| expr MINUS expr
	| const 
	;

type : INT
	| FLOAT
	| CHAR
	;
	
const : INTCONST
	| CHARCONST
	| STRCONST
	| REALCONST
	;
	
%%
	/* main function */
int main(int argc, char *argv[]){
	f = fopen(argv[1], "r");
	if(!f){
		printf("File not opened\n");
		exit(0);
	}
	else{
		yylineno = 1;
		yyrestart(f);
		int type = yylex();
		while(type != 0){
			printTokens(yylineno, type);
			type = yylex();
		}
		fclose(f);
	}
}