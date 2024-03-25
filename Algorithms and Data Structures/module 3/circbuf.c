#include <stdio.h>
#include <stdlib.h>

typedef struct Queue Queue;

struct Queue{
	int *data;
	int cap, count, head, tail;
};

void InitQueue(Queue *q, int n)
{
	q->data = (int*)malloc(n * sizeof(int));
	q->cap = n;
	q->count = 0;
	q->head = 0;
	q->tail = 0;
}

int QueueEmpty(Queue *q)
{
	return (q->count == 0);
}

void Enqueue(Queue *q, int x)
{
	if (q->count == q->cap){
		int *temp = (int*)malloc(q->cap * sizeof(int));
		if (q->tail > q->head){
			for (int i = 0; i < q->count; i++) temp[i] = q->data[i];
		}
		else{
			int i = 0;
			for (int j = q->head; j < q->count; i++, j++) temp[i] = q->data[j];
			for (int j = 0; j < q->tail; i++, j++) temp[i] = q->data[j];
		}
		q->cap = q->cap * 2;
		free(q->data);
		q->data = (int*)malloc(q->cap * sizeof(int));
		for (int i = 0; i < q->count; i++) q->data[i] = temp[i];
		q->tail = q->count;
		q->head = 0;
		free(temp);
	}
	q->data[q->tail] = x;
	q->tail++;
	if (q->tail == q->cap) q->tail = 0;
	q->count++;
}

int Dequeue(Queue *q)
{
	int x = q->data[q->head];
	q->head++;
	if (q->head == q->cap) q->head = 0;
	q->count--;
	return x;
}

int main()
{
	int n, x;
	scanf("%d", &n);
	char command[5];
	Queue q;
	Queue *qp = &q;
	InitQueue(qp, 4);
	for (int i = 0; i < n; i++){
		scanf("%s", command);
		if (strcmp(command, "ENQ") == 0){
			scanf("%d", &x);
			Enqueue(qp, x);
		}
		if (strcmp(command, "DEQ") == 0){
			x = Dequeue(qp);
			printf("%d\n", x);
		}
		if (strcmp(command, "EMPTY") == 0){
			if (QueueEmpty(qp) == 1) printf("true\n");
			else printf("false\n");
		}
	}
	free(q.data);
	return 0;
}