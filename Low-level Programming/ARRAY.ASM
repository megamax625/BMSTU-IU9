; 8. Каждому элементу массива, начиная со второго, присвоить значение максимального элемента из числа ему предшествующих и его самого.
MODEL SMALL
STACK 256

DATASEG
arr dw 9, 8, 10, 8, 12, 10, 15, 14, 20, 22, 10
len dw 11
count dw 11
buf db 6 dup('$')
crlf db 13,10,'$'

CODESEG
start:
mov  ax, @data
mov  ds, ax

mov si, offset arr
mov bx, arr
add si, 2
mov cx, 1
iter:
	cmp cx, len
	jge stop_iter

	mov ax, [si]
	cmp ax, bx
	jle upd_arr
upd_max:
	mov bx, ax
	jmp after_max
upd_arr:
	mov [si], bx
after_max:
	add si, 2
	inc cx
	jmp iter
stop_iter:

; вывод массива

  mov  di, offset arr
print_array:        
  call dollar
  mov  ax, [di]
  call number_to_string
                   
  mov  ah, 9
  mov  dx, offset buf
  int  21h

  mov  ah, 9
  mov  dx, offset crlf
  int  21h

  add  di, 2
  dec  count
  jnz  print_array

  mov ax, 4C00h
  int 21h

proc dollar             
  mov  si, offset buf
  mov  cx, 6
six_dollars:      
  mov  al, '$'
  mov  [si], al
  inc  si
  loop six_dollars
  ret
endp

proc number_to_string
  mov  bx, 10
  mov  cx, 0
cycle1:       
  mov  dx, 0
  div  bx
  push dx
  inc  cx
  cmp  ax, 0
  jne  cycle1
  mov  si, offset buf
cycle2:  
  pop  dx
  add  dl, 48
  mov  [si], dl
  inc  si
  loop cycle2
  ret
endp  

end start