package utils

import (
	"encoding/json"
	"net/http"
)

func WriteResponse(w http.ResponseWriter, value interface{}, success bool, status int) {

	type jsonResponse struct {
		Success    bool        `json:"success"`
		Message    interface{} `json:"message"`
		StatusCode int         `json:"statusCode"`
	}

	w.Header().Add("Content-Type", "application/json")
	w.WriteHeader(status)

	response, err := json.Marshal(jsonResponse{
		Message:    value,
		Success:    success,
		StatusCode: status,
	})

	Logger.Println("success: ", success, "\nstatus: ", status)

	if err != nil {
		w.Write([]byte(err.Error()))
	} else {
		w.Write(response)
	}

}

func HandleError(err error) {
	if err != nil {
		Logger.Printf("%s", err)
	}

}
