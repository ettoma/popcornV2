package handles

import (
	"encoding/json"
	"net/http"

	authdb "github.com/ettoma/popcorn_v2/auth_db"
	firestoreDB "github.com/ettoma/popcorn_v2/firestore_db"
	"github.com/ettoma/popcorn_v2/utils"
)

func HandleAddUser(w http.ResponseWriter, r *http.Request) {
	var userToAdd *authdb.NewUser

	r.Body = http.MaxBytesReader(w, r.Body, 1048576)

	err := json.NewDecoder(r.Body).Decode(&userToAdd)

	if err != nil {
		utils.WriteResponse(w, "Request is malformed", false, http.StatusBadRequest)
	}

	err = authdb.AddUser(userToAdd.Email, userToAdd.Password, firestoreDB.AuthDB)

	if err != nil {
		utils.WriteResponse(w, err.Error(), false, http.StatusNotFound)
	}

	if err == nil {
		utils.WriteResponse(w, "User created", true, http.StatusCreated)
	}
}

func HandleLogIn(w http.ResponseWriter, r *http.Request) {
	var userToAdd *authdb.NewUser

	r.Body = http.MaxBytesReader(w, r.Body, 1048576)

	err := json.NewDecoder(r.Body).Decode(&userToAdd)

	if err != nil {
		utils.WriteResponse(w, "Request is malformed", false, http.StatusBadRequest)
	}

	err = authdb.LogIn(userToAdd.Email, userToAdd.Password, firestoreDB.AuthDB)

	if err != nil {
		utils.WriteResponse(w, err.Error(), false, http.StatusNotFound)
	}

	if err == nil {
		utils.WriteResponse(w, "User logged in", true, http.StatusAccepted)
	}
}