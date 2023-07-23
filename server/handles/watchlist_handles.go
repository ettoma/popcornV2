package handles

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	firestoreDB "github.com/ettoma/popcorn_v2/firestore_db"
	"github.com/ettoma/popcorn_v2/utils"
)

func HandleGetUserWatchlist(w http.ResponseWriter, r *http.Request) {
	var watchlist *firestoreDB.Watchlist
	var user *firestoreDB.User

	r.Body = http.MaxBytesReader(w, r.Body, 1048576)

	err := json.NewDecoder(r.Body).Decode(&user)

	if err != nil {
		utils.WriteResponse(w, "Request is malformed", false, http.StatusBadRequest)
	}

	log.Println("checking watchlist for user: ", user.Username)
	watchlist, err = firestoreDB.GetDocuments(firestoreDB.ClientDB, user.Username)

	if err != nil {
		if err.Error() == "User watchlist is empty" {
			utils.WriteResponse(
				w, "User watchlist didn't exist, created a new one", true, http.StatusCreated)

		} else {

			utils.WriteResponse(w, "Error fetching watchlist", false, http.StatusNotFound)
		}
	}

	watchlistByte, err := json.Marshal(watchlist)

	watchlistJson := fmt.Sprintf("%s", watchlistByte)

	if err == nil {
		utils.WriteResponse(w, watchlistJson, true, http.StatusOK)
	}

}

func HandleAddMovieToWatchlist(w http.ResponseWriter, r *http.Request) {
	var movieToAdd *firestoreDB.MovieToAdd

	r.Body = http.MaxBytesReader(w, r.Body, 1048576)

	err := json.NewDecoder(r.Body).Decode(&movieToAdd)

	// log.Println("username: ", movieToAdd.Username)
	if err != nil {

		utils.WriteResponse(w, "Request is malformed", false, http.StatusBadRequest)
	}

	err = firestoreDB.AddMovieToWatchlist(firestoreDB.ClientDB, movieToAdd.MovieID, movieToAdd.Username)

	if err != nil {
		log.Println("whops")
		utils.WriteResponse(w, "Watchlist not found", false, http.StatusNotFound)
	}

	if err == nil {
		utils.WriteResponse(w, "Movie added", true, http.StatusCreated)
	}
}

func HandleRemoveMovieFromWatchlist(w http.ResponseWriter, r *http.Request) {
	var movieToRemove *firestoreDB.MovieToRemove

	r.Body = http.MaxBytesReader(w, r.Body, 1048576)

	err := json.NewDecoder(r.Body).Decode(&movieToRemove)

	fmt.Println("movie to remove: ", movieToRemove)

	if err != nil {
		utils.WriteResponse(w, "Request is malformed", false, http.StatusBadRequest)
	}

	err = firestoreDB.RemoveMovieFromWatchlist(firestoreDB.ClientDB, movieToRemove.MovieID, movieToRemove.Username)

	if err != nil {
		utils.WriteResponse(w, "Watchlist not found", false, http.StatusNotFound)
	}

	if err == nil {
		utils.WriteResponse(w, "Movie removed", true, http.StatusOK)
	}
}
