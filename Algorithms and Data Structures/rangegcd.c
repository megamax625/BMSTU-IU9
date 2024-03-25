#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int fasterpow(int n){
	if (n == 0)
		return 1;
	if (n % 2 == 1)
		return fasterpow(n - 1) * 2;
	else {
		int b = fasterpow(n / 2);
		return b * b;
	}
}

int gcd (int a, int b) {
	if (b == 0) return abs(a);
	else return gcd(b, a % b);
}
 
int* ComputeLogarithms(int m)
{
	int *lg = (int*)malloc(100000 * m * sizeof(int));
	int i = 1, j = 0;
	while (i < m){
		while (j < fasterpow(i)){
			lg[j] = i - 1;
			j++;
		}
		i++;
	}
	return lg;
}
 
int** SparceTable_Build(int *v, int *lg, int n)
{
	int m = lg[n] + 1;
	int **ST = (int**)malloc(n * m * sizeof(int*));
	int i = 0;
	while (i < n){
		ST[i] = (int*)malloc(m * sizeof(int));
		ST[i][0] = v[i];
		i++;
	}
	int j = 1;
	while (j < m){
		i = 0;
		while (i <= (n - fasterpow(j))){
			ST[i][j] = gcd(ST[i][j - 1], ST[i + (int)fasterpow(j - 1)][j - 1]);
			i++;
		}
		j++;
	}
	return ST;
}

void SparceTable_Query(int **ST, int l, int r, int *lg)
{
	int j = lg[r - l + 1];
	int v = gcd(ST[l][j], ST[r - (int)fasterpow(j) + 1][j]);
	printf("%d\n", v);
}
 
int main()
{
	int n, m, l, r;
	scanf("%d", &n);
	int *array = (int*)malloc(n * sizeof(int));
	for (int i = 0; i < n; i++) scanf("%d", &array[i]);
	scanf("%d", &m);
	int *lg = ComputeLogarithms(20);
	int **ST = SparceTable_Build(array, lg, n);
	free(array);
	for (int i = 0; i < m; i++){
		scanf("%d %d", &l, &r);
		SparceTable_Query(ST, l, r, lg);
	}
	for (int i = 0; i < n; i++) free(ST[i]);
	free(ST);
	free(lg);
	return 0;
}