package db

import (
	"encoding/json"
	"errors"
	"log"

	"github.com/ettoma/popcorn_v2/models"
	"github.com/ettoma/popcorn_v2/utils"
)

func GetWatchlistFromDB(user string) (models.Watchlist, error) {

	rows, err := DB.Query(`SELECT * FROM watchlist WHERE id = $1`, user)

	if err != nil {
		log.Fatal("select error: ", err)
	}

	defer rows.Close()

	if !rows.Next() {
		// No rows found, handle the case where the watchlist doesn't exist yet
		_, err := DB.Exec(`INSERT INTO watchlist (id, watchlist) VALUES ($1, $2)`, user, "[]")
		if err != nil {
			utils.Logger.Printf("Error creating user watchlist: %v", err)
			return models.Watchlist{}, errors.New("Error creating user watchlist")
		}
		return models.Watchlist{}, errors.New("User watchlist didn't exist, created a new one")
	}

	// Rows found, initialize a Watchlist struct and scan into it
	var watchlist models.Watchlist
	err = rows.Scan(&watchlist.ID, &watchlist.Watchlist)
	if err != nil {
		log.Fatal(err)
	}

	return watchlist, nil
}

func AddMovieToWatchlist(user string, movieID int) error {

	var watchlistJson []*models.WatchlistItem

	existingWatchlist, err := GetWatchlistFromDB(user)

	if err != nil {
		utils.Logger.Println("Error fetching watchlist")
		return err
	}

	if len(existingWatchlist.Watchlist) == 0 {
		watchlistJson = append(watchlistJson, &models.WatchlistItem{
			MovieID:    movieID,
			UserRating: 0,
			Watched:    false,
		})
	} else {
		err = json.Unmarshal([]byte(existingWatchlist.Watchlist), &watchlistJson)

		if err != nil {
			utils.Logger.Println("Error unmarshalling watchlist: ", err)
			return err
		}

		for _, movie := range watchlistJson {
			if movie.MovieID == movieID {
				return errors.New("Movie already exists on the watchlist for this user")
			}
		}

		watchlistJson = append(watchlistJson, &models.WatchlistItem{
			MovieID:    movieID,
			UserRating: 0,
			Watched:    false,
		})
	}

	watchlistDb, err := json.Marshal(watchlistJson)

	if err != nil {
		utils.Logger.Println("Error marshalling watchlist: ", err)
		return err
	}

	_, err = DB.Exec(`UPDATE watchlist SET watchlist = $1 WHERE id = $2`, watchlistDb, user)

	if err != nil {
		utils.Logger.Println("Error updating watchlist: ", err)
		return err
	}
	return nil

}

func RemoveMovieFromWatchlist(user string, movieID int) error {
	var watchlistJson []*models.WatchlistItem

	existingWatchlist, err := GetWatchlistFromDB(user)

	if err != nil {
		utils.Logger.Println("Error fetching watchlist")
		return err
	}

	err = json.Unmarshal([]byte(existingWatchlist.Watchlist), &watchlistJson)

	if err != nil {
		utils.Logger.Println("Error unmarshalling watchlist: ", err)
		return err
	}

	if len(watchlistJson) == 0 {
		utils.Logger.Printf("Tried to remove movie from empty watchlist.\nUser: %s\nMovie: %d", user, movieID)
		return errors.New("Watchlist is already empty")
	}

	if len(watchlistJson) == 1 && watchlistJson[0].MovieID == movieID {
		watchlistJson = []*models.WatchlistItem{}

	} else {

		for _, movie := range watchlistJson {

			if movie.MovieID != movieID {
				watchlistJson = append(watchlistJson, movie)
			}
		}
	}

	watchlistDb, err := json.Marshal(watchlistJson)

	if err != nil {
		utils.Logger.Println("Error marshalling watchlist: ", err)
		return err
	}

	_, err = DB.Exec(`UPDATE watchlist SET watchlist = $1 WHERE id = $2`, watchlistDb, user)

	if err != nil {
		utils.Logger.Println("Error updating watchlist: ", err)
		return err
	}

	return nil
}

func RateMovieOnWatchlist(user string, movieID int, rating float32) error {
	var watchlistJson []*models.WatchlistItem
	var updatedWatchlistJson []*models.WatchlistItem

	existingWatchlist, err := GetWatchlistFromDB(user)

	if err != nil {
		utils.Logger.Println("Error fetching watchlist")
		return err
	}

	err = json.Unmarshal([]byte(existingWatchlist.Watchlist), &watchlistJson)

	if err != nil {
		utils.Logger.Println("Error unmarshalling watchlist: ", err)
		return err
	}

	for _, movie := range watchlistJson {
		if movie.MovieID == movieID {
			movie.UserRating = rating
			movie.Watched = true
			updatedWatchlistJson = append(updatedWatchlistJson, movie)
		} else {
			updatedWatchlistJson = append(updatedWatchlistJson, movie)
		}
	}

	watchlistDb, err := json.Marshal(updatedWatchlistJson)

	if err != nil {
		utils.Logger.Println("Error marshalling watchlist: ", err)
		return err
	}

	_, err = DB.Exec(`UPDATE watchlist SET watchlist = $1 WHERE id = $2`, watchlistDb, user)

	if err != nil {
		utils.Logger.Println("Error updating watchlist: ", err)
		return err
	}
	return nil
}
