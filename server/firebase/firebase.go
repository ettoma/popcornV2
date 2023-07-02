package firebase

import (
	"context"
	"fmt"
	"log"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
	"google.golang.org/api/iterator"
	"google.golang.org/api/option"
)

func InitialiseFirestore() (bool, *firestore.Client) {
	ctx := context.Background()
	sa := option.WithCredentialsFile("./firebase/service_account_key.json")
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

func GetDocuments(client *firestore.Client) {
	iter := client.Collection("users").Documents(context.Background())
	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			log.Fatalf("Failed to iterate: %v", err)
		}
		fmt.Println(doc.Data()["watchlist"])
	}
}
