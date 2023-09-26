package handles

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/ettoma/popcorn_v2/db"
	firestoreDB "github.com/ettoma/popcorn_v2/firestore_db"
	"github.com/ettoma/popcorn_v2/models"
	"github.com/ettoma/popcorn_v2/utils"
)

func HandleGetUserWatchlist(w http.ResponseWriter, r *http.Request) {
	var watchlist models.Watchlist
	var user *firestoreDB.User

	r.Body = http.MaxBytesReader(w, r.Body, 1048576)

	err := json.NewDecoder(r.Body).Decode(&user)

	if err != nil {
		utils.WriteResponse(w, "Request is malformed", false, http.StatusBadRequest)
	}

	watchlist, err = db.GetWatchlistFromDB(user.Username)

	if err != nil {
		if err.Error() == "User watchlist didn't exist, created a new one" {
			utils.WriteResponse(
				w, err.Error(), true, http.StatusCreated)
			return

		} else if err.Error() == "Error creating or fetching user watchlist" {

			utils.WriteResponse(w, err.Error(), false, http.StatusNotFound)
			return
		}
	}

	watchlistByte, err := json.Marshal(watchlist)

	watchlistJson := fmt.Sprintf("%s", watchlistByte)

	if err == nil {
		utils.WriteResponse(w, watchlistJson, true, http.StatusOK)
	}

}

func HandleAddMovieToWatchlist(w http.ResponseWriter, r *http.Request) {
	var movieToAdd *models.MovieToAdd

	r.Body = http.MaxBytesReader(w, r.Body, 1048576)

	err := json.NewDecoder(r.Body).Decode(&movieToAdd)

	if err != nil {

		utils.WriteResponse(w, "Request is malformed", false, http.StatusBadRequest)
	}

	err = db.AddMovieToWatchlist(movieToAdd.Username, movieToAdd.MovieID)

	if err != nil {
		utils.Logger.Println("whops, error adding movie to watchlist")
		utils.WriteResponse(w, err.Error(), false, http.StatusConflict)
	}

	if err == nil {
		utils.WriteResponse(w, "Movie added", true, http.StatusCreated)
	}
}

func HandleRemoveMovieFromWatchlist(w http.ResponseWriter, r *http.Request) {
	var movieToRemove *models.MovieToRemove

	r.Body = http.MaxBytesReader(w, r.Body, 1048576)

	err := json.NewDecoder(r.Body).Decode(&movieToRemove)

	if err != nil {
		utils.WriteResponse(w, "Request is malformed", false, http.StatusBadRequest)
	}

	err = db.RemoveMovieFromWatchlist(movieToRemove.Username, movieToRemove.MovieID)

	if err != nil {

		utils.WriteResponse(w, err.Error(), false, http.StatusNotFound)
	}

	if err == nil {
		utils.WriteResponse(w, "Movie removed", true, http.StatusOK)
	}
}

func HandleRateMovieOnWatchlist(w http.ResponseWriter, r *http.Request) {
	var movieToRate *firestoreDB.MovieToRate

	r.Body = http.MaxBytesReader(w, r.Body, 1048576)

	err := json.NewDecoder(r.Body).Decode(&movieToRate)

	if err != nil {
		utils.WriteResponse(w, "Request is malformed", false, http.StatusBadRequest)
	}

	err = firestoreDB.RateMovieOnWatchlist(firestoreDB.ClientDB, movieToRate.MovieID, movieToRate.Username, movieToRate.Rating)

	if err != nil {
		utils.WriteResponse(w, "Watchlist not found", false, http.StatusNotFound)
	}

	if err == nil {
		utils.WriteResponse(w, "Movie rated", true, http.StatusOK)
	}
}
