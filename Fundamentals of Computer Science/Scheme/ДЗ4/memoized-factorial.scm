(define memoized-factorial
  (let ((memo '()))
    (lambda (n)
      (if (assoc n memo)
          (cadr (assoc n memo))
          (let ((result (if (or (= n 0) (= n 1))
                         1
                         (* n (memoized-factorial (- n 1))))))
            (set! memo
                  (cons (list n result) memo))
            result)))))

(begin
  (display (memoized-factorial 10)) (newline)
  (display (memoized-factorial 50)) (newline))