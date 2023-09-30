package handles

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/ettoma/popcorn_v2/utils"
	"github.com/joho/godotenv"
)

func TestHandleGetMovieFromId(t *testing.T) {

	err := godotenv.Load("../.env")
	if err != nil {
		utils.HandleError(err)
	}

	req, err := http.NewRequest("GET", "http://localhost:11111/id=43212", nil)

	if err != nil {
		t.Error("test error: ", err)
	}

	rr := httptest.NewRecorder()

	HandleGetMovieFromId(rr, req)

	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v", status, http.StatusOK)
	}
}
