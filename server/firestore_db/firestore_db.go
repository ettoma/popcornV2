package firestoreDB

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
	"google.golang.org/api/option"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

var ClientDB *firestore.Client

func Initialise() error {

	var isInitialised bool
	//* initialise Firestore database
	isInitialised, ClientDB = InitialiseFirestore()

	if isInitialised == true {
		log.Println("Firestore DB initalised")
		return nil
	}

	return errors.New("Failed to initialise Firestore DB")

}

func InitialiseFirestore() (bool, *firestore.Client) {
	ctx := context.Background()
	sa := option.WithCredentialsFile("./firestore_db/service_account_key.json")
	app, err := firebase.NewApp(ctx, nil, sa)
	if err != nil {
		log.Fatalln(err)
		return false, nil
	}

	client, err := app.Firestore(ctx)
	if err != nil {
		log.Fatalln(err)
		return false, nil
	}

	return true, client
}

func GetDocuments(client *firestore.Client, user string) (*Watchlist, error) {

	doc := client.Doc("users/" + user)
	data, err := doc.Get(context.Background())

	if status.Code(err) == codes.NotFound {
		fmt.Println("ouch: ", err)
		return nil, err
	}

	var w *Watchlist

	err = data.DataTo(&w)
	if err != nil {
		fmt.Println(err)
		return nil, err
	}

	j, err := json.Marshal(w)

	if err != nil {
		fmt.Println(err)
		return nil, err
	}

	var r *Watchlist
	err = json.Unmarshal(j, &r)
	if err != nil {
		fmt.Println(err)
		return nil, err
	}

	return w, nil

}
