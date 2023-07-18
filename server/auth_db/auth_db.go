package authdb

import (
	"context"
	"log"

	firebase "firebase.google.com/go"
	"firebase.google.com/go/auth"
	"google.golang.org/api/option"
)

func InitialiseAuthDB() (bool, *auth.Client) {

	ctx := context.Background()
	sa := option.WithCredentialsFile("./firestore_db/service_account_key.json")

	app, err := firebase.NewApp(ctx, nil, sa)
	if err != nil {
		log.Fatalf("error getting Auth client: %v\n", err)
		return false, nil
	}
	client, err := app.Auth(ctx)
	if err != nil {

		log.Fatalf("error getting Auth client: %v\n", err)
		return false, nil
	}

	return true, client
}

func AddUser(email, password string, client *auth.Client) error {

	params := (&auth.UserToCreate{}).
		UID(email).
		Email(email).
		Password(password)
	u, err := client.CreateUser(context.Background(), params)
	if err != nil {
		log.Printf("error creating user: %v\n", err)
		return err
	}
	log.Printf("Successfully created user: %v\n", u)

	return nil
}

func LogIn(email, password string, client *auth.Client) error {

	token, err := client.CustomToken(context.Background(), email)

	log.Println(token, err)
	return nil
}
