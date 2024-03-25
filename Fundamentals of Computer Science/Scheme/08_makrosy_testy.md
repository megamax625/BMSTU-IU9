=======Макросы=======

Макрос - инструмент переписывания кода.

---Как scheme вычисляет выражения---
(<слово> expr)
Если <слово> - ключевое слово яызка (quote, set etc), то выполняется expr
Если <слово> - имя переменной, то вычисляется значение ф-ции от expr
Если <слово> - имя макроса, выражение переписывается согласно правилам и снова интерпретируется

Синтаксис макросов:

(define-syntax <имя>
  (syntax-rules (<ключевые слова>)
    ((<образец>) (<шаблон>))
    ((<образец>) (<шаблон>))
    ((<образец>) (<шаблон>))
    ...
    ((<образец>) (<шаблон>))
    ((<pattern>) (<template>))))
; если вызов макроса подходит под образец, то он заменяется на шаблон

(<имя> <образцы термов выражения>)
(_ <образцы термов выражения>) 
;вместо имени переменной, ктр нам не интересна, можно использовать нижн подчеркивание _

Образец и шаблон списка:
(<элемент> ... <элемент> . <хвост>)

======Модульное тестирование======
unit-testing;
Модульный тест - тест, проверяющий работу малой части программы: ф-ции, процедуры, класса, метода класса.
Модульный тест самопроверяемый, выполнятеся быстро.

Разработка через тестирование
Выполняется короткими циклами длительностью ~1 минута.

1. Написание теста для неготовой функциональности
2. Написание функциональности, позволяющей пройти новому тесту. Теперь все тесты должны проходить.
3. Рефакторинг - улучшение внутренней структуры программы с точным сохранением внешнего поведения. Тесты должны по-прежнему проходить.

(define-syntax for
  (syntax-rules (:= to do downto)
    ((_ var := start to end do . actions ) ;образец
     (let loop
       ((var start)
        (limit end))
       (if (> var limit)
           #f
           (begin
             (begin . actions)
             (loop  (+ var 1) limit)))))
    ((_ var := start downto end do . actions ) ;образец
     (let loop
       ((var start)
        (limit end))
       (if (< var limit)
           #f
           (begin
             (begin . actions)
             (loop  (- var 1) limit)))))
    )) ;шаблон

(define-syntax my-cond
  (syntax-rules (else)
    ((_ (else . actions)) (begin . actions))
    ((_ (condition . actions))
     (if condition
         (begin . actions)))
    ((_ (condition . actions) . branches)
     (if condition
         (begin . actions)
         (my-cond . branches)))))

(define (f x)
  (my-cond ((> x 0) (display 'pos) (newline))
           ((< x 0) (display 'neg) (newline))
           ((= x 0) (display 'zero) (newline))))

(define-syntax my-begin
  (syntax-rules ()
    ((_ action) action)
    ((_ action . actions)
     (let ((not-used action))
       (my-begin . actions)))))
