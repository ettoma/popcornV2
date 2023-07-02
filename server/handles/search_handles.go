package handles

import (
	"encoding/json"
	"net/http"

	moviesapi "github.com/ettoma/popcorn_v2/movies_api"
	"github.com/gorilla/mux"
)

func HandleGetMoviesFromKeyword(w http.ResponseWriter, r *http.Request) {

	query := mux.Vars(r)["keywords"]

	movie := moviesapi.GetMoviesFromKeyword(query)

	w.WriteHeader(http.StatusOK)
	w.Header().Add("Content-Type", "application/json")

	json.NewEncoder(w).Encode(movie)

}

func HandleGetMovieFromId(w http.ResponseWriter, r *http.Request) {

	query := mux.Vars(r)["id"]

	movie := moviesapi.GetMovieFromId(query)

	w.WriteHeader(http.StatusOK)
	w.Header().Add("Content-Type", "application/json")

	json.NewEncoder(w).Encode(movie)

}
