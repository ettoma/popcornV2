package firestoreDB

import (
	"context"
	"encoding/json"
	"errors"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
	"firebase.google.com/go/auth"
	authdb "github.com/ettoma/popcorn_v2/OLD/auth_db"
	"github.com/ettoma/popcorn_v2/utils"
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

	utils.Logger.Println("Firestore DB initialised correctly")

	var isAuthDBInitialised bool

	isAuthDBInitialised, AuthDB = authdb.InitialiseAuthDB()

	if isAuthDBInitialised != true {
		return errors.New("Failed to initialise Auth DB")
	}

	utils.Logger.Println("Auth DB initialised correctly")

	return nil

}

func InitialiseFirestore() (bool, *firestore.Client) {
	ctx := context.Background()
	// Test
	sa := option.WithCredentialsFile("./service_account_key.json")

	//Production
	// sa := option.WithCredentialsFile("/etc/secrets/service_account_key.json")
	app, err := firebase.NewApp(ctx, nil, sa)
	if err != nil {
		utils.Logger.Fatalln(err)
		return false, nil
	}

	client, err := app.Firestore(ctx)
	if err != nil {
		utils.Logger.Fatalln(err)
		return false, nil
	}

	return true, client
}

func GetDocuments(client *firestore.Client, user string) (*Watchlist, error) {

	doc := client.Doc("users/" + user)
	data, err := doc.Get(context.Background())

	if status.Code(err) == codes.NotFound {
		utils.Logger.Println("Document not found: ", err)
		utils.Logger.Println("creating new document for user ", user)

		_, err := client.Doc("users/"+user).Create(context.Background(), map[string]interface{}{
			"watchlist": []string{},
		},
		)
		utils.Logger.Print(err)
		return nil, errors.New("User watchlist is empty")
	}

	var w *Watchlist

	err = data.DataTo(&w)
	if err != nil {
		utils.Logger.Println(err)
		return nil, err
	}

	j, err := json.Marshal(w)

	if err != nil {
		utils.Logger.Println(err)
		return nil, err
	}

	var r *Watchlist
	err = json.Unmarshal(j, &r)
	if err != nil {
		utils.Logger.Println(err)
		return nil, err
	}

	return w, nil

}
