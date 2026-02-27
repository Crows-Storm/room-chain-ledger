package main

import (
	"log"

	"github.com/Crows-Storm/room-chain-ledger/tree/main/internal/common/viper_conf"
	"github.com/spf13/viper"
)

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

func init() {
	if err := viper_conf.NewViperConfig(); err != nil {
		log.Fatalf("[Room Block] Init: %v \n", err)
	}
}

func main() {
	log.Printf("[Room Block] Init %v \n", viper.Get("blockchain"))
}
