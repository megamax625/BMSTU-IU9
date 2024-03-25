package main

import (
	"fmt"
	"go/ast"
	"go/format"
	"go/parser"
	//"go/printer"
	"go/token"
	"os"
)

func ChangeOperators(file *ast.File) {
	ast.Inspect(file, func(node ast.Node) bool {
		// находим все присваивания
		if assignStmt, ok := node.(*ast.AssignStmt); ok {
			tok := assignStmt.Tok
			if tok.String() != "=" {
				newToken := token.ILLEGAL
				switch tok.String() {
				case "+=":
					newToken = token.ADD
				case "-=":
					newToken = token.SUB
				case "|=":
					newToken = token.OR
				case "^=":
					newToken = token.XOR
				case "*=":
					newToken = token.MUL
				case "/=":
					newToken = token.QUO
				case "%=":
					newToken = token.REM
				case "<<=":
					newToken = token.SHL
				case ">>=":
					newToken = token.SHR
				case "&=":
					newToken = token.AND
				case "&^=":
					newToken = token.AND_NOT
				}
				assignStmt.Tok = token.ASSIGN
				lhs := assignStmt.Lhs[0]
				if id, ok := lhs.(*ast.Ident); ok {
					lname := id.Name
					lobj := id.Obj
					if rhs, ok := assignStmt.Rhs[0].(*ast.BinaryExpr); ok {
						assignStmt.Rhs = []ast.Expr{
							&ast.BinaryExpr{
								X: &ast.Ident{
									NamePos: rhs.Y.Pos(),
									Name:    lname,
									Obj:     lobj,
								},
								OpPos: rhs.Y.Pos(),
								Op:    newToken,
								Y: &ast.BinaryExpr{
									X:     rhs.X,
									OpPos: rhs.OpPos,
									Op:    rhs.Op,
									Y:     rhs.Y,
								},
							},
						}
					}
					if rhs, ok := assignStmt.Rhs[0].(*ast.Ident); ok {
						assignStmt.Rhs = []ast.Expr{
							&ast.BinaryExpr{
								X: &ast.Ident{
									NamePos: rhs.Pos(),
									Name:    lname,
									Obj:     lobj,
								},
								OpPos: rhs.Pos(),
								Op:    newToken,
								Y: &ast.Ident{
									NamePos: rhs.Pos(),
									Name:    rhs.Name,
									Obj:     rhs.Obj,
								},
							},
						}
					}
					if rhs, ok := assignStmt.Rhs[0].(*ast.BasicLit); ok {
						assignStmt.Rhs = []ast.Expr{
							&ast.BinaryExpr{
								X: &ast.Ident{
									NamePos: rhs.Pos(),
									Name:    lname,
									Obj:     lobj,
								},
								OpPos: rhs.Pos(),
								Op:    newToken,
								Y: &ast.BasicLit{
									ValuePos: rhs.ValuePos,
									Value:    rhs.Value,
									Kind:     rhs.Kind,
								},
							},
						}
					}
				}
			}
		}
		return true
	})
}

func main() {
	if len(os.Args) != 2 {
		return
	}

	fset := token.NewFileSet()
	if file, err := parser.ParseFile(fset, os.Args[1], nil, parser.ParseComments); err == nil {
		ChangeOperators(file)

		if format.Node(os.Stdout, fset, file) != nil {
			fmt.Printf("Formatter error: %v\n", err)
		}
		//ast.Fprint(os.Stdout, fset, file, nil)
	} else {
		fmt.Printf("Errors in %s\n", os.Args[1])
	}
}
