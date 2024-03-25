#include <stdio.h>
#include <stdlib.h>
int *array;

int compare(int i, int j)
{
	if (array[i] == array[j]) return 0;
	return array[i] > array[j] ? 1 : -1; 
}

void swap(int i, int j) 
{ 
        int t = array[i]; 
        array[i] = array[j]; 
        array[j] = t; 
} 

int partition(int low, int high, int (*compare)(int i, int j))
{
	int i = low, j = low;
	while (j < high){
		if (compare(j, high) == -1){
			swap(i,j);
			i++;
		}
		j++;
	}
	swap(i,high);
	return i;
}

void selectsort(int s, int e, int(*compare)(int i, int j))
{
	int j = e;
	while (j > s){
		int k = j, i = j - 1;
		while (i >= 0){
			if (compare(k,i) == -1) k = i;
			i--;
		}
		swap(j,k);
		j--;
	}	
}

void quicksort(int low,int high,int m, int (*compare)(int i, int j))
{
	while (high > low){
		if ((high - low + 1) < m){
			selectsort(low, high, compare);
			break;
		}
		int q = partition(low, high, compare);
		if ((q - low) < (high - q)){
			quicksort(low, q - 1, m, compare);
			low = q + 1;
		}
		else{
			quicksort(q + 1, high, m, compare);
			high = q - 1;
		}	
	}	
}

int main()
{
	int n, m;
	scanf("%d", &n);
	scanf("%d", &m);
	array = (int*)malloc(n * sizeof(int)); 
	for (int i = 0; i < n; i++) scanf("%d", &array[i]); 
    quicksort(0, n - 1, m, compare); 
    for (int i = 0; i < n; i++) printf("%d ", array[i]); 
    printf("\n"); 
    free(array); 
    return 0; 
}