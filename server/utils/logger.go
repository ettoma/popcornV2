package utils

import (
	"log"
	"os"
)

var Logger = log.New(os.Stdout, "", log.Ltime|log.Lmicroseconds|log.Ldate|log.Lshortfile)
