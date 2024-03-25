(define (read-words)
  (define (record word result)
    (cond
      ((eof-object? (peek-char)) (if (null? word)
                                     (reverse result)
                                     (reverse (cons word result))))
      ((char-whitespace? (peek-char)) (begin
                                        (read-char)
                                        (if (null? word)
                                          (record '() result)
                                          (record '() (cons (list->string (reverse word)) result)))))
      (else (record (cons (read-char) word) result))))
  (record '() '()))