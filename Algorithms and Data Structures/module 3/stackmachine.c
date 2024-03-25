#include <stdio.h>
#include <stdlib.h>

typedef struct Stack Stack;

struct Stack {
	int *data;
	int cap, top;
};

void InitStack(Stack *s, int n)
{
	s->data = (int*)malloc(sizeof(int) * n);
	s->cap = n;
	s->top = 0;
}

int StackEmpty(Stack *s)
{
	return s->top == 0;
}

void Push(Stack *s, int x)
{
	s->data[s->top] = x;
	s->top++;
}

int Pop(Stack *s)
{
	s->top--;
	return s->data[s->top];
}

int main()
{
	int n, num;
	int op1 = 0, op2 = 0;
	scanf("%d", &n);
	Stack s;
	Stack *sp = &s;
	InitStack(sp, n);
	char command[5];
	for (int i = 0; i < n; i++){
		scanf("%s", command);
		if (strcmp(command, "CONST") == 0){
			scanf("%d", &num);
			Push(sp, num);
		}
		if (strcmp(command, "ADD") == 0){
			op1 = Pop(sp);
			op2 = Pop(sp);
			Push(sp, op1 + op2);
		}
		if (strcmp(command, "SUB") == 0){
			op1 = Pop(sp);
			op2 = Pop(sp);
			Push(sp, op1 - op2);
	    }
		if (strcmp(command, "MUL") == 0){
			op1 = Pop(sp);
			op2 = Pop(sp);
			Push(sp, op1 * op2);
		}
		if (strcmp(command, "DIV") == 0){
			op1 = Pop(sp);
			op2 = Pop(sp);
			Push(sp, op1 / op2);
		}
		if (strcmp(command, "MAX") == 0){
			op1 = Pop(sp);
			op2 = Pop(sp);
			Push(sp, op1 > op2 ? op1 : op2);
		}
		if (strcmp(command, "MIN") == 0){
			op1 = Pop(sp);
			op2 = Pop(sp);
			Push(sp, op1 < op2 ? op1 : op2);
		}
		if (strcmp(command, "NEG") == 0){
			num = Pop(sp);
			Push(sp, -1 * num);
		}
		if (strcmp(command, "DUP") == 0){
			num = Pop(sp);
			Push(sp, num);
			Push(sp, num);
		}
		if (strcmp(command, "SWAP") == 0){
			op1 = Pop(sp);
			op2 = Pop(sp);
			Push(sp, op1);
			Push(sp, op2);
		}
	}
	int res = Pop(sp);
	printf("%d", res);
	free(s.data);
	return 0;
}