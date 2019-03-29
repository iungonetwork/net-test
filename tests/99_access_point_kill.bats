#!/usr/bin/env bats

load common

@test "access point kill" {

  if [ "$KILL_AP" != "y" ]; then
    skip "set KILL_AP=y to test access point kill"
  fi

  signaling_connect
  ap_id=$(jq -r .accessPointId < /tmp/ap.json)
  curl -X POST controller/access-points/$ap_id/kill
  sleep 2
  
  run ping -c 1 -W 1 -q $SIGNET_GW

  signaling_disconnect

  [ "$status" = 1 ]
}