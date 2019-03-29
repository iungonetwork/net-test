#!/usr/bin/env bats

# Try to execute ssid change command via RMI

load common
@test "access point rmi" {
  
  skip "does not work on all operating systems, needs to be revised"
  
  ap_id=$(jq -r .accessPointId < /tmp/ap.json)

  # setup ssh server
  mkdir /root/.ssh
  jq -r .rmiKeys.public_ssh < /tmp/ap.json > /root/.ssh/authorized_keys
  /usr/bin/ssh-keygen -A
  /usr/sbin/sshd -p 22 -D -d -e &

  # mock iungo daemon
  mkdir -p /etc/init.d
  cat << EOL > /etc/init.d/iungo
#!/bin/ash
sleep 1
exit 0
EOL
  chmod a+x /etc/init.d/iungo

  # mock uci app
  cat << EOL > /bin/uci
#!/bin/ash
sleep 1
exit 0
EOL
  chmod a+x /bin/uci

  # try to change ssid
  signaling_connect
  result=$(curl controller/access-points/$ap_id/tasks/setSsid -d '{"ssid":"test"}' -H "Content-Type: application/json" | jq -r .success)
  signaling_disconnect
  [ "$result" = "true" ]
}