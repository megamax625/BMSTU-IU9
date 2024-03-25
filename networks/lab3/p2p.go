package main

import (
	"encoding/json"
	"fmt"
	"github.com/mgutz/logxi/v1"
	"github.com/skorobogatov/input"
	"net"
	"strconv"
	"strings"
	"time"
)

var gcommunism = 0
var gfeudalism = 0
var gcapitalism = 0
var gtime = time.Now()
var currentVote = 0
var encoders []*json.Encoder
var conns []*net.TCPConn
var thisAddr string
var connectedAddrs []string

// Vote - сообщение о голосовании
type Vote struct {
	// "-1" - нужно вычесть голос (при переголосовании), "0" - счёт не поменяется, "+1" - счёт увеличится
	commie  string
	feudal  string
	capital string
}

// Results - тип, в котором хранятся результаты голосования
type Results struct {
	//  количество голосов за каждый из вариантов
	commie  int
	feudal  int
	capital int
	// время обновления результатов
	timeMark time.Time
}

// Request -- сообщение для пира
type Request struct {
	// В поле Command лежит тип команды - "SHOW" или "VOTE" или "RES"
	Command string `json:"command"`
	// Адрес возврата для создания новых подключений
	BackAddr string `json:"backAddr"`
	// В поле Data лежит строка или объект Vote или Results
	Data *json.RawMessage `json:"data"`
}

// Peer - соединение с другим пиром
type Peer struct {
	logger log.Logger    // Объект для печати логов
	conn   *net.TCPConn  // Объект TCP-соединения
	enc    *json.Encoder // Объект для кодирования и отправки сообщений
	dec    *json.Decoder // Объект для декодирования сообщений
	res    Results       // Результаты голосования
}

// NewPeer - конструктор объекта пира
func NewPeer(conn *net.TCPConn) *Peer {
	return &Peer{
		logger: log.New(fmt.Sprintf("peer %s", conn.RemoteAddr().String())),
		conn:   conn,
		enc:    json.NewEncoder(conn),
		dec:    json.NewDecoder(conn),
		res:    Results{0, 0, 0, time.Now()},
	}
}

// send_request - функция для передачи запросов пирам
func send_request(encoder *json.Encoder, command string, backAddr string, data interface{}) {
	var raw json.RawMessage
	raw, _ = json.Marshal(data)
	encoder.Encode(&Request{command, backAddr, &raw})
}

// interact - функция, отвечающая за взаимодействие с пользователем
func interact() {
	for _, conn := range conns {
		defer conn.Close()
		encoder := json.NewEncoder(conn)
		encoders = append(encoders, encoder)
	}
	for {
		// Чтение команды из стандартного потока ввода
		var command string
		fmt.Printf("Command = ")
		command = input.Gets()
		switch command {
		case "VOTE":
			fmt.Printf("Чтобы проголосовать, введите цифру\n1 - за коммунизм\n2 - за феодализм\n3 - за капитализм\n")
			voteStr := input.Gets()
			if vote, err := strconv.Atoi(voteStr); err != nil {
				fmt.Println("Wrong input")
			} else {
				if (vote > 0) && (vote < 4) {
					if vote != currentVote {
						voteMsg := Vote{"0", "0", "0"}
						log.Info("Processing vote", strconv.Itoa(vote), "\n")
						switch vote {
						case 1:
							voteMsg.commie = "+1"
							gcommunism++
						case 2:
							voteMsg.feudal = "+1"
							gfeudalism++
						case 3:
							voteMsg.capital = "+1"
							gcapitalism++
						}
						switch currentVote {
						case 1:
							voteMsg.commie = "-1"
							gcommunism--
						case 2:
							voteMsg.feudal = "-1"
							gfeudalism--
						case 3:
							voteMsg.capital = "-1"
							gcapitalism--
						default:
						}
						currentVote = vote
						for _, encoder := range encoders {
							fmt.Println("Sending vote:", voteMsg)
							voteMsgStr := ""
							if voteMsg.commie == "+1" {
								voteMsgStr += "+ "
							} else if voteMsg.commie == "-1" {
								voteMsgStr += "- "
							} else {
								voteMsgStr += "0 "
							}
							if voteMsg.feudal == "+1" {
								voteMsgStr += "+ "
							} else if voteMsg.feudal == "-1" {
								voteMsgStr += "- "
							} else {
								voteMsgStr += "0 "
							}
							if voteMsg.capital == "+1" {
								voteMsgStr += "+"
							} else if voteMsg.capital == "-1" {
								voteMsgStr += "-"
							} else {
								voteMsgStr += "0"
							}
							send_request(encoder, "VOTE", thisAddr, voteMsgStr)
						}
					}
				} else {
					fmt.Printf("error: wrong vote\n")
				}
			}
		case "SHOW":
			for _, encoder := range encoders {
				send_request(encoder, "SHOW", thisAddr, "")
			}
			time.Sleep(10 * time.Millisecond)
			refrStr := strconv.Itoa(gcommunism) + " " + strconv.Itoa(gfeudalism) + " " + strconv.Itoa(gcapitalism) + " " + gtime.String()
			for _, encoder := range encoders {
				send_request(encoder, "REFRESH", thisAddr, refrStr)
			}
			fmt.Print("RESULTS:\nкоммунимзм:", gcommunism, "\nфеодализм:", gfeudalism, "\nкапитализм:", gcapitalism, "\n")
		default:
			fmt.Printf("error: unknown command\n")
		}
	}
}

