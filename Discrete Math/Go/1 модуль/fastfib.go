package main

import (
	"fmt"
	"math/big"
)

func main() {
	var n int
	fmt.Scan(&n)
	if n == 1 || n == 2 {
		fmt.Print(1)
	} else {
		var A [2][2]*big.Int
		var E [2][2]*big.Int
		for i := 0; i < 2; i++ {
			for j := 0; j < 2; j++ {
				if i == 1 && j == 1 {
					A[i][j] = big.NewInt(0)
				} else {
					A[i][j] = big.NewInt(1)
				}
				if i == j {
					E[i][j] = big.NewInt(1)
				} else {
					E[i][j] = big.NewInt(0)
				}
			}
		}
		fmt.Print(Power(n-1, A, E))
	}
}

func MatrixMultiplication(A, B [2][2]*big.Int) (C [2][2]*big.Int) {
	for i := 0; i < 2; i++ {
		for j := 0; j < 2; j++ {
			C[i][j] = big.NewInt(0)
		}
	}
	for row := 0; row < 2; row++ {
		for col := 0; col < 2; col++ {
			for i := 0; i < 2; i++ {
				t := big.NewInt(0)
				C[row][col].Add(C[row][col], t.Mul(A[row][i], B[i][col]))
			}
		}
	}
	return
}

func Power(n int, A, B [2][2]*big.Int) (res *big.Int) {
	for n > 0 {
		if n&1 == 1 {
			B = MatrixMultiplication(A, B)
		}
		A = MatrixMultiplication(A, A)
		n >>= 1
	}
	res = big.NewInt(0)
	return res.Add(B[1][0], B[1][1])
}