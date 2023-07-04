package moviesapi

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/http/httptrace"
	"os"
	"strings"
	"time"

	"github.com/ettoma/popcorn_v2/models"
)

var BASE_URL = "https://api.themoviedb.org/3"

func GetMovieFromId(id string) *models.MovieDetails {

	var start = time.Now()
	var response *models.MovieDetails
	queryUrl := fmt.Sprintf("%s/movie/%s", BASE_URL, id)

	req, err := http.NewRequest(http.MethodGet, queryUrl, nil)
	if err != nil {
		fmt.Print(err)
	}

	trace := &httptrace.ClientTrace{
		WroteRequest: func(info httptrace.WroteRequestInfo) {
			fmt.Printf("Response time: %v\n\n", time.Since(start))
		},
	}

	req.Header.Add("Authorization", os.Getenv("MOVIEDB_API_KEY"))

	req = req.WithContext(httptrace.WithClientTrace(req.Context(), trace))

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		fmt.Print(err)
	}

	defer res.Body.Close()

	resBody, err := io.ReadAll(res.Body)
	if err != nil {
		fmt.Print(err)
	}

	err = json.Unmarshal(resBody, &response)
	if err != nil {
		fmt.Print(err)
	}

	return response
}

func GetMoviesFromKeyword(query string) *models.QueryResults {
	var response *models.QueryResults

	var start = time.Now()
	query = strings.ReplaceAll(query, " ", "%20")

	queryUrl := fmt.Sprintf("%s/search/movie?query=%s&include_adult=false&language=en-US&page=1", BASE_URL, query)

	req, err := http.NewRequest(http.MethodGet, queryUrl, nil)
	if err != nil {
		fmt.Print(err)
	}

	key := os.Getenv("MOVIEDB_API_KEY")
	req.Header.Add("Authorization", key)

	trace := &httptrace.ClientTrace{
		// DNSDone: func(dnsInfo httptrace.DNSDoneInfo) {
		// 	fmt.Printf("DNS Info: %+v\n", dnsInfo)
		// },
		// GotConn: func(connInfo httptrace.GotConnInfo) {
		// 	fmt.Printf("Got Conn: %+v\n", connInfo)
		// },
		WroteRequest: func(info httptrace.WroteRequestInfo) {
			fmt.Printf("Response time: %v\n\n", time.Since(start))
		},
		// WroteHeaders: func() {
		// 	fmt.Printf("Wrote headers: %v\n", time.Since(start))
		// },
		// GotFirstResponseByte: func() {
		// 	fmt.Printf("Wrote response: %v\n", time.Since(start))
		// },
	}

	req.Header.Add("Authorization", "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmZWRkNjUwNWQ0OTBlZjEyNWIwMzZjYjhlNzQ3YTQ1OCIsInN1YiI6IjY0NzFjNTgzYTE5OWE2MDBiZjI5NjI0NCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.S6O7yWHWLYwOOGwpzW2GhxQJrOHxuzWvx_0NGBve21s")

	req = req.WithContext(httptrace.WithClientTrace(req.Context(), trace))

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		fmt.Print(err)
	}

	defer res.Body.Close()

	resBody, err := io.ReadAll(res.Body)
	if err != nil {
		fmt.Print(err)
	}

	err = json.Unmarshal(resBody, &response)
	if err != nil {
		fmt.Print(err)
	}

	return response

}
