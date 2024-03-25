package main

import "fmt"

func main() {
	var n, m, begin int
	transfMatr := make([][]int, 0)
	exitMatr := make([][]string, 0)
	ScanAuto(&n, &m, &begin, &transfMatr, &exitMatr)
	VisualiseAuto(&begin, &transfMatr, &exitMatr)
}

func ScanAuto(n, m, b *int, tm *[][]int, em *[][]string) {
	fmt.Scan(n)
	fmt.Scan(m)
	fmt.Scan(b)
	var dest int
	var sig string
	*tm = make([][]int, *n)
	*em = make([][]string, *n)
	for i := 0; i < *n; i++ {
		(*tm)[i] = make([]int, 0)
		for j := 0; j < *m; j++ {
			fmt.Scan(&dest)
			(*tm)[i] = append((*tm)[i], dest)
		}
	}
	for i := 0; i < *n; i++ {
		(*em)[i] = make([]string, 0)
		for j := 0; j < *m; j++ {
			fmt.Scan(&sig)
			(*em)[i] = append((*em)[i], sig)
		}
	}
}

func VisualiseAuto(b *int, tm *[][]int, em *[][]string) {
	fmt.Println("digraph {")
	fmt.Println("\trankdir = LR")
	fmt.Println("\tdummy [label = \"\", shape = none]")
	fmt.Printf("\tdummy -> %d\n", *b)
	for i := 0; i < len(*em); i++ {
		fmt.Printf("\t%d [shape = circle]\n", i)
	}
	for i := 0; i < len(*em); i++ {
		for j := 0; j < len((*tm)[i]); j++ {
			fmt.Printf("\t%d -> %d [label = \"%s(%s)\"]\n", i, (*tm)[i][j], string(j+97), (*em)[i][j])
		}
	}
	fmt.Println("}")
}