;;Задание 2
(define (save-data data path)
  (define output (open-output-file path))
  (define (record data)
    (if (null? data)
        (close-output-port output)
        (begin
          (display (car data) output)
          (record (cdr data)))))
  (record (string->list data)))

(define (load-data path)
  (define input (open-input-file path))
  (define (record data)
    (if (eof-object? (peek-char input))
        (begin
          (close-input-port input)
          (reverse data))
        (record (cons (read-char input) data))))
  (record '()))

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

;(save-data "THIS
;
;FILE
;HAS
;FIVE
;STRINGS" "Text.txt") (load-data "Text.txt") (string-count "Text.txt")