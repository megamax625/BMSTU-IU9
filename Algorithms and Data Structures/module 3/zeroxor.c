#include <stdio.h>
#include <stdlib.h>

typedef struct Elem Elem;

struct Elem{
	int key, value;
	struct Elem *next;
};

Elem** InitHashTable(int m)
{
	Elem **t = (Elem**)malloc(m * sizeof(Elem*));
	for (int i = 0; i < m; i++){
		t[i] = (Elem*)malloc(sizeof(Elem));
		t[i]->next = NULL;
		t[i]->key = 0;
		t[i]->value = 0;
	}
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

Elem* Lookup(Elem **t, int m, int k)
{
	int h = abs(k) % m;
	Elem *p = ListSearch(t[h], k);
	if (p == NULL) return NULL;
	else return p;
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
	int h = abs(k) % m;
	t[h] = InsertBeforeHead(t[h], k, v);
	return t;
}

int main()
{
	int n, res = 0;
	scanf("%d", &n);
	Elem **t = InitHashTable(n);
	int *array = (int*)malloc(n * sizeof(int));
	for (int i = 0; i < n; i++) scanf("%d", &array[i]);
	int ixor = 0;
	for (int i = 0; i < n; i++){
		ixor ^= array[i];
		Elem *l = Lookup(t, n, ixor);
		if (l != NULL) l->value += 1; 
		else Insert(t, n, ixor, 0);
	}
	for (int i = 0; i < n; i++){
		Elem *l = t[i];
		while (l != NULL){
			res += l->value * (l->value + 1) / 2;
			l = l->next;
		}
	}
	printf("%d", res);
	for (int i = 0; i < n; i++){
		Elem *l;
		while (t[i] != NULL){
			l = t[i];
			t[i] = t[i]->next;
			free(l);
		}
	}
	free(t);
	free(array);
	return 0;
}