#include <stdio.h>
#include <stdlib.h>

int *array;

int compare(int i, int j)
{
	if (abs(array[i]) == abs(array[j])) return 0;
	return abs(array[i]) > abs(array[j]) ? 1 : -1; 
}

void swap(int i, int j) 
{ 
        int t = array[i]; 
        array[i] = array[j]; 
        array[j] = t; 
} 

void merge(int k,int l,int m, int (*compare)(int i, int j)){
	int *t;
	t = (int*)malloc((m - k + 1) * sizeof(int));
	int i = k, j = l + 1, h = 0;
	while (h < (m - k + 1)){
		if ((j <= m) && ((i == l + 1) || (compare(j,i) == -1))){
			t[h] = array[j];
			j++;
		}else{
			t[h] = array[i];
			i++;	
		}
		h++;	
	}
	for (int n = 0; n < h; n++) array[k + n] = t[n];
	free(t);
}

void insertsort(int s, int e, int (*compare)(int i, int j))
{
	int i = s + 1;
	while (i < (e + 1)){
		int loc = i - 1;
		while ((loc >= s) && (compare(loc, loc + 1) == 1)){
			swap(loc,loc + 1);
			loc--;
		}
		i++;
	}
}

void mergesort(int low, int high, int (*compare)(int i, int j))
{
	if ((high - low + 1) < 5) insertsort(low, high, compare);
	else{
		int med = (low + high) / 2;
		mergesort(low, med, compare);
		mergesort(med + 1, high, compare);
		merge(low, med, high, compare);
	}
}

int main()
{
	int n; 
    scanf("%d", &n); 
    array = (int*)malloc(n * sizeof(int)); 
    for (int i = 0; i < n; i++) scanf("%d", &array[i]); 
    mergesort(0, n - 1, compare); 
    for (int i = 0; i < n; i++) printf("%d ", array[i]); 
    printf("\n"); 
    free(array); 
    return 0; 
}