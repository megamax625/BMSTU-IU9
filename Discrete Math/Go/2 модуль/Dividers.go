package main

import (
	"fmt"
	"sort"
)

func main() {
	var n int
	fmt.Scan(&n)
	var dividers []int
	dividers = GetGraph(n)
	sort.Ints(dividers)
	GraphPrint(dividers)
}

func GetGraph(n int) []int {
	var dividers []int
	for i := 1; i*i <= n; i++ {
		if n%i == 0 {
			dividers = append(dividers, i)
			if !AlreadyAdded(dividers, n/i) {
				dividers = append(dividers, n/i)
			}
		}
	}
	return dividers
}

func AlreadyAdded(dividers []int, number int) bool {
	for _, num := range dividers {
		if num == number {
			return true
		}
	}
	return false
}

func CheckMiddle(dividers []int, high int, low int) bool {
	var based bool = true
	for k := high - 1; k > low; k-- {
		if dividers[high]%dividers[k] == 0 && dividers[k]%dividers[low] == 0 {
			based = false
			return based
		}
	}
	return based
}

func GraphPrint(dividers []int) {
	fmt.Printf("graph {\n")
	var dim = len(dividers)
	for i := 0; i < dim; i++ {
		fmt.Printf("\t%d\n", dividers[i])
	}
	for i := dim - 1; i > 0; i-- {
		for j := i - 1; j >= 0; j-- {
			if dividers[i]%dividers[j] == 0 {
				if CheckMiddle(dividers, i, j) {
					fmt.Printf("\t%d -- %d\n", dividers[i], dividers[j])
				}
			}
		}
	}
	fmt.Printf("}")
}
