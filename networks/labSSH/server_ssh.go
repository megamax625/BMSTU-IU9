package main

import (
	"fmt"
	"github.com/gliderlabs/ssh"
	"golang.org/x/term"
	"io/ioutil"
	"log"
	"os"
	"strings"
)

func main() {
	ssh.Handle(Handler)
	log.Println("starting ssh server on port 2200...")
	log.Fatal(ssh.ListenAndServe(":2200", nil))
}

func Handler(s ssh.Session) {
	term := term.NewTerminal(s, "> ")
	log.Println("user connected")
	fmt.Fprintf(term, "Hello!\n")
	for exitcode := false; exitcode != true; {
		line, err := term.ReadLine()
		log.Println(line)
		if err != nil {
			break
		}
		log.Println(line)
		inputs := strings.Fields(line)
		if len(inputs) > 1 {
			line = inputs[0]
			inputs = inputs[1:]
		} else {
			inputs = nil
		}
		switch line {
			case "SHOW":
				contents, _ := ioutil.ReadDir("./")
				for _, c := range contents {
					fmt.Fprintf(term, "%s\n", c.Name())
				}
			case "MKDIR":
				if len(inputs) != 1 {
					fmt.Fprintf(term, "Incorrect arguments\n")
					continue
				}
				err := os.Mkdir(inputs[0], os.ModePerm)
				if err != nil {
					fmt.Fprintf(term, "Failed to create a directory %s\n", inputs[0])
				} else {
					fmt.Fprintf(term, "Directory %s created\n", inputs[0])
				}
			case "DELDIR":
				if len(inputs) != 1 {
					fmt.Fprintf(term, "Incorrect arguments\n")
					continue
				}
				err := os.RemoveAll(inputs[0])
				if err != nil {
					fmt.Fprintf(term, "Failed to remove a directory %s\n", inputs[0])
				} else {
					fmt.Fprintf(term, "Directory %s removed\n", inputs[0])
				}
			case "EXIT":
				exitcode = true
				fmt.Printf("Closing terminal\n")
				break
			default:
				fmt.Fprintf(term, "Command is not supported\n")
			}
	}
	log.Println("terminal closed\n")
	os.Exit(0)
}