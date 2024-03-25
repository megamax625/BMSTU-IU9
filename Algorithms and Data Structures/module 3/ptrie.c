#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Node Node;
typedef struct NodePref NodePref;

struct Node{
	int value[2];
	Node *parent; 
	Node **arcs;
};

struct NodePref{
	Node *t;
	int i;
};

Node* InitTrie(Node *t, int m)
{
	t = (Node*)malloc(sizeof(Node));
	t->value[0] = 0;
	t->value[1] = 1;
	t->parent = NULL;
	t->arcs = (Node**)malloc(m * sizeof(Node*));
	for (int i = 0; i < m; i++) t->arcs[i] = NULL;
	return t;
}

NodePref Descend(Node *t, char *k, int inc, int m)
{
	Node *x = t;
	int i = 0;
	int len = strlen(k);
	Node *y;
	while (i < len){
		y = x->arcs[k[i] - 97];
		if (y == NULL) break;
		y->value[1] += inc;
		x = y;
		i++;
	}
	NodePref np;
	np.i = i;
	np.t = x;
	if ((np.i < len) && (inc == 0)) np.t = NULL;
	return np;
}

Node* Insert(Node *t, char *k, int m)
{
	NodePref np = Descend(t, k, 1, m);
	int len = strlen(k);
	if ((np.t->value[0] != 0) && (np.i == len)){
		np = Descend(t, k, -1, m);
		return t;
	}
	while (np.i < len){
		Node *x = InitTrie(x, m);
		np.t->arcs[k[np.i] - 97] = x;
		x->parent = np.t;
		np.t = x;
		np.i += 1;
	}
	np.t->value[0] = 1;
	return t;
}

Node* Delete(Node *t, char *k, int m)
{
	NodePref p = Descend(t, k, -1, m);
	p.t->value[0] = 0;
	while ((p.t->parent != NULL) && (p.t->value[0] == 0)){
		int i = 0;
		while ((i < m) && (p.t->arcs[i] == NULL)) i++;
		if (i < m) break;
		Node *x = p.t->parent;
		p.i -= 1;
		x->arcs[k[p.i] - 97] = NULL;
		free(p.t->arcs);
		free(p.t);
		p.t = x;
	}
	return t;
}

void RecFree(Node *t, int m)
{
	if (t != NULL){
		for (int i = 0; i < m; i++) RecFree(t->arcs[i], m);
		free(t->arcs);
		free(t);
	}
}

int main()
{
	int m = 26;
	int n;
	scanf("%d", &n);
	Node *t = InitTrie(t, m);
	char command [6], k[100000];
	for (int i = 0; i < n; i++){
		scanf("%s", command);
		if (strcmp(command, "INSERT") == 0){
			scanf("%s", k);
			t = Insert(t, k, m);
		}
		if (strcmp(command, "DELETE") == 0){
			scanf("%s", k);
			t = Delete(t, k, m);
		}
		if (strcmp(command, "PREFIX") == 0){
			scanf("%s", k);
			NodePref p = Descend(t, k, 0, m);
			if (p.t == NULL) printf("0\n");
			else printf("%d\n", p.t->value[1]); 
		}
	}
	RecFree(t, m);
	return 0;
}