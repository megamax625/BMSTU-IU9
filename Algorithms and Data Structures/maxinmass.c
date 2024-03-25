#include  <stdio.h>

int array[] = {
        100000000,
        400000000,
        300000000,
        500000000,
        200000000
};

int compare(void  *a, void  *b)
{
        int va =  *(int*)a;
        int vb =  *(int*)b;
        if (va == vb) return 0;
        return va  < vb ? -1 : 1;
}

int maxarray(void  *base, unsigned long nel, unsigned long width,
        int (*compare)(void *a, void *b))
{
        unsigned long max = 0;
        for (unsigned long i = 1; i < nel; i++){
            void *mp = (void*)(base + max * width);
            void *p = (void*)(base + i * width);
            if (compare(p,mp) > 0){
                max = i;
            }
        }
        return max;
}


int maxarray(void*, unsigned long, unsigned long,
        int (*)(void  *a, void  *b));

int main(int argc, char  **argv)
{
        printf("%d\n", maxarray(array, 5, sizeof(int), compare));
        return 0;
}