package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

var time = 1
var count = 0

func main() {
	s := ReadString()
	list := make([]Vertex, 0)
	mapper := make(map[string]int)
	MakeNodes(s, &list, mapper)
	MakeEdges(s, &list, mapper)
	Tarjan(&list)
	Trav(&list)
	FindMaxDist(&list)
	PrintDigraph(&list)
}

func PrintDigraph(list *[]Vertex) {
	fmt.Println("digraph {")
	for i := 0; i < len(*list); i++ {
		if (*list)[i].color == "" {
			fmt.Printf("\t%s [label = \"%s(%d)\"]\n", (*list)[i].image, (*list)[i].image, (*list)[i].weight)
		} else if (*list)[i].color == "red" {
			fmt.Printf("\t%s [label = \"%s(%d)\", color = red]\n", (*list)[i].image, (*list)[i].image, (*list)[i].weight)
		} else if (*list)[i].color == "blue" {
			fmt.Printf("\t%s [label = \"%s(%d)\", color = blue]\n", (*list)[i].image, (*list)[i].image, (*list)[i].weight)
		}
	}
	for i := 0; i < len(*list); i++ {
		for _, n := range (*list)[i].neighbours {
			if (((*list)[i].color) == "") || (((*list)[i].color == "red") && ((*list)[n].color != "red")) {
				fmt.Printf("\t%s -> %s\n", (*list)[i].image, (*list)[n].image)
			}
			if ((*list)[i].color == "red") && ((*list)[n].color == "red") {
				if !FoundIn((*list)[n].parents, (*list)[i].index) {
					fmt.Printf("\t%s -> %s\n", (*list)[i].image, (*list)[n].image)
				} else {
					fmt.Printf("\t%s -> %s [color = red]\n", (*list)[i].image, (*list)[n].image)
				}
			}
			if (*list)[i].color == "blue" {
				fmt.Printf("\t%s -> %s [color = blue]\n", (*list)[i].image, (*list)[n].image)
			}
		}
	}
	fmt.Println("}")
}

func MakeNodes(s string, list *[]Vertex, mapper map[string]int) {
	idents := make([]string, 0)
	strCopy := strings.ReplaceAll(s, ";", "<")
	str := strings.Split(strCopy, "<")
	for i := 0; i < len(str); i++ {
		str[i] = strings.ReplaceAll(str[i], " ", "")
	}
	for i := 0; i < len(str); i++ {
		if str[i][len(str[i])-1] == ')' {
			idents = append(idents, str[i])
		}
	}
	id := -1
	for i := 0; i < len(idents); i++ {
		var first, last int
		for ind, c := range idents[i] {
			if c == '(' {
				first = ind
			}
			if c == ')' {
				last = ind
			}
		}
		if last != 0 {
			id = id + 1
			var vert Vertex
			vert.weight, _ = strconv.Atoi(idents[i][first+1 : last])
			vert.index = id
			vert.image = idents[i][:first]
			vert.neighbours = make([]int, 0)
			vert.parents = make([]int, 0)
			vert.component = -1
			vert.dist = vert.weight
			mapper[idents[i][:first]] = id
			*list = append(*list, vert)
		}
	}
}

func MakeEdges(s string, list *[]Vertex, mapper map[string]int) {
	sentence := strings.Split(s, ";")
	for i := 0; i < len(sentence); i++ {
		sentence[i] = strings.ReplaceAll(sentence[i], " ", "")
		jobs := strings.Split(sentence[i], "<")
		for j := 0; j < len(jobs); j++ {
			for k := 0; k < len(jobs[j]); k++ {
				if jobs[j][k] == '(' {
					jobs[j] = jobs[j][:k]
				}
			}
		}
		for j := 0; j < len(jobs)-1; j++ {
			left := mapper[jobs[j]]
			right := mapper[jobs[j+1]]
			if !FoundIn((*list)[left].neighbours, right) {
				(*list)[left].neighbours = append((*list)[left].neighbours, right)
			}
			(*list)[right].num = (*list)[right].num + 1
		}
	}
}

func FindMaxDist(list *[]Vertex) {
	maxDist := (*list)[0].dist
	for i := 0; i < len(*list); i++ {
		if ((*list)[i].dist > maxDist) && ((*list)[i].color != "blue") {
			maxDist = (*list)[i].dist
		}
	}
	for i := 0; i < len(*list); i++ {
		if ((*list)[i].dist == maxDist) && ((*list)[i].color != "blue") {
			GetRed(list, i)
		}
	}
}

func ReadString() string {
	var s, buf string
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		buf = scanner.Text()
		if (buf == "") || (buf == "\r") {
			break
		}
		s = s + buf
	}
	return s
}

type Vertex struct {
	index, num, weight, component, low, t1, dist int
	neighbours, parents                          []int
	image, color                                 string
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

func Push(s *Stack, v int) *Stack {
	s.data[s.top] = v
	s.top = s.top + 1
	return s
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
		if (u == v) && (FoundIn((*list)[u].neighbours, u)) {
			GetBlue(list, u)
		}
		(*list)[u].component = count
		for u != v {
			u = Pop(s)
			(*list)[u].component = count
			GetBlue(list, u)
		}
		count++
	}
}

func FoundIn(list []int, x int) bool {
	for _, n := range list {
		if n == x {
			return true
		}
	}
	return false
}

func Relax(u, v *Vertex) bool {
	changed := (u.dist + v.weight) > v.dist
	if changed {
		v.dist = u.dist + v.weight
		v.parents = make([]int, 0)
		v.parents = append(v.parents, u.index)
	}
	if v.dist == (u.dist + v.weight) {
		if !FoundIn(v.parents, u.index) {
			v.parents = append(v.parents, u.index)
		}
	}
	return changed
}

func Trav(list *[]Vertex) {
	end := 1
	for _, v := range *list {
		if v.color != "blue" {
			for _, n := range v.neighbours {
				if Relax(&v, &(*list)[n]) {
					end = 0
				}
			}
		}
	}
	if end == 0 {
		Trav(list)
	}
}

func GetRed(list *[]Vertex, ind int) {
	(*list)[ind].color = "red"
	if len((*list)[ind].parents) == 0 {
		return
	}
	for _, p := range (*list)[ind].parents {
		if (*list)[p].color != "red" {
			GetRed(list, p)
		}
	}
}

func GetBlue(list *[]Vertex, ind int) {
	(*list)[ind].dist = -1
	(*list)[ind].color = "blue"
	for _, n := range (*list)[ind].neighbours {
		if (*list)[n].color != "blue" {
			GetBlue(list, n)
		}
	}
}