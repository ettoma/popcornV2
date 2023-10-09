package auth

import (
	"os"
	"time"

	"github.com/golang-jwt/jwt/v4"
)

func GenerateTokenString(username string) (string, error) {

	key := []byte(os.Getenv("JWT_SECRET_KEY"))

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"exp":        jwt.NewNumericDate(time.Now().Add(time.Minute * 10)),
		"authorized": true,
		"user":       username,
	})

	tokenString, err := token.SignedString(key)
	if err != nil {
		return "", err
	}
	return tokenString, nil

}
