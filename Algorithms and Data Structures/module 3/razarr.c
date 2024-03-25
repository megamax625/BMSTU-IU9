#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Elem Elem;

struct Elem{
	int key, value;
	struct Elem *next;
};

Elem** InitHashTable(int m)
{
	Elem **t = (Elem**)malloc(m * sizeof(Elem*));
	for (int i = 0; i < m; i++) t[i] = NULL;
	return t;
}

Elem* InitSLList(Elem *l, int i, int val)
{
	l = (Elem*)malloc(sizeof(Elem));
	l->value = val;
	l->key = i;
	return l;
}	

Elem* ListSearch(Elem *l, int k)
{
	Elem *x = l;
	while ((x != NULL) && (x->key != k)) x = x->next;
	return x;
}

int Lookup(Elem **t, int m, int k)
{
	int h = k % m;
	Elem *p = ListSearch(t[h], k);
	if (p == NULL) return 0;
	else return p->value;
}

Elem* InsertBeforeHead(Elem *l, int k, int v)
{
	Elem *p = InitSLList(p, k, v);
	p->next = l;
	l = p;
	return l;
}

Elem** Insert(Elem **t, int m, int k, int v)
{
	int h = k % m;
	t[h] = InsertBeforeHead(t[h], k, v);
	return t;
}

Elem* DeleteHead(Elem *l)
{
	Elem *y = l;
	l = y->next;
	y->next = NULL;
	free(y);
	return l;
}

void DeleteAfter(Elem *l)
{
	Elem *y = l->next;
	l->next = y->next;
	y->next = NULL;
	free(y);
}

Elem* SearchAndDelete(Elem *l, int k)
{
	Elem *y = NULL;
	Elem *x = l;
	while (x != NULL){
		if (x->key == k){
			if (y == NULL) l = DeleteHead(l);
			else DeleteAfter(y);
			break;
		}
		y = x;
		x = x->next;
	}
	return l;
}

Elem** Delete(Elem **t, int m, int k)
{
	int h = k % m;
	t[h] = SearchAndDelete(t[h], k);
	return t;
}

int main()
{
	int n, m;
	scanf("%d", &n);
	scanf("%d", &m);
	char command[6];
	int i, v;
	Elem **t = InitHashTable(m);
	for (int k = 0; k < n; k++){
		scanf("%s", command);
		if (strcmp(command, "ASSIGN") == 0){
			scanf("%d %d", &i, &v);
			if (v == 0) t = Delete(t, m, i);
			else t = Insert(t, m, i, v);
		}
		if (strcmp(command, "AT") == 0){
			scanf("%d", &i);
			printf("%d\n", Lookup(t, m, i));
		}	
	}
	for (int i = 0; i < m; i++){
		Elem *l;
		while (t[i] != NULL){
			l = t[i];
			t[i] = t[i]->next;
			free(l);
		}
	}
	free(t);
	return 0;
}