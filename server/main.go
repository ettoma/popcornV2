package main

import (
	"fmt"
	"log"
	"net/http"
	"time"

	firestoreDB "github.com/ettoma/popcorn_v2/firestore_db"
	"github.com/ettoma/popcorn_v2/handles"
	"github.com/ettoma/popcorn_v2/middlewares"
	"github.com/gorilla/mux"
	"github.com/joho/godotenv"
)

func main() {

	//* load the API key from env
	err := godotenv.Load()
	if err != nil {
		log.Fatalf("err loading: %v", err)
	}

	err = firestoreDB.Initialise()
	if err != nil {
		fmt.Println(err)
	}

	//* initialise server
	PORT := ":8080"

	r := mux.NewRouter().StrictSlash(false)

	r.Use(middlewares.LoggingMiddleware)
	r.Use(middlewares.Cors)

	srv := &http.Server{
		Addr:         PORT,
		Handler:      r,
		ReadTimeout:  time.Second * 15,
		WriteTimeout: time.Second * 15,
	}

	//* Search handles
	r.HandleFunc("/query={keywords}", handles.HandleGetMoviesFromKeyword).Methods("GET")
	r.HandleFunc("/id={id}", handles.HandleGetMovieFromId).Methods("GET")

	r.HandleFunc("/user/watchlist", handles.HandleGetUserWatchlist).Methods("POST")
	r.HandleFunc("/user/watchlist", handles.HandleAddMovieToWatchlist).Methods("PUT")
	r.HandleFunc("/user/watchlist", handles.HandleRemoveMovieFromWatchlist).Methods("DELETE")

	r.HandleFunc("/users/signup", handles.HandleAddUser).Methods("POST")
	r.HandleFunc("/users/login", handles.HandleLogIn).Methods("POST")

	log.Printf("Server started at: http://localhost%s", srv.Addr)
	log.Fatal(srv.ListenAndServe())
}
