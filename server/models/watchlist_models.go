package models

type Watchlist struct {
	ID        string `json:"id"`
	Watchlist string `json:"watchlist"`
}

type WatchlistItem struct {
	MovieID    int     `json:"movieID"`
	UserRating float32 `json:"userRating"`
	Watched    bool    `json:"watched"`
}

type MovieToAdd struct {
	Username string `json:"username"`
	MovieID  int    `json:"movieID"`
}

type MovieToRemove struct {
	Username string `json:"username"`
	MovieID  int    `json:"movieID"`
}

type MovieToRate struct {
	Username string  `json:"username"`
	MovieID  int     `json:"movieID"`
	Rating   float32 `json:"rating"`
}
