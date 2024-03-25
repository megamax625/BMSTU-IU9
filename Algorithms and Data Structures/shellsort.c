#include <stdlib.h> 
#include <stdio.h> 
 
int *array; 
 
int compare(unsigned long i, unsigned long j) 
{ 
        if (i <= j) { 
                printf("COMPARE␣%d␣%d\n", i, j); 
        } else { 
                printf("COMPARE␣%d␣%d\n", j, i); 
        } 
 
        if (array[i] == array[j]) return 0; 
        return array[i] < array[j] ? -1 : 1; 
} 
 
void swap(unsigned long i, unsigned long j) 
{ 
        if (i <= j) { 
                printf("SWAP␣%d␣%d\n", i, j); 
        } else { 
                printf("SWAP␣%d␣%d\n", j, i); 
        } 
 
        int t = array[i]; 
        array[i] = array[j]; 
        array[j] = t; 
} 
 
void shellsort(unsigned long nel, 
        int (*compare)(unsigned long i, unsigned long j), 
        void (*swap)(unsigned long i, unsigned long j)) 
{ 
    unsigned long fib1 = 2, fib2 = 1, d;
	while (fib1 < nel){
		d = fib1;
		fib1 = fib1 + fib2;
		fib2 = d;
	}
	d = fib2;
	while (d > 0){
		for ( long i = d; i < nel; i++){
			for ( long j = i - d; j >= 0; j -= d){
				if (compare(j, j + d) != 1) break;
				swap(j, j + d);
			}	
		}
		if (d == 1) break;
		d = fib1 - fib2;
		fib1 = fib2;
		fib2 = d;
	}
} 
 
int main(int argc, char **argv) 
{ 
        int i, n; 
        scanf("%d", &n); 
 
        array = (int*)malloc(n * sizeof(int)); 
        for (i = 0; i < n; i++) scanf("%d", array+i); 
 
        shellsort(n, compare, swap); 
        for (i = 0; i < n; i++) printf("%d␣", array[i]); 
        printf("\n"); 
 
        free(array); 
        return 0; 
} 