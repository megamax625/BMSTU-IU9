package main

import "fmt"

func main() {
	exprs := make(map[string]int, 1000000)
	var str string
	var strAcc []byte
	var count int
	fmt.Scan(&str)
	for i := 0; i < len(str)-1; i++ {
		if str[i] == 40 {
			count++
		}
	}
	openBrackets := 0
	if str[0] != 40 {
		fmt.Print(0)
	} else {
		for i := 0; i < len([]byte(str))-1; i++ {
			if str[i] == 40 {
				openBrackets++
				unclosedBrackets := 1
				strAcc = make([]byte, 0)
				for j := 1; unclosedBrackets > 0 && i+j < len(str)-1; j++ {
					if str[i+j] == 40 {
						unclosedBrackets++
					} else if str[i+j] != 41 {
						strAcc = append(strAcc, str[i+j])
					} else {
						unclosedBrackets--
					}
					if unclosedBrackets == 0 {
						count -= exprs[string(strAcc)]
						if exprs[string(strAcc)] == 0 {
							exprs[string(strAcc)] = 1
						}
						strAcc = make([]byte, 0)
					}
				}
			}
		}
		fmt.Print(count)
	}
}