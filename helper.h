
struct symbol{
	char *name;
	int value;
}symbol;

struct astNode{
	struct astNode *right;
	struct astNode *left;
	int type;
}astNode;

struct intVal{
	int type;
	int value;
}intVal;

struct floatVal{
	int type;
	float value;
}floatVal;

struct charVal{
	int type;
	char value;
} charVal;

struct stringVal{
	int type;
	char *value;
}stringVal;

struct indentVal{
	int type;
	char *name;
	Symbol *sym;
}identVal;

astNode *newASTNode(int type, astNode *l, astNode *r){
	astNode *node = malloc(sizeof(astNode));
	node->type = type;
	node->l = l;
	node->r = r;
	return node;
}

astNode *newCharLeaf(int type, char value){
	charVal *val = malloc(sizeof(charVal));
	val->type = type;
	val->value = value;
	return (astNode *)val;
}

astNode *newStringLeaf(int type, char *value){
	stringVal *val = malloc(sizeof(stringVal));
	val->value = malloc(sizeof(250));
	val->type = type;
	val->value = value;
	return (astNode *)val;
}

astNode *newFloatLeaf(int type, float value){
	floatVal *val = malloc(sizeof(floatVal));
	val->type = type;
	val->value = value;
	return (astNode *)val;
}

astNode *newIntLeaf(int type, int value){
	intVal *val = malloc(int type, int value);
	val->type = type;
	val->value = value;
	return (astNode *)val;
}

astNode *newIdentifierLeaf(int type, char *name){
	Symbol *s = lookup(name);
	identVal *val = malloc(sizeof(identVal));
	val->name = malloc(sizeof(name));
	val->sym = malloc(sizeof(Symbol *));
	val->sym = s;
	val->name = name;
	val->type = type;
	return (astNode *)val;
}

