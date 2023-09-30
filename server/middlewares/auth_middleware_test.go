package middlewares

import "testing"

func TestGenerateJWT(t *testing.T) {
	token, err := ValidateToken("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRob3JpemVkIjp0cnVlLCJleHAiOjE2OTYwNDg5NzMsInVzZXIiOiJldHRvcmV0b21hIn0._gjAnd-PjnPEy61Uwoh1EFpUHA8ECe8VYGr8KciWiIY")

	if err != nil {
		t.Error("\ntest error: ", err)
	} else {
		t.Log("\ntest success: ", token)
	}

}
