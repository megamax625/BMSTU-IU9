package main

import (
	"fmt"
	"sort"
)

var time = 1

func main() {
	var n int
	fmt.Scan(&n)
	list := make([]*Vertex, n)
	InitList(&list, n)
	mapper := make(map[int]int)
	ScanComms(&list, mapper)
	MakeEdges(&list, mapper)
	DFS(list[0])
	RemoveDead(&list)
	var comparator func(i, j int) bool
	comparator = func(i, j int) bool {
		return list[i].t1 > list[j].t1
	}
	sort.Slice(list, comparator)
	list = Dominators(&list)
	GetLoops(&list)
}

type Vertex struct {
	dead                                bool
	t1, op                              int
	comm                                string
	sdom, idom, ancestor, parent, label *Vertex
	bucket, edgesIn, edgesOut           []*Vertex
}

func InitList(list *[]*Vertex, n int) {
	for i := 0; i < n; i++ {
		var vert Vertex
		vert.dead = true
		vert.sdom = &vert
		vert.ancestor = nil
		vert.label = &vert
		vert.bucket = make([]*Vertex, 0)
		vert.edgesIn = make([]*Vertex, 0)
		vert.edgesOut = make([]*Vertex, 0)
		(*list)[i] = &vert
	}
}

func ScanComms(list *[]*Vertex, m map[int]int) {
	var label, oper int
	var cmd string
	for i := 0; i < len(*list); i++ {
		fmt.Scanf("%d %s %d\n", &label, &cmd, &oper)
		m[label] = i
		(*list)[i].comm = cmd
		if cmd != "ACTION" {
			(*list)[i].op = oper
		}
	}
}

func MakeEdges(list *[]*Vertex, m map[int]int) {
	var oper int
	n := len((*list))
	for i := 0; i < n; i++ {
		switch (*list)[i].comm {
		case "JUMP":
			oper = m[(*list)[i].op]
			(*list)[i].edgesIn = append((*list)[i].edgesIn, (*list)[oper])
			(*list)[oper].edgesOut = append((*list)[oper].edgesOut, (*list)[i])
			break
		case "ACTION":
			if i != n-1 {
				(*list)[i].edgesIn = append((*list)[i].edgesIn, (*list)[i+1])
				(*list)[i+1].edgesOut = append((*list)[i+1].edgesOut, (*list)[i])
			}
			break
		case "BRANCH":
			oper = m[(*list)[i].op]
			(*list)[i].edgesIn = append((*list)[i].edgesIn, (*list)[oper])
			(*list)[oper].edgesOut = append((*list)[oper].edgesOut, (*list)[i])
			if i != n-1 {
				(*list)[i].edgesIn = append((*list)[i].edgesIn, (*list)[i+1])
				(*list)[i+1].edgesOut = append((*list)[i+1].edgesOut, (*list)[i])
			}
			break
		}
	}
}

func DFS(v *Vertex) {
	v.t1 = time
	time = time + 1
	v.dead = false
	for ind, _ := range v.edgesIn {
		if v.edgesIn[ind].dead {
			v.edgesIn[ind].parent = v
			DFS(v.edgesIn[ind])
		}
	}
}

func RemoveDead(list *[]*Vertex) {
	for i := 0; i < len(*list); i++ {
		if !(*list)[i].dead {
			for j := 0; j < len((*list)[i].edgesOut); j++ {
				if (*list)[i].edgesOut[j].dead {
					(*list)[i].edgesOut[j] = (*list)[i].edgesOut[len((*list)[i].edgesOut)-1]
					(*list)[i].edgesOut = (*list)[i].edgesOut[:len((*list)[i].edgesOut)-1]
					j = j - 1
				}
			}
		} else {
			(*list)[i] = (*list)[len(*list)-1]
			(*list)[len(*list)-1] = nil
			(*list) = (*list)[:len(*list)-1]
			i = i - 1
		}
	}
}

func Dominators(list *[]*Vertex) []*Vertex {
	length := len(*list)
	var s Stack
	InitStack(&s, length)
	for _, w := range *list {
		if w.t1 != 1 {
			for _, v := range w.edgesOut {
				u := FindMin(&s, v)
				if u.sdom.t1 < w.sdom.t1 {
					w.sdom = u.sdom
				}
			}
			w.ancestor = w.parent
			w.sdom.bucket = append(w.sdom.bucket, w)
			for _, v := range w.parent.bucket {
				u := FindMin(&s, v)
				if u.sdom == v.sdom {
					v.idom = v.sdom
				} else {
					v.idom = u
				}
			}
			w.parent.bucket = nil
		}
	}
	for _, w := range *list {
		if (w.t1 != 1) && (w.idom != w.sdom) {
			w.idom = w.idom.idom
		}
	}
	(*list)[len(*list)-1].idom = nil
	return (*list)
}

func FindMin(s *Stack, v *Vertex) *Vertex {
	var min *Vertex
	if v.ancestor == nil {
		min = v
	} else {
		u := v
		for u.ancestor.ancestor != nil {
			s = Push(s, u)
			u = u.ancestor
		}
		for s.top != 0 {
			v = Pop(s)
			if v.ancestor.label.sdom.t1 < v.label.sdom.t1 {
				v.label = v.ancestor.label
			}
			v.ancestor = u.ancestor
		}
		min = v.label
	}
	return min
}

type Stack struct {
	top  int
	data []*Vertex
}

func InitStack(s *Stack, N int) {
	s.data = make([]*Vertex, N)
	s.top = 0
}

func Pop(s *Stack) (x *Vertex) {
	s.top = s.top - 1
	x = s.data[s.top]
	return x
}

func Push(s *Stack, v *Vertex) *Stack {
	s.data[s.top] = v
	s.top = s.top + 1
	return s
}

func GetLoops(list *[]*Vertex) {
	count := 0
	for _, v := range *list {
		for _, u := range v.edgesOut {
			for (u != v) && (u != nil) {
				u = u.idom
			}
			if u == v {
				count++
				break
			}
		}
	}
	fmt.Println(count)
}