# SSH server

```sh
sudo apt install openssh-server
sudo tee /etc/ssh/sshd_config.d/local.conf <<'END'
PasswordAuthentication no
END
sudo systemctl restart ssh
```

You may need to open a firewall rule. Here's an example:

```sh
sudo ufw allow proto tcp from 192.168.0.0/24 to any port 22 comment 'SSH from LAN'
```

Clear the `/etc/motd` message (optional):

```sh
sudo tee /etc/motd < /dev/null
```
