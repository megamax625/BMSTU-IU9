package main

import (
	"fmt"
	"github.com/skorobogatov/input"
	"strconv"
)

type Lexem struct {
	Tag
	Image string
}

type Tag int

const (
	ERROR  Tag = 1 << iota // Неправильная лексема
	NUMBER                 // Целое число
	VAR                    // Имя переменной
	PLUS                   // Знак +
	MINUS                  // Знак -
	MUL                    // Знак *
	DIV                    // Знак /
	LPAREN                 // Левая круглая скобка
	RPAREN                 // Правая круглая скобка
)

func skipIdent(str string, i int) int {
	var x int
	for x = i; x < len(str); x++ {
		c := str[x]
		if !((c > 47 && c < 58) || (c > 64 && c < 91) || (c > 96 && c < 123)) {
			break
		}
	}
	return x
}

func skipNum(str string, i int) int {
	var x int
	for x = i; x < len(str); x++ {
		c := str[x]
		if !(c > 47 && c < 58) {
			break
		}
	}
	return x
}

func lexer(expr string, lexems chan Lexem) {
	var lex Lexem
	length = len(expr)
	for i := 0; i < length; i++ {
		switch expr[i] {
		case 10:
			continue
		case 32:
			continue
		case 40:
			lex.Tag = LPAREN
			lex.Image = "("
			lexems <- lex
			break
		case 41:
			lex.Tag = RPAREN
			lex.Image = ")"
			lexems <- lex
			break
		case 42:
			lex.Tag = MUL
			lex.Image = "*"
			lexems <- lex
			break
		case 43:
			lex.Tag = PLUS
			lex.Image = "+"
			lexems <- lex
			break
		case 45:
			lex.Tag = MINUS
			lex.Image = "-"
			lexems <- lex
			break
		case 47:
			lex.Tag = DIV
			lex.Image = "/"
			lexems <- lex
			break
		default:
			c := expr[i]
			if c > 47 && c < 58 {
				end := skipNum(expr, i)
				lex.Tag = NUMBER
				lex.Image = expr[i:end]
				lexems <- lex
				i = end - 1
			} else {
				if (c > 64 && c < 91) || (c > 96 && c < 123) {
					end := skipIdent(expr, i)
					lex.Tag = VAR
					lex.Image = expr[i:end]
					lexems <- lex
					i = end - 1
				} else {
					lex.Tag = ERROR
					lexems <- lex
					errorFound = true
				}
			}
			break
		}
	}
}

// <E>  ::= <T> <E’>.
// <E’> ::= + <T> <E’> | - <T> <E’> | .
// <T>  ::= <F> <T’>.
// <T’> ::= * <F> <T’> | / <F> <T’> | .
// <F>  ::= <number> | <var> | ( <E> ) | - <F>.

var errorFound = false
var tokens []string
var dict []Variable
var length, lInd int
var lexemsArray []Lexem
var lex Lexem

func parseE() {
	parseT()
	parseEPrime()
}

func parseEPrime() {
	if length > lInd {
		lex := lexemsArray[lInd]
		if lex.Tag&(PLUS|MINUS) != 0 {
			lInd++
			parseT()
			tokens = append(tokens, lex.Image)
			parseEPrime()
		} else if lex.Tag&(VAR|NUMBER) != 0 {
			errorFound = true
		}
	}
}

func parseT() {
	parseF()
	parseTPrime()
}

func parseTPrime() {
	if length > lInd {
		lex := lexemsArray[lInd]
		if lex.Tag&(DIV|MUL) != 0 {
			lInd++
			parseF()
			tokens = append(tokens, lex.Image)
			parseTPrime()
		}
	}
}

func parseF() {
	if length > lInd {
		lex := lexemsArray[lInd]
		if lex.Tag&(NUMBER|VAR) != 0 {
			lInd++
			tokens = append(tokens, lex.Image)
		} else if lex.Tag&MINUS != 0 {
			lInd++
			tokens = append(tokens, "-1")
			parseF()
			tokens = append(tokens, "*")
		} else if lex.Tag&LPAREN != 0 {
			lInd++
			parseE()
			if length > lInd {
				lex := lexemsArray[lInd]
				lInd++
				if lex.Tag&RPAREN == 0 {
					errorFound = true
				}
			} else {
				errorFound = true
			}
		} else {
			errorFound = true
		}
	} else {
		errorFound = true
	}
}

func eval() int {
	seq := make([]int, 0)
	for _, x := range tokens {
		tok := x[0]
		if tok > 47 && tok < 58 || (tok == '-' && len(x) > 1) {
			number, _ := strconv.Atoi(x)
			seq = append(seq, number)
		} else if (tok > 64 && tok < 91) || (tok > 96 && tok < 123) {
			number := getStored(x)
			seq = append(seq, number)
		} else {
			op1 := len(seq) - 2
			op2 := len(seq) - 1
			switch x {
			case "*":
				seq = append(seq[:op1], seq[op1]*seq[op2])
				break
			case "/":
				if seq[op1] == 0 {
					seq = append(seq[:op1], 0)
				} else {
					seq = append(seq[:op1], seq[op1]/seq[op2])
				}
				break
			case "+":
				seq = append(seq[:op1], seq[op1]+seq[op2])
				break
			case "-":
				seq = append(seq[:op1], seq[op1]-seq[op2])
				break
			}
		}
	}
	return seq[0]
}

type Variable struct {
	value int
	ident string
}

func main() {
	var expr string
	expr = input.Gets()
	length = len(expr)
	lexems := make(chan Lexem, length)
	lexer(expr, lexems)
	lexemsArray = make([]Lexem, 0)
	close(lexems)
	for x := range lexems {
		lexemsArray = append(lexemsArray, x)
	}
	length = len(lexemsArray)
	parseE()
	if errorFound {
		fmt.Println("error")
	} else {
		for _, x := range lexemsArray {
			if x.Tag&VAR != 0 && stored(x.Image) == false {
				var vari int
				var v Variable
				input.Scanf("%d", &vari)
				v.ident = x.Image
				v.value = vari
				dict = append(dict, v)
			}
		}
		fmt.Println(eval())
	}
}

func stored(str string) bool {
	for _, x := range dict {
		if str == x.ident {
			return true
		}
	}
	return false
}

func getStored(str string) int {
	for _, x := range dict {
		if x.ident == str {
			return x.value
		}
	}
	return 0
}