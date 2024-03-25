#include <stdio.h>
#include <stdlib.h>

typedef struct Task Task;
typedef struct Stack Stack;
int *array;

struct Task { 
    int low, high; 
}; 

struct Stack {
	Task *data;
	int cap, top;
};

void InitStack(Stack *s, int n)
{
	s->data = (Task*)malloc(sizeof(Task) * n);
	s->cap = n;
	s->top = 0;
}

int StackEmpty(Stack *s)
{
	return s->top == 0;
}

void Push(Stack *s, Task x)
{
	s->data[s->top] = x;
	s->top++;
}

Task Pop(Stack *s)
{
	s->top--;
	return s->data[s->top];
}

int compare(int i, int j)
{
	if (array[i] == array[j]) return 0;
	return array[i] > array[j] ? 1 : -1; 
}

void swap(int i, int j) 
{ 
        int t = array[i]; 
        array[i] = array[j]; 
        array[j] = t; 
} 

int partition(int low, int high, int (*compare)(int i, int j))
{
	int i = low, j = low;
	while (j < high){
		if (compare(j, high) == -1){
			swap(i,j);
			i++;
		}
		j++;
	}
	swap(i,high);
	return i;
}

void Quicksort(int* array, int n)
{
	Stack s;
	Stack *sp = &s; 
	InitStack(sp, n * 2);
	Task first, current, next;
	first.low = 0;
	first.high = n - 1;
	Push(sp, first);
	int i = 0;
	while (StackEmpty(sp) == 0){
		current = Pop(sp);
		i = partition(current.low, current.high, compare);
		if (current.high > i + 1){
			next.high = current.high;
			next.low = i + 1;
			Push(sp, next);
		}
		if (current.low < i - 1){
			next.low = current.low;
			next.high = i - 1;
			Push(sp, next);
		}
	}
	free(s.data);
}

int main()
{
	int n;
	scanf("%d", &n);
	array = (int*)malloc(n * sizeof(int));
	for (int i = 0; i < n; i++) scanf("%d", &array[i]);
	Quicksort(array, n);
	for (int i = 0; i < n; i++) printf("%d ", array[i]);
	free(array);
	return 0;
}