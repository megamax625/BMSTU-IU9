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

;; Запрос первых двух символов
(define (peek2 stream)
  (if (null? (car stream))
      (cadr stream)
      (if (null? (cdar stream))
          (list (caar stream))
          (list (caar stream) (cadar stream)))))

;; Продвижение вперёд
(define (next stream)
  (let ((n (peek stream)))
    (if (not (null? (car stream)))
        (set-car! stream (cdr (car stream))))
    n))

;; Задание 1

;<fraction> ::= <sign> <numerator-with-/> <denominator>
;<numerator-with-/> ::= <digit> <integer> /
;<denominator> ::= <digit> <integer>
;<integer> ::= <digit> <integer> | empty
;<sign> ::= + | - | empty
;<digit> ::= 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9


;<string> ::= <whitespaces> <fraction> <fractions> <whitespaces>
;<fractions> ::= <whitespaces> <fraction> <fractions> | empty
;<fraction> ::= <sign> <numerator-with-/> <denominator>
;<whitespaces> ::= <whitespace-symbol> <whitespaces> | empty
;<whitespace-symbol> ::= tab | space | newline
;<numerator-with-/> / ::= <digit> <integer> /
;<denominator> ::= <digit> <integer>
;<integer> ::= <digit> <integer> | empty
;<sign> ::= + | - | empty
;<digit> ::= 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9

