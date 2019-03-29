#!/usr/bin/env bats

@test "add user" {

  if [ "$ADD_USER" != "y" ]; then
    skip "set ADD_USER=y to create new test user"
  fi

  user_id=$(uuidgen)
  result="$(curl http://controller/users -H "Content-Type: application/json" -d '{"userId": "'$user_id'"}' > /tmp/user.json)"
  [ "$(jq -r .userId < /tmp/user.json)" = "$user_id" ]
}