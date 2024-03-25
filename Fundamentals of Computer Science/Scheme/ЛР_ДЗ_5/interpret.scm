(define (operator? op)
  (or
   (equal? op '+)
   (equal? op '-)
   (equal? op '*)
   (equal? op '/)
   (equal? op 'mod)
   (equal? op 'neg)
   (equal? op '=)
   (equal? op '>)
   (equal? op '<)
   (equal? op 'not)
   (equal? op 'and)
   (equal? op 'or)
   (equal? op 'drop)
   (equal? op 'swap)
   (equal? op 'dup)
   (equal? op 'over)
   (equal? op 'rot)
   (equal? op 'depth)))

(define (operate op data-stack)
  (cond
    ((equal? op '+) (cons (+ (cadr data-stack) (car data-stack)) (cddr data-stack)))
    ((equal? op '-) (cons (- (cadr data-stack) (car data-stack)) (cddr data-stack)))
    ((equal? op '*) (cons (* (cadr data-stack) (car data-stack)) (cddr data-stack)))
    ((equal? op '/) (cons (quotient (cadr data-stack) (car data-stack)) (cddr data-stack)))
    ((equal? op 'mod) (cons (remainder (cadr data-stack) (car data-stack)) (cddr data-stack)))
    ((equal? op 'neg) (cons (- (car data-stack)) (cdr data-stack)))
    ((equal? op '=) (if (equal? (cadr data-stack) (car data-stack))
                        (cons -1 (cddr data-stack))
                        (cons 0 (cddr data-stack))))
    ((equal? op '>) (if (> (cadr data-stack) (car data-stack))
                        (cons -1 (cddr data-stack))
                        (cons 0 (cddr data-stack))))
    ((equal? op '<) (if (< (cadr data-stack) (car data-stack))
                        (cons -1 (cddr data-stack))
                        (cons 0 (cddr data-stack))))
    ((equal? op 'not) (if (equal? (car data-stack) 0)
                          (cons -1 (cdr data-stack))
                          (cons 0 (cdr data-stack))))
    ((equal? op 'and) (if (or (= (cadr data-stack) 0) (= (car data-stack) 0))
                          (cons 0 (cddr data-stack))
                          (cons -1 (cddr data-stack))))
    ((equal? op 'or) (if (and (= (cadr data-stack) 0) (= (car data-stack) 0))
                         (cons 0 (cddr data-stack))
                         (cons -1 (cddr data-stack))))
    ((equal? op 'drop) (cdr data-stack))
    ((equal? op 'swap) (cons (cadr data-stack) (cons (car data-stack) (cddr data-stack))))
    ((equal? op 'dup) (cons (car data-stack) (cons (car data-stack) (cdr data-stack))))
    ((equal? op 'over) (cons (cadr data-stack) (cons (car data-stack) (cons (cadr data-stack) (cddr data-stack)))))
    ((equal? op 'rot) (cons (caddr data-stack) (cons (cadr data-stack) (cons (car data-stack) (cdddr data-stack)))))
    ((equal? op 'depth) (cons (length data-stack) data-stack))))

(define (skip-definition program ind)
  (if (equal? (vector-ref program ind) 'end)
      ind
      (skip-definition program (+ ind 1))))

; if с альтернативной веткой else
(define (skip-if-branch program ind)
  (if (or (equal? (vector-ref program ind) 'endif) (equal? (vector-ref program ind) 'else))
      ind
      (skip-if-branch program (+ ind 1))))

; цикл While
(define (skip-while program ind)
  (if (equal? (vector-ref program ind) 'wend)
      ind
      (skip-while program (+ ind 1))))

(define (interpret program data-stack)
  (define (main data-stack return-stack counter dict)
    (if (>= counter (vector-length program))
        data-stack
        (let ((op (vector-ref program counter)))
          (cond
            ((integer? op) (main (cons op data-stack) return-stack (+ counter 1) dict))
            ((operator? op) (main (operate op data-stack) return-stack (+ counter 1) dict))
            ((equal? op 'define)
             (main data-stack return-stack (+ (skip-definition program counter) 1) (cons (list (vector-ref program (+ counter 1)) (+ counter 2)) dict)))
            ((assoc op dict) (main data-stack (cons (+ counter 1) return-stack) (cadr (assoc op dict)) dict))
            ((or (equal? op 'end) (equal? op 'exit)) (main data-stack (cdr return-stack) (car return-stack) dict))
            ((equal? op 'if) (if (= (car data-stack) 0)
                                 (main (cdr data-stack) return-stack (+ (skip-if-branch program counter) 1) dict)
                                 (main (cdr data-stack) return-stack (+ counter 1) dict)))
            ((equal? op 'else) (main data-stack return-stack (+ (skip-if-branch program (+ counter 1))) dict))
            ((equal? op 'endif) (main data-stack return-stack (+ counter 1) dict))
            ((equal? op 'while) (if (= (car data-stack) 0)
                                    (main (cdr data-stack) return-stack (+ (skip-while program counter) 1) dict)
                                    (main (cdr data-stack) (cons counter return-stack) (+ counter 1) dict)))
            ((equal? op 'wend) (main data-stack (cdr return-stack) (car return-stack) dict))))))
  (main data-stack '() 0 '()))

; Тестирование
(define-syntax test
  (syntax-rules ()
    ((_ exprs res)
     (list (quote exprs) res))))

(define (run-test testin)
    (write (car testin))
    (let ((res (eval (car testin) (interaction-environment))))
      (if (equal? res (cadr testin))
          (begin
            (display " ok")
            (newline)
            #t)
          (begin
            (display " FAIL")
            (newline)
            (display "Expected: ") (write (cadr testin))
            (newline)
            (display "Returned: ") (write res)
            (newline)
            #f))))

(define (run-tests tests)
  (define (pom res tests)
    (if (null? tests)
        res
        (pom (and res (car tests)) (cdr tests))))
  (pom #t (map run-test tests)))

(define tests
  (list (test (interpret #(2 3 * 4 5 * +) '()) '(26))
        (test (interpret #(3 7 +) '()) '(10))
        (test (interpret #(3 7 -) '()) '(-4))
        (test (interpret #(3 7 *) '()) '(21))
        (test (interpret #(7 3 /) '()) '(2))
        (test (interpret #(7 3 mod) '()) '(1))
        (test (interpret #(7 neg) '()) '(-7))
        (test (interpret #(3 7 =) '()) '(0))
        (test (interpret #(7 4 - 3 =) '()) '(-1))
        (test (interpret #(3 7 >) '()) '(0))
        (test (interpret #(7 3 <) '()) '(0))
        (test (interpret #(3 7 <) '()) '(-1))
        (test (interpret #(7 3 >) '()) '(-1))
        (test (interpret #(7 not) '()) '(0))
        (test (interpret #(0 not) '()) '(-1))
        (test (interpret #(3 7 and) '()) '(-1))
        (test (interpret #(0 7 and) '()) '(0))
        (test (interpret #(3 0 and) '()) '(0))
        (test (interpret #(3 7 or) '()) '(-1))
        (test (interpret #(0 0 or) '()) '(0))
        (test (interpret #(3 0 or) '()) '(-1))
        (test (interpret #(0 3 or) '()) '(-1))
        (test (interpret #(drop) '(1)) '())
        (test (interpret #(drop) '(1 2)) '(2))
        (test (interpret #(swap) '(2 1)) '(1 2))
        (test (interpret #(dup) '(1)) '(1 1))
        (test (interpret #(dup) '(1 2)) '(1 1 2))
        (test (interpret #(over) '(2 1)) '(1 2 1))
        (test (interpret #(over) '(3 2 1)) '(2 3 2 1))
        (test (interpret #(rot) '(3 2 1)) '(1 2 3))
        (test (interpret #(rot) '(4 3 2 1)) '(2 3 4 1))
        (test (interpret #(depth) '()) '(0))
        (test (interpret #(depth) '(1 2 3 4 5)) '(5 1 2 3 4 5))
        (test (interpret #(   define -- 1 - end
                               5 -- --      ) '()) '(3))
        (test (interpret #(   define abs 
                               dup 0 < 
                               if neg endif 
                               end 
                               9 abs 
                               -9 abs      ) (quote ())) '(9 9))
        (test (interpret #(   define =0? dup 0 = end
                               define <0? dup 0 < end
                               define signum
                               =0? if exit endif
                               <0? if drop -1 exit endif
                               drop
                               1
                               end
                               0 signum
                               -5 signum
                               10 signum       ) (quote ())) '(1 -1 0))
        (test (interpret #(   define -- 1 - end
                               define =0? dup 0 = end
                               define =1? dup 1 = end
                               define factorial
                               =0? if drop 1 exit endif
                               =1? if drop 1 exit endif
                               dup --
                               factorial
                               *
                               end
                               0 factorial
                               1 factorial
                               2 factorial
                               3 factorial
                               4 factorial     ) (quote ())) '(24 6 2 1 1))
        (test (interpret #(   define =0? dup 0 = end
                               define =1? dup 1 = end
                               define -- 1 - end
                               define fib
                               =0? if drop 0 exit endif
                               =1? if drop 1 exit endif
                               -- dup
                               -- fib
                               swap fib
                               +
                               end
                               define make-fib
                               dup 0 < if drop exit endif
                               dup fib
                               swap --
                               make-fib
                               end
                               10 make-fib     ) (quote ())) '(0 1 1 2 3 5 8 13 21 34 55))
        (test (interpret #(   define =0? dup 0 = end
                               define gcd
                               =0? if drop exit endif
                               swap over mod
                               gcd
                               end
                               90 99 gcd
                               234 8100 gcd    ) '()) '(18 9))
        (test (interpret #(if 1 else 0 endif) '(0)) '(0))
        (test (interpret #(if 1 else 0 endif) '(-1)) '(1))
        (test (interpret #(1 2 > if 1 else 0 endif) '()) '(0))
        (test (interpret #(1 1 and if 20 30 - else 4 10 * endif) '()) '(-10))
        (test (interpret #(0 0 or if 50 30 + else 25 4 * endif) '()) '(100))
        (test (interpret #(while + wend) '(0 1 2 3)) '(1 2 3))
        (test (interpret #(while + wend) '(2 -2 2 3 4)) '(3 4))
        ))