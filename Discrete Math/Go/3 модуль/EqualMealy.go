package main

import (
	"fmt"
	"sort"
)

var count = 0

func main() {
	var n1, m1, begin1, n2, m2, begin2 int
	tm1 := make([][]int, 0)
	em1 := make([][]string, 0)
	b := 0
	ScanAuto(&n1, &m1, &begin1, &tm1, &em1)
	tm1, em1 = Canonize(&m1, &begin1, &tm1, &em1)
	tmRes1, emRes1 := AufenkampHohn(&tm1, &em1, m1)
	count = 0
	tmRes1, emRes1 = Canonize(&m1, &b, &tmRes1, &emRes1)
	tm2 := make([][]int, 0)
	em2 := make([][]string, 0)
	count = 0
	ScanAuto(&n2, &m2, &begin2, &tm2, &em2)
	tm2, em2 = Canonize(&m2, &begin2, &tm2, &em2)
	tmRes2, emRes2 := AufenkampHohn(&tm2, &em2, m2)
	count = 0
	tmRes2, emRes2 = Canonize(&m2, &b, &tmRes2, &emRes2)
	CompareAutos(&tmRes1, &emRes1, &tmRes2, &emRes2)
}

func CompareAutos(tmr1 *[][]int, emr1 *[][]string, tmr2 *[][]int, emr2 *[][]string) {
	if (len(*tmr1) == len(*tmr2)) && (len((*tmr1)[0]) == len((*tmr2)[0])) {
		for i := 0; i < len(*tmr1); i++ {
			for j := 0; j < len((*tmr1)[0]); j++ {
				if ((*tmr1)[i][j] != (*tmr2)[i][j]) || ((*emr1)[i][j] != (*emr2)[i][j]) {
					fmt.Println("NOT EQUAL")
					return
				}
			}
		}
		fmt.Println("EQUAL")
	} else {
		fmt.Println("NOT EQUAL")
	}
}

func Find(x *state) *state {
	root := x
	for root.parent != root {
		root = root.parent
	}
	return root
}

func Union(x, y *state) {
	rootx := Find(x)
	rooty := Find(y)
	if rootx.depth < rooty.depth {
		rootx.parent = rooty
	} else {
		rooty.parent = rootx
		if (rootx.depth == rooty.depth) && (rootx != rooty) {
			rootx.depth++
		}
	}
}

type state struct {
	index, depth, canonic, color, num int
	parent                            *state
}

func Canonize(m *int, b *int, tm *[][]int, em *[][]string) ([][]int, [][]string) {
	st := make([]state, 0)
	for i := 0; i < len(*tm); i++ {
		var t state
		t.index = i
		t.canonic = -1
		t.color = 0
		st = append(st, t)
	}
	DFS(&st, tm, *m, *b)
	l := len(*tm)
	newSt := make([]state, 0)
	for _, q := range st {
		newSt = append(newSt, q)
	}
	for i := 0; i < len(st); i++ {
		if st[i].canonic == -1 {
			copy(st[i:], st[i+1:])
			st = st[:len(st)-1]
			l--
		}
	}
	eRes := make([][]string, 0)
	tRes := make([][]int, 0)
	for i := 0; i < l; i++ {
		er := make([]string, *m)
		eRes = append(eRes, er)
		tr := make([]int, *m)
		tRes = append(tRes, tr)
	}
	var comparator func(i, j int) bool
	comparator = func(i, j int) bool {
		return st[j].canonic > st[i].canonic
	}
	sort.Slice(st, comparator)
	for i := 0; i < len(st); i++ {
		for j := 0; j < *m; j++ {
			tRes[i][j] = newSt[(*tm)[st[i].index][j]].canonic
		}
		eRes[i] = (*em)[st[i].index]
	}
	return tRes, eRes
}

func DFS(st *[]state, tm *[][]int, m, x int) {
	(*st)[x].color = 1
	(*st)[x].canonic = count
	count++
	for i := 0; i < m; i++ {
		if (*st)[(*tm)[(*st)[x].index][i]].color == 0 {
			DFS(st, tm, m, (*tm)[(*st)[x].index][i])
		}
	}
}

func Split1(st *[]state, em *[][]string, m int) (int, []state) {
	p := make([]state, len(*st))
	l := len(*st)
	for i, _ := range *st {
		(*st)[i].parent = &(*st)[i]
		(*st)[i].depth = 0
	}
	for i, q1 := range *st {
		for j, q2 := range *st {
			if i >= j {
				continue
			}
			if Find(&q1) != Find(&q2) {
				eq := true
				for k := 0; k < m; k++ {
					if (*em)[q1.index][k] != (*em)[q2.index][k] {
						eq = false
						break
					}
				}
				if eq {
					Union(&q1, &q2)
					l--
				}
			}
		}
	}
	for _, q := range *st {
		p[q.index] = *Find(&q)
	}
	return l, p
}

