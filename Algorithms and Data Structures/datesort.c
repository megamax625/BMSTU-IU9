#include <stdio.h>
#include <stdlib.h>

typedef struct Date Date;

struct Date{
	int year, month, day;
};

int get_set(char key, Date *rec, int i)
{
	int k;
	if (key == 'd') k = rec[i].day;
	else if (key == 'm') k = rec[i].month;
	else if (key == 'y') k = rec[i].year - 1970;
	return k;
}

Date* DistributionSort(char key, Date *rec, int n)
{
	int set;
	if (key == 'd') set = 31;
	else if (key == 'm') set = 12;
	else if (key == 'y') set = 60;
	int count[set];
	for (int i = 0; i < set; i++) count[i] = 0;
	int j = 0, k = 0;
	while (j < n){
		k = get_set(key, rec, j);
		count[k] += 1;
		j++;
	}
	int i = 1;
	while (i < set){
		count[i] += count[i - 1];
		i++;
	}
	Date *D = (Date*)malloc(n * sizeof(Date));
	j = n - 1;
	while (j >= 0){
		k = get_set(key, rec, j);
		i = count[k] - 1;
		count[k] = i;
		D[i].day = rec[j].day;
		D[i].month = rec[j].month;
		D[i].year = rec[j].year;
		j--;
	}
	for (int i = 0; i < n; i++) rec[i] = D[i];
	free(D);
	return rec;
}

int main()
{
	int n;
	scanf("%d", &n);
	Date* date = (Date*)malloc(n * sizeof(Date));
	for (int i = 0; i < n; i++) scanf("%d %d %d", &date[i].year, &date[i].month, &date[i].day);
	date = DistributionSort('d', date, n);
	date = DistributionSort('m', date, n);
	date = DistributionSort('y', date, n);
	for (int i = 0;	i < n; i++) printf("%d %d %d\n", date[i].year, date[i].month, date[i].day);
	free(date);
	return 0;
}