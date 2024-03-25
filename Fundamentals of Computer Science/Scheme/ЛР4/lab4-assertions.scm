;;Задание 1
(define call-cc call-with-current-continuation)
(define continuation #f)
(define-syntax use-assertions
  (syntax-rules ()
    ((_) (call-cc
          (lambda (failure)
            (set! continuation
                  (lambda (expr)
                    (display "FAILED: ")
                    (display expr)
                    (failure))))))))
(define-syntax assert
  (syntax-rules ()
    ((_ assertion)
     (if (not assertion) (continuation 'assertion)))))

(use-assertions) ; Инициализация вашего каркаса перед использованием

; Определение процедуры, требующей верификации переданного ей значения:

(define (1/x x)
  (assert (not (zero? x))) ; Утверждение: x ДОЛЖЕН БЫТЬ > 0
  (/ 1 x))

; Применение процедуры с утверждением:
(display "Условие не нарушено:")
(newline)
(map 1/x '(1 2 3 4 5)) ; ВЕРНЕТ список значений в программу
(display "Условие нарушено:")
(newline)
(map 1/x '(-2 -1 0 1 2)) ; ВЫВЕДЕТ в консоль сообщение и завершит работу программы