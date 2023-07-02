package main

import (
	"log"
	"net/http"
	"time"

	"github.com/ettoma/popcorn_v2/firebase"
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

	//* initialise Firestore database
	isInitialised, client := firebase.InitialiseFirestore()

	if isInitialised {
		firebase.GetDocuments(client)
	}

	//* initialise server
	PORT := ":8080"

	r := mux.NewRouter().StrictSlash(false)

	r.Use(middlewares.LoggingMiddleware)

	srv := &http.Server{
		Addr:         PORT,
		Handler:      r,
		ReadTimeout:  time.Second * 15,
		WriteTimeout: time.Second * 15,
	}

	//* Search handles
	r.HandleFunc("/query={keywords}", handles.HandleGetMoviesFromKeyword).Methods("GET")
	r.HandleFunc("/id={id}", handles.HandleGetMovieFromId).Methods("GET")

	log.Fatal(srv.ListenAndServe())
}
