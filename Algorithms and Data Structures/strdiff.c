#include  <stdio.h>

int strdiff(char *a, char *b)
{
    int i = 0, ans = 0;
    while((a[i] != 0) || (b[i] != 0)){
		for (int j = 0; j < 8;j++){
			if ((a[i] & (1 << j)) == (b[i] & (1 << j))) ans++;
			else return ans;
		}
        i++;
    }
	return -1;
}

int main(int argc, char **argv)
{
        char s1[1000], s2[1000];
        gets(s1);
        gets(s2);
        printf("%d\n", strdiff(s1, s2));

        return 0;
}