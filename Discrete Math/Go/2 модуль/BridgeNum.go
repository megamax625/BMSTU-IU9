package main

import "fmt"

func main() {
	var N, M, bridgenum int
	fmt.Scan(&N, &M)
	list := make([]Vertex, 0)
	var q Queue
	InitQueue(&q, N)
	list = GraphInit(list, N)
	var u, v int
	for i := 0; i < M; i++ {
		fmt.Scanf("%d %d", &u, &v)
		list[v].neighbours = append(list[v].neighbours, u)
		list[u].neighbours = append(list[u].neighbours, v)
	}
	bridgenum = DFS1(&list, &q)
	bridgenum = DFS2(&list, &q, bridgenum)
	fmt.Println(bridgenum)
}

type Vertex struct {
	component, visited int
	neighbours         []int
	parent             *Vertex
}

func GraphInit(list []Vertex, N int) []Vertex {
	for i := 0; i < N; i++ {
		var vert Vertex
		vert.visited = 0
		vert.component = -1
		vert.neighbours = make([]int, 0)
		list = append(list, vert)
	}
	return list
}

type Queue struct {
	cap, count, head, tail int
	data                   []*Vertex
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

func DFS1(list *[]Vertex, q *Queue) (bridges int) {
	bridges = 0
	for ind, num := range *list {
		if num.visited == 0 {
			bridges--
			VisitVertex1(list, q, &(*list)[ind])
		}
	}
	return bridges
}

func VisitVertex1(list *[]Vertex, q *Queue, vert *Vertex) {
	(*vert).visited = 1
	Enqueue(q, vert)
	for _, num := range (*vert).neighbours {
		if (*list)[num].visited == 0 {
			(*list)[num].parent = vert
			VisitVertex1(list, q, &((*list)[num]))
		}
	}
}

func DFS2(list *[]Vertex, q *Queue, bridgenum int) (bridges int) {
	bridges = bridgenum
	var vert *Vertex
	comp := 0
	for (*q).count > 0 {
		vert = Dequeue(q)
		if (*vert).component == -1 {
			VisitVertex2(list, vert, comp)
			comp++
			bridges++
		}
	}
	return bridges
}

func VisitVertex2(list *[]Vertex, vert *Vertex, comp int) {
	(*vert).component = comp
	for _, num := range (*vert).neighbours {
		if ((*list)[num].parent != vert) && ((*list)[num].component == -1) {
			VisitVertex2(list, &((*list)[num]), comp)
		}
	}
}