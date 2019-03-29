#!/usr/bin/env bats

signaling_connect() {
	mkdir -p /dev/net
	if [ ! -c /dev/net/tun ]; then
	    mknod /dev/net/tun c 10 200
	fi
	openvpn --client --dev tun --ca /tmp/caCert --cert /tmp/cert --key /tmp/key --remote openvpn --proto tcp &
	sleep 2
	ip route add 172.28.1.16/32 via 10.8.0.1
}

signaling_disconnect() {
	killall openvpn
}