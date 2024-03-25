#include  <stdio.h>

int array[] = { 1, 2, 3, 4, 5, 3, 2, -5 };

int less(unsigned long i, unsigned long j)
{
        return array[i]  < array[j];
}

unsigned long peak(unsigned long nel,
        int (*less)(unsigned long i, unsigned long j))
{
        unsigned long first = 0, last = nel;
        unsigned long middle = first + (last - first) / 2;
        while(!(less(middle - 1,middle) && less(middle + 1,middle)) || (last - first > 2)){
            if (less(middle - 1,middle)){
                first = middle;
            }else{
                last = middle;
            }
            middle = first + (last - first) / 2;
        }
    return middle;
}

unsigned long peak(unsigned long,
        int (*)(unsigned long, unsigned long));

int main(int argc, char  **argv)
{
        unsigned long i = peak(8, less);
        if ((i == 0 || array[i]  >= array[i-1]) &&
                (i == 7 || array[i]  >= array[i+1])) {
                printf("CORRECT\n");
        } else {
                printf("WRONG\n");
        }
        return 0;
}