#include <stdio.h>

int power_of_2(int num)
{
	if (num == 0) return 0;
	return (num & (num - 1)) == 0;
}   

int recursion_count(int *num, int n, int index, int sum, int res)
{
	if (index == n-1) {                                    
		sum += num[index];
		if (power_of_2(sum) == 1) res++;
		return res;    
	}                
	else {
		sum += num[index];
		if (power_of_2(sum) == 1) res++;
		index++;
		res += recursion_count(num, n, index, sum - num[index - 1], 0);
		res += recursion_count(num, n, index, sum, 0);
		return res;
	}	
}

int main()
{
	int n;
	scanf("%d", &n);
	int num[n];
	for (int i = 0; i < n; i++) scanf("%d", &num[i]);
	int res = recursion_count(num, n, 0, 0, 0);
	printf("%d", res);
	return 0;
}