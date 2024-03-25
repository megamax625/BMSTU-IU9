(define-syntax flatten
  (syntax-rules ()
    ((_ data) (let func ((input data))
                (cond
                  ((null? input) '())
                  ((list? (car input)) (append (func (car input)) (func (cdr input))))
                  (else (cons (car input) (func (cdr input)))))))))

(flatten '())
(flatten '(1))
(flatten '(1 2 3))
(flatten '(1 (2 3 (4 5)) 6 (7 (8 (9 10)))))
(flatten '(1 (2 (3 (4 (5 (6 (7 (8 (9 (10)))))))))))