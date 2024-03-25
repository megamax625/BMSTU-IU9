package main

import "fmt"

var inf = 999999

func main() {
	var N, res int
	fmt.Scan(&N)
	if N == 1 {
		fmt.Scan(&res)
		fmt.Print(res)
	} else {
		table := make([][]Vertex, N)
		ScanTable(&table, N)
		table = *Dijkstra(&table, N)
		res = table[N-1][N-1].dist
		fmt.Print(res)
	}
}

func ScanTable(t *[][]Vertex, N int) {
	var val int
	var vert Vertex
	for i := 0; i < N; i++ {
		(*t)[i] = make([]Vertex, N)
		for j := 0; j < N; j++ {
			(*t)[i][j].neighbours = make([]Vertex, 0)
		}
	}
	for i := 0; i < N; i++ {
		for j := 0; j < N; j++ {
			vert.Xind = i
			vert.Yind = j
			fmt.Scan(&val)
			vert.weight = val
			vert.neighbours = (*t)[i][j].neighbours
			(*t)[i][j] = vert
			if i > 0 {
				(*t)[i-1][j].neighbours = append((*t)[i-1][j].neighbours, vert)
			}
			if i < N-1 {
				(*t)[i+1][j].neighbours = append((*t)[i+1][j].neighbours, vert)
			}
			if j > 0 {
				(*t)[i][j-1].neighbours = append((*t)[i][j-1].neighbours, vert)
			}
			if j < N-1 {
				(*t)[i][j+1].neighbours = append((*t)[i][j+1].neighbours, vert)
			}
		}
	}
}

func Relax(u, v *Vertex, w int) bool {
	changed := (u.dist + w) < v.dist
	if changed {
		v.dist = u.dist + w
	}
	return changed
}

func Dijkstra(table *[][]Vertex, N int) *[][]Vertex {
	var pq PrioQ
	InitPQ(&pq, N*N)
	for i := 0; i < N; i++ {
		for j := 0; j < N; j++ {
			if (i == 0) && (j == 0) {
				(*table)[i][j].dist = (*table)[i][j].weight
			} else {
				(*table)[i][j].dist = inf
			}
			Insert(&pq, &(*table)[i][j])
		}
	}
	for !Empty(&pq) {
		v := ExtractMin(&pq)
		v.index = -1
		for _, u := range v.neighbours {
			if ((*table)[u.Xind][u.Yind].index != -1) && (Relax(v, &(*table)[u.Xind][u.Yind], (*table)[u.Xind][u.Yind].weight)) {
				DecreaseKey(&pq, (*table)[u.Xind][u.Yind].index, (*table)[u.Xind][u.Yind].dist)
			}
		}
	}
	return table
}

type PrioQ struct {
	count int
	heap  []*Vertex
}

type Vertex struct {
	Xind, Yind, index, dist, weight int
	neighbours                      []Vertex
}

func InitPQ(pq *PrioQ, n int) {
	(*pq).heap = make([]*Vertex, n)
	(*pq).count = 0
}

func Heapify(ti int, n int, pq *PrioQ) *PrioQ {
	var l, r, j int
	i := ti
	for {
		l = 2*i + 1
		r = l + 1
		j = i
		if (l < n) && (pq.heap[i].dist > pq.heap[l].dist) {
			i = l
		}
		if (r < n) && (pq.heap[i].dist > pq.heap[r].dist) {
			i = r
		}
		if i == j {
			break
		}
		(*pq).heap[i], (*pq).heap[j] = (*pq).heap[j], (*pq).heap[i]
		(*pq.heap[i]).index = i
		(*pq.heap[j]).index = j
	}
	return pq
}

func Empty(pq *PrioQ) bool {
	return (*pq).count == 0
}

func Insert(pq *PrioQ, u *Vertex) {
	i := (*pq).count
	(*pq).count = i + 1
	(*pq).heap[i] = u
	for (i > 0) && ((*pq).heap[(i-1)/2].dist > (*pq).heap[i].dist) {
		(*pq).heap[(i-1)/2], (*pq).heap[i] = (*pq).heap[i], (*pq).heap[(i-1)/2]
		(*pq).heap[i].index = i
		i = (i - 1) / 2
	}
	(*pq.heap[i]).index = i
	(*u).index = i
}

func DecreaseKey(pq *PrioQ, ti int, k int) {
	i := ti
	(*pq).heap[i].dist = k
	for (i > 0) && ((*pq).heap[(i-1)/2].dist > k) {
		(*pq).heap[(i-1)/2], (*pq).heap[i] = (*pq).heap[i], (*pq).heap[(i-1)/2]
		(*pq).heap[i].index = i
		i = (i - 1) / 2
	}
	(*pq).heap[i].index = i
}

func ExtractMin(pq *PrioQ) *Vertex {
	ptr := pq.heap[0]
	(*pq).count = (*pq).count - 1
	if !Empty(pq) {
		(*pq).heap[0] = (*pq).heap[pq.count]
		(*pq).heap[0].index = 0
		(*pq) = *Heapify(0, (*pq).count, pq)
	}
	return ptr
}