package main

import "fmt"

// Заменить запись сокращённых операторов присваивания x OP= y на соответствующие полные записи x = x OP y.
// (OP может быть +, -, |, ^, *, /, %, <<, >>, &, &^).
func main() {
	var x int = 1028
	var y int = 15
	x = x + y*2
	x = x + y // сумма
	x = x - 2 // вычитание
	fmt.Println(x, y)
	x = x / y       // деление
	x = x * (y + 2) // умножение
	fmt.Println(x, y)
	var z = x % y // остаток от деления
	x = x % y
	fmt.Println(x, z)
	var i = 1036
	var j = 3064
	y = y & i  // лог. И
	j = j | i  // лог. ИЛИ
	x = x ^ i  // xor
	z = z << 3 // сдвиг влево
	fmt.Println(y, j, x, z)
	y = y >> 2 // сдвиг вправо
	x = x &^ y // bit clear (лог. И НЕ)
	fmt.Println(y, x)
}
