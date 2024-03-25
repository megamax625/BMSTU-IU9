package main

import "fmt"

func main() {
	var n int
	fmt.Scan(&n)
	arr := make([]int, n)
	for i := 0; i < n; i++ {
		fmt.Scan(&arr[i])
	}
	Qsort(n,
		func(i, j int) bool {
			return arr[i] < arr[j]
		},
		func(i, j int) {
			t := arr[j]
			arr[j] = arr[i]
			arr[i] = t
		})
	for i := 0; i < n; i++ {
		fmt.Print(arr[i], " ")
	}
}

func Qsort(n int,
	less func(i, j int) bool,
	swap func(i, j int)) {
	QsortRec(0, n-1, less, swap)
}

func QsortRec(low int, high int,
	less func(i, j int) bool,
	swap func(i, j int)) {
	if low < high {
		q := Partition(low, high, less, swap)
		QsortRec(low, q-1, less, swap)
		QsortRec(q+1, high, less, swap)
	}
}

func Partition(low int, high int,
	less func(i, j int) bool,
	swap func(i, j int)) int {
	i := low
	j := low
	for j < high {
		if less(j, high) {
			swap(i, j)
			i++
		}
		j++
	}
	swap(i, high)
	return i
}