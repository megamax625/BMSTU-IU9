class MegaQueue[T](xs: List[T], ys: List[T], max: List[T]) {
    val inlist = xs
    val outlist = ys
    val maxval = max

    def this() = this(Nil, Nil, Nil)
    def this(l: List[T]) = this(l, Nil, Nil)
    def this(xs: T*) = this(List[T](xs: _*), Nil, Nil)
    def this(l1: List[T], l2: List[T]) = this(l1, l2, Nil)

    def enqueue(v: T)(implicit para: QueueOps[T]): MegaQueue[T] = new MegaQueue[T](v +: inlist, outlist, para.maxvalGet(v, maxval))
    
    def dequeue(): MegaQueue[T] = {
        if (outlist.isEmpty && !inlist.isEmpty) {
            var outlistNew = inlist.reverse
            val droppedV = outlistNew.head
            outlistNew = outlistNew.drop(1)
            if (!maxval.isEmpty && maxval.head == droppedV){
                new MegaQueue[T](Nil, outlistNew, maxval.drop(1))
            } else {
                new MegaQueue[T](Nil, outlistNew)
            }
        } else if (!empty()){
            val droppedV = outlist.head
            if (!maxval.isEmpty && maxval.head == droppedV){
                new MegaQueue[T](inlist, outlist.drop(1), maxval.drop(1))
            } else {
                new MegaQueue[T](inlist, outlist.drop(1))
            }
        } else {
            println("Cannot dequeue from empty queue")
            new MegaQueue[T]()
        }
    }
    
    def empty() = inlist.isEmpty && outlist.isEmpty

    override def toString(): String = {
        val q = inlist ::: outlist.reverse
        return q.toString()
    }

    def maxG()(implicit para: QueueOps[T]): T = para.maxGet(maxval)
    def setMaxval(xs: List[T])(implicit para: QueueOps[T]): List[T] = para.setMaxval(xs)
}

trait QueueOps[T] {
    def maxvalGet(v: T, mv: List[T]): List[T]
    def setMaxval(xs: List[T]): List[T]
    def maxGet(mv: List[T]): T
}

object QueueOps {
    implicit def numericOps[T](implicit numeric: Numeric[T]): QueueOps[T] = 
        new QueueOps[T] {
            def maxvalGet(v: T, mv: List[T]): List[T] = if (!mv.isEmpty && numeric.gteq(v, mv.head)) v +: mv else mv
            def setMaxval(xs: List[T]): List[T] = xs.drop(1).foldLeft(List[T](xs.head))((left, right) 
                                                                    => if (numeric.gteq(right, left.last)) left :+ right else left)
            def maxGet(mv: List[T]): T = if (!mv.isEmpty) mv.head else numeric.fromInt(-9999)
        }
    implicit def stringOps[T](implicit str: T): QueueOps[String] = 
        new QueueOps[String] {
            def maxvalGet(v: String, mv: List[String]): List[String] = List.empty[String]
            def setMaxval(xs: List[String]): List[String] = List.empty[String]
            def maxGet(mv: List[String]): String = "max method not supported for non-numeric types"
        }
}

object Main extends App {
    var stringQ = new MegaQueue("abc", "cda")
    var intQ = new MegaQueue(1, 2, 3, -10)
    println(stringQ + ", empty = " + stringQ.empty())
    stringQ = stringQ.enqueue("fabdgf")
    println(stringQ + ", empty = " + stringQ.empty())
    stringQ = stringQ.dequeue()
    println(stringQ + ", empty = " + stringQ.empty())
    stringQ = stringQ.enqueue("opefds")
    println(stringQ + ", empty = " + stringQ.empty())
    stringQ = stringQ.dequeue()
    println(stringQ + ", empty = " + stringQ.empty())
    stringQ = stringQ.dequeue()
    println(stringQ + ", empty = " + stringQ.empty())
    stringQ = stringQ.dequeue()
    println(stringQ + ", empty = " + stringQ.empty())
    stringQ = stringQ.dequeue()  // dequeue из пустой очереди - получим предупреждение
    stringQ = stringQ.enqueue("eqdva")
    println(stringQ + ", empty = " + stringQ.empty())

    intQ = intQ.enqueue(5)
    println(intQ)
    println(intQ.maxG())
    intQ = intQ.dequeue()
    println(intQ)
    println(intQ.maxG())
    intQ = intQ.dequeue()
    println(intQ.maxG())
    println(intQ)
    intQ = intQ.dequeue()
    println(intQ.maxG())
    println(intQ)
    intQ = intQ.dequeue()
    println(intQ.maxG())
    println(intQ)
    intQ = intQ.dequeue()
    intQ = intQ.enqueue(-100)
    println(intQ.maxG())
    println(intQ)
}