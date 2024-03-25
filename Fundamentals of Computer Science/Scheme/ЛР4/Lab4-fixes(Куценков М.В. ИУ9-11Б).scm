;; Задание 6 Б. Циклы for
(define-syntax for
  (syntax-rules (in as)
    ((_ x in xs . exprs) (for-each
                          (lambda (x) (begin . exprs)) xs))
    ((_ xs as x . exprs) (for-each
                          (lambda (x) (begin . exprs)) xs))))

;(for i in '(1 2 3)
;  (for j in '(4 5 6)
;    (display (list i j))
;    (newline)))
;(newline)
;(for '(1 2 3) as i
;  (for '(4 5 6) as j
;    (display (list i j))
;    (newline)))

;;Задание 2
(define (save-data data path)
  (define output (open-output-file path))
  (write data output)
  (close-output-port output))

(define (load-data path)
  (define input (open-input-file path))
  (read input))

(define (string-count path)
  (define input (open-input-file path))
  (define (count counter last-remaining-string)
    (let ((input-char (read-char input)))
      (if (eof-object? input-char)
          (begin
            (close-input-port input)
            (if (null? last-remaining-string)
                count
                (+ counter 1)))
          (if (equal? input-char #\newline)
              (if (null? last-remaining-string)
                  (count counter last-remaining-string)
                  (count (+ 1 counter) (cdr last-remaining-string)))
              (if (char-whitespace? input-char)
                  (count counter last-remaining-string)
                  (count counter '(1)))))))
    (count 0 '()))

; (save-data "This file has one string" "Text.txt") (load-data "Text.txt") (string-count "lab4-save_load_count_including-lists.scm")