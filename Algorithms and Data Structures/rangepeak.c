#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void build(long *v, int i, int a, int b, int *t, int n)
{
	if (a == b) t[i] = peak_check(v, a, n);
	else{
		int m = (a + b) / 2;
		build(v, 2 * i + 1, a, m, t, n);
		build(v, 2 * i + 2, m + 1, b, t, n);
		t[i] = t[2 * i + 1] + t[2 * i + 2];
	}
}

int* SegmentTree_Build(long *v, int n)
{
	int *t = (int*)malloc(4 * n * sizeof(int));
	for (int i = 0; i < 4 * n; i++) t[i] = 0;
	build(v, 0, 0, n - 1, t, n);
	return t;
}

void update(int j, int a, int b, int *t, long *v, int n, int i)
{
	if (a == b) t[i] = peak_check(v, a, n);
	else{
		int m = (a + b) / 2;
		if (j <= m) update(j, a, m, t, v, n, i * 2 + 1);
		else update(j, m + 1, b, t, v, n, i * 2 + 2);
		t[i] = t[2 * i + 1] + t[2 * i + 2];
	}
}

void SegmentTree_Update(int j, long x, int n, int *t, long *v)
{
	v[j] = x;
	update(j, 0, n - 1, t, v, n, 0);
	if (j != 0) update(j - 1, 0, n - 1, t, v, n, 0);
	if (j != (n - 1)) update(j + 1, 0, n - 1, t, v, n, 0);
}

int peak_check(long *v, int i, int n)
{
	if (i >= n) return 0;
	if (n == 1) return 1;
	if ((i == 0) && (n == 2)){
		if (v[i] >= v[i + 1]) return 1;
		else return 0;
	}
	if ((i == 1) && (n == 2)){
		if (v[i] >= v[i - 1]) return 1;
		else return 0;
	}
	if (n >= 3){
		if (i == 0){
			if (v[i] >= v[i + 1]) return 1;
			else return 0;
		}
		if (i == (n - 1)){
			if (v[i] >= v[i - 1]) return 1;
			else return 0;
		}
		if ((v[i] >= v[i + 1]) && (v[i] >= v[i - 1])) return 1;
		else return 0;
	}	
}

int peak(int l, int r, int a, int b, int i, int *t)
{
	if ((l == a) && (r == b)) return t[i];
	int m = (a + b) / 2;
	if (r <= m) return peak(l, r, a, m, 2 * i + 1, t);
	else{
		if (l > m) return peak(l, r, m + 1, b, 2 * i + 2, t);
		else return peak(l, m, a, m, 2 * i + 1, t) + peak(m + 1, r, m + 1, b, 2 * i + 2, t);
	}
}

int main()
{
	int n, m;
	scanf("%d", &n);
	long *array = (long*)malloc(n * sizeof(long));
	for (int i = 0; i < n; i++) scanf("%ld", &array[i]);
	int *t = SegmentTree_Build(array, n);
	scanf("%d", &m);
	char func[5];
	int l, r;
	long x;
	for (int i = 0; i < m; i++){
		scanf("%s", func);
		if (strcmp(func, "PEAK") == 0){
			scanf("%d %d", &l, &r);
			printf("%d\n", peak(l, r, 0, n - 1, 0, t));
		}
		else{
			scanf("%d %ld", &l, &x);
			SegmentTree_Update(l, x, n, t, array);
		}	
	}
	free(array);
	free(t);
	return 0;
}