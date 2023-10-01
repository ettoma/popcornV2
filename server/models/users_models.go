package models

type NewUser struct {
	UID string `json:"uid"`
}

type ExistingUser struct {
	Username  string `json:"username"`
	CreatedAt int    `json:"createdat"`
}
