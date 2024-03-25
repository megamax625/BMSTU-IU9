package main

import "fmt"

func main() {
	var k int64
	fmt.Scan(&k)
	if k < 9 {
		fmt.Println(k + 1)
	} else {
		var digit, rank int64 = k + 1 - 9, 1
		var digitsave, x int64
		for digit > 0 {
			rank++
			digitsave = digit
			digit -= 9 * power(10, (rank-1)) * rank
		}
		digit = digitsave
		x = power(10, (rank - 1))
		if digit/rank != 0 {
			x = power(10, (rank-1)) + digit/rank + digit%rank - 1
		}
		digit = rank - digit%rank
		for digit > 0 && digit%rank != 0 {
			x /= 10
			digit--
		}
		fmt.Println(x % 10)
	}
}

func power(base int64, pow int64) int64 {
	var num int64 = 1
	for ; pow > 0; pow-- {
		num *= base
	}
	return num
}