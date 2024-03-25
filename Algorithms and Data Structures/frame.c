#include <stdio.h>
#include <string.h>

int main(int argc , char ** argv)
{   
    if (argc != 4) printf("%s", "Usage: frame <height> <width> <text>");
	else{
		int height = atoi(argv[1]);
		int width = atoi(argv[2]);
		int len = strlen(argv[3]);
		if (((len + 2) > width) || (height < 3)) printf("%s", "Error");
		else{
			for (int i = 0; i < width;i++) printf("*");
			for (int i = 1; i < (height + 1)/2 - 1 ;i++){
				printf("\n*");
				for(int j = 0; j < width - 2;j++) printf(" ");
				printf("*");
			}
			printf("\n*");
			for (int i = 0; i < (width - len - 2) / 2; i++) printf(" ");
			for (int i = 0; i < len;i++) printf("%c", argv[3][i]);
			for (int i = 0; i < ((width - len - 2) + 2 - 1) / 2; i++) printf(" ");
			printf("*");
			for (int i = (height + 1) / 2; i < height - 1;i++){
				printf("\n*");
				for(int j = 0; j < width - 2;j++) printf(" ");
				printf("*");
			}
			printf("\n");
			for (int i = 0; i < width;i++) printf("*");
		}
	}
	return 0;
}	