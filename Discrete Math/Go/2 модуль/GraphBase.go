package main

import "fmt"

var time = 1
var count = 0

func main() {
	var N, M int
	fmt.Scan(&N)
	fmt.Scan(&M)
	list := make([]Vertex, 0)
	list = GraphInit(list, N)
	list = ScanEdges(list, M)
	Tarjan(&list)
	condense := make([]Vertex, count)
	condense = CondenseInit(condense)
	condense = CountVisits(list, condense)
	PrintNodes(list, condense)
}

func GraphInit(list []Vertex, N int) []Vertex {
	for i := 0; i < N; i++ {
		var vert Vertex
		vert.image = i
		vert.component = -1
		vert.neighbours = make([]int, 0)
		list = append(list, vert)
	}
	return list
}

func ScanEdges(list []Vertex, M int) []Vertex {
	for i := 0; i < M; i++ {
		var v1, v2 int
		fmt.Scanf("%d %d", &v1, &v2)
		list[v1].neighbours = append(list[v1].neighbours, v2)
	}
	return list
}

func CondenseInit(c []Vertex) []Vertex {
	for i := 0; i < count; i++ {
		var vert Vertex
		vert.image = i
		vert.component = i
		vert.visit = 0
		vert.neighbours = make([]int, 0)
		c[i] = vert
	}
	return c
}

func CountVisits(list, c []Vertex) []Vertex {
	for ind, _ := range list {
		for _, v := range list[ind].neighbours {
			if list[v].component != list[ind].component {
				c[list[v].component].visit++
			}
		}
	}
	return c
}

func PrintNodes(list, c []Vertex) {
	for _, v1 := range c {
		if v1.visit == 0 {
			for ind, v2 := range list {
				if v1.component == v2.component {
					fmt.Print(v2.image, " ")
					list = list[ind:]
					break
				}
			}
		}
	}
}

type Stack struct {
	top  int
	data []int
}

func InitStack(s *Stack, N int) {
	s.data = make([]int, N)
	s.top = 0
}

func Pop(s *Stack) (x int) {
	s.top = s.top - 1
	x = s.data[s.top]
	return x
}

func Push(s *Stack, x int) *Stack {
	s.data[s.top] = x
	s.top = s.top + 1
	return s
}

type Vertex struct {
	image, component, low, t1, visit int
	neighbours                       []int
}

func Tarjan(list *[]Vertex) {
	var s Stack
	InitStack(&s, len(*list))
	for ind, v := range *list {
		if v.t1 == 0 {
			VisitvertexTarjan(list, ind, &s)
		}
	}
}

func VisitvertexTarjan(list *[]Vertex, v int, s *Stack) {
	(*list)[v].t1 = time
	(*list)[v].low = time
	time = time + 1
	Push(s, v)
	for _, u := range (*list)[v].neighbours {
		if (*list)[u].t1 == 0 {
			VisitvertexTarjan(list, u, s)
		}
		if ((*list)[u].component == -1) && ((*list)[v].low > (*list)[u].low) {
			(*list)[v].low = (*list)[u].low
		}
	}
	if (*list)[v].t1 == (*list)[v].low {
		u := Pop(s)
		(*list)[u].component = count
		for (*list)[u].image != (*list)[v].image {
			u = Pop(s)
			(*list)[u].component = count
		}
		count++
	}
}