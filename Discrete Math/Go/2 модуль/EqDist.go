package main

import (
	"fmt"
	"sort"
)

func main() {
	var N, M int
	fmt.Scan(&N)
	fmt.Scan(&M)
	list := make([]Vertex, 0)
	var q Queue
	InitQueue(&q, N)
	list = GraphInit(list, N)
	GetList(list, M)
	var k, vert int
	fmt.Scan(&k)
	distances := make([][]int, k)
	for i := 0; i < k; i++ {
		fmt.Scan(&vert)
		distances[i] = make([]int, N)
		BFS(&list, q, vert, &distances[i])
	}
	res := make([]int, 0)
	cond := 1
	for i := 0; i < N; i++ {
		cond = 1
		for j := 0; j < k-1; j++ {
			if (distances[j+1][i] != distances[j][i]) || (distances[j][i] == 0) {
				cond = 0
				break
			}
		}
		if cond == 1 {
			res = append(res, i)
		}
	}
	sort.Ints(res)
	if len(res) == 0 {
		fmt.Println("-")
	} else {
		for _, num := range res {
			fmt.Printf("%d ", num)
		}
	}
}

type Queue struct {
	cap, count, head, tail int
	data                   []*Vertex
}

type Vertex struct {
	number, visited int
	neighbours      []int
}

func BFS(list *[]Vertex, q Queue, first int, distances *[]int) {
	for i := 0; i < len(*list); i++ {
		(*list)[i].visited = 0
	}
	(*list)[first].visited = 1
	Enqueue(&q, &(*list)[first])
	for q.count > 0 {
		vert := Dequeue(&q)
		for _, num := range (*vert).neighbours {
			if (*list)[num].visited == 0 {
				(*distances)[num] = (*distances)[vert.number] + 1
				(*list)[num].visited = 1
				Enqueue(&q, &(*list)[num])
			}
		}
	}
}

func GraphInit(list []Vertex, N int) []Vertex {
	for i := 0; i < N; i++ {
		var vert Vertex
		vert.visited = 0
		vert.number = i
		vert.neighbours = make([]int, 0)
		list = append(list, vert)
	}
	return list
}

func GetList(list []Vertex, M int) {
	var u, v int
	for i := 0; i < M; i++ {
		fmt.Scanf("%d %d", &u, &v)
		list[v].neighbours = append(list[v].neighbours, u)
		list[u].neighbours = append(list[u].neighbours, v)
	}
}

func InitQueue(q *Queue, n int) {
	(*q).data = make([]*Vertex, n)
	(*q).head, (*q).tail, (*q).count = 0, 0, 0
	(*q).cap = n
}

func Enqueue(q *Queue, x *Vertex) {
	if (*q).count == (*q).cap {
		fmt.Println("This shouldn't happen")
	}
	(*q).data[(*q).tail] = x
	(*q).tail++
	if (*q).tail == (*q).cap {
		(*q).tail = 0
	}
	(*q).count++
}

func Dequeue(q *Queue) (x *Vertex) {
	if (*q).count == 0 {
		fmt.Println("This shouldn't happen")
	}
	x = (*q).data[(*q).head]
	(*q).head++
	if (*q).head == (*q).cap {
		(*q).head = 0
	}
	(*q).count--
	return x
}