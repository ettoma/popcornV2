package firestoreDB

import (
	"context"
	"fmt"

	"cloud.google.com/go/firestore"
	"github.com/ettoma/popcorn_v2/utils"
)

func AddMovieToWatchlist(client *firestore.Client, movieID int, user string) error {

	doc := client.Doc("users/" + user)

	var movieToAdd *WatchlistItem

	movieToAdd = &WatchlistItem{
		MovieID:    movieID,
		UserRating: 0.0,
		Watched:    false,
	}

	existingWatchlist, err := GetDocuments(client, user)

	if err != nil {
		fmt.Println(err)
	}

	for _, movie := range existingWatchlist.Watchlist {
		if movieToAdd.MovieID == movie.MovieID {
			fmt.Print("already exists")
			return err
		}
	}

	newWatchlist := append(existingWatchlist.Watchlist, *movieToAdd)

	_, err = doc.Update(context.Background(), []firestore.Update{
		{
			Path:  "watchlist",
			Value: newWatchlist,
		},
	})

	if err != nil {
		fmt.Print(err)
	}

	return nil
}

func RemoveMovieFromWatchlist(client *firestore.Client, movieID int, user string) error {

	doc := client.Doc("users/" + user)

	existingWatchlist, err := GetDocuments(client, user)

	utils.HandleError(err)

	var newWatchlist []WatchlistItem

	for _, movie := range existingWatchlist.Watchlist {
		if movieID != movie.MovieID {
			newWatchlist = append(newWatchlist, movie)
		}
	}

	_, err = doc.Update(context.Background(), []firestore.Update{
		{
			Path:  "watchlist",
			Value: newWatchlist,
		},
	})

	if err != nil {
		fmt.Print(err)
	}

	return nil
}

func RateMovieOnWatchlist(client *firestore.Client, movieID int, user string, rating float32) error {
	doc := client.Doc("users/" + user)

	existingWatchlist, err := GetDocuments(client, user)

	utils.HandleError(err)

	var newWatchlist []WatchlistItem

	for _, movie := range existingWatchlist.Watchlist {
		if movieID == movie.MovieID {
			newWatchlist = append(newWatchlist, WatchlistItem{
				MovieID:    movieID,
				UserRating: rating,
				Watched:    true,
			})
		} else {
			newWatchlist = append(newWatchlist, movie)
		}
	}

	_, err = doc.Update(context.Background(), []firestore.Update{
		{
			Path:  "watchlist",
			Value: newWatchlist,
		},
	})

	if err != nil {
		fmt.Print(err)
	}

	return nil
}
