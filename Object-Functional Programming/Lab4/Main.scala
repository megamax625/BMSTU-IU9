/*  Абстрактный синтаксис арифметических выражений:

    Expr → Expr + Expr | Expr - Expr | Expr * Expr | Expr / Expr | VARNAME

    Написать функцию ratioPolynomns : Expr => Expr, которая преобразует выражение в полином (если в нём нет операции деления) 
    или в отношение двух полиномов (если операция деления есть).
*/

abstract class Expr {
    def +(b: Expr) = new +(this, b)
    def -(b: Expr) = new -(this, b)
    def *(b: Expr) = new *(this, b)
    def /(b: Expr) = new /(this, b)
}

case class Var(name: String) extends Expr {
    override def toString(): String = name.toString()
}
case class +(a: Expr, b: Expr) extends Expr {
    override def toString(): String = "(" + a.toString() + " + " + b.toString() + ")"
}
case class -(a: Expr, b: Expr) extends Expr {
    override def toString(): String = "(" + a.toString() + " - " + b.toString() + ")"
}
case class *(a: Expr, b: Expr) extends Expr {
    override def toString(): String = "(" + a.toString() + " * " + b.toString() + ")"
}
case class /(a: Expr, b: Expr) extends Expr {
    override def toString(): String = "(" + a.toString() + " / " + b.toString() + ")"
}

object Main {
    def ratioPolynomns(e: Expr): Expr = e match {
        case (a / b) / c => ratioPolynomns(a / ratioPolynomns(b * c))
        case a / (b / c) => ratioPolynomns(a * c) / ratioPolynomns(b)

        case (a * b) / (c * d) => ratioPolynomns(ratioPolynomns(a * b) / ratioPolynomns(c * d))

        case (a / b) + c => ratioPolynomns(ratioPolynomns((a + ratioPolynomns(b * c))) / b)
        case (a / b) - c => ratioPolynomns(ratioPolynomns((a - ratioPolynomns(a * c))) / b)
        case (a / b) * c => ratioPolynomns(ratioPolynomns(a * c) / c)

        case a + (b / c) => ratioPolynomns(ratioPolynomns((ratioPolynomns(a * c) + b)) / c)
        case a - (b / c) => ratioPolynomns(ratioPolynomns((ratioPolynomns(a * c) - b)) / c)
        case a * (b / c) => ratioPolynomns(ratioPolynomns(a * b) / c)
        
        case (x + y) * b => ratioPolynomns(ratioPolynomns(x * b) + ratioPolynomns(y * b))
        case (x - y) * b => ratioPolynomns(ratioPolynomns(x * b) - ratioPolynomns(y * b))
        case a * (x + y) => ratioPolynomns(ratioPolynomns(a * x) + ratioPolynomns(a * y))
        case a * (x - y) => ratioPolynomns(ratioPolynomns(a * x) - ratioPolynomns(a * y))

        case a / b => ratioPolynomns(a) / ratioPolynomns(b)
        case a * b => ratioPolynomns(a) * ratioPolynomns(b)
        case a + b => ratioPolynomns(a) + ratioPolynomns(b)
        case a - b => ratioPolynomns(a) - ratioPolynomns(b)
        case other => other
    }

    def main(args: Array[String]): Unit = {
        val t1 = Var("a")
        val t2 = Var("a") + Var("b")
        val t3 = Var("a") - Var("b")
        val t4 = Var("a") * Var("b")
        val t5 = Var("a") / Var("b")
        val t6 = (Var("a") + Var("b")) * Var("c")
        val t7 = (Var("a") - Var("b")) * Var("c")
        val t8 = Var("e") * Var("c") * ((Var("a") * Var("b")) + Var("d"))
        val t9 = (Var("a") + Var("b")) * (Var("c") + Var("d"))
        val t10 = Var("a") + (Var("b") / Var("c"))
        val t11 = t6 / t7
        val t12 = (t9 * t10) / t7
        val t13 = (Var("a") + Var("b")) / Var("c") + (Var("d") / Var("e"))
        val t14 = Var("a") + (Var("b") / Var("c"))

        print("rp t1: ")
        println(ratioPolynomns(t1))
        print("rp t2: ")
        println(ratioPolynomns(t2))
        print("rp t3: ")
        println(ratioPolynomns(t3))
        print("rp t4: ")
        println(ratioPolynomns(t4))
        print("rp t5: ")
        println(ratioPolynomns(t5))
        print("rp t6: ")
        println(ratioPolynomns(t6))
        print("rp t7: ")
        println(ratioPolynomns(t7))
        print("rp t8: ")
        println(ratioPolynomns(t8))
        print("rp t9: ")
        println(ratioPolynomns(t9))
        print("rp t10: ")
        println(ratioPolynomns(t10))
        print("rp t11: ")
        println(ratioPolynomns(t11))
        print("rp t12: ")
        println(ratioPolynomns(t12))
        print("rp t13: ")
        println(ratioPolynomns(t13))
        print("rp t14: ")
        println(ratioPolynomns(t14))
    }
}