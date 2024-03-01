# Set up a user account (as admin)

## Set up sudo without password (optional)

```sh
sudo EDITOR=vim visudo
```

Change this line:

```diff
-%sudo   ALL=(ALL:ALL) ALL
+%sudo   ALL=NOPASSWD: ALL
```

## Create system groups

Create some groups that the user should belong to. These are normally created
when installing packages, but you might not have done that yet. Note that
`addgroup` will print a warning if the groups already exist.

```sh
sudo addgroup --system docker
sudo addgroup --system libvirt
```

## Create the user

```sh
NEWUSER=⟪NAME⟫
```

If you want, you can create a ZFS dataset for the user's home directory.

```sh
zfs create rpool/home/$NEWUSER
find /etc/skel -mindepth 1 -maxdepth 1 -exec cp -av {} /home/$NEWUSER \;
sudo adduser --disabled-password --no-create-home $NEWUSER
chown -R $NEWUSER:$NEWUSER /home/$NEWUSER
```

Otherwise, to create a normal home directory:

```sh
sudo adduser --disabled-password $NEWUSER
```

Then, add the user to some groups:

```sh
sudo usermod --append --groups docker,libvirt,sudo,systemd-journal $NEWUSER
```

### Set a password (optional)

```sh
sudo passwd $NEWUSER
```

### Set up SSH (optional)

This authorizes the keys that a user has on GitHub, which can be convenient:

```sh
sudo -i -u $NEWUSER
mkdir -m 700 -p .ssh
curl https://github.com/⟪USER⟫.keys | tee -a .ssh/authorized_keys
```
