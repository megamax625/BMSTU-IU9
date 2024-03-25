#include <stdio.h>

int main()
{
	short m = 0,n = 0,line = 4001,col = 4001;
	scanf("%hd %hd", &m,&n);
	int mins[n], row[n], saddle = 0;
	for (short i = 0; i < m; i++){
		if (i == 0){
			for (short j = 0; j < n; j++){
			scanf("%d", &row[j]);
			mins[j] = row[j];
			}
		}
		else for (short j = 0; j < n; j++){
			scanf("%d", &row[j]);
			if (row[j] < mins[j]) mins[j] = row[j];
		}
		short maxind = 0;
		for (short j = 0; j < n; j++) if (row[j] > row[maxind]) maxind = j;
		char second = 0;
		for (short j = 0; j < n; j++) if ((row[maxind] == row[j]) && (maxind != j)) second = 1;
		if (second == 0){
			if (row[maxind] == mins[maxind]){
				saddle = row[maxind];
				line = i;
				col = maxind;
			}
		}
	}
	if (col < 4001){
		if (saddle == mins[col]) printf("%hd %hd", line,col);
		else printf("none");
	}
	else printf("none");
	return 0;
}