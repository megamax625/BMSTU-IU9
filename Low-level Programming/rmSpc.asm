; Задана строка слов. Слово–последовательность знаков без пробелов. Оставить между всеми словами по одному пробелу, удалив лишние.
include mymtasm.inc
MODEL SMALL
STACK 256
DATASEG
string db "So     this  is   a         test string  231#@(%(!@  end!$"
CODESEG
start:
    INIT string

looper:
    lodsb           ; al <= ds:si
    CHECKSYM spaceJump, exit ; проверяет, закончилась ли строка или встречен ли пробел увеличивает счётчик длины строки, если нет
    stosb           ; копируем символ, если не пробел и не конец строки
    jmp   looper

spaceJump:
	CHECKSPACE looper
    stosb           ; es:di <= al
    jmp   looper

exit:
	GETRES_DISPLAY ; преобразование и вывод результата
end start
