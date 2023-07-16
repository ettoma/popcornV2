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

	// uid := "IgjufntrQ3YtIufZ157o8jv864i2"
	// u, err := client.GetUser(ctx, uid)
	// if err != nil {
	// 	log.Fatalf("error getting user %s: %v\n", uid, err)
	// }
	// log.Printf("Successfully fetched user data: %v\n", u)
	// log.Print(u.Email)

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
	user, err := client.EmailSignInLink(context.Background(), email, &auth.ActionCodeSettings{
		URL: "https://google.com",
	})
	if err != nil {
		log.Println(err)
		return err
	}

	log.Println(user)

	// // If the user is logged in, print their uid.
	// if user != nil {
	//     log.Println(user.UID)
	// }
	return nil
}
