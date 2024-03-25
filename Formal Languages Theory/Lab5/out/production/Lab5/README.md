Грамматика для описания модели БД:
[DB] -> [Tables] <br>
[Tables] -> [Table] | [Table][TableDelimeter][Tables] <br>
[Table] -> [Name][LeftParenthesis][TableContents][RightParenthesis] <br>
[TableContents] -> [ID][Attributes][Connections] <br>
[ID] -> [IDDenomination][LeftParenthesis][Attributes][RightParenthesis] <br>
[Attributes] -> [Attribute] | [Attribute][AttributeDelimeter][Attributes] <br>
[Attribute] -> [Name][AttributeTypeDelimeter][AttributeType] <br>
[Connections] -> [Connection] | [Connection][ConnectionDelimeter][Connections] <br>
[Connection] -> [ConnectionDenomination][Name][ConnectionType] <br>
[ConnectionType] -> [0.1Denomination] | [0.NDenomination] | [1.1Denomination] | [1.NDenomination] <br>
[LeftParenthesis] -> '{' <br>
[RightParenthesis] -> '}' <br>
[IDDenomination] -> 'ID' <br>
[AttributeDelimeter] -> ',' <br>
[ConnectionDelimeter] -> ',' <br>
[Name] -> [A-Za-z][NameRight] <br>
[NameRight] -> [A-Za-z][NameRight] | [Empty] <br>
[AttributeType] -> 'int' | 'float' | 'money' | 'datetime' | 'char' | 'string' <br>
[Empty] = '' <br>
ПАРАМЕТРИЗУЕТСЯ: <br>
[TableDelimeter] DEFAULT ',' <br>
[AttributeTypeDelimeter] DEFAULT ',' <br>
[ConnectionDenomination] DEFAULT 'CONNECTION' <br>
[0.1Denomination] DEFAULT '0.1' <br>
[0.NDenomination] DEFAULT '0.N' <br>
[1.1Denomination] DEFAULT '1.1' <br>
[1.NDenomination] DEFAULT '1.N' <br>

Запуск программы: <br>
**java Main.java path** либо  **java Main.java path/testname.txt path/syntaxname.txt**  <br>
где **path** - путь к папке, в которой лежат файлы **test.txt** и **syntax.txt** (**syntax.txt** может быть пустым или не существовать),
**testname.txt** и **syntaxname.txt** - имена файлов, в которых находится описание модели и пользовательского синтаксиса соответственно <br>