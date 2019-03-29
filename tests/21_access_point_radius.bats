#!/usr/bin/env bats

# Check if RADIUS server accepts issued AP secret
# We need to do this over signaling network, RADIUS server will reject connections otherwise

load common

radius_secret=$(jq -r .radiusSecret < /tmp/ap.json)

setup() {
	signaling_connect
}

gen_eapol_config() {

  user_id=$(jq -r .userId < /tmp/user.json)
  password=$(jq -r .password < /tmp/user.json)

	cat << EOL > $1
network={
  key_mgmt=WPA-EAP
  eap=$2
  identity="$user_id"
  password="$password"
  phase2="auth=$3"
}
EOL
}

@test "radius credentials are valid" {
  radius_secret=$(jq -r .radiusSecret < /tmp/ap.json)
  radtest user pass $RADIUS_IP 0 $radius_secret | grep -q "Access-Reject"
  status=$?
  [ "$status" -eq 0 ]
}

@test "user authetication TTLS/PAP" {
  gen_eapol_config /tmp/eap_config_ttls_pap TTLS PAP
  eapol_test -c /tmp/eap_config_ttls_pap -a $RADIUS_IP -s $radius_secret -o /tmp/radius.crt
  result=$?
  [ "$result" -eq 0 ]
}

@test "user authetication TTLS/MSCHAPV2" {
  gen_eapol_config /tmp/eap_config_ttls_mschapv2 TTLS MSCHAPV2
  eapol_test -c /tmp/eap_config_ttls_mschapv2 -a $RADIUS_IP -s $radius_secret -o /tmp/radius.crt
  result=$?
  [ "$result" -eq 0 ]
}

@test "user authetication PEAP/MSCHAPV2" {
  gen_eapol_config /tmp/eap_config_peap_mschapv2 PEAP MSCHAPV2
  eapol_test -c /tmp/eap_config_peap_mschapv2 -a $RADIUS_IP -s $radius_secret -o /tmp/radius.crt
  result=$?
  [ "$result" -eq 0 ]
}

teardown() {
	signaling_disconnect
}