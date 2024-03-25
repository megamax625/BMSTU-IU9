package main

import (
	"errors"
	"fmt"
	"github.com/unknwon/com"
	"golang.org/x/crypto/ssh"
	"io/ioutil"
	"log"
	"net"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func main() {
	config := ssh.ServerConfig{
		PasswordCallback: func(conn ssh.ConnMetadata, password []byte) (*ssh.Permissions, error) {
			if conn.User() == "admin" {
				if string(password) == "12345" {
					return &ssh.Permissions{}, nil
				}
			}
			return nil, errors.New("")
		},
		MaxAuthTries: -1,
	}
	keyPath := "host.rsa"
	if !com.IsExist(keyPath) {
		err := os.MkdirAll(filepath.Dir(keyPath), os.ModePerm)
		if err != nil {
			return
		}
		_, stderr, err := com.ExecCmd("ssh-keygen", "-f", keyPath, "-t", "rsa", "-N", "")
		if err != nil {
			panic(fmt.Sprintf("Fail to generate private key: %v - %s", err, stderr))
		}
		fmt.Printf("New private key is generateed: %s\n", keyPath)
	}

	privateBytes, err := ioutil.ReadFile(keyPath)
	if err != nil {
		panic("Failed to load private key")
	}
	private, err := ssh.ParsePrivateKey(privateBytes)
	if err != nil {
		panic("Failed to parse private key")
	}
	config.AddHostKey(private)

	fmt.Println("Start listening")
	listener, err := net.Listen("tcp", "127.0.0.1:2200")
	if err != nil {
		log.Fatal(err)
	}
	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Print(err)
		}

		fmt.Printf("Handshaking for %s\n", conn.RemoteAddr())
		sConn, chans, _, err := ssh.NewServerConn(conn, &config)
		if err != nil {
			log.Print(err)
			continue
		}
		fmt.Printf("Connection from %s (%s)\n", sConn.RemoteAddr(), sConn.ClientVersion())
		handle(chans)
	}
}

func handle(chans <-chan ssh.NewChannel) {
	for newChan := range chans {
		if newChan.ChannelType() != "session" {
			err := newChan.Reject(ssh.UnknownChannelType, "unknown channel type")
			if err != nil {
				return
			}
			continue
		}
		channel, requests, err := newChan.Accept()
		if err != nil {
			log.Fatalf("Could not accept channel: %v", err)
		}
		execcode := false
		chRequests := make(chan *ssh.Request, 15)
		var c string
		for req := range requests {
			fmt.Println(req.Type)
			if req.Type == "exec" {
				execcode = true
				c = string(req.Payload)
			}
			chRequests <- req
			if req.Type == "shell" || req.Type == "exec" {
				break
			}
		}
		go func(in <-chan *ssh.Request) {
			for req := range in {
				err := req.Reply(req.Type == "shell" || req.Type == "exec", nil)
				if err != nil {
					return
				}
			}
		}(chRequests)

		if execcode {
			defer channel.Close()
			split := strings.Split(c, " ")
			fmt.Println(split)
			buf := make([]byte, 0)
			for _, s := range []byte(split[0]) {
				if !(s < 97 || s > 122) {
					buf = append(buf, byte(s))
				}
			}
			split[0] = string(buf)
			res, err := exec.Command(split[0], split[1:]...).Output()
			if err != nil {
				log.Print(err)
				channel.Write([]byte(err.Error() + "\n"))
			}
			if _, err := channel.Write(res) ; err != nil {
				return
			}
			if _, err := channel.SendRequest("exit-status", false, []byte{0, 0, 0, 0}); err != nil {
				return
			}
			if err := channel.Close(); err != nil {
				return
			}
		} else {
			a := make([]byte, 100)
			defer channel.Close()
			for {
				if _, err2 := channel.Write([]byte(">")); err2 != nil {
					return
				}
				if _, err2 := channel.Read(a); err2 != nil {
					return
				}
				cmd := string(a)
				i := strings.Index(cmd, "\n")
				cmd = cmd[:i]
				if cmd == "EXIT" {
					if err := channel.Close(); err != nil {
						return
					}
					break
				}
				split := strings.Split(cmd, " ")
				fmt.Println(split)
				res, err := exec.Command(split[0], split[1:]...).Output()
				if err != nil {
					log.Print(err)
					if _, err2 := channel.Write([]byte(err.Error() + "\n")); err2 != nil {
						return
					}
				}
				if _, err := channel.Write(res); err != nil {
					return
				}
				if _, err := channel.SendRequest("exit-status", false, []byte{0, 0, 0, 0}); err != nil {
					return
				}
			}
		}
	}
}