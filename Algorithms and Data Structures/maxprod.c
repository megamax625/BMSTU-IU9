#include <stdio.h>
#include <stdlib.h>
#include <math.h>
float *array;
void Kadane(int n, int *bounds)
{
	int l = 0, r = 0;
	int start = 0, i = 0;
	float sum =	0, maxsum = array[0];
	while (i < n){
		sum += array[i];
		if (sum > maxsum){
			maxsum = sum;
			l = start;
			r = i;
		}
		i++;
		if (sum < 0){
			sum = 0;
			start = i;
		}	
	}
	bounds[0] = l;
	bounds[1] = r;
}

int main()
{
	int n;
	scanf("%d", &n);
	int bounds[2] = {0};
	array = (float*)malloc(n * sizeof(float));
	float a, b;
	for (int i = 0; i < n; i++){
		scanf("%f/%f", &a, &b);
		if (a == 0) array[i] = -10000000;
		else array[i] = logf(a/b);
	}
	Kadane(n, bounds);
	printf("%d %d", bounds[0], bounds[1]);
	free(array);
	return 0;
}