package main

import "fmt"

var table, variations [][]int
var gf, gs []int
var N int

func main() {
	fmt.Scan(&N)
	table = make([][]int, N)
	ScanTable(table)
	list := make([]int, N)
	variations = make([][]int, 0)
	Trav(list, 0, 0, 0, 0)
	GetRes()
}

func ScanTable(table [][]int) {
	var t string
	for i := 0; i < N; i++ {
		table[i] = make([]int, N)
		for j := 0; j < N; j++ {
			fmt.Scan(&t)
			if t == "-" {
				table[i][j] = 1
			} else {
				table[i][j] = 0
			}
		}
	}
}

func GetRes() {
	if len(variations) == 0 {
		fmt.Println("No solution")
	} else {
		PrintRes()
	}
}

func PrintRes() {
	for ind, _ := range variations {
		gf[ind] = N/2 - gs[ind]
	}
	vars := make([][]int, len(variations))
	for i := 0; i < N; i++ {
		for ind, v := range variations {
			if v[i] == 0 {
				if gf[ind] == 0 {
					v[i] = 2
				}
				if gf[ind] > 0 {
					v[i] = 1
					gf[ind] = gf[ind] - 1
				}
			}
			vars[ind] = append(vars[ind], v[i])
		}
	}
	res := vars[0]
	for _, v := range variations {
		if len(v) <= len(res) {
			for ind, _ := range v {
				if res[ind] < v[ind] {
					break
				} else if res[ind] > v[ind] {
					copy(res, v)
					break
				}
			}
		}
	}
	for ind, v := range res {
		if v == 1 {
			fmt.Printf("%d ", ind+1)
		}
	}
}

func Trav(groups []int, anyLimit, firstLimit, secondLimit, num int) {
	i := 0
	if num == N {
		variations = append(variations, groups)
		gf = append(gf, anyLimit)
		gs = append(gs, firstLimit)
		return
	}
	for ; i < N; i++ {
		if table[num][i] == 0 {
			break
		}
	}
	if i == N {
		groups[num] = 0
		Trav(groups, anyLimit+1, firstLimit, secondLimit, num+1)
	} else {
		NewGroups(groups, anyLimit, firstLimit, secondLimit, num, i)
	}
}

func NewGroups(groups []int, anyLimit, firstLimit, secondLimit, num, i int) {
	{
		gf := make([]int, 0)
		gs := make([]int, 0)
		for _, v := range groups {
			gf = append(gf, v)
			gs = append(gs, v)
		}
		gf[num] = 1
		gs[num] = 2
		condF := true
		condS := true
		for ; (i < N) && (condF || condS); i++ {
			if table[num][i] == 0 {
				if groups[i] == 1 {
					condF = false
				}
				if groups[i] == 2 {
					condS = false
				}
				if groups[i] == 0 {
					gf[i] = 2
					gs[i] = 1
				}
			}
		}
		if condF {
			Trav(gf, anyLimit, firstLimit+1, secondLimit, num+1)
		}
		if condS {
			Trav(gs, anyLimit, firstLimit, secondLimit+1, num+1)
		}
	}
}