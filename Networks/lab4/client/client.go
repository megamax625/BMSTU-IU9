package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"github.com/mgutz/logxi/v1"
	"github.com/skorobogatov/input"
	"net"
	"os"
	"strconv"
	"time"
)

import "proto"

func interact(conn *net.UDPConn) {
	defer conn.Close()
	var i uint
	i = 0
	for {
		i++
		fmt.Printf("command = ")
		command := input.Gets()
		switch command {
		case "add":
			fmt.Printf("value = ")
			num := input.Gets()
			handleReq(conn, "add", &num, i)
		case "sum":
			fmt.Printf("first = ")
			first := input.Gets()
			fmt.Printf("second = ")
			second := input.Gets()
			edges := []string{first, second}
			handleReq(conn, "sum", &edges, i)
		case "remove":
			fmt.Printf("index = ")
			index := input.Gets()
			handleReq(conn, "remove", &index, i)
		case "quit":
			handleReq(conn, "quit", nil, i)
			return
		default:
			log.Error("unknown command")
			continue
		}
	}
}

// handleReq - функция, содержащая цикл взаимодействия с сервером.
func handleReq(conn *net.UDPConn, command string, data interface{}, id uint)  {
	var rawData json.RawMessage
	rawData, _ = json.Marshal(data)
	Index := strconv.Itoa(int(id))
	rawReq, _ := json.Marshal(&proto.Request{command, &rawData, Index})
	buf := make([]byte, 2000)
	for {
		deadline:=time.Now().Add(3*time.Second)
		conn.SetDeadline(deadline)
		if _, err := conn.Write(rawReq); err != nil {
			log.Error("sending request to server", "error", err)
			log.Info("sending the request again")
			continue
		}
		deadline=time.Now().Add(3*time.Second)
		conn.SetDeadline(deadline)
		if bytesRead, err := conn.Read(buf); err != nil {
			log.Error("receiving answer from server", "error", "timeout")
			continue
		} else {
			deadline=deadline.Add(3*time.Second)
			conn.SetDeadline(deadline)
			var resp proto.Response
			if err := json.Unmarshal(buf[:bytesRead], &resp); err != nil {
				log.Error("couldn't parse answer", "answer", buf, "error", err)
			} else {
				switch resp.Status {
				case "ok":
					if resp.Index == Index {
						log.Info("client conn is off")
						return
					}
				case "add":
					var msg string
					if err := json.Unmarshal(*resp.Data, &msg); err != nil {
						log.Error("couldn't parse answer", "answer", resp.Data, "error", err)
					} else {
						if resp.Index == Index {
							log.Info("successful interaction with server", "added:", msg)
							return
						}
					}
				case "failed":
					var reason string
					if err := json.Unmarshal(*resp.Data, &reason); err != nil {
						log.Error("couldn't parse answer", "answer", resp.Data, "error", err)
					} else {
						if resp.Index == Index {
							log.Error("failed", "reason:", reason)
							return
						}
					}
				case "sum":
					var sum string
					if err := json.Unmarshal(*resp.Data, &sum); err != nil {
						log.Error("couldn't parse answer", "answer", resp.Data, "error", err)
					} else {
						if resp.Index == Index {
							log.Info("successful interaction with server", "sum:", sum)
							fmt.Printf("result: " + sum + "\n")
							return
						}
					}
				default:
					log.Error("server reports unknown status %q\n", resp.Status)
				}
			}
		}
	}
}

func main() {
	var (
		serverAddrStr string
		helpFlag      bool
	)
	flag.StringVar(&serverAddrStr, "server", "127.0.0.1:6000", "set server IP address and port")
	flag.BoolVar(&helpFlag, "help", false, "print options list")

	if flag.Parse(); helpFlag {
		fmt.Fprint(os.Stderr, "client [options]\n\nAvailable options:\n")
		flag.PrintDefaults()
	} else if serverAddr, err := net.ResolveUDPAddr("udp", serverAddrStr); err != nil {
		log.Error("resolving server address", "error", err)
	} else if conn, err := net.DialUDP("udp", nil, serverAddr); err != nil {
		log.Error("creating connection to server", "error", err)
	} else {
		interact(conn)
	}
}