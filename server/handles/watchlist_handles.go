package handles

import (
	"encoding/json"
	"fmt"
	"net/http"

	firestoreDB "github.com/ettoma/popcorn_v2/firestore_db"
)

func HandleGetUserWatchlist(w http.ResponseWriter, r *http.Request) {
	var watchlist *firestoreDB.Watchlist
	var user *firestoreDB.User

	r.Body = http.MaxBytesReader(w, r.Body, 1048576)

	err := json.NewDecoder(r.Body).Decode(&user)
	fmt.Println(user)

	if err != nil {
		fmt.Print(err)
	}

	watchlist, err = firestoreDB.GetDocuments(firestoreDB.ClientDB, user.Username)

	if err != nil {
		fmt.Println(err)
	}

	w.WriteHeader(http.StatusOK)
	w.Header().Add("Content-Type", "application/json")

	json.NewEncoder(w).Encode(watchlist)
}
