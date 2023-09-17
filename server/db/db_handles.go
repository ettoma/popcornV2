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
		log.Fatal("select: ", err)
	}

	//!! fix error when user signs up for the first time and watchlist doesn't exist
	// if !rows.Next() {

	// 	_, err := DB.Exec(`INSERT INTO watchlist (id, watchlist) VALUES ($1, $2)`, user, "[]")

	// 	if err != nil {
	// 		utils.Logger.Printf("Error adding user to watchlist: %v", err)
	// 	}
	// 	return models.Watchlist{}, errors.New("User watchlist is empty")
	// } else {
	for rows.Next() {

		if rows.Err() != nil {
			log.Fatal("select: ", rows.Err().Error())
			return models.Watchlist{}, rows.Err()
		}
		var w models.Watchlist

		err := rows.Scan(&w.ID, &w.Watchlist)

		if err != nil {
			log.Fatal(err)
		}
		return w, nil
	}
	// }

	return models.Watchlist{}, nil
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

	for _, movie := range watchlistJson {
		if movie.MovieID != movieID {
			watchlistJson = append(watchlistJson, movie)
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
