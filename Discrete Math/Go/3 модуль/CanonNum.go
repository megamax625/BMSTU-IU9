package main

import (
	"fmt"
	"sort"
)

var count = 0

func main() {
	var n, m, begin int
	var vert Vertex
	var auto = make([]Vertex, 0)
	ScanAuto(&n, &m, &begin, &vert, &auto)
	DFS(&auto, begin)
	Numerate(&auto, &n)
	PrintRes(n, m, &auto)
}

func PrintRes(n, m int, a *[]Vertex) {
	fmt.Println(n)
	fmt.Println(m)
	fmt.Println(0)
	for _, st := range *a {
		if st.canonic != -1 {
			for i := 0; i < m; i++ {
				fmt.Printf("%d ", st.neighbours[i].dest)
			}
			fmt.Println()
		}
	}
	for _, st := range *a {
		if st.canonic != -1 {
			for i := 0; i < m; i++ {
				fmt.Printf("%s ", st.neighbours[i].sig)
			}
			fmt.Println()
		}
	}
}

func ScanAuto(n, m, b *int, v *Vertex, a *[]Vertex) {
	fmt.Scan(n)
	fmt.Scan(m)
	fmt.Scan(b)
	var dest int
	for i := 0; i < *n; i++ {
		v.index = i
		v.color = 0
		v.canonic = -1
		v.neighbours = make([]Edge, 0)
		for j := 0; j < *m; j++ {
			fmt.Scan(&dest)
			var edt Edge
			edt.dest = dest
			v.neighbours = append(v.neighbours, edt)
		}
		*a = append(*a, *v)
	}
	var sig string
	for i := 0; i < *n; i++ {
		for j := 0; j < *m; j++ {
			fmt.Scan(&sig)
			(*a)[i].neighbours[j].sig = sig
		}
	}
}

func DFS(a *[]Vertex, i int) {
	(*a)[i].color = 1
	(*a)[i].canonic = count
	count++
	for _, ed := range (*a)[i].neighbours {
		if (*a)[ed.dest].color == 0 {
			DFS(a, ed.dest)
		}
	}
}

func Numerate(a *[]Vertex, n *int) {
	for i := 0; i < len(*a); i++ {
		if (*a)[i].canonic == -1 {
			*n = (*n) - 1
		}
		for j := 0; j < len((*a)[i].neighbours); j++ {
			(*a)[i].neighbours[j].dest = (*a)[(*a)[i].neighbours[j].dest].canonic
		}
		(*a)[i].index = (*a)[i].canonic
	}
	var comparator func(i, j int) bool
	comparator = func(i, j int) bool {
		return (*a)[j].canonic > (*a)[i].canonic
	}
	sort.Slice(*a, comparator)
}

type Vertex struct {
	neighbours            []Edge
	index, color, canonic int
}

type Edge struct {
	dest int
	sig  string
}