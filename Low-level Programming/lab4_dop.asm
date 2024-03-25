; доп задание - лр4 для беззнаковых чисел
; по сути изменения нужно было внести только в функцию ввода чисел для того, чтобы отделить знак '-' от модульного представления числа,
; а также добавить ветвления в зависимости от того, какие из операндов отрицательные, в основной участок кода, запускающий процедуры.
; в зависимости от знаков операндов: + и + = обычное сложение и умножение, - и - = сложение модулей со знаком - и умножение со знаком +,
; + и - или - и + = вычитание и умножение со знаком -
MODEL SMALL
STACK 256

DATASEG
dummy db 0ah, '$'
overflow dw 0 ; перенос
negative dw 0 ; если получилось число меньше нуля
equal dw 0 ; если числа равны
neg1 dw 0; если первое число отрицательное
neg2 dw 0; если второе число отрицательное
symcheck1 dw 0 ; проверка, что введённые символы лежат в интервале между 0 и 9
symcheck2 dw 0 ; проверка, что введённые символы лежат в интервале между 0 и 9
s_error   db 'Error!',13,10,'$'
op1 db 30, 31 dup (?)
op2 db 30, 31 dup (?)
answer db 60 dup (32)
buf db 60 dup (32)


CODESEG
;ввод числа и преобразование ascii-кодов в цифровые значения
proc input
	xor bx, bx
    mov bp, sp
    mov dx, [bp+2]
    xor ax, ax
	mov ah, 0Ah
	int 21h
    mov di, [bp+2]
    add di, 2
handle:
    cmp byte ptr [di], 13
    je handle_exit
    cmp byte ptr [di], 45
    je handle_minus
    cmp byte ptr [di], 48
    jl wrongsym
    cmp byte ptr [di], 57
    jg wrongsym
    sub byte ptr [di], '0'
    cmp bx, 1
    jne handle_skip
    mov al, byte ptr [di]
    mov byte ptr [di-1], al
handle_skip:
    inc di
    jmp handle
handle_minus:
	sub byte ptr [di - 1], 1
	inc di
	mov bx, 1
	jmp handle
wrongsym:
	mov cx, 1
handle_exit:
    ret
endp input

; преобразование строки и вывод
proc print
    mov di, offset answer
    mov cx, 60
prep:
    mov al, byte ptr [di]
    cmp al, 32
    je nzero
    add al, '0'
    mov byte ptr [di], al
    jmp skip_prep
nzero:
    sub al, 19
    mov byte ptr [di], al
skip_prep:
    inc di
    loop prep

    mov byte ptr [di], "$"
    mov dx, offset answer
    mov ah, 09h
	int 21h
    call getans
	ret	
endp

; получаем ответ 
proc getans
    mov di, offset answer
    mov cx, 60
cycle1:
    mov byte ptr [di], 32
    inc di
    loop cycle1
    ret    
endp

; Сравниваем два аргумента
proc Compare
    mov di, offset op1
    mov si, offset op2
    xor dx, dx
    xor bx, bx
    mov dl, byte ptr [di + 1]
    mov bl, byte ptr [si + 1]
    cmp dx, bx 
    ja gre
    jl less
    add di, 2
    add si, 2

comp:
    mov bl, byte ptr [di]
    mov dl, byte ptr [si]
    cmp bl, 13
    je equality
    cmp bl, dl
    ja gre
    jl less
    inc di
    inc si
    jmp comp

equality: 
        mov ax, 1
        mov [equal], 1
        jmp compare_exit
gre:
        mov ax, 1
        jmp compare_exit
less:
        xor ax, ax
        mov [negative], 1
        jmp compare_exit    
compare_exit:
    ret
endp

; сложение
proc addition 
    mov bp, sp
    mov di, [bp + 2]
    mov si, [bp + 4]
    mov bx, offset answer

    add bx, 59
    xor dx, dx
    xor cx, cx
    mov dl, byte ptr [di + 1]
    mov cl, byte ptr [si + 1]

    inc di
    add di, dx
    inc si
    add si, cx
    mov [overflow], 0
    sub dx, cx
add1:
    xor ax, ax
    mov al, byte ptr [di]
    add al, byte ptr [si]
    add ax, [overflow]
    mov [overflow], 0
    cmp ax, 10
    jl cycle2
    mov [overflow], 1 
    push bx
    mov bl, 10
    div bl
    pop bx
    mov al, ah
    xor ah, ah
