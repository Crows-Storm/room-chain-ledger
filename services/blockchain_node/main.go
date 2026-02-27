package main

import (
	"fmt"

	"github.com/Crows-Storm/room-chain-ledger/pkg/crypto"
)

func main() {

	fmt.Println(crypto.Hello())

}

//const (
//	DEFAULT = "/"
//	PING    = "/ping"
//	CLOCK   = "/clock"
//)

//func init() {
//	if err := viper_conf.NewViperConfig(); err != nil {
//		log.Fatalf("[Room Block] Init: %v \n", err)
//	}
//}

//func main() {
//	log.Println("=== Room Block Service Starting ===")
//
//	mux := http.NewServeMux()
//	mux.HandleFunc(DEFAULT, func(w http.ResponseWriter, r *http.Request) {
//		_, _ = io.WriteString(w, "Hello World")
//	})
//
//	mux.HandleFunc(PING, func(w http.ResponseWriter, r *http.Request) {
//		_, _ = io.WriteString(w, "UP")
//	})
//	if err := http.ListenAndServe(":8081", mux); err != nil {
//		log.Fatal(err)
//	}
//	log.Println("=== Room Block Service Shutdown ===")
//}
