#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Stack Stack;

struct Stack{
	int *data;
	int cap, top1, top2, max;
};

void InitDoubleStack(Stack *s, int n)
{
	s->data = (int*)malloc(n * sizeof(int));
	s->cap = n;
	s->top1 = 0;
	s->top2 = n - 1;
	s->max = -2000000000;
}

int StackEmpty1(Stack *s)
{
	return (s->top1 == 0);
}

int StackEmpty2(Stack *s)
{
	return (s->top2 == (s->cap - 1));
}

void Push1(Stack *s, int x)
{
	s->data[s->top1] = x;
	s->top1++;
}

void Push2(Stack *s, int x)
{
	s->data[s->top2] = x;
	s->top2--;
}

int Pop1(Stack *s)
{
	s->top1--;
	return s->data[s->top1];
}

int Pop2(Stack *s)
{
	s->top2++;
	return s->data[s->top2];
}

void InitQueueOnStack(Stack *s, int n)
{
	InitDoubleStack(s, n);
}

int QueueEmpty(Stack *s)
{
	return (StackEmpty1(s) && StackEmpty2(s));
}

void Enqueue(Stack *s, int x)
{
	Push1(s, x);
	if (x > s->max) s->max = x;
}

int Dequeue(Stack *s)
{
	if (StackEmpty2(s) == 1){
		while (StackEmpty1(s) == 0) Push2(s, Pop1(s));
	}
	int x = Pop2(s);
	if (x == s->max){
		s->max = -2000000000;
		for (int i = 0; i < s->top1; i++) if (s->data[i] > s->max) s->max = s->data[i];
		for (int i = s->top2 + 1; i < s->cap; i++) if (s->data[i] > s->max) s->max = s->data[i];
	}
	return x;
}

int Maximum(Stack *s)
{
	return s->max;
}

int main()
{
	int n, x;
	scanf("%d", &n);
	Stack s;
	Stack *sp = &s;
	InitQueueOnStack(sp, 100000);
	char command[5];
	for (int i = 0; i < n; i++){
		scanf("%s", command);
		if (strcmp(command, "ENQ") == 0){
			scanf("%d", &x);
			Enqueue(sp, x);
		}
		if (strcmp(command, "DEQ") == 0) printf("%d\n", Dequeue(sp));
		if (strcmp(command, "MAX") == 0) printf("%d\n", Maximum(sp));
		if (strcmp(command, "EMPTY") == 0){
			if (QueueEmpty(sp) == 0) printf("false\n");
			else printf("true\n");
		}
	}
	free(s.data);
	return 0;
}