package authdb

import (
	"context"

	"github.com/ettoma/popcorn_v2/utils"

	firebase "firebase.google.com/go"
	"firebase.google.com/go/auth"
	"google.golang.org/api/option"
)

func InitialiseAuthDB() (bool, *auth.Client) {

	ctx := context.Background()
	// Test
	sa := option.WithCredentialsFile("./service_account_key.json")

	//Production
	// sa := option.WithCredentialsFile("/etc/secrets/service_account_key.json")

	app, err := firebase.NewApp(ctx, nil, sa)
	if err != nil {
		utils.Logger.Fatalf("error getting Auth client: %v\n", err)
		return false, nil
	}
	client, err := app.Auth(ctx)
	if err != nil {

		utils.Logger.Fatalf("error getting Auth client: %v\n", err)
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
		utils.Logger.Printf("error creating user: %v\n", err)
		return err
	}
	utils.Logger.Printf("Successfully created user: %v\n", u)

	return nil
}

func LogIn(email, password string, client *auth.Client) error {

	token, err := client.CustomToken(context.Background(), email)

	utils.Logger.Println(token, err)
	return nil
}
