package main

import (
	"fmt"
	"sort"
)

func main() {
	var n, ki, ko int
	im := make([][]int, 0)
	em := make([][]string, 0)
	inp := make([]string, 0)
	outp := make([]string, 0)
	ScanAuto(&n, &ki, &ko, &im, &em, &inp, &outp)
	st := make([]state, 0)
	FillStates(&st, &im, &em)
	im = RefreshIm(&st, &im, &em, &ki)
	VisualiseAuto(&im, &inp, &st)
}

type state struct {
	q int
	y string
}

func RefreshIm(st *[]state, im *[][]int, em *[][]string, ki *int) [][]int {
	newIm := make([][]int, len(*st))
	for i := 0; i < len(*st); i++ {
		newIm[i] = make([]int, *ki)
		for j := 0; j < *ki; j++ {
			var tst state
			tst.q = (*im)[(*st)[i].q][j]
			tst.y = (*em)[(*st)[i].q][j]
			newIm[i][j] = GetIndex(st, &tst)
		}
	}
	return newIm
}

func FillStates(st *[]state, im *[][]int, em *[][]string) {
	for i := 0; i < len(*im); i++ {
		for j := 0; j < len((*im)[i]); j++ {
			var tst state
			tst.q = (*im)[i][j]
			tst.y = (*em)[i][j]
			if GetIndex(st, &tst) == -1 {
				*st = append(*st, tst)
			}
		}
	}
	var comparator func(i, j int) bool
	comparator = func(i, j int) bool {
		return (*st)[j].q > (*st)[i].q
	}
	sort.Slice(*st, comparator)
}

func GetIndex(st *[]state, tst *state) int {
	for i := 0; i < len(*st); i++ {
		if ((*tst).q == (*st)[i].q) && ((*tst).y == (*st)[i].y) {
			return i
		}
	}
	return -1
}

func ScanAuto(n, ki, ko *int, im *[][]int, em *[][]string, inputs, outputs *[]string) {
	fmt.Scan(ki)
	var dest int
	var sig string
	*inputs = make([]string, 0)
	*outputs = make([]string, 0)
	for i := 0; i < *ki; i++ {
		fmt.Scan(&sig)
		*inputs = append(*inputs, sig)
	}
	fmt.Scan(ko)
	for i := 0; i < *ko; i++ {
		fmt.Scan(&sig)
		*outputs = append(*outputs, sig)
	}
	fmt.Scan(n)
	*im = make([][]int, *n)
	*em = make([][]string, *n)
	for i := 0; i < *n; i++ {
		(*im)[i] = make([]int, 0)
		for j := 0; j < *ki; j++ {
			fmt.Scan(&dest)
			(*im)[i] = append((*im)[i], dest)
		}
	}
	for i := 0; i < *n; i++ {
		(*em)[i] = make([]string, 0)
		for j := 0; j < *ki; j++ {
			fmt.Scan(&sig)
			(*em)[i] = append((*em)[i], sig)
		}
	}
}

func VisualiseAuto(im *[][]int, inp *[]string, st *[]state) {
	fmt.Println("digraph {")
	fmt.Println("\trankdir = LR")
	for i := 0; i < len(*st); i++ {
		fmt.Printf("\t%d [label = \"(%d,%s)\"]\n", i, (*st)[i].q, (*st)[i].y)
	}
	for i := 0; i < len(*im); i++ {
		for j := 0; j < len((*im)[i]); j++ {
			fmt.Printf("\t%d -> %d [label = \"%s\"]\n", i, (*im)[i][j], (*inp)[j])
		}
	}
	fmt.Println("}")
}