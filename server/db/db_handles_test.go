package db

import (
	"testing"

	"github.com/ettoma/popcorn_v2/models"
)

func TestAddMovieToWatchlist(t *testing.T) {

	testData := models.MovieToAdd{
		Username: "1234569",
		MovieID:  431234,
	}

	err := AddMovieToWatchlist(testData.Username, testData.MovieID)

	if err != nil {
		t.Error("test error: ", err)
	}

}
