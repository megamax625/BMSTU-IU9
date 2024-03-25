; char * strrchr( const char *string, int symbol);
; Функция ищет последнее вхождение символа symbol в строку string. Возвращает указатель на последнее вхождение символа в строке string. Завершающий нулевой символ считается частью строки. Таким образом, он также ; может быть найден для получения указателя на конец строки.

MODEL SMALL
STACK 256

DATASEG
dummy db 0Ah, '$'
string db 100, 99 dup ('$')
chr db '?'

CODESEG

proc strrchr
		push bp
		mov bp, sp
        mov bx, @data
        mov es, bx
        xor bx, bx
		mov bl, byte ptr [bp+4] ; символ
		mov di, [bp+6]			; строка

        xor ax, ax            ; al = 0
        mov al, '$'         ; al='$'
        mov cx, -1
repne   scasb                 ; доходим до 0 в конце строки	
		inc cx
        neg cx
        dec di				; указывает на 0 в конце строки
        mov al, bl
        std					; теперь di будет уменьшаться
repne   scasb                   ; находим нужный байт
        inc di
        cmp     byte ptr [di], al        ; проверяем на совпадение
        je      getans  ; если да, то присваиваем ответ
        mov     [bp+6], word ptr 0 
        jmp     skip
getans:
        mov ax, offset di
		mov [bp+6], ax
skip:
        cld
        pop bp
        ret 2
endp

; тестируем запуском процедуры с данными, введёнными с клавиатуры, сначала строка, потом символ
start:	mov ax, @data
		mov ds, ax
		mov dx, offset string
		mov ax, 0
		mov ah, 0Ah
		int 21h
		
		mov dx, offset dummy
		mov ah, 09h
		int 21h
		
		mov dx, offset string
		add dx, 2

		mov ah, 01h
		int 21h
		mov chr, al

		push offset dx
		push word ptr chr
		call strrchr

		pop dx
		mov ah, 09h
		int 21h	; выводится вся строка после последего вхождения исходного символа

		mov ah, 4ch
		int 21h
end start
