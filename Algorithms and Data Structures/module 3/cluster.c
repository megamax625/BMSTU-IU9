#include <stdio.h>
#include <stdlib.h>

typedef struct PQueue PQueue;

struct PQueue{
	int *heap;
	int cap, count;
};

void heapify(int i, int n, PQueue *pq)
{
	for (;;){
		int l = 2 * i + 1;
		int r = l + 1;
		int j = i;
		if ((l < n) && (pq->heap[i] > pq->heap[l])) i = l;
		if ((r < n) && (pq->heap[i] > pq->heap[r])) i = r;
		if (i == j) break;
		int t = pq->heap[i];
		pq->heap[i] = pq->heap[j];
		pq->heap[j] = t;
	}
}

void InitPriorityQueue(PQueue *pq, int n)
{
	pq->heap = (int*)malloc(n * sizeof(int));
	pq->cap = n;
	pq->count = 0;
}

int QueueEmpty(PQueue *pq)
{
	return (pq->count == 0);
}

int Maximum(PQueue *pq)
{
	return pq->heap[0];
}

void Insert(PQueue *pq, int ptr)
{
	int i = pq->count;
	pq->count = i + 1;
	pq->heap[i] = ptr;
	while ((i > 0) && (pq->heap[(i - 1) / 2] > pq->heap[i])){
		int t = pq->heap[i];
		pq->heap[i] = pq->heap[(i - 1) / 2];
		pq->heap[(i - 1) / 2] = t;
		i = (i - 1) / 2;
	}
}

int ExtractMax(PQueue *pq)
{
	int ptr = pq->heap[0];
	pq->count--;
	if (pq->count > 0){
		pq->heap[0] = pq->heap[pq->count];
		heapify(0, pq->count, pq);
	}
	return ptr;
}

int main()
{
	int n, m, t1, t2, finish = 0;
	scanf("%d", &n);
	scanf("%d", &m);
	PQueue p;
	PQueue *pq = &p;
	InitPriorityQueue(pq, m);
	for (int i = 0; i < n; i++){
		scanf("%d %d", &t1, &t2);
		finish = t1 + t2;
		Insert(pq, finish);
	}
	for (int i = n; i < m; i++){
		scanf("%d %d", &t1, &t2);
		finish = ExtractMax(pq);
		if (finish >= t1) finish += t2;
		else finish = t1 + t2;
		Insert(pq, finish);
	}
	while (QueueEmpty(pq) == 0) finish = ExtractMax(pq);
	printf("%d", finish);
	free(p.heap);
	return 0;
}