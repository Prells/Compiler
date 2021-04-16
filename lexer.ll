%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>	
	#include "parser.tab.h"
	char *curFileName;
	FILE *f;
	int popfile();
	int newfile(char *fn);
	/* buffer for files */
	struct bufstack{
		struct bufstack *prev;
		YY_BUFFER_STATE bs;
		int lineno;
		char *fileName;
		FILE *f;
	} *curbs;
	
	int popfile(){
		struct bufstack *bs = curbs;
		struct bufstack *prevbs;

		if(!bs) return 0;

		fclose(bs->f);
		free(bs->f);
		yy_delete_buffer(bs->bs);
		prevbs = bs->prev;
		free(bs);
		if(!prevbs) return 0;
		yy_switch_to_buffer(prevbs->bs);
		curbs = prevbs;
		yylineno = curbs->lineno;
		curFileName = curbs->fileName;
		return 1;
	}
	int newfile(char *fn){
		FILE *f = fopen(fn, "r");
		struct bufstack *bs = malloc(sizeof(struct bufstack));
		if(!f){ perror(fn); return 0;}
		if(!bs){ perror("malloc"); exit(1); }
		if(curbs)curbs->lineno = yylineno;
		bs->prev = curbs;
		bs->bs = yy_create_buffer(f, YY_BUF_SIZE);
		bs->f = f;
		bs->fileName = strdup(fn);
		yy_switch_to_buffer(bs->bs);
		curbs = bs;
		yylineno = 1;
		curFileName = bs->fileName;
		return 1;
	}
	
%}

%option noyywrap 
%option yylineno

%x IFILE
%x IN_COMMENT

UCN (\\u[0-9a-fA-F]{4}|\\U[0-9a-fA-F]{8})
print [ -~]
INT "int"
FLOAT "float"
CHAR "char"
VOID "void"
FOR "for"
WHILE "while"
IF "if"
ELSE "else"
BREAK "break"
CONTINUE "continue"
RET "return"
IDENT [a-z_][a-z0-9]*
INTCONST [0-9]*
REALCONST [^[\-+]?[0-9]*\.?[0-9]+([eE][\-+]?[0-9]+)?$]
STRCONST \"{print}*\"
CHARCONST  (\'{print}\')|(\'\\[nftrbv]\')
LPAR "("
RPAR ")"
LBRACKET "["
RBRACKET "]"
LBRACE "{"
RBRACE "}"
ASSIGN "="
EQUAL "=="
NEQUAL "!="
PLUSASSIGN "+="
MINUSASSIGN "-="
STARASSIGN "*="
SLASHASSIGN "/="
BANG "!"
PIPE "|"
DPIPE "||"
INCR "++"
DECR "--"
LT "<"
GT ">"
LE "<="
GE ">="
MOD "%"
COLON ":"
SEMI ";"
COMMA ","
QUEST "?"
TILDE "~"
AMP "&"
DAMP "&&"


%%
	
	
<INITIAL>{
	^"#"[ \t]*include[ \t]*[\"<]				{ BEGIN(IFILE); }
	"/*"										{ BEGIN(IN_COMMENT); }
	"#define"[ \t]*[^ \t\n]+[ \t]*[0-9]*		{ fprintf(stderr, "Error in %s Line %d: directive '#define' not implemented, ignoring\n", curFileName, yylineno); }
	"#ifndef"[ \t]*[^ \t\n]+[ \t]*				{ fprintf(stderr, "Error in %s Line %d: directive '#ifndef' not implemented, ignoring\n", curFileName, yylineno); }
	"#endif"									{ fprintf(stderr, "Error in %s Line %d: directive '#endif' not implemented, ignoring\n", curFileName, yylineno); }
	"#ifdef"[ \t]*[^ \t\n]+[ \t]*				{ fprintf(stderr, "Error in %s Line %d: directive '#ifdef' not implemented, ignoring\n", curFileName, yylineno); }
	[ \t\n]+     								/* eat up whitespace */
	{INT}										{ return INT; }
	{FLOAT}										{ return FLOAT; }
	{CHAR}										{ return CHAR; }
	{VOID}										{ return VOID; }
	{FOR}										{ return FOR; }
	{WHILE}										{ return WHILE; }
	{IF}										{ return IF; }
	{ELSE}										{ return ELSE; }
	{BREAK}										{ return BREAK; }
	{CONTINUE}									{ return CONTINUE; }
	{RET}										{ return RET; }
	{IDENT}										{ return IDENT; }
	{INTCONST}									{ return INTCONST; }
	{REALCONST}									{ return REALCONST; }
	{STRCONST}									{ return STRCONST;}
	{CHARCONST}									{ return CHARCONST; }
	{LPAR}										{ return LPAR;  }
	{RPAR}										{ return RPAR; }
	{LBRACKET}									{ return LBRACKET; }
	{RBRACKET}									{ return RBRACKET; }
	{RBRACE}									{ return RBRACE; }
	{LBRACE}									{ return LBRACE; }
	{ASSIGN}									{ return ASSIGN; }
	{EQUAL}										{ return EQUAL; }
	{NEQUAL}									{ return NEQUAL; }
	{PLUSASSIGN}								{ return PLUSASSIGN; }
	{MINUSASSIGN} 								{ return MINUSASSIGN; }
	{STARASSIGN}								{ return STARASSIGN; }
	{SLASHASSIGN}								{ return SLASHASSIGN; }
	{BANG}										{ return BANG; }
	{PIPE}										{ return PIPE; }
	{DPIPE}										{ return DPIPE; }
	{INCR}										{ return INCR; }
	{DECR}										{ return DECR; }
	{LT}										{ return LT; }
	{GT}										{return GT; }
	{LE}										{ return LE; }
	{GE}										{ return GE; }
	{MOD}										{ return MOD; }
	{COLON}										{ return COLON; }
	{SEMI}										{ return SEMI; }
	{COMMA}										{ return COMMA; }
	{QUEST}										{ return QUEST; }
	{TILDE}										{ return TILDE; }
	{AMP}										{ return AMP; }
	{DAMP}										{ return DAMP; }

}
<IN_COMMENT>{
	"*/"	BEGIN(INITIAL);
	[^*\n]+   //eat comment in chunks
	"*"		  //eat the lone star
	\n		  yylineno++;
}
<IFILE>{
	[^>\"]+  {
		{
			int c;
			while(c = input() && c != '\n');
		}
		newfile(strdup(yytext));
		BEGIN(INITIAL);
	}
	.|\n  {
		fprintf(stderr, "%s:%d bad include line\n", curFileName, yylineno);
		BEGIN(INITIAL);
	}
}

<<EOF>>		{ if(!popfile()) yyterminate(); }


%%


