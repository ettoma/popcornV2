package main

import (
	"net/http"
	"time"

	"github.com/ettoma/popcorn_v2/db"
	"github.com/ettoma/popcorn_v2/handles"
	"github.com/ettoma/popcorn_v2/middlewares"
	"github.com/ettoma/popcorn_v2/utils"
	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
	"github.com/joho/godotenv"
)

func main() {

	//* load the API key from env
	err := godotenv.Load()
	if err != nil {
		utils.Logger.Fatalf("err loading environment variables: %v", err)
	}

	//* initialise db
	err = db.Init()

	if err != nil {
		utils.Logger.Fatalf("err loading database: %v", err)
	}

	//* initialise server
	PORT := ":11111"
	r := mux.NewRouter()

	r.Use(middlewares.LoggingMiddleware)

	srv := &http.Server{
		Addr: PORT,
		Handler: handlers.CORS(
			handlers.AllowedOrigins([]string{"*"}),
			handlers.AllowedMethods([]string{"GET", "POST", "PUT", "DELETE", "OPTIONS"}),
			handlers.AllowedHeaders([]string{"X-Requested-With", "Content-Type", "Authorization"}),
		)(r),
		ReadTimeout:  time.Second * 15,
		WriteTimeout: time.Second * 15,
	}

	r.HandleFunc("/", handles.HandleHome).Methods("GET")
	//* Search handles
	r.HandleFunc("/query={keywords}", handles.HandleGetMoviesFromKeyword).Methods("GET")
	r.HandleFunc("/id={id}", handles.HandleGetMovieFromId).Methods("GET")

	r.HandleFunc("/user/watchlist", handles.HandleGetUserWatchlist).Methods("POST")
	r.HandleFunc("/user/watchlist/add", handles.HandleAddMovieToWatchlist).Methods("PUT")
	r.HandleFunc("/user/watchlist", handles.HandleRemoveMovieFromWatchlist).Methods("DELETE")
	r.HandleFunc("/user/watchlist/rating", handles.HandleRateMovieOnWatchlist).Methods("POST")

	r.HandleFunc("/users/signup", handles.HandleAddUser).Methods("POST")
	r.HandleFunc("/users/login", handles.HandleLogIn).Methods("POST")

	utils.Logger.Printf("Server started at: http://localhost%s \n", PORT)

	utils.Logger.Fatal(srv.ListenAndServe())
}

// func main() {
// 	db.Init()
// }
