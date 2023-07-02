package middlewares

import (
	"log"
	"net/http"
)

func LoggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {

		log.Printf("\nURI: %s \nMethod: %s \n", r.RequestURI, r.Method)

		next.ServeHTTP(w, r)
	})
}