// serve - метод, в котором реализовано взаимодействие с пиром
func (peer *Peer) serve() {
	defer peer.conn.Close()
	for {
		var req Request
		if err := peer.dec.Decode(&req); err != nil {
			peer.logger.Error("cannot decode message", "reason", err)
			break
		} else {
			peer.logger.Info("received message")
			peer.handleRequest(&req)
		}
	}
}

// handleRequest - метод обработки запроса от пира
func (peer *Peer) handleRequest(req *Request) {
	errorMsg := ""
	if req.Data == nil {
		errorMsg = "data field is absent"
	} else {
		var cmd string
		cmd = req.Command
		peer.logger.Info("Received a string command:", cmd, "\n")
		if cmd == "VOTE" {
			addrDup := false
			backAddr := req.BackAddr
			for _, addr := range connectedAddrs {
				if addr == backAddr {
					addrDup = true
					break
				}
			}
			if addrDup == false {
				if addr, err := net.ResolveTCPAddr("tcp", backAddr); err != nil {
					log.Error("address resolution failed", "address", backAddr)
				} else {
					log.Info("resolved TCP address", "address", addr.String())
					if conn, err := net.DialTCP("tcp", nil, addr); err == nil {
						encoder := json.NewEncoder(conn)
						encoders = append(encoders, encoder)
						conns = append(conns, conn)
						connectedAddrs = append(connectedAddrs, backAddr)
					}
				}
			}
			var voteMsg string
			voter := new(Vote)
			if err := json.Unmarshal(*req.Data, &voteMsg); err != nil {
				errorMsg = "malformed data type"
			} else {
				voteMsgSplit := strings.Split(voteMsg, " ")
				voter.commie = voteMsgSplit[0]
				voter.feudal = voteMsgSplit[1]
				voter.capital = voteMsgSplit[2]
				peer.logger.Info("Counting votes\n")
				if voter.commie == "+" {
					peer.res.commie++
					gcommunism++
				} else if voter.commie == "-" {
					peer.res.commie--
					gcommunism--
				}
				if voter.feudal == "+" {
					peer.res.feudal++
					gfeudalism++
				} else if voter.feudal == "-" {
					peer.res.feudal--
					gfeudalism--
				}
				if voter.capital == "+" {
					peer.res.capital++
					gcapitalism++
				} else if voter.capital == "-" {
					peer.res.capital--
					gcapitalism--
				}
				peer.res.timeMark = time.Now()
				gtime = peer.res.timeMark
				peer.logger.Info("Votes counted:" + voter.commie + voter.feudal + voter.capital + "\n" +
					"Current votes:" + strconv.Itoa(gcommunism) + strconv.Itoa(gfeudalism) + strconv.Itoa(gcapitalism) + "\n")
			}
		} else if cmd == "RES" {
			var resStr string
			var results Results
			if err := json.Unmarshal(*req.Data, &resStr); err != nil {
				errorMsg = "malformed data type"
			} else {
				resStrSplit := strings.Split(resStr, " ")
				results.commie, _ = strconv.Atoi(resStrSplit[0])
				results.feudal, _ = strconv.Atoi(resStrSplit[1])
				results.capital, _ = strconv.Atoi(resStrSplit[2])
				results.timeMark, _ = time.Parse("20060101", resStrSplit[3])
				if peer.res.timeMark.Before(results.timeMark) {
					peer.res = results
					peer.logger.Info("Vote results received\n")
				}
			}
		} else if cmd == "REFRESH" {
			peer.logger.Info("Got refresh request from a peer\n")
			var resStr string
			var results Results
			if err := json.Unmarshal(*req.Data, &resStr); err != nil {
				errorMsg = "malformed data type"
			} else {
				resStrSplit := strings.Split(resStr, " ")
				results.commie, _ = strconv.Atoi(resStrSplit[0])
				results.feudal, _ = strconv.Atoi(resStrSplit[1])
				results.capital, _ = strconv.Atoi(resStrSplit[2])
				results.timeMark, _ = time.Parse("20060101", resStrSplit[3])
				if peer.res.timeMark.Before(results.timeMark) {
					peer.res = results
					peer.logger.Info("Vote results received\n")
				}
			}
		} else if cmd == "SHOW" {
			peer.logger.Info("Sending results to a peer\n")
			backAddr := req.BackAddr
			addrDup := false
			for _, addr := range connectedAddrs {
				if addr == backAddr {
					addrDup = true
					break
				}
			}
			if addrDup == false {
				if addr, err := net.ResolveTCPAddr("tcp", backAddr); err != nil {
					log.Error("address resolution failed", "address", backAddr)
				} else {
					log.Info("resolved TCP address", "address", addr.String())
					if conn, err := net.DialTCP("tcp", nil, addr); err == nil {
						encoder := json.NewEncoder(conn)
						encoders = append(encoders, encoder)
						conns = append(conns, conn)
						connectedAddrs = append(connectedAddrs, backAddr)

						resStr := strconv.Itoa(peer.res.commie) + " " + strconv.Itoa(peer.res.feudal) + " " +
							strconv.Itoa(peer.res.capital) + " " + peer.res.timeMark.String()
						send_request(encoder, "RES", backAddr, resStr)
						peer.logger.Info("Results sent\n")
					}
				}
			}
		}
	}
	if errorMsg == "" {
		peer.logger.Info("information from peer handled")
	} else {
		peer.logger.Error("information handling failed", "reason", errorMsg)
	}
}
func listen(addrStr string) {
	var listener *net.TCPListener
	defer listener.Close()
	// Разбор адреса
	if addr, err := net.ResolveTCPAddr("tcp", addrStr); err != nil {
		log.Error("address resolution failed", "address", addrStr)
	} else {
		log.Info("resolved TCP address", "address", addr.String())
		// Cлушаем на заданном адресе
		if listener, err = net.ListenTCP("tcp", addr); err != nil {
			log.Error("listening failed", "reason", err)
		} else {
			// Приём входящих соединений
			for {
				if conn, err := listener.AcceptTCP(); err != nil {
					log.Error("cannot accept connection", "reason", err)
				} else {
					log.Info("accepted connection", "address", conn.RemoteAddr().String())
					// Запуск go-программы для обслуживания клиентов.
					go NewPeer(conn).serve()
				}
			}
		}
	}
}
func main() {
	var pAddr [10]string
	pAddr[0] = "127.0.0.1:8000"
	pAddr[1] = "127.0.0.1:8001"
	pAddr[2] = "127.0.0.1:8002"
	pAddr[3] = "127.0.0.1:8003"
	pAddr[4] = "127.0.0.1:8004"
	pAddr[5] = "127.0.0.1:8005"
	pAddr[6] = "127.0.0.1:8006"
	pAddr[7] = "127.0.0.1:8007"
	pAddr[8] = "127.0.0.1:8008"
	pAddr[9] = "127.0.0.1:8009"
	var addrEnd string
	fmt.Println("Выберите цифру, на которую будет оканчиваться номер порта (от 0 до 9): ")
	_, err := fmt.Scan(&addrEnd)
	if err != nil {
		return
	}
	addrNum, err := strconv.Atoi(addrEnd)
	thisAddr = pAddr[addrNum]
	go listen(thisAddr)
	// Установка соединения с пирами
	for i := 0; i < 10; i++ {
		if i == addrNum {
			continue
		}
		connAddr := "127.0.0.1:800" + strconv.Itoa(i)
		if addr, err := net.ResolveTCPAddr("tcp", connAddr); err != nil {
			fmt.Printf("error: %v\n", err)
		} else if conn, err := net.DialTCP("tcp", nil, addr); err == nil {
			conns = append(conns, conn)
			connectedAddrs = append(connectedAddrs, connAddr)
		}
	}
	interact()
}