(define (sign? char)
  (or (equal? char #\+) (equal? char #\-)))
(define (digit? char)
  (char-numeric? char))
(define (my-gcd a b)
  (if (= (- a b) 0)
      a
      (if (< a b)
          (my-gcd a (- b a))
          (my-gcd (- a b) b))))
(define (check-frac str)
  (let* ((eos #\↵)
         (stream (make-stream (string->list str) eos)))
    (call-cc
     (lambda (error)
       (check-fraction stream error)))))
(define (scan-frac str)
  (let* ((eos #\↵)
         (stream (make-stream (string->list str) eos)))
    (call-cc
     (lambda (error)
       (scan-fraction stream error)))))
(define (scan-many-fracs str)
  (let* ((eos #\↵)
         (stream (make-stream (string->list str) eos)))
    (call-cc
     (lambda (error)
       (scan-fractions stream error)))))

;<fraction> ::= <sign> <numerator> / <denominator>
(define (check-fraction stream error)
  (if (or (sign? (peek stream)) (digit? (peek stream)))
      (begin
        (next stream)
        (and (check-numerator stream error) (check-denominator stream error)))
      (error #f)))

(define (scan-fraction stream error)
  (cond
    ((sign? (peek stream)) 
     (let ((sign (next stream))
           (s-n (string->number (list->string (scan-numerator stream error))))
           (s-d (string->number (list->string (scan-denominator stream error)))))
       (if (equal? sign #\+)
           (/ (/ s-n (my-gcd s-n s-d)) (/ s-d (my-gcd s-n s-d)))
           (- (/ (/ s-n (my-gcd s-n s-d)) (/ s-d (my-gcd s-n s-d)))))))
    ((digit? (peek stream)) (let ((s-n (string->number (list->string (scan-numerator stream error))))
                                  (s-d (string->number (list->string (scan-denominator stream error)))))
                              (/ (/ s-n (my-gcd s-n s-d)) (/ s-d (my-gcd s-n s-d)))))
    (else (error #f))))

(define (scan-fractions stream error)
  (define (scan-acc stream error acc)
    (cond
      ((char-whitespace? (peek stream)) (begin (next stream) (scan-acc stream error acc)))
      ((sign? (peek stream)) (let ((sign (next stream))
                                   (s-n (string->number (list->string (scan-numerator stream error))))
                                   (s-d (string->number (list->string (scan-denominator stream error)))))
                               (if (equal? sign #\+)
                                   (scan-acc stream error (append acc (/ (/ s-n (my-gcd s-n s-d)) (/ s-d (my-gcd s-n s-d)))))
                                   (scan-acc stream error (append acc (- (/ (/ s-n (my-gcd s-n s-d)) (/ s-d (my-gcd s-n s-d)))))))))
      ((digit? (peek stream)) (let ((s-n (string->number (list->string (scan-numerator stream error))))
                                    (s-d (string->number (list->string (scan-denominator stream error)))))
                                (if (null? acc)
                                    (scan-acc stream error (list (append acc (/ (/ s-n (my-gcd s-n s-d)) (/ s-d (my-gcd s-n s-d))))))
                                    (scan-acc stream error (append acc (list (/ (/ s-n (my-gcd s-n s-d)) (/ s-d (my-gcd s-n s-d)))))))))
      ((and (null? (car stream)) (not (null? acc))) acc)
      (else (error #f))))
  (scan-acc stream error '()))
;<numerator-with-/> / ::= <digit> <integer> /
(define (check-numerator stream error)
  (define (numcheck stream error digit-found)
    (let ((s (next stream)))
      (cond
        ((equal? s #\/) digit-found)
        ((digit? s) (numcheck stream error #t))
        (else (error #f)))))
  (numcheck stream error #f))

(define (scan-numerator stream error)
  (define (numscan stream error num)
    (let ((s (next stream)))
      (cond
        ((equal? s #\/) (reverse num))
        ((char-whitespace? s) (reverse num))
        ((digit? s) (numscan stream error (cons s num)))
        (else (error #f)))))
  (numscan stream error '()))

;<denominator> ::= <digit> <integer>
(define (check-denominator stream error)
  (let ((s (next stream)))
    (cond
      ((equal? s #\↵) #t)
      ((digit? s) (check-denominator stream error))
      (else (error #f)))))

(define (scan-denominator stream error)
  (define (denomscan stream error den)
    (let ((s (next stream)))
      (cond
        ((equal? s #\↵) (reverse den))
        ((char-whitespace? s) (reverse den))
        ((digit? s) (denomscan stream error (cons s den)))
        (else (error #f)))))
  (denomscan stream error '()))


;; Задание 2
;<Program>  ::= <Articles> <Body> .
;<Articles> ::= <Article> <Articles> | .
;<Article>  ::= define word <Body> end .
;<Body>     ::= if <Body> endif <Body> | integer <Body> | word <Body> | .

(define (word? x)
  (and
   (symbol? x)
   (not
    (or
     (equal? x 'define)
     (equal? x 'end)
     (equal? x 'if)
     (equal? x 'endif)))))

(define (parse vect)
  (let* ((eos #\↵)
         (stream (make-stream (vector->list vect) eos)))
    (call-cc
     (lambda (error)
       (define res (program stream error))
       (and (equal? (peek stream) eos)
            res)))))

;<Program>  ::= <Articles> <Body> .
(define (program stream error)
  (list (articles stream error) (body stream error)))

;<Articles> ::= <Article> <Articles> | .
(define (articles stream error)
  (if (equal? (peek stream) 'define)
      (cons (article stream error) (articles stream error))
      '()))

;<Article>  ::= define word <Body> end .
(define (article stream error)
  (if (equal? (peek stream) 'define)
      (begin
        (next stream)
        (let ((w (next stream))
              (b (body stream error))
              (e (next stream)))
          (if (and (word? w) (equal? e 'end))
              (list w b)
              (error #f))))
      '()))

;<Body>  ::= if <Body> endif <Body> | integer <Body> | word <Body> | .
(define (body stream error)
  (cond
    ((equal? (peek stream) 'if)
     (let ((i (next stream))
           (b (body stream error))
           (e (next stream)))
       (if (equal? e 'endif)
           (cons (list i b) (body stream error))
           (error #f))))
    ((or (number? (peek stream)) (word? (peek stream)))
     (cons (next stream) (body stream error)))
    (else '())))
       

;; Тесты

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
   (test (check-frac "110/111") #t)
   (test (check-frac "-4/3") #t)
   (test (check-frac "+5/10") #t)
   (test (check-frac "5.0/10") #f)
   (test (check-frac "FF/10") #f)
   (test (check-frac "/") #f)
   (test (check-frac " /") #f)
   (test (check-frac "/ ") #f)
   (test (check-frac "5/") #f)
   (test (check-frac "/5") #f)
   (test (scan-frac "110/111") (/ 110 111))
   (test (scan-frac "-4/3") (/ -4 3))
   (test (scan-frac "+5/10") (/ 1 2))
   (test (scan-frac "5.0/10") #f)
   (test (scan-frac "FF/10") #f)
   (test (scan-many-fracs "\t1/2 1/3\n\n10/8") (list (/ 1 2)(/ 1 3)(/ 5 4)))
   (test (scan-many-fracs "\t1/2 1/3\n\n2/-5") #f)
   (test (scan-many-fracs "\t1/2 1/3\nFFF\n3/4") #f)
   (test (scan-many-fracs "\t1/2 1/3\n1/4FFF") #f)))

(define tests-2
  (list
   (test (parse #(1 2 +)) '(() (1 2 +)))
   (test (parse #(x dup 0 swap if drop -1 endif)) '(() (x dup 0 swap (if (drop -1)))))
   (test (parse #( define -- 1 - end
                    define =0? dup 0 = end
                    define =1? dup 1 = end
                    define factorial
                    =0? if drop 1 exit endif
                    =1? if drop 1 exit endif
                    dup --
                    factorial
                    *
                    end
                    0 factorial
                    1 factorial
                    2 factorial
                    3 factorial
                    4 factorial ))
         '(((-- (1 -))
            (=0? (dup 0 =))
            (=1? (dup 1 =))
            (factorial
             (=0? (if (drop 1 exit)) =1? (if (drop 1 exit)) dup -- factorial *)))
           (0 factorial 1 factorial 2 factorial 3 factorial 4 factorial)))
   (test (parse #(define word w1 w2 w3)) #f)
   (test (parse #(x dup 0 swap if drop -1 if drop -2 endif -3 endif)) '(() (x dup 0 swap (if (drop -1 (if (drop -2)) -3)))))
   (test (parse #(define define -- end 2 define)) #f)
   (test (parse #(define if ++ end 1 if drop 2 endif)) #f)
   (test (parse #(define endif * end 1 if drop 2 endif 3)) #f)
   (test (parse #(define end 0 end 1 if drop 2 endif 3)) #f)
   ))

(run-tests tests-1)
(run-tests tests-2)