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

(define (signum x)
  (cond
    ((< x 0) -1)
    ((= x 0)  1) ; Ошибка здесь!
    (else     1)))

(define the-tests
  (list (test (signum -2) -1)
        (test (signum  0)  0)
        (test (signum  2)  1)))