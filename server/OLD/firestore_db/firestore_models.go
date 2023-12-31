package firestoreDB

type Watchlist struct {
	Watchlist []WatchlistItem `json:"watchlist" firebase:"watchlist"`
}
type WatchlistItem struct {
	MovieID    int     `json:"movieID" firebase:"movieID"`
	UserRating float32 `json:"userRating" firebase:"userRating"`
	Watched    bool    `json:"watched" firebase:"watched"`
}

type User struct {
	Username string `json:"username"`
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
