MACRO INIT STRNAME {
    mov ax, STRNAME
    mov si, ax              ; в fasm не работает offset
    mov di, si				; в di имеем итоговую строку
    xor cx, cx 				; переменная, показывающая, можно ли скопировать пробел
    xor bx, bx 				; счётчик длины итоговой строки
}

MACRO CHECKSYM SPACEJUMP, EXITJUMP {
	cmp   al,'$'
    je    EXITJUMP
    cmp   al,' '
    je   SPACEJUMP
    inc bx			; если символ не пробел и не дошли до конца строки, увеличиваем счётчик и теперь можем скопировать один пробел в будущем
    mov cx, 1
}

MACRO CHECKSPACE BACKJUMP {
	cmp cx, 0
    je  BACKJUMP  ; излишние пробелы не копируем
    inc bx		  ; если не лишний, копируем и увеличиваем счётчик длины строки
    xor cx, cx
}

MACRO GETRES_DISPLAY ACC {
    mov byte ptr di, "$"   ; записываем "$" в конец получившейся строки
    sub di, bx 			   ; сдвигаем di на начало строки
    add [ACC], bl          ; устанавливаем размер сообщения в файле
	mov ah, 09h
	mov dx, di
	int 21h
}
