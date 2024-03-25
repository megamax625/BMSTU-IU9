// Класс MegaQueue[T], представляющий неизменяемую очередь с операциями enqueue, dequeue и empty, реализованную через два списка. 
// В случае, если T — числовой тип, для очереди должна быть также доступна операция max, работающая за константное время.
class MegaQueue[T](xs: List[T], ys: List[T], maxs: List[T]) {
    val inlist = xs
    val outlist = ys
    val max = maxs

    def this(v: T) = this(List(v), Nil, List(v))

    def enqueue(v: T)(implicit qops: QueueOps[T]): MegaQueue[T] = {
        val (mq1: List[T], mq2: List[T], mq3: List[T]) = qops.enqueue(v, inlist, outlist, max)
        new MegaQueue[T](mq1, mq2, mq3)
    }
    def dequeue()(implicit qops: QueueOps[T]): (T, MegaQueue[T]) = {
        val (v, mq1: List[T], mq2: List[T], mq3: List[T]) = qops.dequeue(inlist, outlist, max)
        (v, new MegaQueue[T](mq1, mq2, mq3))
    }
    def getMax()(implicit qops: QueueOps[T]): T = qops.getMax(max)
    def empty() = inlist.isEmpty && outlist.isEmpty

    override def toString(): String = {
        val q = inlist ::: outlist.reverse
        return q.toString()
    }
}

trait QueueOps[T] {
    def enqueue(v: T, xs: List[T], ys: List[T], maxs: List[T]) : (List[T], List[T], List[T])
    def dequeue(xs: List[T], ys: List[T], maxs: List[T]): (T, List[T], List[T], List[T])
    def getMax(maxs: List[T]): T
}

object QueueOps {
    implicit def numeric_ops[T](implicit n: Numeric[T]): QueueOps[T] = 
        new QueueOps[T] {
            def enqueue(v: T, xs: List[T], ys: List[T], maxs: List[T]): (List[T], List[T], List[T]) = if (n.gteq(v, maxs.head)) (v +: xs, ys, v +: maxs) else (v +: xs, ys, maxs)
            def dequeue(xs: List[T], ys: List[T], maxs: List[T]): (T, List[T], List[T], List[T]) = (xs, ys, maxs) match {
                case (Nil, Nil, maxs) => {
                    print("Trying to dequeue from an empty queue!!!\n")
                    (n.zero, Nil, Nil, Nil)
                }
                case (xs, Nil, maxs) if (n.equiv(maxs.last, xs.last)) => (xs.reverse.head, Nil, xs.reverse.drop(1), maxs.dropRight(1))
                case (xs, Nil, maxs) => (xs.reverse.head, Nil, xs.reverse.drop(1), maxs)
                case (xs, ys, maxs) if (n.equiv(maxs.last, ys.head)) => (ys.head, xs, ys.drop(1), maxs.dropRight(1))
                case (xs, ys, maxs) => (ys.head, xs, ys.drop(1), maxs)
            }
            def getMax(maxs: List[T]): T = if (!(maxs.length == 0)) maxs.head else n.zero
        }
    implicit val string_ops: QueueOps[String] = 
        new QueueOps[String] {
            def enqueue(v: String, xs: List[String], ys: List[String], maxs: List[String]): (List[String], List[String], List[String]) = (v +: xs, ys, Nil)
            def dequeue(xs: List[String], ys: List[String], maxs: List[String]): (String, List[String], List[String], List[String]) = (xs, ys, maxs) match {
                case (Nil, Nil, maxs) => {
                    print("Trying to dequeue from an empty queue!!!\n")
                    ("", Nil, Nil, Nil)
                }
                case (xs, Nil, maxs) => (xs.reverse.head, Nil, xs.reverse.drop(1), Nil)
                case (xs, ys, maxs) => (ys.head, xs, ys.drop(1), Nil)
            }
            def getMax(maxs: List[String]): String = {
                println("Cannot get max from a non-numeric queue!!!")
                return ""
            }
        }
}

object Main extends App {
    var intQ = new MegaQueue(10)
    println(intQ)
    println(intQ.getMax)
    intQ = intQ.enqueue(5)
    println(intQ)
    println(intQ.getMax())
    intQ = intQ.enqueue(100)
    println(intQ)
    println(intQ.getMax())
    println("Empty? " + intQ.empty())
    println("max: " + intQ.max)

    var (i1, intQ1) = intQ.dequeue()
    println(intQ1, i1)
    println(intQ1.getMax)
    println("max: " + intQ1.max)
    var (i2, intQ2) = intQ1.dequeue()
    println(intQ2, i2)
    println(intQ2.getMax())
    println("max: " + intQ2.max)
    var (i3, intQ3) = intQ2.dequeue()
    println(intQ3, i3)
    println(intQ3.getMax())
    println("max: " + intQ3.max)
    println("Empty? " + intQ3.empty() + "\n\n")
    var (i4, intQ4) = intQ3.dequeue()

    var stringQ = new MegaQueue("abs")
    stringQ = stringQ.enqueue("cba")
    println(stringQ + ", empty = " + stringQ.empty())   
    var (s1, stringQ1) = stringQ.dequeue()  
    println(stringQ1 + ", empty = " + stringQ1.empty())
    var (s2, stringQ2) = stringQ1.dequeue()  
    println(stringQ2 + ", empty = " + stringQ2.empty())
    var (s3, stringQ3) = stringQ2.dequeue()             // dequeue из пустой очереди - получим предупреждение
    stringQ = stringQ1.enqueue("oasd")
    println(stringQ + ", empty = " + stringQ.empty() + "\n\n")
}