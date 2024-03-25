package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"github.com/mgutz/logxi/v1"
	"net"
	"os"
	"strconv"
)

import "proto"

// Client - состояние клиента.
type Client struct {
	resp   map[int]proto.Response // Ответы на уже обработанные запросы
	arr    []int   	 	 // Текущий массив полученных от клиента чисел
	count  int           // Количество полученных от клиента чисел
}

// NewClient - конструктор клиента, принимает в качестве параметра
// объект UDP-соединения.
func NewClient() *Client {
	return &Client{
		resp: 	make(map[int]proto.Response),
		arr:    make([]int, 0, 100),
		count:  0,
	}
}

// serve - метод, в котором реализован цикл взаимодействия с клиентом.
// Подразумевается, что метод serve будет вызаваться в отдельной go-программе.
func serve(conn *net.UDPConn) {
	clientMap := make(map[string]*Client)
	buf := make([]byte, 100)
	for {
		if read, addr, err := conn.ReadFromUDP(buf); err != nil {
			log.Error("receiving message from client", "error", err)
		} else {
			addrStr := addr.String()
			_, mapfind := clientMap[addrStr]
			if !mapfind {
				log.Info("client is connected", "client", addrStr)
				clientMap[addrStr] = NewClient()
			}
			var req proto.Request
			if err := json.Unmarshal(buf[:read], &req); err != nil {
				log.Error("couldn't parse request", "request", buf[:read], "error", err)
				respond("failed", err, "-1", addr, conn)
			} else {
				id, _ := strconv.Atoi(req.Index)
				resp, mapfind2 := clientMap[addrStr].resp[id]
				if mapfind2 {
					log.Info("Sending the response again")
					respond(resp.Status, resp.Data, resp.Index, addr, conn)
				} else {
					handleRequest(&req, conn, clientMap, addr, addrStr, id)
				}
			}
		}
	}
}

// handleRequest - метод обработки запроса от клиента.
func handleRequest(req *proto.Request, conn *net.UDPConn, clientMap map[string]*Client, addr *net.UDPAddr,addrStr string, id int) bool {
	switch req.Command {
	case "quit":
		clientMap[addrStr].resp[id] = proto.Response{"ok", nil, req.Index}
		if respond("ok", nil, req.Index, addr, conn) {
			log.Info("client is off", "client", addrStr)
		}
	case "add":
		var x string
		errorMsg := ""
		if req.Data == nil {
			errorMsg = "data field is absent"
		} else {
			if err := json.Unmarshal(*req.Data, &x); err != nil {
				errorMsg = "malformed data field"
			} else {
				num, _ := strconv.Atoi(x)
				log.Info("performing addition", "value", x)
				clientMap[addrStr].arr = append(clientMap[addrStr].arr, num)
				clientMap[addrStr].count++
			}
		}
		if errorMsg == "" {
			var rawData json.RawMessage
			rawData, _ = json.Marshal(x)
			clientMap[addrStr].resp[id] = proto.Response{"add", &rawData, req.Index}
			if respond("add", x, req.Index, addr, conn) {
				log.Info("successful interaction with client", "added number:", clientMap[addrStr].count, "client", addrStr)
			}
		} else {
			log.Error("addition failed", "with reason", errorMsg)
			respond("failed", errorMsg, req.Index, addr, conn)
		}
	case "remove":
		errorMsg := ""
		if req.Data == nil {
			errorMsg = "data field is absent"
		} else {
			var i string
			if err := json.Unmarshal(*req.Data, &i); err != nil {
				errorMsg = "malformed data field"
			} else {
				index, _ := strconv.Atoi(i)
				index--
				if (index < 1) || (index > clientMap[addrStr].count) {
					errorMsg = "incorrect index"
				} else {
					log.Info("performing removal", "index", strconv.Itoa(index+1))
					clientMap[addrStr].arr = append((clientMap[addrStr].arr)[:index], (clientMap[addrStr].arr)[index+1:]...)
					clientMap[addrStr].count--
				}
			}
		}
		if errorMsg == "" {
			respond("ok", nil, req.Index, addr, conn)
		} else {
			log.Error("removal failed", "reason", errorMsg)
			respond("failed", errorMsg, req.Index, addr, conn)
		}
	case "sum":
		if clientMap[addrStr].count == 0 {
			log.Error("calculation failed", "reason:", "nothing to sum")
			respond("failed", "nothing to sum", req.Index, addr, conn)
		} else {
			errorMsg := ""
			if req.Data == nil {
				errorMsg = "data field is absent"
			} else {
				var strs [2]string
				if err := json.Unmarshal(*req.Data, &strs); err != nil {
					errorMsg = "malformed data field"
				} else {
					var edges [2]int
					if len(strs) < 2 {
						strs[1] = strs[0]
					}
					edges[0], _ = strconv.Atoi(strs[0])
					edges[1], _ = strconv.Atoi(strs[1])
					if edges[0] < 1 || edges[0] > edges[1] || edges[1] > clientMap[addrStr].count+1 {
						errorMsg = "wrong indexes"
					} else {
						log.Info("performing summation", "indexes", strs[0] + " to " + strs[1])
						summator := (clientMap[addrStr].arr)[edges[0]-1 : edges[1]]
						var currentSum int
						for _, num := range summator {
							currentSum += num
						}
						respond("sum", strconv.Itoa(currentSum), req.Index, addr, conn)
					}
				}
			}
			if !(errorMsg == "") {
				log.Error("addition failed", "reason", errorMsg)
				respond("failed", errorMsg, req.Index, addr, conn)
			}
		}
	default:
		log.Error("addition failed", "unknown command")
		respond("failed", "unknown command", req.Index, addr, conn)
	}
	return false
}

// respond - вспомогательный метод для передачи ответа с указанным статусом и данными
func respond(status string, data interface{}, Index string, addr *net.UDPAddr, conn *net.UDPConn) bool {
	var rawData json.RawMessage
	rawData, _ = json.Marshal(data)
	rawResp, _ := json.Marshal(&proto.Response{status, &rawData, Index})
	if _, err := conn.WriteToUDP(rawResp, addr); err != nil {
		log.Error("sending response to client", "error", err)
		return false
	}
	return true
}

func main() {
	var (
		serverAddrStr string
		helpFlag      bool
	)
	flag.StringVar(&serverAddrStr, "addr", "127.0.0.1:6000", "set server IP address and port")
	flag.BoolVar(&helpFlag, "help", false, "print options list")

	if flag.Parse(); helpFlag {
		fmt.Fprint(os.Stderr, "server [options]\n\nAvailable options:\n")
		flag.PrintDefaults()
	} else if serverAddr, err := net.ResolveUDPAddr("udp", serverAddrStr); err != nil {
		log.Error("resolving server address", "error", err)
	} else if conn, err := net.ListenUDP("udp", serverAddr); err != nil {
		log.Error("creating listening connection", "error", err)
	} else {
		log.Info("server listens incoming messages from clients")
		serve(conn)
	}
}