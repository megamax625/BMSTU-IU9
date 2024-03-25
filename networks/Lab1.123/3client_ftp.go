package main

import (
	"bytes"
	"fmt"
	"github.com/jlaffaye/ftp"
	"github.com/skorobogatov/input"
	"io/ioutil"
	"log"
	"os"
	"time"
)

func main() {
	var command string

	c, err := ftp.Dial("127.0.0.1:3600", ftp.DialWithTimeout(5*time.Second))
	if err != nil {
		log.Fatal(err)
	}
	err = c.Login("Max", "123")
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Connected to server")
	path := "/"

	for command != "QUIT" {

		// Чтение команды из стандартного потока ввода
		fmt.Printf("command = ")
		command = input.Gets()

		switch (command) {
		case "ADD":
			fmt.Printf("text = ")
			text := input.Gets()
			data := bytes.NewBufferString(text)
			fmt.Printf("name = ")
			filename := input.Gets()
			err = c.Stor(path + filename, data)
			if err != nil {
				panic(err)
			}
		case "RETR":
			fmt.Printf("name = ")
			filename := input.Gets()
			r, err := c.Retr(path + filename)
			if err != nil {
				panic(err)
			}
			defer r.Close()
			// создаём файл
			f, err := os.Create(filename)
			if err != nil {
				log.Fatal(err)
			}
			// закрываем файл
			defer f.Close()
			buf, err := ioutil.ReadAll(r)
			f.WriteString(string(buf))
		case "MKDIR":
			fmt.Printf("name = ")
			dirname := input.Gets()
			err := c.MakeDir(path + dirname)
			if err != nil {
				log.Fatal(err)
			}
		case "DELF":
			fmt.Printf("name = ")
			filename := input.Gets()
			err := c.Delete(path + filename)
			if err != nil {
				log.Fatal(err)
			}
		case "DELDIR":
			fmt.Printf("name = ")
			dirname := input.Gets()
			err := c.RemoveDirRecur(path + dirname)
			if err != nil {
				log.Fatal(err)
			}
		case "SHOW":
			dirContents, err := c.List(path)
			if err != nil {
				log.Fatal(err)
			}
			fmt.Printf("Directory contents %s\n", path)
			for i := 0; i < len(dirContents); i++ {
				fmt.Println(dirContents[i].Name)
			}
		case "CD":
			fmt.Printf("path = ")
			path = input.Gets()
		case "QUIT":
			if err := c.Quit(); err != nil {
				log.Fatal(err)
			}
		default:
			fmt.Printf("Wrong command\nUse QUIT to close the connection\n")
		}
	}
	fmt.Println("Logged off server")
}