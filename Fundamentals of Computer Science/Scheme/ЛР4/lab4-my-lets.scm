(define-syntax my-let
  (syntax-rules ()
    ((_ ((var init) ...) body-first . body-next)
     ((lambda (var ...) body-first . body-next)
      init ...))))

(define-syntax my-let*
  (syntax-rules ()
    ((_ () body-first . body-next)
     (my-let () body-first . body-next))
    ((_ ((var1 init1) (var2 init2) ...) body-first . body-next)
     (my-let ((var1 init1))
             (my-let* ((var2 init2) ...)
                     body-first . body-next)))))

(my-let ((x 2) (y 3))
  (* x y))
; Вернёт 6

(my-let ((x 2) (y 3))
  (my-let ((x 7)
        (z (+ x y)))
    (* z x)))
; Вернёт 35

(my-let ((x 2) (y 3))
  (my-let* ((x 7)
         (z (+ x y)))
    (* z x)))
; Вернёт 70
