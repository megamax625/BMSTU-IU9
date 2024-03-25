#include <stdio.h>
#include <stdlib.h>

typedef struct node node;
typedef struct num num;
typedef struct ident ident;

struct node{
	int key, value, balance;
	struct node *parent, *left, *right;
};

struct num{
	int end, value;
};

struct ident{
	int end, value;
};

node* InitAVLTree(node *t)
{
	t = NULL;
	return t;
}

node* Insert(node **t, int k, int v)
{
	node *y = (node*)malloc(sizeof(node));
	y->key = k;
	y->value = v;
	y->parent = NULL;
	y->left = NULL;
	y->right = NULL;
	if (*t == NULL) *t = y;
	else{
		node *x = *t;
		for (;;){
			if (k < x->key){
				if (x->left == NULL){
					x->left = y;
					y->parent = x;
					break;
				}
				x = x->left;
			}
			else{
				if (x->right == NULL){
					x->right = y;
					y->parent = x;
					break;
				}
				x = x->right;
			}
		}
	}
	return y;
}

node* ReplaceNode(node *t, node *x, node *y)
{
	if (x == t){
		t = y;
		if (y != NULL) y->parent = NULL;
	}
	else{
		node *p = x->parent;
		if (y != NULL) y->parent = p;
		if (p->left == x) p->left = y;
		else p->right = y;
	}
	return t;
}

node* RotateLeft(node *t, node *x)
{
	node *y = x->right;
	t = ReplaceNode(t, x, y);
	node *p = y->left;
	if (p != NULL) p->parent = x;
	x->parent = y;
	x->right = p;
	x->balance -= 1;
	y->left = x;
	if (y->balance > 0) x->balance -= y->balance;
	y->balance -= 1;
	if (x->balance < 0) y->balance += x->balance;
	return t;
}

node* RotateRight(node *t, node *x)
{
	node *y = x->left;
	t = ReplaceNode(t, x, y);
	node *p = y->right;
	if (p != NULL) p->parent = x;
	x->parent = y;
	x->left = p;
	x->balance += 1;
	y->right = x;
	if (y->balance < 0) x->balance -= y->balance;
	y->balance += 1;
	if (x->balance > 0) y->balance += x->balance;
	return t;
}

node* InsertAVL(node *t, int k, int v)
{
	node *a = Insert(&t, k, v);
	a->balance = 0;
	for (;;){
		node *x = a->parent;
		if (x == NULL) break;
		if (a == x->left){
			x->balance -= 1;
			if (x->balance == 0) break;
			if (x->balance == -2){
				if (a->balance == 1) t = RotateLeft(t, a);
				t = RotateRight(t, x);
				break;
			}
		}
		else{
			x->balance += 1;
			if (x->balance == 0) break;
			if (x->balance == 2){
				if (a->balance == -1) t = RotateRight(t, a);
				t = RotateLeft(t, x);
				break;
			}
		}
		a = x;
	}
	return t;
}

node* Lookup(node *t, int k)
{
	node *x = t;
	while ((x != NULL) && (x->key != k)){
		if (k < x->key) x = x->left;
		else x = x->right;
	}
	return x;
}

int SpecPred(char *sent, int i)
{
	return (sent[i] == '+' || sent[i] == '-' || sent[i] =='*' || sent[i] == '/' || sent[i] == '(' || sent[i] == ')' || sent[i] == ' ' || sent[i] == '\0');
}

num NumSkip(char *sent, int i)
{
	num res;
	char *rec = (char*)malloc(100 * sizeof(char));
	int j = 0;
	while (!SpecPred(sent, i)){
		rec[j] = sent[i];
		j++;
		i++;
	}
	res.value = 0;
	res.end = i;
	int ord = 1;
	for (int k = j - 1; k > -1; k--){
		res.value += (rec[k] - 48) * ord;
		ord *= 10;
	}
	free(rec);
	return res;
}

ident IdentSkip(char *sent, int i)
{
	ident res;
	res.value = 0;
	int ord = 1;
	while (!SpecPred(sent, i)){
		res.value += sent[i] * ord;
		i++;
		ord *= 36;
	}
	res.end = i;
	return res;
}

void RecFree(node *t)
{
	if (t != NULL){
		RecFree(t->left);
		RecFree(t->right);
		free(t);
	}
}

int main()
{
	int n;
	scanf("%d \n", &n);
	char *sent = (char*)malloc((n + 1) * sizeof(char));
	int idents = 0, i = 0; 
	node *t = InitAVLTree(t);
	gets(sent);
	while (sent[i] != '\0'){
		while (sent[i] == ' ') i++;
		if (sent[i] == '\0') break;
		switch (sent[i]){
		case '+':
			i++;
			printf("SPEC 0\n");
			break;
		case '-':
			i++;
			printf("SPEC 1\n");
			break;
		case '*':
			i++;
			printf("SPEC 2\n");
			break;
		case '/':
			i++;
			printf("SPEC 3\n");
			break;
		case '(':
			i++;
			printf("SPEC 4\n");
			break;
		case ')':
			i++;
			printf("SPEC 5\n");
			break;
		default:
			if ((sent[i] > 47) && (sent[i] < 58)){
				num n = NumSkip(sent, i);
				printf("CONST %d\n", n.value);
				i = n.end;
			}
			else{
				ident id = IdentSkip(sent, i);
				i = id.end;
				node *p;
				p = Lookup(t, id.value);
				if ((p == NULL) || (p->key != id.value)){
					printf("IDENT %d\n", idents);
					t = InsertAVL(t, id.value, idents);
					idents++;
				}
				else printf("IDENT %d\n", p->value);
			}
		}
	}
	RecFree(t);
	free(sent);
	return 0;
}