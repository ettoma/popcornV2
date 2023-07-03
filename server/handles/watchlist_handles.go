package handles

import (
	"fmt"
	"net/http"

	firestoreDB "github.com/ettoma/popcorn_v2/firestore_db"
)

func HandleGetUserWatchlist(w http.ResponseWriter, r *http.Request) {
	var watchlist *firestoreDB.Watchlist

	watchlist, err := firestoreDB.GetDocuments(client)

	if err != nil {
		fmt.Println(err)
	}

	fmt.Println(watchlist.Watchlist)
}
