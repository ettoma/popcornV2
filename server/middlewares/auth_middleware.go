package middlewares

import (
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strings"
	"time"

	"github.com/ettoma/popcorn_v2/utils"
	"github.com/golang-jwt/jwt/v4"
)

func JWTAuthMiddleware(next http.Handler) http.Handler {

	fmt.Println("using jwt middleware")

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {

		tokenObj := r.Header.Get("Authorization")

		token := strings.Split(tokenObj, " ")[1]

		isValid, err := ValidateToken(token)

		if err != nil {
			utils.WriteResponse(w, err.Error(), false, http.StatusUnauthorized)
			return
		}

		if !isValid {
			utils.WriteResponse(w, "invalid token", false, http.StatusUnauthorized)
			return
		}
		next.ServeHTTP(w, r)
	})
}

func ValidateToken(tokenString string) (bool, error) {

	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("Unexpected signing method: %v", token.Header["alg"])
		}

		key := utils.JWT_SECRET_KEY
		// key := []byte(os.Getenv("JWT_SECRET_KEY"))
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

	t := jwt.New(jwt.SigningMethodHS256)

	t.Claims = &jwt.RegisteredClaims{
		ExpiresAt: jwt.NewNumericDate(time.Now().Add(time.Hour * 1)),
	}

	s, err := t.SignedString(utils.SECRET_KEY)
	if err != nil {
		fmt.Println(err)
	}

	fmt.Println("token: ", s)

	token, err := jwt.Parse(s, func(token *jwt.Token) (interface{}, error) {
		return utils.SECRET_KEY, nil
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
