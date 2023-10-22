package middlewares

import (
	"testing"

	"github.com/ettoma/popcorn_v2/utils"
)

func TestGenerateJWT(t *testing.T) {
	err := GenerateJWT()

	if err != nil {
		t.Error("\ntest error: ", err)
	} else {
		t.Log("\ntest success: no error")
	}

}

func TestValidateToken(t *testing.T) {
	isValid, err := ValidateToken(utils.TEST_TOKEN)

	if err != nil {
		t.Error("\nError validating token: ", err)
	} else {
		t.Log("\nToken is valid: ", isValid)
	}
}