cycle2:
    mov byte ptr [bx], al
    dec di
    dec si
    dec bx
    loop add1
    
    mov cx, dx
    cmp cx, 0
    je skip_add
add2:
    xor ax, ax
    mov al, [di]
    add ax, [overflow]
    mov [overflow], 0
    cmp ax, 10
    jl cycle3
    mov [overflow], 1
    push bx
    mov bl, 10
    div bl
    pop bx
    mov al, ah
    xor ah, ah
cycle3:
    mov byte ptr [bx], al
    dec di
    dec bx
    loop add2

skip_add:    
    cmp [overflow], 1
jne add_exit
    mov byte ptr [bx], 1    
add_exit:
    ret    
endp

proc subtraction
    mov bp, sp
    mov di, [bp + 2]
    mov si, [bp + 4]
    mov bx, offset answer
    add bx, 59
    xor dx, dx
    xor cx, cx
    mov dl, byte ptr [di + 1]
    mov cl, byte ptr [si + 1]
    inc di
    add di, dx
    inc si
    add si, cx
    mov [overflow], 0
    sub dx, cx
    mov ax, [equal]
    cmp ax, 1
    jne sub1
    mov byte ptr [bx], 0
    ret
sub1:
    xor ax, ax
    mov al, byte ptr [di]
    sub ax, [overflow]
    mov [overflow], 0
    mov ah, byte ptr [si]
    cmp al, ah 
    jae sub_skip1
    mov [overflow], 1
    add al, 10
sub_skip1:
    sub al, ah
    mov byte ptr [bx], al
    dec di
    dec si
    dec bx
    loop sub1

    mov cx, dx
    cmp cx, 0
    je sub_skip3
sub2:
    xor ax, ax
    mov al, byte ptr [di]
    sub ax, [overflow]
    mov [overflow], 0
    cmp al, -1
    jne sub_skip2
    mov [overflow], 1
    add al, 10
sub_skip2:
    mov byte ptr [bx], al
    dec di
    dec bx
    loop sub2
sub_skip3:
    call rmzero   
    ret    
endp

; Убираем нули и добавляем символ - если надо
proc rmzero
  mov di, offset answer
s1:        
    mov al, byte ptr [di]
    cmp al, 32
    je s2
    cmp al, 0
    jne s3
    mov byte ptr [di], 32
s2:
    inc di
    jmp s1
s3:        
    xor ax, ax
    mov ax, [negative]
    cmp al, 0
    je s4
    dec di
    mov byte ptr [di], -3
s4:    
    ret
endp

; Умножение
proc multiplication 
    mov [overflow], 0
    mov bp, sp
    mov di, [bp + 2]   
    mov si, [bp + 4]
    mov bx, offset answer
    add bx, 59
    xor dx, dx
    xor cx, cx
    mov cl, byte ptr [di + 1]
    push cx
    mov dl, byte ptr [si + 1]
    inc di
    add di, cx
    push di
    inc si
    add si, dx
    dec cx
    cmp cx, 0
    je mult_skip1
mult1:
    xor ax, ax
    mov al, byte ptr [di]
    mul byte ptr [si]
    add ax, [overflow]
    mov [overflow], 0
    cmp ax, 10
    jl mult_skip2
    push bx
    mov bl, 10
    div bl
    xor bx, bx
    mov bl, al
    mov [overflow], bx
    pop bx
    mov al, ah
    xor ah, ah
mult_skip2:
    mov byte ptr [bx], al
    dec di
    dec bx
    loop mult1

mult_skip1:    
    xor ax, ax
    mov al, byte ptr [di]
    mul byte ptr [si]
    add ax, [overflow]
    mov [overflow], 0  
    cmp ax, 10
    jae mult_skip3
    mov byte ptr [bx], al
    jmp mult_skip4   
mult_skip3:
    push bx
    mov bl, 10
    div bl
    pop bx
    mov byte ptr [bx], ah
    dec bx
    mov byte ptr [bx], al 
mult_skip4:
    dec dx
    dec si
mult2:
    cmp dx, 0
    je mult_exit
    mov bx, offset buf
    add bx, 59
    push si
    mov si, offset op2
    xor cx, cx
    mov cl, byte ptr [si + 1]
    pop si
    sub cx, dx
makezeroes:
    mov byte ptr [bx], 0
    dec bx
    loop makezeroes

    pop di    
    pop cx
    push cx
    push di
    dec cx    
