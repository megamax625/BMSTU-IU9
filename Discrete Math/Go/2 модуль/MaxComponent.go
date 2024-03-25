package main

import (
	"fmt"
)

func main() {
	var N, M int
	fmt.Scan(&N, &M)
	verges := make([][2]int, 0)
	list := make([]Vertex, 0)
	var comp Component
	comp.index = -1
	comp.minVertex = -1
	comp.verge, comp.vertex = 0, 0
	list = GraphInit(list, N)
	var pairs [2]int
	var vert1, vert2 int
	for i := 0; i < M; i++ {
		fmt.Scanf("%d %d", &vert1, &vert2)
		pairs[0] = vert1
		pairs[1] = vert2
		list[vert2].neighbours = append(list[vert2].neighbours, vert1)
		list[vert1].neighbours = append(list[vert1].neighbours, vert2)
		verges = append(verges, pairs)
	}
	DFS(&list, &comp)
	GraphPrint(list, comp, verges)
}

type Component struct {
	index, vertex, verge, minVertex int
}

type Vertex struct {
	number, component, visited int
	neighbours                 []int
}

func GraphInit(list []Vertex, N int) []Vertex {
	for i := 0; i < N; i++ {
		var vert Vertex
		vert.number = i
		vert.visited = 0
		vert.component = -1
		vert.neighbours = make([]int, 0)
		list = append(list, vert)
	}
	return list
}

func DFS(list *[]Vertex, comp *Component) {
	var VisitVertex func(list *[]Vertex, vertex *Vertex, comp *Component)
	VisitVertex = func(list *[]Vertex, vertex *Vertex, comp *Component) {
		(*vertex).visited = 1
		(*vertex).component = (*comp).index
		(*comp).vertex++
		if (*vertex).number < (*comp).minVertex {
			(*comp).minVertex = (*vertex).number
		}
		for _, num := range (*vertex).neighbours {
			(*comp).verge++
			if (*list)[num].visited == 0 {
				VisitVertex(list, &((*list)[num]), comp)
			}
		}
	}

	var compon Component
	compon.index = 0
	for ind, vert := range *list {
		if vert.visited == 0 {
			VisitVertex(list, &(*list)[ind], &compon)
			if compon.vertex > comp.vertex {
				*comp = compon
			}
			if compon.vertex == comp.vertex {
				if compon.verge > comp.verge {
					*comp = compon
				}
				if compon.verge == comp.verge {
					if compon.minVertex > comp.minVertex {
						*comp = compon
					}
				}
			}
			compon.index++
			compon.vertex, compon.verge = 0, 0
			compon.minVertex = -1
		}
	}
}

func GraphPrint(list []Vertex, comp Component, verges [][2]int) {
	fmt.Println("graph {")
	for _, num := range list {
		if num.component == comp.index {
			fmt.Printf("\t%d [color = red]\n", num.number)
		} else {
			fmt.Printf("\t%d\n", num.number)
		}
	}
	for _, pair := range verges {
		if list[pair[0]].component == comp.index {
			fmt.Printf("\t%d -- %d [color = red]\n", pair[0], pair[1])
		} else {
			fmt.Printf("\t%d -- %d\n", pair[0], pair[1])
		}
	}
	fmt.Println("}")
}