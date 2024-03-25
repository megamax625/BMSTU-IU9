MODEL SMALL
STACK 256

DATASEG
a db 10
b db 4
d db 5
c db 20
res db 0
res10 db "000000$"
res16 db "00000h$"

CODESEG
start:
mov ax, @data
mov ds, ax

; вычисляем выражение вида 4 * a + b * d + c
mov bl, a
shl bl, 1
shl bl, 1

mov dl, d
mov al, b
mul dl
add al, bl

mov bl, c
add al, bl
mov res, al

; заполняем десятичную и шестнадцатеричную строки
mov bl, 10
mov si, 4

fill_10: 
    div bl
    add ah, 48
    mov res10[si], ah
    xor ah, ah
    dec si
    cmp al, 0
    jg fill_10

    mov si, 5
    mov res10[si], 10
    xor ax, ax
    mov al, res

mov bl, 10h
mov si, 4

fill_16:
    div bl
    cmp ah, 10
    jl app_num
    jge app_let
app_num:
    add ah, 48
    jmp cont
app_let:
    add ah, 55
    jmp cont
cont:
    mov res16[si], ah
    xor ah, ah
    dec si
    cmp al, 0
    jg fill_16

    mov si, 5
    mov res16[si], 10

; удаляем ведущие нули и выводим десятичную строку
mov si, offset res10
del_zero10:
	mov bl, byte ptr [si]
    cmp bl, "0"
    jne print_10
    inc si
    jmp del_zero10
print_10:
	mov ah, 09h
	mov dx, si
	int 21h

; удаляем ведущие нули и выводим шестнадцатеричную строку
mov si, offset res16
del_zero16:
	mov bl, byte ptr [si]
    cmp bl, "0"
    jne print_16
    inc si
    jmp del_zero16
print_16:
	mov ah, 09h
	mov dx, si
	int 21h

mov ax, 4C00h
int 21h
end start
