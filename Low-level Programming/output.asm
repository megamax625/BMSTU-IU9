org 100h                    ;Программа начинается с адреса 100h
    jmp start               ;Перепрыгнуть данные
;-------------------------------------------------------------------------------
; Данные
file_name db 'hello.txt',0
buffer    db 'samplefile',13,10,'Hello!'
size      db 19
s_error   db 'Error!',13,10,'$'
s_pak     db 'Press any key...$'
handle    rw 1              ;Дескриптор файла
;-------------------------------------------------------------------------------
; Код
start:
    mov ah,3Ch              ;Функция DOS 3Ch (создание файла)
    mov dx,file_name        ;Имя файла
    xor cx,cx               ;Нет атрибутов - обычный файл
    int 21h                 ;Обращение к функции DOS
    jnc @F                  ;Если нет ошибки, то продолжаем
    call error_msg          ;Иначе вывод сообщения об ошибке
    jmp exit                ;Выход из программы
@@: mov [handle],ax         ;Сохранение дескриптора файла
 
    mov bx,ax               ;Дескриптор файла
    mov ah,40h              ;Функция DOS 40h (запись в файл)
    mov dx,buffer           ;Адрес буфера с данными
    movzx cx,[size]         ;Размер данных
    int 21h                 ;Обращение к функции DOS
    jnc close_file          ;Если нет ошибки, то закрыть файл
    call error_msg          ;Вывод сообщения об ошибке
 
close_file:
    mov ah,3Eh              ;Функция DOS 3Eh (закрытие файла)
    mov bx,[handle]         ;Дескриптор
    int 21h                 ;Обращение к функции DOS
    jnc exit                ;Если нет ошибки, то выход из программы
    call error_msg          ;Вывод сообщения об ошибке
 
exit:
    mov ah,9
    mov dx,s_pak
    int 21h                 ;Вывод строки 'Press any key...'
    mov ah,8                ;\
    int 21h                 ;/ Ввод символа без эха
    mov ax,4C00h            ;\
    int 21h                 ;/ Завершение программы
 
;-------------------------------------------------------------------------------
; Процедура вывода сообщения об ошибке
error_msg:
    mov ah,9
    mov dx,s_error
    int 21h                 ;Вывод сообщения об ошибке
    ret