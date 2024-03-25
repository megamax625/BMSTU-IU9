(define (count x xs)
  (cond
    ((null? xs) 0)
    ((equal? x (car xs)) (+ 1 (count x (cdr xs))))
    (else (count x (cdr xs)))))

(define (delete pred? xs)
  (define (pom pred? xs ys)
    (cond
      ((null? xs) ys)
      ((pred? (car xs)) (pom pred? (cdr xs) ys))
      (else (pom pred? (cdr xs) (append ys (cons (car xs) '()))))))
  (pom pred? xs '()))

(define (iterate f x n)
  (define (pom f x n xs)
    (if (= n 0)
        xs
        (pom f (f x) (- n 1) (append xs (cons x '())))))
  (pom f x n '()))

(define (intersperse e xs)
  (define (pom e xs ys)
    (cond
      ((null? xs) ys)
      ((null? (cdr xs)) (append ys (cons (car xs) '())))
      (else (pom e (cdr xs) (append ys (cons (car xs) (cons e '())))))))
  (pom e xs '()))

(define (any? pred? xs)
  (and
   (not (null? xs))
   (or
    (pred? (car xs))
    (any? pred? (cdr xs)))))

(define (all? pred? xs)
  (or
   (null? xs)
   (and
    (pred? (car xs))
    (all? pred? (cdr xs)))))

(define (o . fs)
  (define (pom x fs)
    (if (null? fs)
        x
        (pom ((car fs) x) (cdr fs))))
  (lambda(x) (pom x (reverse fs))))

(define (f x) (+ x 2))
(define (g x) (* x 3))
(define (h x) (- x))
