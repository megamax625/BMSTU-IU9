#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Elem Elem;

struct Elem {	
    struct Elem *next; 
    char *word; 
}; 

Elem* InitSingleLinkedList(Elem *l)
{
	l = (Elem*)malloc(sizeof(Elem));
	l->next = NULL;
	l->word = (char*)malloc(1000 * sizeof(char));
	return l;
}

Elem* Insert(Elem *l, char *y)
{
	Elem *z;
	z = InitSingleLinkedList(z);
	strcpy(z->word, y);
	l->next = z;
	return z;
}

int ListLength(Elem *l)
{
	int len = 0;
	Elem *x = l;
	while (x != NULL){
		len++;
		x = x->next;
	}
	return len;
}

void swap(Elem *e1, Elem *e2)
{
	char *t;
	t = e2->word;
	e2->word = e1->word;
	e1->word = t;
}

struct Elem *bsort(struct Elem *list) 
{ 
    int n = ListLength(list);
	int t = n - 1;
	while (t > 0){
		Elem *x = list;
		int bound = t;
		t = 0;
		int i = 0;
		while (i < bound){
			if (strlen(x->word) > (strlen(x->next->word))){
				swap(x, x->next);
				t = i;
			}
			x = x->next;
			i++;
		}
	}
	return list;
} 

int main()
{
	char *string = (char*)malloc(10000 * sizeof(char));
	gets(string);
	int i = 0;
	Elem *list;
	list = InitSingleLinkedList(list);
	Elem *first;
	first = list;
	while (string[i] != '\0'){
		char *acc = (char*)malloc(1000 * sizeof(char));
		int j = 0;
		if (string[i] != ' '){
			while ((string[i] != ' ') && (string[i] != '\0')){
				acc[j] = string[i];
				i++;
				j++;
			}
			acc[j] = '\0';
			list = Insert(list, acc);
		}
		while (string[i] == ' ') i++;
		free(acc);
	}
	list = first->next;
	free(first->word);
	free(first);
	list = bsort(list);
	while (list != NULL){
		printf("%s ", list->word);
		free(list->word);
		first = list;
		list = list->next;
		free(first);
	}
	free(string);
	return 0;
}