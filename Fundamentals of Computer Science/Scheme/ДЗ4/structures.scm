(define-syntax make-fields
  (syntax-rules ()
    ((_ (field)) (list `field))
    ((_ (field1 field2 ...)) (append (list 'list `field1) (make-fields (field2 ...))))
    ((_ type (field1 field2 ...)) (append `type (make-fields (field1 field2 ...))))))
(define-syntax allow-make
  (syntax-rules ()
    ((_ type (field1 field2 ...))
     (eval (list 'define (list (string->symbol (string-append (symbol->string 'make-) (symbol->string 'type)))
                               (append '(list) (make-fields 'type (field1 field2 ...)))))
           (interaction-environment)))))
(define-syntax allow-pred
  (syntax-rules ()
    ((_ type) (eval (list 'define `(list (string-append (symbol->string `type) "?") 'object) '(and
                                                                                               (list? object)
                                                                                               (symbol? (car object))
                                                                                               (equal? (car object) `type)))
                    (interaction-environment)))))
(define-syntax define-struct
  (syntax-rules ()
    ((_ type (field1 field2 ...))
     (begin
       (allow-make type (field1 field2 ...))
       (allow-pred type (field1 field2 ...))
       (allow-ref type (field1 field2 ...))
       (allow-set type (field1 field2 ...))))))

(define-struct pos (row col))