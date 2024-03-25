## Лабораторная работа №5
Вариант 1.
## Грамматика для описания модели БД:
```
[DB] -> [Tables]
[Tables] -> [Table] | [Table][TableDelimeter][Tables]
[Table] -> [Name][LeftParenthesis][TableContents][RightParenthesis]
[TableContents] -> [ID][Attributes][Connections]
[ID] -> [IDDenomination][LeftParenthesis][Attributes][RightParenthesis]
[Attributes] -> [Attribute] | [Attribute][AttributeDelimeter][Attributes]
[Attribute] -> [Name][AttributeTypeDelimeter][AttributeType]
[Connections] -> [Connection] | [Connection][ConnectionDelimeter][Connections]
[Connection] -> [ConnectionDenomination][Name][ConnectionType]
[ConnectionType] -> [0.1Denomination] | [0.NDenomination] | [1.1Denomination] | [1.NDenomination]
[LeftParenthesis] -> '{'
[RightParenthesis] -> '}'
[IDDenomination] -> 'ID'
[AttributeDelimeter] -> ','
[ConnectionDelimeter] -> ','
[Name] -> [A-Za-z][NameRight]
[NameRight] -> [A-Za-z][NameRight] | [Empty]
[AttributeType] -> 'int' | 'float' | 'money' | 'datetime' | 'char' | 'string'
[Empty] = ''

ПАРАМЕТРИЗУЮТСЯ:
[TableDelimeter] DEFAULT ','
[AttributeTypeDelimeter] DEFAULT ':'
[ConnectionDenomination] DEFAULT 'CONNECTION'
[0.1Denomination] DEFAULT '0.1'
[0.NDenomination] DEFAULT '0.N'
[1.1Denomination] DEFAULT '1.1'
[1.NDenomination] DEFAULT '1.N'
```

## Компиляция программы:
Внутри директории src ```javac Main.java``` <br>
## Запуск программы:
```java Main.java path``` либо  ```java Main.java path/testname.txt path/syntaxname.txt```  <br>
где **path** - путь к папке, в которой лежат файлы **test.txt** и **syntax.txt** (**syntax.txt** может быть пустым или не существовать),
**testname.txt** и **syntaxname.txt** - имена файлов, в которых находится описание модели и пользовательского синтаксиса соответственно. <br>

## Пользовательсктй синтаксис:
- ```TableDelimeter``` - разделитель между таблицами
- ```AttributeTypeDelimeter``` - разделитель между именем атрибута и его типом
- ```ConnectionDenomination``` - ключевое слово для обозначения связи между таблицами
- ```0.1Denomination``` - обозначение кардинальности 0.1
- ```0.NDenomination``` - обозначение кардинальности 0.N
- ```1.1Denomination``` - обозначение кардинальности 1.1
- ```1.NDenomination``` - обозначение кардинальности 1.N <br>

Значения по умолчанию:
- ```TableDelimeter``` = ,
- ```AttributeTypeDelimeter``` = :
- ```ConnectionDenomination``` = CONNECTION
- ```0.1Denomination``` = 0.1
- ```0.NDenomination``` = 0.N
- ```1.1Denomination``` = 1.1
- ```1.NDenomination``` = 1.N <br>

Строки в файле ```syntax.txt``` разделяются знаком ```~```. Парметры задаются строками вида ```параметр = значение ~```. Нельзя использовать строковые значения с знаками ```=``` и ```~```. <br>

## Вывод программы
После запуска программы создается папка ```output```, в которой создаются файлы ```er_diagram.pdf``` и ```relational_diagram.pdf```, в которых сгенерированы диаграммы "сущность-связь" и реляционные диаграммы соответственно. <br>

## Необходимые установки
- [eralchemy](https://pypi.org/project/ERAlchemy/) : через ```pip install eralchemy```. Для отрисовки диаграмм;
- pygraphviz : через ```pip install pygraphviz```. Без него не устанавливался eralchemy.
- libgraphviz-dev : через ```sudo apt-get install libgraphviz-dev```. Без него не устанвливался pygraphviz.