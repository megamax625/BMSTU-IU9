// Элемент свободной группы с двумя образующими. Представляет собой либо пустое слово (единица группы),
// либо конечное слово, составленное из четырёх символов a, ã, b, ƃ̃ таким образом, что в нём a не появляется рядом с ã,
// а b не появляется рядом с ƃ. Операция сложения двух слов определяется как их конкатенация с последующим
// сокращением пар aã, ãa, bƃ и ƃb. Операция взятия обратного элемента — как переворачивание слова
// с одновременной заменой a на ã, ã — на a, b — на ƃ и ƃ — на b.

class Group(str: String){
  val inputList: List[Char] = str.toList
  val chars = Set('a', 'ã', 'b', 'ƃ')
  val word: List[Char] = removePairs()

  // проверка того, что слово состоит только из символов a, ã, b, b̃ или пустое
  def checkDefinition(): Boolean = {
      inputList.forall(chars.contains)
  }

  def removePairs(): List[Char] = {
    if (!checkDefinition()) {
      println("The string " + str + " doesn't meet the definition!")
      List.empty[Char]
    }
    else {
      inputList.foldLeft(List.empty[Char])({
        case (Nil, char) => List(char)
        case (list, char) if arePair(list.last, char) => list.dropRight(1)
        case (list, char) => list :+ char
      })
    }
  }

  def arePair: (Char, Char) => Boolean = {
    case ('a', 'ã') => true
    case ('ã', 'a') => true
    case ('b', 'ƃ') => true
    case ('ƃ', 'b') => true
    case _ => false
  }

  def inverseChar: Char => Char = {
    case 'a' => 'ã'
    case 'ã' => 'a'
    case 'b' => 'ƃ'
    case 'ƃ' => 'b'
  }

  def inverseWord = new Group(word.reverse.map(char => inverseChar(char)).mkString)

  def + (w: Group): Group = new Group(this.getWord ++ w.getWord)

  def getWord: String = {
      word.mkString
  }
}

//// Тестирование
//val x = new Group("aaabb")
//val y = new Group("ƃƃã")
//val z = x + y   // должно быть aa
//x.getWord
//y.getWord
//z.getWord
//
//x.inverseWord.getWord   // должно быть ƃƃããã
//y.inverseWord.getWord   // должно быть abb
//z.inverseWord.getWord   // должно быть ãã
//
//val x2 = x.inverseWord
//(x + x2).getWord    // должны быть пустые
//val y2 = y.inverseWord
//(y + y2).getWord
//val z2 = z.inverseWord
//(z + z2).getWord
//
//val incorrect = new Group("qwe")  // сообщит об ошибке и станет пустым
//incorrect.getWord
//
//val r = new Group("ƃƃa")
//(x + r).getWord   // должно быть aaaa
//(y2 + r).getWord  // должно быть aa
//(z + r).getWord   // должно быть aaƃƃa
