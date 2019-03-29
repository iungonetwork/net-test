#!/usr/bin/env bats

# Check if IP assigned by OpenVPN server is the same as issued when AP was created

load common

setup() {
	signaling_connect
}

@test "access point ip is assigned correctly" {
  assigned_ip=$(jq -r .ipAddress < /tmp/ap.json)
  actual_ip=$(/sbin/ifconfig tun0 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}')
  [ "$actual_ip" = "$assigned_ip" ]
}

@test "access point is marked as online when connected" {
  ap_id=$(jq -r .accessPointId < /tmp/ap.json)
  ap_index=$(curl controller | jq -r ".status.accessPointsOnline | index (\"$ap_id\")")
  [ "$ap_index" != "null" ]
}

@test "access point is marked as offline when disconnected" {
  signaling_disconnect
  ap_id=$(jq -r .accessPointId < /tmp/ap.json)
  ap_index=$(curl controller | jq -r ".status.accessPointsOnline | index (\"$ap_id\")")
  [ "$ap_index" = "null" ]
  signaling_connect
}

teardown() {
  signaling_disconnect
}