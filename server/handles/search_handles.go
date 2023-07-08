package handles

import (
	"net/http"

	moviesapi "github.com/ettoma/popcorn_v2/movies_api"
	"github.com/ettoma/popcorn_v2/utils"
	"github.com/gorilla/mux"
)

func HandleGetMoviesFromKeyword(w http.ResponseWriter, r *http.Request) {

	query := mux.Vars(r)["keywords"]

	movie := moviesapi.GetMoviesFromKeyword(query)

	utils.WriteResponse(w, movie, true, http.StatusOK)

}

func HandleGetMovieFromId(w http.ResponseWriter, r *http.Request) {

	query := mux.Vars(r)["id"]

	movie := moviesapi.GetMovieFromId(query)

	utils.WriteResponse(w, movie, true, http.StatusOK)

}
