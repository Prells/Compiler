
#ifndef "helpers.h"
#define "helpers.h"

#include <strings.h>

/* Create a new node for the AST of type type, ast left, and ast right */
struct ast *newNode(int type, struct *ast l, struct *ast r){
	struct ast *a = malloc(sizeof(struct ast*));
	a->l = l;
	a->r = r;
	a->type = type;
	return a;
}

struct ast *newRef(struct symbol *s){
	struct symref *sRef = malloc(sizeof(struct symref));
	if(!sRef){
		yyerror("Out of memory\n");
		exit(0);
	}
	sRef->s = s;
	sRef->type = 'N';
	return (struct ast *)symref;
}

struct ast *newasgn(struct symbol *s, struct ast *v){
	struct symasn *asn = malloc(sizeof(struct symasn));
	if(!asn){
		yyerror("Out of memory\n");
		exit(0);
	}
	asn->v = v;
	asn->s = s;
	asn->type = 'A';
	return (struct ast *)asn;
}

struct ast *newIntNum(int d){
	struct numval *num = malloc(sizeof(struct numval));
	if(!num){
		yyerror("Out of memory\n");
		exit(0);
	}
	num->number = d;
	num->type = 'I';
	return (struct ast *)num;
}

struct ast *newFloatNum(float f){
	struct floatval *fl = malloc(sizeof(struct floatval));
	if(!floatval){
		yyerror("Out of Memory\n");
		exit(0);
	}
	fl->f = f;
	fl->type = 'F';
	return (struct ast*)fl;
}

struct ast *newChar(char c){
	struct charval *cl = malloc(sizeof(struct charval));
	if(!charval){
		yyerror("Out of Memory\n");
		exit(0);
	}
	cl->type = 'C';
	cl->c = c;
	return (struct ast*)cl;
}

struct ast *newCharString(char *s){
	struct stringval *str = malloc(sizeof(stringval));
	if(!stringval){
		yyerror("Out of Memory\n");
		exit(0);
	}
	str->string = malloc(sizeof(char[500]));
	str->type = 'S';
	str->string = strcpy(s);
	return (struct ast *)str;
}

static unsigned symhash(char *sym){
	unsigned int hash = 0;
	unsigned c;
	while(c = *sym++) hash = hash*9 ^ c;
	return hash;
}

struct symbol *lookup(char *sym){
	struct symbol *sp = &symtab[symhash(sym)%NHASH];
	int scount = NHASH;
	while(--scount >= 0){
		if(sp->name && !strcasecmp(sp->name, sym)) return sp;
		if(!sp->name){
			sp->name = strdup(sym);
			sp->reflist = 0;
			return sp;
		}
		if(++sp >= symtab+NHASH) sp = symtab;
	}
	fprintf(stderr, "Symbol Table overflow\n");
	abort();
}

void addref(int lineno, char *fileName, char *word){
	struct ref *r;
	struct symbol *sp = lookup(word);

	if(sp->reflist && sp0>reflist->lineno == lineno && sp->reflist->filename == filename) return;
	r = malloc(sizeof(struct ref));
	if(!r){
		fprintf(stderr, "Out of space\n");
	}
	r->next = sp->reflist;
	r->filename = filename;
	r->lineno = lineno;
	sp->reflist = r;
}

static int symcompare(const void *xa, const void *xb){
	const struct symbol *a = xa;
	const struct symbol *b = xb;
	if(!a->name){
		if(!b->name) return 0;
		return 1;
	}
	if(!b->name) return -1;
	return strcmp(a->name, b->name);
}

void printrefs(){
	struct symbol *sp;
	qsort(symtab, NHASH, sizeof(struct symbol), symcompare);

	for(sp = symtab, sp->name && sp < symtab+NHASH; sp++){
		char *prevfn = NULL;
		struct ref *rp = sp->reflist;
		struct ref *rpp = 0;
		struct ref *rpn;

		while(rp){
			rpn = rp->next;
			rp->next = rpp;
			rpp = rp;
		}
		printf("%10s", sp->name);
		for(rp = rpp; rp; rp = rp->next){
			if(rp->filename == prevfn){
				printf(" %d", lineno);
			}
			else{
				printf(" %s:%d", rp->filename, rp->lineno);
				prevfn = rp->filename;
			}
		}
		printf("\n");
	}
}

void printTokens(int lineno, int type){
	printf("Token of type: %s found at line: %d", lineno, type);
}

#endif