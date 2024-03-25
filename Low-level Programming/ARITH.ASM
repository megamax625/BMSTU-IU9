MODEL SMALL
STACK 256

DATASEG
a dw 14
b dw 30
d dw 5
c dw 23

CODESEG
start:
mov ax, @data
mov ds, ax

mov bx, a
shl bx, 1
shl bx, 1

mov dx, d
mov ax, b
mul dx
add ax, bx

mov bx, c
add ax, bx

mov bx, ax
mov ax, 4C00h
int 21h
end start
