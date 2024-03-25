INIT MACRO STRNAME
	mov   ax,@data
    mov   ds,ax
    mov   es,ax
    mov   si,offset STRNAME ; в si имеем исходную строку
    mov   di,si				; в di имеем итоговую строку
    xor cx, cx 				; переменная, показывающая, можно ли скопировать пробел
    xor bx, bx 				; счётчик длины итоговой строки
ENDM

CHECKSYM MACRO SPACEJUMP, EXITJUMP
	cmp   al,'$'
    je    EXITJUMP
    cmp   al,' '
    je   SPACEJUMP
    inc bx			; если символ не пробел и не дошли до конца строки, увеличиваем счётчик и теперь можем скопировать один пробел в будущем
    mov cx, 1
ENDM

CHECKSPACE MACRO BACKJUMP
	cmp cx, 0
    je  BACKJUMP  ; излишние пробелы не копируем
    inc bx		  ; если не лишний, копируем и увеличиваем счётчик длины строки
    xor cx, cx
ENDM

GETRES_DISPLAY MACRO
    mov byte ptr [di], "$"   ; записываем "$" в конец получившейся строки
    sub di, bx 				 ; сдвигаем di на начало строки
	mov ah, 09h
	mov dx, di
	int 21h
	mov ax, 4C00h
	int 21h
ENDM