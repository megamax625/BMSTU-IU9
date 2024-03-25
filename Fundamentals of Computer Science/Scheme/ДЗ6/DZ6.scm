(define call-cc call-with-current-continuation)
;; Конструктор потока
(define (make-stream items . eos)
  (if (null? eos)
      (make-stream items #f)
      (list items (car eos))))

;; Запрос текущего символа
(define (peek stream)
  (if (null? (car stream))
      (cadr stream)
      (caar stream)))

;; Продвижение вперёд
(define (next stream)
  (let ((n (peek stream)))
    (if (not (null? (car stream)))
        (set-car! stream (cdr (car stream))))
    n))

;; Задание 1 - Лексический анализатор.

; <exp> ::= <const> | <variable> | "(" <exp> <op> <exp> ")" | <exp> <op> <exp>
; <const> ::= DIGIT <const'> | - DIGIT <const'>
; <const'> ::= DIGIT <const'> | e
; <variable> ::= LETTER <variable'> | - LETTER <variable'>
; <variable'> ::= LETTER <variable'> | e
; <op> = + | - | * | / | ^


(define (op? char)
  (or (equal? char #\+) (equal? char #\-) (equal? char #\*) (equal? char #\/) (equal? char #\^)))
(define (digit? char)
  (char-numeric? char))
(define (bracket? char)
  (or (equal? char #\() (equal? char #\))))
(define (letter? char)
  (char-alphabetic? char))

(define (tokenize str)
  (let* ((eos #\↵)
         (stream (make-stream (string->list str) eos)))
    (call-cc
     (lambda (error)
       (scan stream error '())))))

(define (scan stream error tokens)
  (let ((char (next stream)))
    (cond
      ((equal? char #\↵) tokens)
      ((char-whitespace? char) (scan stream error tokens))
      ((digit? char) (scan-const stream error tokens (make-string 1 char)))
      ((letter? char) (scan-variable stream error tokens (make-string 1 char))) 
      ((op? char) (scan stream error (append tokens (cons (string->symbol (make-string 1 char)) '()))))
      ((bracket? char) (scan stream error (append tokens (cons (make-string 1 char) '()))))
      (else error #f))))

; <const> ::= DIGIT <const'> | - DIGIR <const'>
; <const'> ::= DIGIT <const'> | e
(define (scan-const stream error tokens const)
  (let ((char (peek stream)))
    (cond
      ((digit? char) (begin
                       (next stream)
                       (scan-const stream error tokens (string-append const (make-string 1 char)))))
      ((or (equal? char #\↵) (char-whitespace? char) (bracket? char) (op? char) (variable? char))
       (scan stream error (append tokens (cons (string->number const) '()))))
      (else #f))))

; <variable> ::= LETTER <variable'> | - LETTER <variable'>
; <variable'> ::= LETTER <variable'> | e
(define (scan-variable stream error tokens variable)
  (let ((char (peek stream)))
    (cond
      ((letter? char) (begin
                        (next stream)
                        (scan-variable stream error tokens (string-append variable (make-string 1 char)))))
      ((or (equal? char #\↵) (char-whitespace? char) (bracket? char) (op? char) (digit? char))
       (scan stream error (append tokens (cons (string->symbol variable) '()))))
      (else #f))))

; Задание 2 - Синтаксический анализатор.

;Expr    ::= Term Expr' .
;Expr'   ::= AddOp Term Expr' | .
;Term    ::= Factor Term' .
;Term'   ::= MulOp Factor Term' | .
;Factor  ::= Power Factor' .
;Factor' ::= PowOp Power Factor' | .
;Power   ::= value | "(" Expr ")" | unaryMinus Power .
;Терминалы - value, "(", ")" и знаки операций.

(define (parse exp)
  (call-cc
   (lambda (error)
     (let* ((stream (make-stream exp #\↵))
            (res (term stream error (factor stream error))))
       (expr stream error res)))))

;Expr    ::= Term Expr' .
;Expr'   ::= AddOp Term Expr' | .
(define (expr stream error res)
  (let ((symbol (peek stream)))
    (cond
      ((equal? symbol #\↵) res)
      ((or (equal? symbol '+) (equal? symbol '-)) (begin
                                                    (next stream)
                                                    (expr stream error (list res symbol (term stream error (factor stream error))))))
      ((and (not (equal? symbol ")")) (equal? symbol #\↵)) (error #f))
      (else res))))

;Term    ::= Factor Term' .
;Term'   ::= MulOp Factor Term' | .
(define (term stream error res)
  (let ((symbol (peek stream)))
    (cond
      ((equal? symbol #\↵) res)
      ((or (eq? symbol '*) (eq? symbol '/)) (begin
                                              (next stream)
                                              (term stream error (list res symbol (factor stream error)))))
      (else res))))

;Factor  ::= Power Factor' .
;Factor' ::= PowOp Power Factor' | .
(define (factor stream error)
  (let ((res (power stream error))
        (symbol (peek stream)))
    (cond
      ((equal? symbol #\↵) res)
      ((eq? symbol '^) (begin
                         (next stream)
                         (list res '^ (factor stream error))))
      (else res))))

;Power   ::= value | "(" Expr ")" | unaryMinus Power .
(define (power stream error)
  (let ((symbol (next stream)))
    (cond
      ((equal? symbol #\↵) (error #f))
      ((eq? symbol '-) (list '- (power stream error))) 
      ((or (number? symbol) (symbol? symbol)) symbol)
      ((equal? symbol "(") (let ((res (expr stream error (term stream error (factor stream error)))))
                             (if (and (not (equal? (peek stream) #\↵)) (equal? (next stream) ")"))
                                 res
                                 (error #f))))
      (else (error #f)))))

; Задание 3 - Преобразователь дерева разбора в выражение на Scheme

(define (tree->scheme tree)
  (if (and (list? tree) (= (length tree) 3))
      (if (eq? (cadr tree) '^)
          (list 'expt (tree->scheme (car tree)) (tree->scheme (caddr tree)))
          (list (cadr tree) (tree->scheme (car tree)) (tree->scheme (caddr tree))))
      tree))

; Тесты
(define-syntax test
  (syntax-rules ()
    ((_ exprs res)
     (list (quote exprs) res))))

(define (run-test testin)
  (write (car testin))
  (let ((res (eval (car testin) (interaction-environment))))
    (if (equal? res (cadr testin))
        (begin
          (display " ok")
          (newline)
          #t)
        (begin
          (display " FAIL")
          (newline)
          (display "Expected: ") (write (cadr testin))
          (newline)
          (display "Returned: ") (write res)
          (newline)
          #f))))

(define (run-tests tests)
  (define (pom res tests)
    (if (null? tests)
        res
        (pom (and res (car tests)) (cdr tests))))
  (pom #t (map run-test tests)))

(define tests-1
  (list
   (test (tokenize "1") '(1))
   (test (tokenize "-a") '(- a))
   (test (tokenize "-a + b * x^2 + dy") '(- a + b * x ^ 2 + dy))
   (test (tokenize "(a - 1)/(b + 1)") '("(" a - 1 ")" / "(" b + 1 ")"))
   ))

(define tests-2
  (list
   (test (parse (tokenize "a/b/c/d")) '(((a / b) / c) / d)) ; Ассоциативность левая
   (test (parse (tokenize "a^b^c^d")) '(a ^ (b ^ (c ^ d)))) ; Ассоциативность правая
   (test (parse (tokenize "a/(b/c)")) '(a / (b / c))) ; Порядок вычислений задан скобками
   (test (parse (tokenize "a + b/c^2 - d")) '((a + (b / (c ^ 2))) - d)) ; Порядок вычислений определен только приоритетом операций
   ))

(define tests-3
  (list
   (test (tree->scheme (parse (tokenize "x^(a + 1)"))) '(expt x (+ a 1)))
   (test (eval (tree->scheme (parse (tokenize "2^2^2^2"))) (interaction-environment)) 65536)
   ))

(run-tests tests-1)
(run-tests tests-2)
(run-tests tests-3)