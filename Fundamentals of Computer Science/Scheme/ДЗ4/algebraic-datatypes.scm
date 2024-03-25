(define-syntax allow-pred
  (syntax-rules ()
    ((_ type var ...)
     (begin
       (eval '(define type (list 'var ...)) (interaction-environment))
       (eval (list 'define (list (string->symbol (string-append (symbol->string 'type) "?")) 'object)
                   '(and (member (car object) type) (list? object))) (interaction-environment))))))
(define-syntax allow-constr
  (syntax-rules ()
    ((_ type arg ...)
     (eval '(define (type arg ...) (list 'type arg ...)) (interaction-environment)))))
(define-syntax define-data
  (syntax-rules ()
    ((_ type ((var arg ...) ...))
        (begin
          (allow-pred type var ...)
          (allow-constr var arg ...) ...))))
