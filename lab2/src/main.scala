import scala.annotation.tailrec

object main {

  def print(str: String) {
    if (str.isEmpty) println("Empty")
    else println(str)
  }

  def main(args: Array[String]): Unit = {
    val x = new Group("aaabb")
    val y = new Group("ƃƃã")
    val z = x + y // должно быть aa
    print(x.getWord)
    print(y.getWord)
    print(z.getWord)

    print(x.inverseWord.getWord) // должно быть ƃƃããã
    print(y.inverseWord.getWord) // должно быть abb
    print(z.inverseWord.getWord) // должно быть ãã

    val x2 = x.inverseWord
    print((x + x2).getWord) // должны быть пустые
    val y2 = y.inverseWord
    print((y + y2).getWord)
    val z2 = z.inverseWord
    print((z + z2).getWord)

    val incorrect = new Group("qwe") // сообщит об ошибке и станет пустым
    print(incorrect.getWord)

    val r = new Group("ƃƃa")
    print((x + r).getWord) // должно быть aaaa
    print((y2 + r).getWord) // должно быть aa
    print((z + r).getWord) // должно быть aaƃƃa
  }
}
