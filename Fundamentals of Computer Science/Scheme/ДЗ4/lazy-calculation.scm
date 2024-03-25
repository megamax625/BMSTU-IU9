(define-syntax lazy-cons
  (syntax-rules ()
    ((_ a b) (cons a (delay b)))))
(define (lazy-car p)
  (car p))
(define (lazy-cdr p)
  (force (cdr p)))
(define (lazy-head xs k)
  (if (< k 1)
      '()
      (cons (lazy-car xs) (lazy-head (lazy-cdr xs) (- k 1)))))
(define (lazy-ref xs k)
  (if (= k 0)
      (lazy-car xs)
      (lazy-ref (lazy-cdr xs) (- k 1))))
(define (naturals start)
  (lazy-cons start (naturals (+ start 1))))
  
(display (lazy-head (naturals 10) 12)) (newline)

(define (lazy-factorial n)
  (define (fact-inf start val)
    (lazy-cons val (fact-inf (+ start 1) (* (+ start 1) val))))
  (lazy-ref (fact-inf 0 1) n))

(begin
  (display (lazy-factorial 10)) (newline)
  (display (lazy-factorial 50)) (newline))

(define lazy-zip
  (lambda (x y) (lazy-cons (* (car x) (car y)) (lazy-zip (lazy-cdr x) (lazy-cdr y)))))
(lazy-head
  (lazy-zip
    (naturals 4)
    (naturals 10))
  5)
; Выведет (40 55 72 91 112)

(define ones
  (lazy-cons 1 ones))
(lazy-head ones 10)
; Выведет (1 1 1 1 1 1 1 1 1 1)

(define (lazy-skip xs n)
  (if (= n 0)
      xs
      (lazy-skip (lazy-cdr xs) (- n 1))))