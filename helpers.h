
#define NHASH 9997


struct astNode{
	int type;
	struct astNode *l;
	struct astNode *r;
};

struct symbol{
	char *name;
	int value;
};

struct symbol symtab[NHASH];

struct symlist{
	struct symbol *sym;
	struct symlist *next;
};


void freeTree();

struct numval{
	int type;
	int number;
};

struct floatval{
	float f;
	int type;
};

struct symasn{
	int type;			/* type = */
	struct symbol *s;
	struct astNode *v; /* value */
};

struct charval{
	int type;
	char c;
};

struct stringval{
	int type;
	char *string;
};

struct symref{
	int type;
	struct symbol *s;
};

/* Create a new node for the AST of type type, ast left, and ast right */
struct ast *newNode(int type, struct ast *l, struct ast *r);
struct ast *newRef(struct symbol *s);
struct ast *newasgn(struct symbol *s, struct ast *v);
struct ast *newIntNum(int d);
struct ast *newFloatNum(float f);
struct ast *newChar(char c);
struct ast *newCharString(char *s);
void printrefs();
static int symcompare(const void *xa, const void *xb);
void addref(int lineno, char *fileName, char *word, int flags);

struct symbol *lookup(char *sym);
static unsigned symhash(char *sym);
void printTokens(int, int);

