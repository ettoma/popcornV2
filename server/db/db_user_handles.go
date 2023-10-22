package db

import (
	"errors"
	"fmt"
	"time"

	"github.com/ettoma/popcorn_v2/utils"
)

func checkIfUserExists(uuid string) bool {
	r, err := DB.Exec(`SELECT * FROM users WHERE uid = $1`, uuid)

	if err != nil {
		utils.Logger.Println(err)
		return false
	}

	rowsAffected, _ := r.RowsAffected()

	if rowsAffected == 0 {
		fmt.Println("This is a new user")
		return false
	}
	if rowsAffected != 0 {
		return true
	}

	return false
}

func AddUserToDB(username string) error {

	isUserExist := checkIfUserExists(username)

	if isUserExist == true {
		return errors.New("User already exists")
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
