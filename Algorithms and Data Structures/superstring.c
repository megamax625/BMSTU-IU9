#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int overlap(char *s1, char *s2, int size_t)
{
    int overlap = 0;
    int s1_right = strnlen(s1, size_t) - 1, s2_length = strnlen(s2, size_t);
	char *suffix;
	for (int i = s1_right, j = 1; i > 0 && j < s2_length;i--, j++){
		char *start = (char*)malloc(size_t * sizeof(char));
		char *end = (char*)malloc(size_t * sizeof(char));
		start[j] = 0;
		strncpy(start, s2, j);
		suffix = &s1[i];
		strcpy(end, suffix);
		if (strcmp(start, end) == 0) overlap = j;
		free(start);
		free(end); 
	}
	return overlap;
}

void merge(char *s1, char *s2, char *t, int o){
    char *post_overlap = &s2[o];
    strcpy(t, s1);
    strcat(t, post_overlap);
}

int main()
{
    char n;
    scanf("%hhu", &n);
    int size = 50;
    int size_t = size * n;
    char ind1 = 0, ind2 = 0;
    char **strings = (char**)malloc(size_t * sizeof(char));
    if (strings == NULL) return -1;
    char *string_sizes = (char*)malloc(n * size_t * sizeof(char));
	if (string_sizes == NULL) return -1;
	for (char i = 0; i < n; i++){ 
		strings[i] = string_sizes + (i * size_t);
		scanf("%s", strings[i]);
	}
	int max_overlap = 0;
	char len = n;
	char *mergant1, *mergant2;
	while(len > 1){
	    for (char i = 0; i < n; i++) {
			if (strnlen(strings[i], size_t) == 0) continue;
			for (char j = 0; j < n; j++) {
				if ((i == j) || (strnlen(strings[j], size_t) == 0)) continue;
				if ((max_overlap == 0) || (overlap(strings[i], strings[j], size_t) > max_overlap)) {
					max_overlap = overlap(strings[i], strings[j], size_t);
					mergant1 = strings[i];
					mergant2 = strings[j];
					ind1 = i;
					ind2 = j;
				}
			}
		}
		char *t = (char*)malloc(100000 * sizeof(char));
		merge(mergant1, mergant2, t, max_overlap);
		strcpy(strings[ind1], t);	
		strings[ind2][0] = 0;
		len--;
		free(t);
		max_overlap = 0;
	    for (char i = 0; i < n; i++){
	        if(strings[i][0] != 0);
	    }
	}
	unsigned int ans = strnlen(strings[ind1], 100000);
	printf("%ld", ans);
	free(string_sizes);
	free(strings);
	return 0;
}