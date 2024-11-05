# Wireguard VPN

I use Wireguard as a VPN between my personal machines.

## Create keys

Create a new key-pair and a pre-shared key:

```sh
sudo -i
apt install wireguard-tools
cd /etc/wireguard
umask 077
wg genkey | tee private.key | wg pubkey | tee public.key
wg genpsk | tee private-psk.key
```

## Set up remote

```sh
sudo sensible-editor /etc/wireguard/wg0.conf
sudo systemctl reload wg-quick@wg0.service
```

Allocate new IP address(es) for the new peer. I use an IPv6 range, or two IPv4
ranges in case IPv6 is broken and there's a local conflict on one of the IPv4
ranges. Note: generate your own IPv6 unique local address range.

Add a new Peer entry that looks something like this:

```
# TODO: description/hostname
[Peer]
PublicKey = GtL7fZc/bLnqZldpVofMCD6hDjrK28SsdLxevJ+qtKU= # TODO
AllowedIPs = fd8d:f94d:67f9::4/128,10.0.0.4/32,10.11.12.4/32 # TODO
PresharedKey = SECRET
```

This isn't really a tutorial on how to set up Wireguard, but my well-connected
server's header looks like this:

```
[Interface]
PrivateKey = SECRET
Address = fd8d:f94d:67f9::1/64,10.0.0.1/24,10.11.12.1/24
ListenPort = 51820
PostUp = ip6tables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -i wg0 -j ACCEPT
PostDown = ip6tables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -i wg0 -j ACCEPT
```


## Set up local

```sh
cat > wg0.conf <<EOF
[Interface]
# Public key: $(cat public.key)
PrivateKey = $(cat private.key)
Address = fd8d:f94d:67f9::4/64,10.0.0.4/24,10.11.12.4/24 # TODO

[Peer]
PublicKey = GtL7fZc/bLnqZldpVofMCD6hDjrK28SsdLxevJ+qtKU= # TODO
PresharedKey = $(cat private-psk.key)
Endpoint = demo.wireguard.com:51820 # TODO
AllowedIPs = fd8d:f94d:67f9::/64,10.0.0.0/24,10.11.12.0/24 # TODO
PersistentKeepalive = 25 # helps with NAT/firewalls
EOF
sensible-editor wg0.conf
sudo systemctl enable --now wg-quick@wg0.service
```

## Set up `/etc/hosts`

Update the `/etc/hosts` file on the remote, then copy the entries to the local
machine. You may want to update other peers as well.

## Check status

```sh
sudo wg
```
