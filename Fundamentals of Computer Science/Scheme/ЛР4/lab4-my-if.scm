(define-syntax my-if
  (syntax-rules ()
    ((_ condition consequent alternative) (let ((if-true (delay consequent))
                                                (if-false (delay alternative)))
                                            (force
                                             (or
                                              (and
                                               condition
                                               if-true)
                                              if-false))))))

(my-if #t 1 (/ 1 0))
(my-if #f (/ 1 0) 1)
; Вернут 1
                
