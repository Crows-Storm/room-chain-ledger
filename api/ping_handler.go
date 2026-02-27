//package api
//
//import (
//	"net/http"
//	"time"
//)
//
//type PingHandler struct {
//	BaseHandler
//	startTime time.Time
//}
//
//func NewPingHandler() *PingHandler {
//	return &PingHandler{
//		startTime: time.Now(),
//	}
//}
//
//func (h *PingHandler) GetPing(w http.ResponseWriter, r *http.Request) {
//	if r.Method != http.MethodGet {
//		h.Error(w, http.StatusMethodNotAllowed, "Method not allowed")
//		return
//	}
//
//	data := map[string]interface{}{
//		"status":    "UP",
//		"timestamp": time.Now().Unix(),
//		"uptime":    time.Since(h.startTime).String(),
//	}
//	h.Success(w, data)
//}
