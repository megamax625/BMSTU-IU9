#include <stdio.h>
#include <string.h>

int word_count(char *src)
{
	int count = 0;
	for (int i = 0; i < strlen(src); i++){
		if (src[i] == ' ') continue;
		else{
			count++;
			while ((src[i] != ' ') && (src[i] != 0)) i++;
		}	
	}
	return count;
}

void csort(char *src, char *dest)
{
	int n = word_count(src);
	int words_len[n];
	int count[2][n];
	for (int i = 0; i < n; i++){
		count[0][i] = 0;
		count[1][i] = 0;
		words_len[i] = 0;
	}	
	int word = 0;
	for (int i = 0; i < strlen(src); i++){
		if (src[i] == ' ') continue;
		else{
			count[0][word] = i;
			while ((src[i] != ' ') && (src[i] != 0)){
				words_len[word] += 1;
				i++;	
			}
			word++;	
		}		
	}
	for (int i = 0; i < n - 1; i++){
		word = i + 1;
		while (word < n){
			if (words_len[word] < words_len[i]) count[1][i] += 1;
			else count[1][word] += 1;
			word++;
		}	
	}
	int k = 0;
	for (int m = 0; m < n; m++){
		for (int i = 0; i < n; i++){
			if (count[1][i] == m){
				for (int j = count[0][i]; j < count[0][i] + words_len[i]; j++) dest[k++] = src[j];
				if (m != (n - 1)) dest[k++] = ' ';
				i = -1;
				m++;
			}	
		}
	}
	dest[k] = 0;
}

int main()
{
	char src[1000];
	gets(src);
	char dest[1000];
	csort(src, dest);
	printf("%s", dest);
	return 0;
}