package main

import (
	"fmt"
)

func main() {
	var N, M, begin int
	fmt.Scan(&N)
	fmt.Scan(&M)
	tm := make([][]edge, N)
	alphabet := make([]string, 0)
	SFinal_is := make([]int, N)
	inAlphabet := make(map[string]bool)
	ScanAuto(&N, &M, &begin, &tm, &alphabet, &inAlphabet, &SFinal_is)
	del, F, labels := Det(&alphabet, &tm, &SFinal_is, &begin)
	PrintAuto(&alphabet, &del, &F, &labels)
}

func PrintAuto(alp *[]string, del, F, labels *[][]int) {
	fmt.Println("digraph {")
	fmt.Printf("\trankdir = LR\n")
	fmt.Printf("\tdummy [label = \"\", shape = none]\n")
	for i := 0; i < len(*labels); i++ {
		b := false
		for j := 0; j < len(*F); j++ {
			b = Equal(&(*F)[j], &(*labels)[i])
			if b {
				break
			}
		}
		if b {
			fmt.Printf("\t%d [label = \"%v\", shape = doublecircle]\n", i, (*labels)[i])
		} else {
			fmt.Printf("\t%d [label = \"%v\", shape = circle]\n", i, (*labels)[i])
		}
	}
	fmt.Printf("\tdummy -> 0\n")
	for i := 0; i < len(*del); i++ {
		stFound := make(map[int]bool)
		for j := 0; j < len(*alp); j++ {
			_, stCond := stFound[(*del)[i][j]]
			if !stCond {
				stFound[(*del)[i][j]] = true
				fmt.Printf("\t%d -> %d [label = \"%s", i, (*del)[i][j], (*alp)[j])
				for n := j + 1; n < len(*alp); n++ {
					if (*del)[i][n] == (*del)[i][j] {
						fmt.Printf(", %s", (*alp)[n])
					}
				}
				fmt.Printf("\"]\n")
			}
		}
	}
	fmt.Println("}")
}

func Equal(op1, op2 *[]int) bool {
	if len(*op1) != len(*op2) {
		return false
	} else {
		for i := 0; i < len(*op1); i++ {
			if (*op1)[i] != (*op2)[i] {
				return false
			}
		}
	}
	return true
}

func ScanAuto(n, m, b *int, tm *[][]edge, alp *[]string, inA *map[string]bool, final *[]int) {
	for i := 0; i < *n; i++ {
		(*tm)[i] = make([]edge, 0)
	}
	var extnum, tarnum int
	var symbol string
	for i := 0; i < *m; i++ {
		fmt.Scan(&extnum, &tarnum, &symbol)
		var te edge
		te.sig = symbol
		te.dest = tarnum
		(*tm)[extnum] = append((*tm)[extnum], te)
		_, alFound := (*inA)[symbol]
		if !((symbol == "lambda") || alFound) {
			(*alp) = append(*alp, symbol)
			(*inA)[symbol] = true
		}
	}
	for i := 0; i < *n; i++ {
		fmt.Scan(&tarnum)
		(*final)[i] = tarnum
	}
	fmt.Scan(b)
}

type Stack struct {
	data [][]int
	top  int
}

func Det(alp *[]string, tm *[][]edge, final *[]int, b *int) ([][]int, [][]int, [][]int) {
	z := make([]int, 0)
	z = append(z, *b)
	q := Closure(tm, &z)
	var s Stack
	InitStack(&s)
	Push(&s, &q)
	Q := make([][]int, 0)
	Q = append(Q, q)
	smt := make([][][]int, 1)
	F := make([][]int, 0)
	labels := make([][]int, 0)
	tr := 0
	for !Empty(&s) {
		z = Pop(&s)
		for i := 0; i < len(z); i++ {
			if (*final)[z[i]] == 1 {
				F = append(F, z)
			}
		}
		for i := 0; i < len(*alp); i++ {
			du := make([]int, 0)
			for j := 0; j < len(z); j++ {
				for k := 0; k < len((*tm)[z[j]]); k++ {
					if (*tm)[z[j]][k].sig == (*alp)[i] {
						du = append(du, (*tm)[z[j]][k].dest)
					}
				}
			}
			zprime := Closure(tm, &du)
			if !Nested(&Q, &zprime) {
				Q = append(Q, zprime)
				Push(&s, &zprime)
				var sus [][]int
				smt = append(smt, sus)
			}
			if i == 0 {
				labels = append(labels, z)
				tr++
			}
			smt[tr-1] = append(smt[tr-1], zprime)
		}
	}
	l := len(smt)
	del := make([][]int, l)
	for i := 0; i < l; i++ {
		del[i] = make([]int, len(*alp))
	}
	for i := 0; i < len(smt); i++ {
		for j := 0; j < len(*alp); j++ {
			tr = 0
			for k := 0; k < len(labels); k++ {
				if Equal(&(smt[i][j]), &(labels[k])) {
					break
				}
				tr++
			}
			del[i][j] = tr
		}
	}
	return del, F, labels
}

func Nested(m *[][]int, ar *[]int) bool {
	for i := 0; i < len(*m); i++ {
		if len((*m)[i]) == len(*ar) {
			cond := true
			for j := 0; j < len(*ar); j++ {
				if (*m)[i][j] != (*ar)[j] {
					cond = false
					break
				}
			}
			if cond {
				return true
			}
		}
	}
	return false
}

func Closure(tm *[][]edge, z *[]int) (C []int) {
	C = make([]int, 0)
	stFound := make(map[int]bool)
	for i := 0; i < len(*z); i++ {
		DFS(tm, &(*z)[i], &stFound, &C)
	}
	return C
}

func DFS(tm *[][]edge, q *int, stF *map[int]bool, C *[]int) {
	_, cond := (*stF)[*q]
	if !cond {
		(*stF)[*q] = true
		*C = append(*C, *q)
		for i := 0; i < len((*tm)[*q]); i++ {
			if (*tm)[*q][i].sig == "lambda" {
				DFS(tm, &(*tm)[*q][i].dest, stF, C)
			}
		}
	}
}

func InitStack(st *Stack) {
	(*st).data = make([][]int, 1000000)
	(*st).top = 0
}

func Push(st *Stack, el *[]int) {
	(*st).data[(*st).top] = *el
	(*st).top++
}

func Pop(st *Stack) (el []int) {
	(*st).top--
	return (*st).data[(*st).top]
}

func Empty(st *Stack) bool {
	return (*st).top <= 0
}

type edge struct {
	sig  string
	dest int
}