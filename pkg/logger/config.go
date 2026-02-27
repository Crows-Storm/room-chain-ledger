package logger

type Config struct {
	Level string `json:"level"`
}

func (c *Config) SetLoggerDefaults() {
	if c.Level == "" {
		c.Level = "info"
	}
}
