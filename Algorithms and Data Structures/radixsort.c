#include <stdio.h>
#include <stdlib.h>

typedef union Int32 Int32;

union Int32 { 
    int x; 
    unsigned char bytes[4]; 
}; 

Int32* DistribSort(int key, Int32 *seq, int n)
{
	int count[256];
	for (int i = 0; i < 256; i++) count[i] = 0;
	for (int i = 0; i < n; i++){
		int k = seq[i].bytes[key];
		count[k] += 1;
	}
	for (int i = 1; i < 256; i++) count[i] += count[i - 1];
	Int32* p = (Int32*)malloc(n * sizeof(Int32));
	int j = n - 1;
	while (j >= 0){
		int k = seq[j].bytes[key];
		int i = count[k] - 1;
		count[k] = i;
		p[i].x = seq[j].x;
		j--;
	}
	free(seq);
	return p;
}

Int32* Last_DistribSort(int key, Int32 *seq, int n)
{
	int count[256];
	for (int i = 0; i < 256; i++) count[i] = 0;
	for (int i = 0; i < n; i++){
		int k = seq[i].bytes[key];
		count[k & 128] += 1;
	}
	for (int i = 1; i < 256; i++) count[255 - i] += count[255 - i + 1];
	Int32* p = (Int32*)malloc(n * sizeof(Int32));
	int j = n - 1;
	while (j >= 0){
		int k = seq[j].bytes[key];
		int i = count[k & 128] - 1;
		count[k & 128] = i;
		p[i].x = seq[j].x;
		j--;
	}
	free(seq);
	return p;
}

Int32* RadixSort(int bytenum, Int32 *seq, int n)
{
	int j = 0;
	while (j < bytenum){
		seq = DistribSort(j, seq, n);
		j++;
	}
	seq = Last_DistribSort(3, seq, n);
	return seq;
}

int main()
{
	int n;
	scanf("%d", &n);
	Int32* seq = (Int32*)malloc(n * sizeof(Int32));
	for (int i = 0; i < n; i++) scanf("%d", &seq[i].x);
	seq = RadixSort(4, seq, n);
	for (int i = 0; i < n; i++) printf("%d ", seq[i].x);
	free(seq);
	return 0;
}