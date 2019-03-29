FROM bats/bats
COPY ./tests /tests
RUN apk add --no-cache util-linux curl jq openvpn freeradius freeradius-radclient wpa_supplicant openssh