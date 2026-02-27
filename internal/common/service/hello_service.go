package service

import "fmt"

type HelloService struct{}

func NewHelloService() *HelloService {
	return &HelloService{}
}

func (s *HelloService) GetHelloMessage() string {
	return "Hello World"
}

func (s *HelloService) GetHelloMessageWithName(name string) string {
	if name == "" {
		name = "World"
	}
	return fmt.Sprintf("Hello %s", name)
}
