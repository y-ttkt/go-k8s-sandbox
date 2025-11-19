package main

import (
	"github.com/y-ttkt/go-k8s-sandbox/internal/server"
	"log"
)

func main() {
	srv := server.NewHttpServer(":8080")
	log.Fatal(srv.ListenAndServe())
}
