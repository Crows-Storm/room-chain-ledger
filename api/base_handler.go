package api

import (
	"encoding/json"
	"log"
	"net/http"
	"strings"
)

type BaseHandler struct{}

func (h *BaseHandler) JSON(w http.ResponseWriter, status int, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	err := json.NewEncoder(w).Encode(data)
	if err != nil {
		log.Fatalf("[Base Handler] ERROR: %v", err)
		return
	}
}

func (h *BaseHandler) Success(w http.ResponseWriter, data interface{}) {
	h.JSON(w, http.StatusOK, Result{
		Success: true,
		Data:    data,
	})
}

func (h *BaseHandler) Error(w http.ResponseWriter, status int, message string) {
	h.JSON(w, status, Result{
		Success: false,
		Error:   message,
	})
}

func (h *BaseHandler) GetPathSegments(r *http.Request) []string {
	return strings.Split(strings.Trim(r.URL.Path, "/"), "/")
}
