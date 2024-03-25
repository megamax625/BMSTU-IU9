#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int split(char *s, char ***words)
{
    int n = 0, i = 0;
	char **strns = (char**)malloc(100000 * sizeof(char*));
	char *word = (char*)malloc(sizeof(char) * 1000);
	while ((s[i] != '\n') && (s[i] != '\0')){
		int l = 0;
		if (s[i] != ' '){
			while ((s[i] != ' ') && (s[i] != '\0')){
				word[l] = s[i];
				i++;
				l++;
			}
			word[l] = '\0';
			strns[n] = (char*)malloc((l + 1) * sizeof(char));
			strcpy(strns[n], word);
			n++;
		}
		while (s[i] == ' ') i++;
	}
	*words = strns;
	return n;
}

#define INITIAL_SIZE 128

char *getstring()
{
    char *s;
    int flag, len = 0, size = INITIAL_SIZE;

    s = (char*)malloc(INITIAL_SIZE);
    if (s == NULL) return NULL;

    for (;;) {
        if (fgets(s+len, size-len, stdin) == NULL) {
            free(s);
            return NULL;
        }

        len += (int)strlen(s+len);
        if (s[len-1] == '\n') break;

        char *new_s = (char*)malloc(size *= 2);
        if (new_s == NULL) {
            free(s);
            return NULL;
        }

        memcpy(new_s, s, len);
        free(s);
        s = new_s;
    }

    s[len-1] = 0;
    return s;
}

void printword(char *s)
{
    printf("\"");
    for (;;) {
        char c = *s++;
        switch (c) {
        case 0:
            printf("\"\n");
            return;
        case '\a':
            printf("\\a");
            break;
        case '\b':
            printf("\\b");
            break;
        case '\f':
            printf("\\f");
            break;
        case '\n':
            printf("\\n");
            break;
        case '\r':
            printf("\\r");
            break;
        case '\t':
            printf("\\t");
            break;
        case '\v':
            printf("\\v");
            break;
        case '\\':
            printf("\\\\");
            break;
        case '\"':
            printf("\\\"");
            break;
        default:
            printf(c >= 0x20 && c <= 0x7E ? "%c" : "\\x%02x", c);
        }
    }
}

int main()
{
    char *s = getstring();
    if (s == NULL) return 1;

    char **words;
    int n = split(s, &words);
    free(s);

    for (int i = 0; i < n; i++) printword(words[i]);

    for (int i = 0; i < n; i++) free(words[i]);
    free(words);
    return 0;
}