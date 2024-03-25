package main

import (
	"fmt"
	"math"
	"sort"
)

func main() {
	var N int
	var res float64
	fmt.Scan(&N)
	length := N * (N - 1) / 2
	sets := make([]Set, N)
	roads := make([]Road, length)
	ScanCoords(N, &sets)
	GetLens(N, sets, roads)
	res = MST_Kruskal(roads, length)
	fmt.Printf("%.2f", res)
}

func ScanCoords(N int, sets *[]Set) {
	var x, y int
	var attr Set
	for i := 0; i < N; i++ {
		fmt.Scanf("%d %d", &x, &y)
		attr.x = x
		attr.y = y
		attr.depth = 1
		attr.parent = nil
		(*sets)[i] = attr
	}
}

func GetLens(N int, sets []Set, roads []Road) {
	var temp Road
	var pos int = 0
	for i := 0; i < N; i++ {
		for j := i + 1; j < N; j++ {
			temp.u = &sets[i]
			temp.v = &sets[j]
			len_x := sets[i].x - sets[j].x
			len_y := sets[i].y - sets[j].y
			len_t := math.Sqrt(float64((len_x * len_x) + (len_y * len_y)))
			temp.length = len_t
			roads[pos] = temp
			pos++
		}
	}
}

type Set struct {
	x, y, depth int
	parent      *Set
}

type Road struct {
	length float64
	u, v   *Set
}

func MST_Kruskal(roads []Road, n int) (res float64) {
	var comparator func(i, j int) bool
	comparator = func(i, j int) bool {
		return roads[j].length > roads[i].length
	}
	sort.Slice(roads, comparator)
	shortest := SpanningTree(roads, n)
	return shortest
}

func SpanningTree(roads []Road, n int) (res float64) {
	res = 0
	for i := 0; i < n; i++ {
		u := roads[i].u
		v := roads[i].v
		if Find(u) != Find(v) {
			res += roads[i].length
			Union(u, v)
		}
	}
	return res
}

func Find(x *Set) (root *Set) {
	if (*x).parent == nil {
		root = x
	} else {
		root = Find((*x).parent)
	}
	return root
}

func Union(x, y *Set) {
	root_x := Find(x)
	root_y := Find(y)
	if root_x.depth < root_y.depth {
		root_x.parent = root_y
	} else {
		root_y.parent = root_x
		if (root_x.depth == root_y.depth) && (root_x != root_y) {
			root_x.depth++
		}
	}
}
