#include <stdio.h>
#include <string.h>
#define width 100
#define size_t int

int compare(const void *a, const void *b)
{
	size_t a_len = strnlen(a, width);
	size_t b_len = strnlen(b, width);
	size_t a_count = 0, b_count = 0;
	for (size_t i = 0; i < a_len; i++) if (*((char*)a + i) == 97) a_count++;
	for (size_t i = 0; i < b_len; i++) if (*((char*)b + i) == 97) b_count++;
	return a_count > b_count ? 1 : 0;
}

void Heapify(void *base, size_t width, 
		int (*compare) (const void *a, const void *b), size_t n, size_t p)
{
	char *l, *r, *pp, *jp;
	size_t j, li, ri;
	char t;
	for (;;) {
		j = p;
		li = 2 * p + 1;
		ri = 2 * p + 2;
		l = r = pp = jp = (char*)base;
		l += width * li;
		r += width * ri;
		pp += width * p;
		if ((li < n) && (compare(pp, l) == 0)){
			p = li;
			pp = (char*)base;
			pp += width * p;
		}
		if ((ri < n) && (compare(pp, r) == 0)){
			p = ri;
			pp = (char*)base;
			pp += width * p;
		}
		if (p == j) break;
		jp += width * j;
		for (size_t i = 0; i < width; i++){
			t = *(char*)jp;
			*(char*)jp = *(char*)pp;
			*(char*)pp = t;
			pp++;
			jp++;
		}	
	}	
}	

void Build_Max_Heap (void *base, size_t nel, size_t width, int (*compare) (const void *a, const void *b))
{
	size_t p = nel / 2 - 1;
	while (p >= 0) {
		Heapify(base, width, compare, nel, p);
		p--;
	}
}

void hsort(void *base, size_t nel, size_t width,
		int (*compare) (const void *a, const void *b))
{
	char *ip, *b;
	char t;
	Build_Max_Heap(base, nel, width, compare);
	size_t e = nel - 1;
	b = (char*)base;
	ip = (char*)base;
	ip += width * e;
	while (e > 0){
		for (size_t i = 0; i < width; i++){
			t = *(char*)b;
			*(char*)b = *(char*)ip;
			*(char*)ip = t;
			ip++;
			b++;
		}
		b = (char*)base;
		ip -= width * 2;
		Heapify(base, width, compare, e, 0);
		e--;
	}	
}

int main()
{
	size_t n;
	scanf("%d", &n);
	char array[n][width];
	for (size_t i = 0; i < n; i++) scanf("%s", &array[i]);
	hsort(array, n, width, compare);
	for (size_t i = 0; i < n; i++) printf("%s\n", array[i]);
	return 0;
}