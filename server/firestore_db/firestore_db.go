package firestoreDB

import (
	"context"
	"encoding/json"
	"fmt"
	"log"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
	"google.golang.org/api/option"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

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

func GetDocuments(client *firestore.Client) (*Watchlist, error) {

	doc := client.Doc("users/ettore-1234")
	data, err := doc.Get(context.Background())

	if status.Code(err) == codes.NotFound {
		fmt.Println("ouch: ", err)
		return nil, err
	}

	var w *Watchlist

	err = data.DataTo(&w)
	fmt.Print(err)
	fmt.Println(w.Watchlist)

	j, err := json.Marshal(w)

	if err != nil {
		fmt.Println(err)
		return nil, err
	}
	fmt.Printf("%s", j)

	var r *Watchlist
	err = json.Unmarshal(j, &r)
	if err != nil {
		fmt.Println(err)
		return nil, err
	}
	fmt.Println(r)

	return w, nil

}
