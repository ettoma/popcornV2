package middlewares

import (
	"fmt"
	"log"
	"net/http"
)

func LoggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {

		log.Printf("\nURI: %s \nMethod: %s \n", r.RequestURI, r.Method)

		next.ServeHTTP(w, r)
	})
}

var domains = [...]string{"http://localhost:52233", "", "http://localhost:8080", "http://localhost:56088"}

func Cors(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		origin := r.Header.Get("Origin")

		allowedDomains := make([]string, 0)
		for _, domain := range domains {
			if origin == domain {
				allowedDomains = append(allowedDomains, origin)
				w.Header().Add("Access-Control-Allow-Origin", origin)
				w.Header().Add("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE")
				w.Header().Add("Access-Control-Allow-Headers", "Authorization")
				next.ServeHTTP(w, r)
				break
			}
		}
		if len(allowedDomains) > 0 {
			fmt.Printf("Origin is on allowed list: %s \n\n", allowedDomains[0])
		} else if len(allowedDomains) == 0 {
			fmt.Printf("origin not on allowed list: %s \n\n", origin)
		}

	})
}
