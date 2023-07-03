package firestoreDB

type Watchlist struct {
	Watchlist []WatchlistItem `json:"watchlist" firebase:"watchlist"`
}
type WatchlistItem struct {
	MovieID    int     `json:"movieID" firebase:"movieID"`
	UserRating float32 `json:"userRating" firebase:"userRating"`
	Watched    bool    `json:"watched" firebase:"watched"`
}
