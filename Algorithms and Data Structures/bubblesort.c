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
 
void bubblesort(unsigned long nel, 
        int (*compare)(unsigned long i, unsigned long j), 
        void (*swap)(unsigned long i, unsigned long j)) 
{ 
    unsigned long left = 0, right = nel - 1;
    unsigned long flag1 = 0, flag2 = 0;
	while (left < right){
		for (unsigned long i = left; i < right; i++){
			if (compare(i, i+1) == 1){
				swap(i, i+1);
				flag1 = i;
			}	
		}
		flag2 = flag1;
		for (unsigned long i = flag2; i > left; i--){
			if (compare(i, i-1) == -1){
				swap(i-1, i);
				flag2 = i;
			}	
		}
		left = flag2;
		right = flag1;
		flag1 = flag2;
	}
} 


int main(int argc, char **argv) 
{ 
        int i, n; 
        scanf("%d", &n); 
 
        array = (int*)malloc(n * sizeof(int)); 
        for (i = 0; i < n; i++) scanf("%d", array+i); 
 
        bubblesort(n, compare, swap); 
        for (i = 0; i < n; i++) printf("%d␣", array[i]); 
        printf("\n"); 
 
        free(array); 
        return 0; 
} 

nel – количество элементов в последовательности;
compare – указатель на функцию сравнения, которая возвращает -1, если i-тый элемент меньше j-того, 0 – в случае, если i-тый элемент равен j-тому, и 1 – в случае, если i-тый элемент больше j-того;
swap – указатель на функцию обмена i-того и j-того элементов последовательности.