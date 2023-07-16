package firestoreDB

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
	"firebase.google.com/go/auth"
	authdb "github.com/ettoma/popcorn_v2/auth_db"
	"google.golang.org/api/option"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

var ClientDB *firestore.Client
var AuthDB *auth.Client

func Initialise() error {

	var isFirestoreInitialised bool
	//* initialise Firestore database
	isFirestoreInitialised, ClientDB = InitialiseFirestore()

	if isFirestoreInitialised != true {
		return errors.New("Failed to initialise Firestore DB")
	}

	log.Println("Firestore DB initialised correctly")

	var isAuthDBInitialised bool

	isAuthDBInitialised, AuthDB = authdb.InitialiseAuthDB()

	if isAuthDBInitialised != true {
		return errors.New("Failed to initialise Auth DB")
	}

	log.Println("Auth DB initialised correctly")

	return nil

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
		fmt.Println("Document not found: ", err)
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
