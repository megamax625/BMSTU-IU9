package main

import (
	"github.com/goftp/file-driver"
	"github.com/goftp/server"
)

func main(){
	factory := &filedriver.FileDriverFactory{
		RootPath: "/home/megamax625/Desktop/сети лабы/Lab1.123/fileDir",
		Perm: server.NewSimplePerm("root", "root"),
	}

	au := server.SimpleAuth{
		Name: 	  "Max",
		Password: "123",
	}

	opts := &server.ServerOpts{
		Factory: factory,
		Port: 3600,
		Hostname: "127.0.0.1",
		Auth: &au,
	}

	server := server.NewServer(opts)
	server.ListenAndServe()
}