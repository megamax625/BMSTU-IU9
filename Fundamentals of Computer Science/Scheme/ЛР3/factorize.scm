(load "unit-testing.scm")

(define (factorize expr)
  (let ((x (cadr (cadr expr)))
        (y (cadr (cadr (cdr expr)))))
    (cond ((and (eq? (car expr) '+) (equal? (caddr (cadr expr)) 3) (equal? (caddr (caddr expr)) 3))
           (list '* (list '+ x y) (list '+ (list '- (list 'expt x 2) (list '* x y)) (list 'expt y 2))))
          ((and (eq? (car expr) '-) (equal? (caddr (cadr expr)) 2) (equal? (caddr (caddr expr)) 2))
           (list '* (list '- x y) (list '+ x y)))
          ((and (eq? (car expr) '-) (equal? (caddr (cadr expr)) 3) (equal? (caddr (caddr expr)) 3))
           (list '* (list '- x y) (list '+ (list '+ (list 'expt x 2) (list '* x y)) (list 'expt y 2))))
          (else expr))))

(define the-tests
  (list (test (factorize '(- (expt x 2) (expt y 2))) '(* (- x y) (+ x y))) 
        (test (factorize '(- (expt (+ first 1) 2) (expt (- second 1) 2)))
              '(* (- (+ first 1) (- second 1))
                  (+ (+ first 1) (- second 1))))
        (test (eval (list (list 'lambda 
                                '(x y) 
                                (factorize '(- (expt x 2) (expt y 2))))
                          1 2)
                    (interaction-environment)) -3)
        (test (eval (list (list 'lambda
                                '(x y)
                                (factorize '(+ (expt x 3) (expt y 3))))
                          6 10)
                    (interaction-environment)) 1216)
        (test (eval (list (list 'lambda
                                '(x y)
                                (factorize '(- (expt x 3) (expt y 3))))
                          12 10)
                    (interaction-environment)) 728)
        (test (factorize '(- (expt x 3) (expt y 4))) '(- (expt x 3) (expt y 4)))
        (test (factorize '(+ (expt x 2) (expt y 2))) '(+ (expt x 2) (expt y 2)))))

