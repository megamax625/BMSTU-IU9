;; Задание 1

(define (my-range a b d)
  (define (pom a b d xs)
    (if (< a b)
        (pom (+ a d) b d (append xs (cons a '())))
        xs))
  (pom a b d '()))

(define (my-flatten xs)
  (cond
    ((null? xs) '())
    ((list? (car xs)) (append (my-flatten (car xs)) (my-flatten (cdr xs))))
    (else (cons (car xs) (my-flatten (cdr xs))))))

(define (my-element? x xs)
  (and
   (not (null? xs))
   (or
    (equal? x (car xs))
    (my-element? x (cdr xs)))))

(define (my-filter pred? xs)
  (define (pom pred? xs ys)
    (cond
      ((null? xs) ys)
      ((pred? (car xs)) (pom pred? (cdr xs) (append ys (cons (car xs) '()))))
      (else (pom pred? (cdr xs) ys))))
  (pom pred? xs '()))

(define (my-fold-left op xs)
  (if (null? (cdr xs))
      (car xs)
      (my-fold-left op (append (cons (op (car xs) (car (cdr xs))) '()) (cdr (cdr xs))))))

(define (my-fold-right op xs)
  (define (reversed op rxs)
    (if (null? (cdr rxs))
        (car rxs)
        (reversed op (append (cons (op (car (cdr rxs)) (car rxs)) '()) (cdr (cdr rxs))))))
  (reversed op (reverse xs)))

;; Задание 2

(define (list->set xs)
  (define (pom xs ys)
    (cond
      ((null? xs) ys)
      ((my-element? (car xs) ys) (pom (cdr xs) ys))
      (else (pom (cdr xs) (append ys (cons (car xs) '()))))))
  (pom xs '()))

(define (set? xs)
  (or
   (null? xs)
   (and
    (not (my-element? (car xs) (cdr xs)))
    (set? (cdr xs)))))

(define (union xs ys)
  (define (pom xs res)
    (cond
      ((null? xs) res)
      ((my-element? (car xs) res) (pom (cdr xs) res))
      (else (pom (cdr xs) (append res (cons (car xs) '()))))))
  (pom xs (pom ys '())))

(define (intersection xs ys)
  (define (pom xs ys res)
    (cond
      ((null? xs) res)
      ((my-element? (car xs) ys) (pom (cdr xs) ys (append res (cons (car xs) '()))))
      (else (pom (cdr xs) ys res))))
  (pom xs ys '()))

(define (difference xs ys)
  (define (pom xs ys res)
    (cond
      ((null? xs) res)
      ((my-element? (car xs) ys) (pom (cdr xs) ys res))
      (else (pom (cdr xs) ys (append res (cons (car xs) '()))))))
  (pom xs ys '()))

(define (symmetric-difference xs ys)
  (difference (union xs ys) (intersection xs ys)))

(define (set-eq? xs ys)
  (or
   (and (null? xs) (null? ys))
   (equal? (symmetric-difference xs ys) '())))

;; Задание 3

(define (string-trim-left str)
  (define (pom xs)
    (cond
      ((null? xs) xs)
      ((char-whitespace? (car xs)) (pom (cdr xs)))
      (else xs)))
  (list->string (pom (string->list str))))

(define (string-trim-right str)
  (list->string (reverse (string->list (string-trim-left (list->string (reverse (string->list str))))))))

(define (string-trim str)
  (string-trim-right (string-trim-left str)))

(define (string-prefix? a b)
  (define (pom a b)
    (and
     (not (> (length a) (length b)))
     (or
      (null? a)
      (and
       (equal? (car a) (car b))
       (pom (cdr a) (cdr b))))))
  (pom (string->list a) (string->list b)))

(define (string-suffix? a b)
  (string-prefix? (list->string (reverse (string->list a))) (list->string (reverse (string->list b)))))

(define (string-infix? a b)
  (define (compare x y)
    (or
     (null? x)
     (and
      (equal? (car x) (car y))
      (compare (cdr x) (cdr y)))))
  (define (pom x y)
    (and
     (not (> (length x) (length y)))
     (if (equal? (car x) (car y))
         (compare x y)
         (pom x (cdr y)))))
  (pom (string->list a) (string->list b)))

(define (string-split str sep)
  (define (sep-found? xs ys)
    (or
     (null? ys)
     (and
      (not (null? xs))
      (equal? (car xs) (car ys))
      (sep-found? (cdr xs) (cdr ys)))))
  (define (skip xs ys)
    (if (null? ys)
        xs
        (skip (cdr xs) (cdr ys))))
  (define (pom str sep res accum)
    (cond
      ((null? str) (if (null? accum)
                       (reverse res)
                       (reverse (cons (list->string accum) res))))
      ((sep-found? str sep) (pom (skip str sep) sep (cons (list->string accum) res) '()))
      (else (pom (cdr str) sep res (append accum (cons (car str) '()))))))
  (pom (string->list str) (string->list sep) '() '()))

;; Задание 4

(define (make-multi-vector sizes . fill)
  (let ((m (make-vector (+ 1 (apply * sizes)))))
    (if (not (null? fill))
        (vector-fill! m (car fill)))
    (vector-set! m 0 sizes)
    m))

(define (multi-vector? m)
  (and
   (vector? m)
   (pair? (vector-ref m 0))
   (equal? (vector-length m) (+ 1 (apply * (vector-ref m 0))))))

(define (multi-vector-ref m indices)
  (define (get-index m indices)
    (define (pom sizes indices index)
      (if (pair? sizes)
          (pom (cdr sizes) (cdr indices) (+ index (* (car indices) (apply * sizes))))
          (+ index (car indices))))
    (pom (cdr (reverse (vector-ref m 0))) indices 1))
  (vector-ref m (get-index m indices)))

(define (multi-vector-set! m indices x)
  (define (get-index m indices)
    (define (pom sizes indices index)
      (if (pair? sizes)
          (pom (cdr sizes) (cdr indices) (+ index (* (car indices) (apply * sizes))))
          (+ index (car indices))))
    (pom (cdr (reverse (vector-ref m 0))) indices 1))
  (vector-set! m (get-index m indices) x))

;; Задание 5

(define (o . fs)
  (define (pom x fs)
    (if (null? fs)
        x
        (pom ((car fs) x) (cdr fs))))
  (lambda(x) (pom x (reverse fs))))

(define (f x) (+ x 2))
(define (g x) (* x 3))
(define (h x) (- x))