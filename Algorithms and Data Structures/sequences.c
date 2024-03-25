#include <stdio.h>
#include <stdlib.h>

int main()
{
	int n1,n2;
	scanf("%d", &n1);
	int *seq1 = (int*)malloc(n1 * sizeof(int));
	for (int i = 0; i < n1; i++) scanf("%d", &seq1[i]);
	if (seq1 == NULL ) {
        printf ("Не хватает памяти \n" );
        return -1;
    }
	scanf("%d", &n2);
	int *seq2 = (int*)malloc(n2 * sizeof(int));
	if (seq2 == NULL ) {
        printf ("Не хватает памяти \n" );
        return -1;
    }
	for (int i = 0; i < n2; i++) scanf("%d", &seq2[i]);
	int a1 = 0, a2 = 0;
	while (a1 != n1 || a2 != n2){
		if (a1 == n1){
			printf("%d ", seq2[a2]);
			a2 += 1;
		}
		else if (a2 == n2){
			printf("%d ", seq1[a1]);
			a1 += 1;
		}
		else if (seq1[a1] >= seq2[a2]){
			printf("%d ", seq2[a2]);
			a2 += 1;
		}
		else{
			printf("%d ", seq1[a1]);
			a1 += 1;
		}
	}
	free(seq1);
	free(seq2);
	return 0;
}