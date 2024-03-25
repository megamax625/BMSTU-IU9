#include <stdio.h>
#include <stdlib.h>

int main()
{
	char k;
	int n;
	scanf("%d %d", &k,&n);
	char *numdiv = (char*)malloc((n + 1) * sizeof(char));
	if (numdiv == NULL ) {
        printf ("Не хватает памяти \n" );
        return -1;
        }
	for (int j = 2; j <= n;j++) numdiv[j] = 1;
	for (int j = 2; j <= n;j++){
		if (numdiv[j] == 1){
			for (int i = 2 * j; i <= n;i += j){
				numdiv[i] = numdiv[i / j] + 1;
			}	
		}	
	} 
	for (int j = 2; j <= n;j++){
        if (numdiv[j] == k) printf("%d ", j);
	}
	free(numdiv);
	return 0;
}