# Wireguard VPN

I use Wireguard as a VPN between my personal machines.

## Create a new key pair

```sh
sudo -i
apt install wireguard-tools
cd /etc/wireguard
umask 077
wg genkey | tee private.key | wg pubkey | tee public.key
```

## Set up remote

```sh
sudo sensible-editor /etc/wireguard/wg0.conf
sudo systemctl reload wg-quick@wg0.service
```

Allocate new IP address(es) for the new peer.

Add a new Peer entry that looks something like this:

```
# TODO: description/hostname
[Peer]
PublicKey = GtL7fZc/bLnqZldpVofMCD6hDjrK28SsdLxevJ+qtKU= # TODO
AllowedIPs = 10.0.0.4/32,10.11.12.4/32 # TODO
```

This isn't really a tutorial on how to set up Wireguard, but my well-connected
server's header looks like this:

```
[Interface]
PrivateKey = SECRET
Address = 10.0.0.1/24,10.11.12.1/24
ListenPort = 51820
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
```

I use two IP ranges in case there's a local conflict. TODO: set up IPv6

## Set up local

```sh
cat > wg0.conf <<EOF
[Interface]
# Public key: $(cat public.key)
PrivateKey = $(cat private.key)
Address = 10.0.0.4/24,10.11.12.4/24 # TODO

[Peer]
PublicKey = GtL7fZc/bLnqZldpVofMCD6hDjrK28SsdLxevJ+qtKU= # TODO
Endpoint = demo.wireguard.com:51820 # TODO
AllowedIPs = 10.0.0.0/24,10.11.12.0/24 # TODO
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
