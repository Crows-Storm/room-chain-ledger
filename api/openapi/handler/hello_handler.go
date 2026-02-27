package handler

import (
	"net/http"
	"room-chain-ledger/internal/common/service"
)

type HelloHandler struct {
	helloService service.HelloService
}

func NewHelloHandler(helloService *service.HelloService) *HelloHandler {
	return &HelloHandler{
		helloService: *helloService,
	}
}

func (h *HelloHandler) GetHello(w http.ResponseWriter, r *http.Request) {

}