mult_subtr:
    xor ax, ax
    mov al, byte ptr [di]
    mul byte ptr [si]
    add ax, [overflow]
    mov [overflow], 0
    cmp ax, 10
    jl mult_skip5
    push bx
    mov bl, 10
    div bl
    xor bx, bx
    mov bl, al
    mov [overflow], bx
    pop bx
    mov al, ah
    xor ah, ah
mult_skip5:
    mov byte ptr [bx], al
    dec di
    dec bx
    loop mult_subtr

    xor ax, ax
    mov al, byte ptr [di]
    mul byte ptr [si]
    add ax, [overflow]
    mov [overflow], 0  
    cmp ax, 10
    jae mult_skip6
    mov byte ptr [bx], al
    jmp mult_skip7   
mult_skip6:
    push bx
    mov bl, 10
    div bl
    pop bx
    mov byte ptr [bx], ah
    dec bx
    mov byte ptr [bx], al
mult_skip7:
    call mulproc
    dec dx
    dec si    
    jmp mult2    
mult_exit:
    pop cx
    pop di
    ret
endp 

proc mulproc
    push di
    push si
    mov di, offset buf
    mov si, offset answer
    add di, 59
    add si, 59
    mov [overflow], 0
mult_add1:
    xor ax, ax
    mov al, byte ptr [si]
    cmp al, 32
je mult_add2
    add al, byte ptr [di]
    add ax, [overflow]
    mov [overflow], 0
    cmp ax, 10
    jl mulproc_skip1
    mov [overflow], 1 
    push bx
    mov bl, 10
    div bl
    pop bx
    mov al, ah
    xor ah, ah
mulproc_skip1:
    mov byte ptr [si], al
    dec di
    dec si
    jmp mult_add1
mult_add2:
    xor ax, ax
    mov al, byte ptr [di]
    cmp al, 32
    je mulproc_skip2
    add ax, [overflow]
    mov [overflow], 0
    cmp ax, 10
    jl mulproc_skip3
    mov [overflow], 1
    push bx
    mov bl, 10
    div bl
    pop bx
    mov al, ah
    xor ah, ah
mulproc_skip3:
    mov byte ptr [si], al
    dec di
    dec si
    jmp mult_add2
mulproc_skip2:    
    cmp [overflow], 1
    jne mulproc_skip4
    mov byte ptr [si], 1    
mulproc_skip4:
    pop si
    pop di
    ret  
endp

start:	
    mov ax, @data
    mov ds, ax

    mov ax, offset op1
    push ax
	call input
	mov [symcheck1], cx
	cmp symcheck1, 1
	je wrongsymbol
	mov [neg1], bx
    mov dx, offset dummy
    mov ah, 09h
    int 21h

    mov ax, offset op2
    push ax
	call input
	mov [symcheck2], cx
	cmp symcheck2, 1
	je wrongsymbol
	mov [neg2], bx
    mov dx, offset dummy
    mov ah, 09h
    int 21h

    call compare
    cmp ax, 1
    jne main_less
    push offset op2
    push offset op1
    jmp main_skip
main_less:	; т.к. поменяли порядок операндов, то обменяем и их значения минуса
    push offset op1
    push offset op2
    mov ax, [neg1]
    mov bx, [neg2]
    mov [neg1], bx
    mov [neg2], ax
    jmp main_skip

wrongsymbol:
	mov dx, offset s_error
	mov ah, 9
	int 21h
	jmp main_skip2
main_skip:

	mov ax, [neg1]
	mov bx, [neg2]
	cmp ax, bx
	jne branch2
branch1:
	mov dx, offset dummy
	mov ah, 09h
	int 21h
    call addition
    cmp [neg1], 1
    jne output
    mov [negative], 1
    call rmzero
    jmp output
branch2:
	mov [negative], 0
	cmp [neg1], 1
	jne branch2_skip
	mov [negative], 1
branch2_skip:
	call subtraction

output:
    call print
    mov dx, offset dummy
	mov ah, 09h
	int 21h
    
    call multiplication
    mov ax, [neg1]
    mov bx, [neg2]
    cmp ax, bx
    je same_sign
    mov [negative], 1
    call rmzero
same_sign:
    call print
    mov dx, offset dummy
	mov ah, 09h
	int 21h
	jmp main_skip2

main_skip2:
	mov ah, 4ch
	int 21h
end start