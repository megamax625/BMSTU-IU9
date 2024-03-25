# Лабораторная работа №1 по курсу "Конструирование компиляторов" 
# Раскрутка самоприменимого компилятора
**Выполнил студент группы ИУ9-61Б Куценков М.В.**
Цель работы - ознакомление с раскруткой самоприменимых компиляторов на примере моедльного компилятора.
Был выполнен вариант работы №19: для компилятора **P5** сделать идентификаторы и ключевые слова чувствительны к регистру.
## Ход выполнения работы
Язык Pascal не является чувствительным к регистру.
Поэтому в компиляторе **P5** для операций, работающих со строками, такими, как сравнение строки с зарезервированным словом или сравнения двух строк, используется функция перевода **lcases()**, переводящая строку в нижний регистр с помощью вызова функции **lcase()**, получающей нижний регистр символа, для каждого символа строки. Для реализации изменения логики работы компилятора в теле функции lcase() был закомментирован условный оператор, осуществляющий логику работы функции, и вследствие этого функция стала просто возвращать полученный в качестве аргумента символ.
### Результат использования diff pcom.pas pcom2.pas
```
814c814
<     if (c >= 'A') and (c<= 'Z') then c := chr(ord(c)-ord('A')+ord('a'));
---
>     {if (c >= 'A') and (c<= 'Z') then c := chr(ord(c)-ord('A')+ord('a')); - "выключили" функцию перевода в нижний регистр}

```
Далее были созданы тестовые программы hello.pas и hello2.pas, демонстрирующие чувствительность регистров для ключевых слов и идентификаторов соответственно.
### Исходный код hello.pas
```
program hello(output);

BeGiN
   writeln('Hello, world')
EnD.
```
### Результат вызова ./pint < hello.pas после компиляции pcom2.pas
```
$./pint < hello.pas
P5 Pascal interpreter vs. 1.0

Assembling/loading program
Running program

P5 Pascal compiler vs. 1.0


     1       40 program hello(output); 
     2       40  
     3       40 BeGiN 
     3   ****       ^18
     4       40    writeln('Hello, world') 
     5       40 EnD. 
   *** eof encountered

     6   ****  ,17,6,13,6,21

Errors in program: 6

Error numbers in listing:
-------------------------
  6  Illegal symbol
 13  'end' expected
 17  'begin' expected
 18  Error in declaration part
 21  '*' expected


program complete

```
### Исходный код hello2.pas
```
program hello(output);
var value1, VaLuE1 : integer;
begin
   value1 := 1;
   VaLuE1 := 2;
   writeln(value1, VaLuE1);
end.
```
### Результат вызова ./pint < hello2.pas после компиляции pcom2.pas
```
$./pint < hello2.pas
P5 Pascal interpreter vs. 1.0

Assembling/loading program
Running program

P5 Pascal compiler vs. 1.0


     1       40 program hello(output); 
     2       40 var value1, VaLuE1 : integer; 
     3       48 begin 
     4        3    value1 := 1; 
     5        7    VaLuE1 := 2; 
     6        9    writeln(value1, VaLuE1); 
     7       19 end. 

Errors in program: 0

program complete

```
### Компиляция pcom2.pas
При попытке компиляции pcom2.pas с помощью полученного в результате компиляции pcom2.pas псевдокода будут получены ошибки, так как исходный код pcom2.pas содержит несколько переменных, записанных в отличающемся от их определения регистре.
```
$./pcom < pcom2.pas
P5 Pascal compiler vs. 1.0


     1       40 (*$c+,t-,d-,l-

Errors in program: 0
$mv prr prd
$./pint <pcom2.pas
P5 Pascal interpreter vs. 1.0

Assembling/loading program
Running program

P5 Pascal compiler vs. 1.0


     1       40 (*$c+,t-,d-,l-
  1381   ****                                                ^104
  1484   ****                                                   ^104

Errors in program: 2

Error numbers in listing:
-------------------------
104  Identifier not declared


program complete
```
### Внесение изменений в pcom2.pas
Был создан файл pcom3.pas, исправляющий указанные недочёты.
```
$diff pcom2.pas pcom3.pas
1381c1381
<                 begin k := k+1; if k <= DIGMAX then digit[k] := ch;
---
>                 begin k := k+1; if k <= digmax then digit[k] := ch; {был необъявленный идентификатор DIGMAX (объявлен digmax)}
1484c1484
<          else if ch = '.' then begin sy := LbRaCk; nextch end
---
>          else if ch = '.' then begin sy := lbrack; nextch end {был необъявленный идентификатор lbRaCk (объявлен lbrack)}

```
### Завершение шага раскрутки путём компиляции pcom3.pas с помощью полученного в результате компиляции pcom2.pas псевдокода
```
./pint < pcom3.pas
P5 Pascal interpreter vs. 1.0

Assembling/loading program
Running program

P5 Pascal compiler vs. 1.0


     1       40 (*$c+,t-,d-,l-
 
Errors in program: 0

program complete

```
