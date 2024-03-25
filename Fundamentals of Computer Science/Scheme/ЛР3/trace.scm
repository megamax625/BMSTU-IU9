(define-syntax trace
  (syntax-rules ()
    ((_ expr)
     (begin
       (display 'expr)
       (display " => ")
       (let
           ((exprcalc expr))
         (display exprcalc)
         (newline)
         exprcalc)))))

(define (zip . xss)
  (if (or (null? xss)
          (null? (trace (car xss))))
      '()
      (cons (map car xss)
            (apply zip (map cdr (trace xss))))))
       
;(zip '(1 2 3) '(one two three))
;(car xss) => (1 2 3)
;xss => ((1 2 3) (one two three))
;(car xss) => (2 3)
;xss => ((2 3) (two three))
;(car xss) => (3)
;xss => ((3) (three))
;(car xss) => ()
;((1 one) (2 two) (3 three))
