#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Node Node;

struct Node{
	int key, count;
	char s[10];
	struct Node *parent, *left, *right;
};

Node* InitBSTree(Node *t)
{
	t = NULL;
	return t;
}

Node* Insert(Node *t, int k)
{
	Node *y = (Node*)malloc(sizeof(Node));
	y->key = k;
	scanf("%s", y->s);
	y->parent = NULL;
	y->left = NULL;
	y->right = NULL;
	y->count = 0;
	if (t == NULL) t = y;
	else{
		Node *x = t;
		for (;;){
			x->count += 1;
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
	return t;
}

Node* Lookup(Node *t, int k, int FromDelete)
{
	Node *x = t;
	while ((x != NULL) && (x->key != k)){
		if (FromDelete != 0) x->count -= 1;
		if (k < x->key) x = x->left;
		else x = x->right;
	}
	return x;
}

Node* ReplaceNode(Node *t, Node *x, Node *y)
{
	if (x == t){
		t = y;
		if (y != NULL) y->parent = NULL;
	}
	else{
		Node *p = x->parent;
		if (y != NULL) y->parent = p;
		if (p->left == x) p->left = y;
		else p->right = y;
	}
	return t;
}

Node* Minimum(Node *t)
{
	Node *x;
	if (t == NULL) x = NULL;
	else{
		x = t;
		while (x->left != NULL){
			x->count -= 1;
			x = x->left;
		}
	}
	return x;
}

Node* Succ(Node *x)
{
	Node *y;
	if (x->right != NULL) y = Minimum(x->right);
	else{
		y = x->parent;
		while ((y != NULL) && (x == y->right)){
			x = y;
			y = y->parent;
		}
	}
	return y;
}

Node* Delete(Node *t, int k)
{
	Node *x = Lookup(t, k, 1);
	if ((x->left == NULL) && (x->right == NULL)) t = ReplaceNode(t, x, NULL);
	else{
		if (x->left == NULL) t = ReplaceNode(t, x, x->right);
		else{
			if (x->right == NULL) t = ReplaceNode(t, x, x->left);
			else{
				Node *y = Succ(x);
				t = ReplaceNode(t, y, y->right);
				x->left->parent = y;
				y->left = x->left;
				if (x->right != NULL) x->right->parent = y;
				y->right = x->right;
				y->count = x->count - 1;
				t = ReplaceNode(t, x, y);
			}
		}
	}
	free(x);
	return t;
}

Node* Search(Node *t, int x)
{
	Node *r = t;
	for (;;){
		if (r->left == NULL){
			if (x == 0) return r;
			else{
				r = r->right;
				x--;
			}
		}
		else{
			if ((r->left->count + 1) == x) return r;
			else {
				if (r->left->count + 1 > x) r = r->left;
				else{
					x = x - r->left->count - 2;
					r = r->right;
				}
			}
		}
	}
}

void RecFree(Node *t)
{
	if (t != NULL){
		RecFree(t->right);
		RecFree(t->left);
		free(t);
	}
}

int main()
{
	int n, k;
	scanf("%d", &n);
	char command[6];
	Node *t = InitBSTree(t);
	Node *r;
	for (int i = 0; i < n; i++){
		scanf("%s", command);
		if (strcmp(command, "INSERT") == 0){
			scanf("%d", &k);
			t = Insert(t, k);
		}
		if (strcmp(command, "LOOKUP") == 0){
			scanf("%d", &k);
			r = Lookup(t, k, 0);
			printf("%s\n", r->s);
		}
		if (strcmp(command, "DELETE") == 0){
			scanf("%d", &k);
			t = Delete(t, k);
		}
		if (strcmp(command, "SEARCH") == 0){
			scanf("%d", &k);
			r = Search(t, k);
			printf("%s\n", r->s);
		}
	}
	RecFree(t);
	return 0;
}