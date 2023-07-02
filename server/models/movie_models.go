package models

type genre struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

type MovieDetails struct {
	ID         int    `json:"id"`
	Title      string `json:"title"`
	PosterPath string `json:"poster_path"`
	// Genres      []genre `json:"genres"`
	Overview    string  `json:"overview"`
	ReleaseDate string  `json:"release_date"`
	VoteAvg     float32 `json:"vote_average"`
	VoteCount   int     `json:"vote_count"`
}

type QueryResults struct {
	Results []MovieDetails `json:"results"`
}
