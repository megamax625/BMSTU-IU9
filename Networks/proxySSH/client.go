package main

import (
	"bytes"
	"log"
	"net/http"
	"time"

	"github.com/gorilla/websocket"
	"golang.org/x/crypto/ssh"
)

const (
	// Time allowed to write a message to the peer.s
	writeWait = 10 * time.Second

	// Time allowed to read the next pong message from the peer.
	pongWait = 60 * time.Second

	// Send pings to peer with this period. Must be less than pongWait.
	pingPeriod = (pongWait * 9) / 10

	// Maximum message size allowed from peer.
	maxMessageSize = 512
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}

// Client is a middleman between the websocket connection and the hub.
type Client struct {
	// The websocket connection.
	conn *websocket.Conn

	// Buffered channel of outbound messages.
	send chan []byte
}

// readPump pumps messages from the websocket connection to the hub.
//
// The application runs readPump in a per-connection goroutine. The application
// ensures that there is at most one reader on a connection by executing all
// reads from this goroutine.
func (c *Client) readPump() {
	defer func() {
		c.conn.Close()
	}()
	c.conn.SetReadLimit(maxMessageSize)
	c.conn.SetReadDeadline(time.Now().Add(pongWait))
	c.conn.SetPongHandler(func(string) error { c.conn.SetReadDeadline(time.Now().Add(pongWait)); return nil })
	name := ""
	pass := ""
	host := "127.0.0.1"
	port := "2200"
	for iter := 1;;{
		_, message, err := c.conn.ReadMessage()
		if err != nil {
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				log.Printf("error: %v", err)
			}
			break
		}
		if iter == 1 {
			iter++
			name = string(message)
			continue
		}
		if iter == 2 {
			iter++
			pass = string(message)
		}
		config := &ssh.ClientConfig{
			User: name,
			Auth: []ssh.AuthMethod{
				ssh.Password(pass),
			},
			HostKeyCallback: ssh.InsecureIgnoreHostKey(),
		}
		sshClient, err := ssh.Dial("tcp", host+":"+port, config)
		if err != nil {
			iter = 1
			c.send <- []byte("failed_reg")
			log.Printf("Error: %v", err)
			continue
		}
		defer sshClient.Close()
		if iter == 3 {
			iter++
			sshClient.Close()
			continue
		}
		sess, err := sshClient.NewSession()
		if err != nil {
			log.Printf("Error: %v", err)
		}
		defer sess.Close()
		var b bytes.Buffer
		sess.Stdout = &b
		err = sess.Run(string(message))
		if err != nil {
			log.Printf("Error: %v", err)
		}
		if err != nil {
			log.Printf("Error: %v", err)
		}
		bs := b.Bytes()
		sshClient.Close()
		sess.Close()
		c.send <- bs
	}
}

// writePump pumps messages from the hub to the websocket connection.
//
// A goroutine running writePump is started for each connection. The
// application ensures that there is at most one writer to a connection by
// executing all writes from this goroutine.
func (c *Client) writePump() {
	ticker := time.NewTicker(pingPeriod)
	defer func() {
		ticker.Stop()
		c.conn.Close()
	}()
	for {
		select {
		case message, ok := <-c.send:
			c.conn.SetWriteDeadline(time.Now().Add(writeWait))
			if !ok {
				// The hub closed the channel.
				c.conn.WriteMessage(websocket.CloseMessage, []byte{})
				return
			}

			w, err := c.conn.NextWriter(websocket.TextMessage)
			if err != nil {
				return
			}
			w.Write(message)

			n := len(c.send)
			for i := 0; i < n; i++ {
				w.Write(<-c.send)
			}

			if err := w.Close(); err != nil {
				return
			}
		case <-ticker.C:
			c.conn.SetWriteDeadline(time.Now().Add(writeWait))
			if err := c.conn.WriteMessage(websocket.PingMessage, nil); err != nil {
				return
			}
		}
	}
}

// serveWs handles websocket requests from the peer.
func serveWs(w http.ResponseWriter, r *http.Request) {
	upgrader.CheckOrigin = func(r *http.Request) bool {
		return true
	}
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println(err)
		return
	}
	client := &Client{conn: conn, send: make(chan []byte, 256)}
	// Allow collection of memory referenced by the caller by doing all work in
	// new goroutines.
	go client.writePump()
	go client.readPump()
}

func main() {
	http.HandleFunc("/ws", func(w http.ResponseWriter, r *http.Request) {
		serveWs(w, r)
	})
	err := http.ListenAndServe("127.0.0.1:2201", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}