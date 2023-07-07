package firestoreDB

import (
	"context"
	"fmt"

	"cloud.google.com/go/firestore"
)

func AddMovieToWatchlist(client *firestore.Client, movieID int, user string) error {

	doc := client.Doc("users/" + user)

	var movieToAdd *WatchlistItem

	movieToAdd = &WatchlistItem{
		MovieID:    movieID,
		UserRating: 0.0,
		Watched:    false,
	}

	fmt.Println(movieToAdd)

	existingWatchlist, err := GetDocuments(client, user)

	fmt.Println("existing watchlist: ", existingWatchlist)

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

	fmt.Println("new watchlist: ", newWatchlist)

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
