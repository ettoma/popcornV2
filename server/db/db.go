package db

import (
	"database/sql"
	"os"

	_ "github.com/lib/pq"
)

var DB *sql.DB

func Init() error {

	connStr := os.Getenv("DB_CONN_STRING")

	DB, _ = sql.Open("postgres", connStr)

	if err := DB.Ping(); err != nil {
		return err
	}

	return nil

}
