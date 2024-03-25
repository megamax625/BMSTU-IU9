#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int max(int a, int b)
{
	return (a > b) ? a : b;
}

int query(int *t, int l, int r, int i, int a, int b)
{
	if ((l == a) && (r == b)) return t[i];
	else{
		int m = (a + b) / 2;
		if (r <= m) return query(t, l, r, 2 * i + 1, a, m);
		else if (l > m) return query (t, l, r, 2 * i + 2, m + 1, b);
		else return max(query(t, l, m, 2 * i + 1, a, m), query(t, m + 1, r, 2 * i + 2, m + 1, b));
	}	
}

void SegmentTree_Build(int *v, int i, int a, int b, int *t)
{
	if (a == b) t[i] = v[a];
	else{
		int m = (a + b) / 2;
		SegmentTree_Build(v, 2 * i + 1, a, m, t);
		SegmentTree_Build(v, 2 * i + 2, m + 1, b, t);
		t[i] = max(t[2 * i + 1], t[2 * i + 2]);
	}	
}

void SegmentTree_Update(int j, int x, int i, int a, int b, int *t)
{
	if (a == b) t[i] = x;
	else{
		int m = (a + b) / 2;
		if (j <= m) SegmentTree_Update(j, x, 2 * i + 1, a, m, t);
		else SegmentTree_Update(j, x, 2 * i + 2, m + 1, b, t);
		t[i] = max(t[2 * i + 1], t[2 * i + 2]);
	}	
}

int main()
{
	int n;
	scanf("%d", &n);
	int *v = (int*)malloc(n * sizeof(int));
	for (int i = 0; i < n; i++) scanf("%d", &v[i]);
	int *t = (int*)malloc(4 * n * sizeof(int));
	SegmentTree_Build(v, 0, 0, n - 1, t);
	free(v);
	int k;
	scanf("%d", &k);
	char func[4];
	int l, r, ans;
	for (int y = 0; y < k; y++){
		scanf("%s %d %d", func, &l, &r);
		if (strcmp(func, "UPD") == 0) SegmentTree_Update(l, r, 0, 0, n - 1, t);
		else{
			ans = query(t, l, r, 0, 0, n - 1);
			printf("%d\n", ans);
		}	
	}
	free(t);
	return 0;
}