package middlewares

import (
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"os"
	"time"

	"github.com/ettoma/popcorn_v2/utils"
	"github.com/golang-jwt/jwt/v4"
)

func JWTAuthMiddleware(next http.Handler) http.Handler {

	jwt.New(jwt.SigningMethodES256)
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		next.ServeHTTP(w, r)
	})
}

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

func ValidateToken(tokenString string) (bool, error) {

	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("Unexpected signing method: %v", token.Header["alg"])
		}

		key := []byte(os.Getenv("JWT_SECRET_KEY"))
		return key, nil
	})

	if token != nil {
		if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
			var date time.Time
			switch exp := claims["exp"].(type) {
			case float64:
				date = time.Unix(int64(exp), 0)
			case json.Number:
				v, _ := exp.Int64()
				date = time.Unix(v, 0)
			}
			// _, errGettingUser := database.GetUserByUsername(claims["user"].(string))
			// if errGettingUser != nil {
			// 	return false, errors.New("user not found: " + claims["user"].(string))

			fmt.Printf(" username: %s \n authorised: %v \n expiresAt: %s \n", claims["user"], claims["authorized"], date)
			return true, nil

		}
	}
	return false, err

}

func GenerateJWT() error {

	secret := []byte("supersecretkey")
	t := jwt.New(jwt.SigningMethodHS256)

	t.Claims = &jwt.RegisteredClaims{
		ExpiresAt: jwt.NewNumericDate(time.Now().Add(time.Hour * 1)),
	}

	s, err := t.SignedString(secret)
	if err != nil {
		fmt.Println(err)
	}

	// fmt.Println("signed string: ", s)

	token, err := jwt.Parse(s, func(token *jwt.Token) (interface{}, error) {
		return "oksad", nil
	})

	if token.Valid {
		utils.Logger.Println("valid")
		return nil
	} else if errors.Is(err, jwt.ErrTokenMalformed) {
		return jwt.ErrTokenMalformed
	} else if errors.Is(err, jwt.ErrTokenExpired) || errors.Is(err, jwt.ErrTokenNotValidYet) {
		return jwt.ErrTokenExpired
	} else if errors.Is(err, jwt.ErrInvalidKey) {
		return jwt.ErrInvalidKey
	} else {
		return err
	}

}
