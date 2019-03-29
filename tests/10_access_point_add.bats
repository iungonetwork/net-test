#!/usr/bin/env bats

@test "add access point" {

  if [ "$ADD_AP" != "y" ]; then
    skip "set ADD_AP=y to create new test access point"
  fi

  ap_id=$(uuidgen)
  ap_mac="00:00:00:00:00:00"
  result="$(curl http://controller/access-points -H "Content-Type: application/json" -d '{"accessPointId": "'$ap_id'", "macAddress":"'$ap_mac'"}' > /tmp/ap.json)"
  jq -r .signalingKeys.key < /tmp/ap.json > /tmp/key
  chmod 600 /tmp/key
  jq -r .signalingKeys.cert < /tmp/ap.json > /tmp/cert
  jq -r .signalingKeys.caCert < /tmp/ap.json > /tmp/caCert
  [ "$(jq -r .accessPointId < /tmp/ap.json)" = "$ap_id" ]
}