package main

import "fmt"

func main() {
	var N, M int
	fmt.Scan(&N)
	fmt.Scan(&M)
	list := make([]*Vertex, 0)
	list = GraphInit(list, N)
	list = GetEdges(list, M)
	res := MstPrim(list)
	fmt.Println(res)
}

func GraphInit(list []*Vertex, N int) []*Vertex {
	for i := 0; i < N; i++ {
		var vert Vertex
		vert.image = i
		vert.index = -1
		vert.neighbours = make([]Edge, 0)
		list = append(list, &vert)
	}
	return list
}

func GetEdges(list []*Vertex, M int) []*Vertex {
	var u, v, length int
	for i := 0; i < M; i++ {
		fmt.Scanf("%d %d %d", &u, &v, &length)
		var t1, t2 Edge
		t1.len = length
		t1.neighbour = v
		t2.len = length
		t2.neighbour = u
		list[u].neighbours = append(list[u].neighbours, t1)
		list[v].neighbours = append(list[v].neighbours, t2)
	}
	return list
}

type Vertex struct {
	index, image, key, value int
	neighbours               []Edge
}

type Edge struct {
	len, neighbour int
}

type PrioQ struct {
	count int
	heap  []*Vertex
}

func InitPQ(pq *PrioQ, n int) {
	pq.heap = make([]*Vertex, n)
	pq.count = 0
}

func Heapify(ti int, n int, pq *PrioQ) *PrioQ {
	var l, r, j int
	i := ti
	for {
		l = 2*i + 1
		r = l + 1
		j = i
		if (l < n) && (pq.heap[i].key > pq.heap[l].key) {
			i = l
		}
		if (r < n) && (pq.heap[i].key > pq.heap[r].key) {
			i = r
		}
		if i == j {
			break
		}
		pq.heap[i], pq.heap[j] = pq.heap[j], pq.heap[i]
		(*pq.heap[i]).index = i
		(*pq.heap[j]).index = j
	}
	return pq
}

func Empty(pq *PrioQ) bool {
	return (*pq).count == 0
}

func Insert(pq *PrioQ, u *Vertex) {
	i := pq.count
	pq.count = i + 1
	pq.heap[i] = u
	for (i > 0) && (pq.heap[(i-1)/2].key > pq.heap[i].key) {
		pq.heap[(i-1)/2], pq.heap[i] = pq.heap[i], pq.heap[(i-1)/2]
		pq.heap[i].index = i
		i = (i - 1) / 2
	}
	(*pq.heap[i]).index = i
	(*u).index = i
}

func DecreaseKey(pq *PrioQ, ti int, k int) {
	i := ti
	pq.heap[i].key = k
	for (i > 0) && (pq.heap[(i-1)/2].key > k) {
		pq.heap[(i-1)/2], pq.heap[i] = pq.heap[i], pq.heap[(i-1)/2]
		pq.heap[i].index = i
		i = (i - 1) / 2
	}
	pq.heap[i].index = i
}

func ExtractMin(pq *PrioQ) *Vertex {
	ptr := pq.heap[0]
	pq.count = pq.count - 1
	if !Empty(pq) {
		pq.heap[0] = pq.heap[pq.count]
		pq.heap[0].index = 0
		pq = Heapify(0, pq.count, pq)
	}
	return ptr
}

func MstPrim(list []*Vertex) (T int) {
	v := list[0]
	T = 0
	var pq PrioQ
	InitPQ(&pq, len(list)-1)
	for {
		v.index = -2
		for _, u := range v.neighbours {
			if list[u.neighbour].index == -1 {
				list[u.neighbour].value = v.image
				list[u.neighbour].key = u.len
				Insert(&pq, list[u.neighbour])
			} else {
				if (list[u.neighbour].index != -2) && (u.len <= list[u.neighbour].key) {
					list[u.neighbour].value = v.image
					DecreaseKey(&pq, list[u.neighbour].index, u.len)
				}
			}
		}
		if Empty(&pq) {
			break
		}
		v = ExtractMin(&pq)
		T += v.key
	}
	return T
}