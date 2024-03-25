#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int Lowest_Powerof2(int a)
{
	int num = 1;
	while (num < a) num *= 2;
	return num;
}

int build(char* v, int l, int r, int n, int *t)
{
	int sum = 0;
	int bound = (r < n) ? r : n;
	while (l < bound){
		int m = (l + r) / 2;
		sum = sum ^ build(v, l, m, n, t);
		l = m + 1;
	}
	if (r < n){
		sum = sum ^ (1 << (v[r] - 97));
		t[r] = sum;
	}
	return sum;	
}	

int* FenwickTree_Build(char *v, int n)
{
	int *t = (int*)malloc(n * sizeof(int));
	int r = Lowest_Powerof2(n);
	int p = build(v, 0, r - 1, n, t);
	return t;
}

int query(int *t, int i)
{
	int b = 0;
	while (i >= 0){
		b = b ^ t[i];
		i = (i & (i + 1)) - 1;
	}
	return b;	
}	

int FenwickTree_Query(int *t, int l, int r)
{
	return query(t, r) ^ query(t, l - 1);
}

void FenwickTree_Update(int i, int sig, int n, int *t)
{
	while (i < n){
		t[i] = t[i] ^ sig;
		i = i | (i + 1);
	}	
}

int main()
{
	char *str = (char*)malloc(1000001 * sizeof(char));
	scanf("%s", str);
	int n = strlen(str), m;
	int *t = FenwickTree_Build(str, n);
	char *subst = (char*)malloc(1000001 * sizeof(char));
	scanf("%d", &m);
	char func[4];
	int l, r;
	for (int i = 0; i < m; i++){
		scanf("%s", func);
		if (strcmp(func, "HD") == 0){
			scanf("%d %d", &l, &r);
			int len = r - l + 1;
			int v = FenwickTree_Query(t, l, r);
			if ((len % 2 == 0) && (v == 0)) printf("YES\n");
			else if ((len % 2 == 1) && ((v & (v - 1)) == 0)) printf("YES\n");
			else printf("NO\n");
		}
		else{
			scanf("%d %s", &l, subst);
			int i = 0, len = strlen(subst);
			while (i < len){
				int sig = (1 << (str[l] - 97)) ^ (1 << (subst[i] - 97));
				FenwickTree_Update(l, sig, n, t);
				str[l] = subst[i];
				l++;
				i++;
			}	
		}	
	}
	free(str);
	free(subst);
	free(t);
	return 0;
}