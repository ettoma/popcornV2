package db

import (
	"errors"
	"fmt"
	"time"
)

func checkIfUserExists(uuid string) error {
	r, err := DB.Exec(`SELECT * FROM users WHERE uid = $1`, uuid)

	if err != nil {
		return err
	}

	rowsAffected, _ := r.RowsAffected()

	if rowsAffected == 0 {
		fmt.Println("This is a new user")
	}
	if rowsAffected != 0 {
		return errors.New("User already exists")
	}

	return nil
}

func AddUserToDB(username string) error {

	err := checkIfUserExists(username)

	if err != nil {
		return err
	}

	createdAt := time.Now().Unix()

	res, err := DB.Exec(`INSERT INTO users (uid, createdAt) VALUES ($1,$2)`, username, createdAt)

	if err != nil {
		return err
	}

	insertId, _ := res.LastInsertId()
	fmt.Println("Created user", insertId)
	return nil
}