func Split(st *[]state, p *[]state, tm *[][]int, m int) (int, []state) {
	l := len(*st)
	for i, _ := range *st {
		(*st)[i].parent = &(*st)[i]
		(*st)[i].depth = 0
	}
	for i := 0; i < len(*st); i++ {
		for j := i + 1; j < len(*st); j++ {
			if (Find(&(*st)[i]) != Find(&(*st)[j])) && ((*p)[(*st)[i].index] == (*p)[(*st)[j].index]) {
				eq := true
				for k := 0; k < m; k++ {
					w1 := (*tm)[(*st)[i].index][k]
					w2 := (*tm)[(*st)[j].index][k]
					if (*p)[w1] != (*p)[w2] {
						eq = false
					}
				}
				if eq {
					Union(&(*st)[i], &(*st)[j])
					l--
				}
			}
		}
	}
	for i := 0; i < len(*st); i++ {
		(*p)[(*st)[i].index] = *Find(&(*st)[i])
	}
	return l, *p
}

func AufenkampHohn(tm *[][]int, em *[][]string, m int) ([][]int, [][]string) {
	st := make([]state, 0)
	for i := 0; i < len(*tm); i++ {
		var t state
		t.index = i
		st = append(st, t)
	}
	l, p := Split1(&st, em, m)
	for {
		var t int
		t, p = Split(&st, &p, tm, m)
		if l == t {
			break
		}
		l = t
	}
	Q := make([]state, 0)
	del := make([][]int, 0)
	phi := make([][]string, 0)
	p = *Reduce(&p)
	for _, q := range st {
		newq := p[q.index]
		if !Found(&Q, &newq) {
			Q = append(Q, newq)
			tst := make([]int, 0)
			est := make([]string, 0)
			for i := 0; i < m; i++ {
				tst = append(tst, p[(*tm)[q.index][i]].num)
				est = append(est, (*em)[q.index][i])
			}
			del = append(del, tst)
			phi = append(phi, est)
		}
	}
	return del, phi
}

func Reduce(p *[]state) *[]state {
	maxes := make([]int, 0)
	for i := 0; i < len(*p); i++ {
		(*p)[i].num = (*p)[i].index
		if !FoundArr((*p)[i].index, maxes) {
			maxes = append(maxes, (*p)[i].index)
		}
	}
	min := 999999999
	for i := 0; i < len(maxes); i++ {
		eq := true
		for j := 0; j < len(*p); j++ {
			if (*p)[j].num == i {
				eq = false
				break
			}
			if ((*p)[j].num < min) && ((*p)[j].num > i) {
				min = (*p)[j].num
			}
		}
		if eq {
			for j := 0; j < len(*p); j++ {
				if (*p)[j].num == min {
					(*p)[j].num = i
				}
			}
		}
		min = 999999999
	}
	return p
}

func FoundArr(n int, ar []int) bool {
	for _, v := range ar {
		if v == n {
			return true
		}
	}
	return false
}

func Found(Q *[]state, newq *state) bool {
	for _, q := range *Q {
		if *newq == q {
			return true
		}
	}
	return false
}

func ScanAuto(n, m, b *int, tm *[][]int, em *[][]string) {
	fmt.Scan(n)
	fmt.Scan(m)
	fmt.Scan(b)
	var dest int
	var sig string
	*tm = make([][]int, *n)
	*em = make([][]string, *n)
	for i := 0; i < *n; i++ {
		(*tm)[i] = make([]int, 0)
		for j := 0; j < *m; j++ {
			fmt.Scan(&dest)
			(*tm)[i] = append((*tm)[i], dest)
		}
	}
	for i := 0; i < *n; i++ {
		(*em)[i] = make([]string, 0)
		for j := 0; j < *m; j++ {
			fmt.Scan(&sig)
			(*em)[i] = append((*em)[i], sig)
		}
	}
}

func VisualiseAuto(b *int, tm *[][]int, em *[][]string) {
	fmt.Println("digraph {")
	fmt.Println("\trankdir = LR")
	fmt.Println("\tdummy [label = \"\", shape = none]")
	fmt.Printf("\tdummy -> %d\n", *b)
	for i := 0; i < len(*em); i++ {
		fmt.Printf("\t%d [shape = circle]\n", i)
	}
	for i := 0; i < len(*tm); i++ {
		for j := 0; j < len((*tm)[i]); j++ {
			fmt.Printf("\t%d -> %d [label = \"%s(%s)\"]\n", i, (*tm)[i][j], string(j+97), (*em)[i][j])
		}
	}
	fmt.Println("}")
}
