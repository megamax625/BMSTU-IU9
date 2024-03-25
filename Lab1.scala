val split: (List[Int], Int => Boolean) => List[List[Int]] = {
    def rec: (List[Int], Int => Boolean, List[Int]) => List[List[Int]] = {
        case (Nil, p, Nil) => Nil
        case (Nil, p, acc) => List(acc)
        case (x :: xs, p, acc) if (p(x)) => (if (acc == Nil) Nil else List(acc)) ::: rec(xs, p, Nil)
        case (x :: xs, p, acc) => rec(xs, p, (acc ::: List(x)))
    }
    (list, a) => rec(list, a, Nil)
}

val list = List(1, 2, 3, -10, 5, 6, -8, 9)
val ListSepByNeg = split(list, _ < 0)
val ListSepByEven = split(list, _ % 2 == 0)
val ListSepByOdd = split(list, _ % 2 == 1)
val EmptyListSep = split(Nil, _ > 0)
val SingleSublist = split(list, _ < -100)