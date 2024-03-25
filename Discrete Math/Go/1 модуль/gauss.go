package main

import (
	"fmt"
	"math/big"
)

var solutions [5]*big.Rat

func main() {
	var n, elem, row, col int64
	fmt.Scan(&n)
	m := n + 1
	var matrix [5][6]*big.Rat
	for row = 0; row < n; row++ {
		for col = 0; col < m; col++ {
			fmt.Scanf("%d", &elem)
			t := new(big.Rat)
			t.SetInt64(elem)
			matrix[row][col] = t
		}
	}
	//	for row = 0; row < n; row++ {
	//		for col = 0; col < m; col++ {
	//			fmt.Print(matrix[row][col], " ")
	//		}
	//		fmt.Print("\n")
	//	}
	if gauss(matrix, n) == 1 {
		var i int64
		for i = 0; i < n; i++ {
			fmt.Println(solutions[i])
		}
	} else {
		fmt.Print("No solution")
	}
}

func gauss(a [5][6]*big.Rat, n int64) (solNum int) {
	var i int64
	where := make([]int64, 5)
	for i = 0; i < n; i++ {
		where[i] = -1
		solutions[i] = new(big.Rat)
	}
	var col, row int64
	t1 := new(big.Rat)
	t2 := new(big.Rat)
	t3 := new(big.Rat)
	for ; col < n && row < n; col++ {
		pivot := row
		for i := row; i < n; i++ {
			t3.Sub(t1.Abs(a[i][col]), t2.Abs(a[pivot][col]))
			if t3.Sign() == 1 {
				pivot = i
			}
		}
		for i := col; i <= n; i++ {
			a[pivot][i], a[row][i] = a[row][i], a[pivot][i]
		}
		where[col] = row
		for i = 0; i < n; i++ {
			if i != row {
				t1 := new(big.Rat)
				if a[row][col].Sign() == 0 {
					return -1
				}
				t1.Mul(a[i][col], t1.Inv(a[row][col]))
				for j := col; j <= n; j++ {
					a[i][j].Sub(a[i][j], t2.Mul(a[row][j], t1))
				}
			}
		}
		row++
	}
	for i = 0; i < n; i++ {
		if where[i] != -1 {
			solutions[i].Mul(a[where[i]][n], t1.Inv(a[where[i]][i]))
		}
	}
	for i = 0; i < n; i++ {
		if where[i] == -1 {
			return -1
		}
	}
	return 1
}