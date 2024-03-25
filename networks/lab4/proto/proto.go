package proto

import "encoding/json"

// Request -- запрос клиента к серверу.
type Request struct {
	// Поле Command может принимать 4 значения:
	// * "quit" - прощание с сервером (после этого сервер рвёт соединение);
	// * "add" - передача нового целого числа на сервер;
	// * "remove" - удаление целого числа на сервере;
	// * "sum" - просьба посчитать сумму чисел на отрезке.
	Command string `json:"command"`

	// Если Command == "add", в поле Data должно лежать число,
	// Если Command == "remove", в поле Data должно лежать натуральное число - индекс,
	// Если Command == "sum", в поле Data должны лежать два индекса - конца отрезка,
	// В противном случае, поле Data пустое.
	Data *json.RawMessage `json:"data"`

	// Индекс запроса, целое число
	Index string `json:"ident"`
}

// Response -- ответ сервера клиенту.
type Response struct {
	// Поле Status может принимать три значения:
	// * "ok" - успешное выполнение команд "quit", "add", "remove";
	// * "failed" - в процессе выполнения команды произошла ошибка;
	// * "result" - сумма чисел на отрезке вычислена.
	Status string `json:"status"`

	// Если Status == "failed", то в поле Data находится сообщение об ошибке.
	// Если Status == "result", в поле Data должно лежать целое число
	// В противном случае, поле Data пустое.
	Data *json.RawMessage `json:"data"`

	// Индекс запроса
	Index string `json:"ident"`
}
