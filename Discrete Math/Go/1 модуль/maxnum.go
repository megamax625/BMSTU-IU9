package main

import (
	"fmt"
	"strconv"
)

var arr = make([]int, 0)

func main() {
	var n int
	fmt.Scan(&n)
	var arr []int = make([]int, n)
	for i := 0; i < n; i++ {
		fmt.Scan(&arr[i])
	}
	swap := func(i, j int) {
		arr[i], arr[j] = arr[j], arr[i]
	}
	compare := func(i, j int) bool {
		strA := strconv.Itoa(arr[i])
		strB := strconv.Itoa(arr[j])
		return strA+strB > strB+strA
	}
	Qsort(n, compare, swap)
	for i := 0; i < n; i++ {
		fmt.Printf("%d", arr[i])
	}
}

func Qsort(n int,
	compare func(i, j int) bool,
	swap func(i, j int)) {
	QsortRec(0, n-1, compare, swap)
}

func QsortRec(low int, high int,
	compare func(i, j int) bool,
	swap func(i, j int)) {
	if low < high {
		q := Partition(low, high, compare, swap)
		QsortRec(low, q-1, compare, swap)
		QsortRec(q+1, high, compare, swap)
	}
}

func Partition(low int, high int,
	compare func(i, j int) bool,
	swap func(i, j int)) int {
	i := low
	j := low
	for j < high {
		if compare(j, high) {
			swap(i, j)
			i++
		}
		j++
	}
	swap(i, high)
	return i
}