package viper_conf

import "github.com/spf13/viper"

func NewViperConfig() error {
	viper.SetConfigName("global")
	viper.SetConfigType("yaml")
	viper.AddConfigPath("../common/viper_conf")
	viper.AutomaticEnv()
	return viper.ReadInConfig()
}
