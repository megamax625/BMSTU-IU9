package main

import "fmt"
import "github.com/skorobogatov/input"

func main() {
	var (
		s    string
		x, y rune
	)
	input.Scanf("%s\n %c %c", &s, &x, &y)
	fmt.Println(MinDist(s, x, y))
}
                                                                            
func MinDist(s string, x rune, y rune) int {
	var (
		dist           int = 1000001
		xind, yind     int = 1000001, 1000001
		index, newDist int
	)
	for _, symbol := range s {
		if symbol == x {
			xind = index
		} else if symbol == y {
			yind = index
		}
		if xind != 1000001 && yind != 1000001 {
			newDist = xind - yind
			if newDist < 0 {
				newDist *= -1
			}
			newDist--
			if newDist < dist {
				dist = newDist
			}
		}
		index++
	}
	return dist
}