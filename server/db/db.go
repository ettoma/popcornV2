package db

import (
	"database/sql"
	"os"
	"time"

	"github.com/ettoma/popcorn_v2/utils"
	_ "github.com/lib/pq"
)

var DB *sql.DB

func heartbeat(DB *sql.DB) {

	ticker := time.NewTicker(1 * time.Minute)
	quit := make(chan struct{})
	go func() {
		for {
			select {
			case <-ticker.C:
				err := DB.Ping()
				if err != nil {
					utils.Logger.Printf("DB heartbeat error: %v\n", DB.Ping())
				} else {
					utils.Logger.Printf("DB heartbeat ok\nOpen connections: %d", DB.Stats().OpenConnections)
				}
			case <-quit:
				ticker.Stop()
				return
			}
		}
	}()

}

func Init() error {

	connStr := os.Getenv("DB_CONN_STRING")

	DB, _ = sql.Open(os.Getenv("DB_DRIVER"), connStr)

	if err := DB.Ping(); err != nil {
		return err
	}

	go heartbeat(DB)

	return nil

}
