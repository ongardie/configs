# Debian Bookworm on ZFS install (using debootstrap)

These instructions describe how to install Debian Bookworm with a root ZFS
partition. The Debian Installer doesn't support ZFS (due to licensing
concerns), so these instructions use `debootstrap` to do a manual install. A
speed run through the instructions takes about 30 minutes (if everything goes
well).

Installing Debian with ZFS is a pain and may not be worth the trouble. I
started using ZFS in 2022 after
[experiencing some disk corruption](https://hachyderm.io/@ongardie/109322827923900236).
The "killer feature" of ZFS for me is simply integrity checking. Other features
that I've found helpful are:
- transparent encryption,
- snapshots,
- transparent compression, and
- transparent dedup (the "legacy" implementation is not recommendable for most
  situations, but it helps on backup drives;
  [fast dedup](https://openzfs.org/wiki/OpenZFS_Developer_Summit_2023), under
  development, would be much better).

ZFS has many other features, including RAID-Z across disks and streaming
changes over the network. I haven't used these.

As of 2024, a few other filesystems seem interesting, but I'm not ready to
switch to any of these yet:
- [Bcachefs](https://en.m.wikipedia.org/wiki/Bcachefs) (2015, merged into Linux
  in 2023): Relative newcomer.
- [Btrfs](https://en.wikipedia.org/wiki/Btrfs) (2009): Some features still
  under development.
- [F2FS](https://en.m.wikipedia.org/wiki/F2FS) (2012): It might be used on
  Android phones.
- [NILFS](https://en.m.wikipedia.org/wiki/NILFS) (2005): I don't know whether
  it's widely used.

Fortunately, the pain with ZFS is mostly in the installation process (which I
do infrequently), and these instrutions help streamline that.

## Related

- [Debian Installation Guide, manual setup](https://www.debian.org/releases/stable/amd64/apds03.en.html)
- [OpenZFS, instructions for Debian Bookworm](https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/Debian%20Bookworm%20Root%20on%20ZFS.html)
- [Anarcat's migration article](https://anarc.at/blog/2022-11-17-zfs-migration/)
- [Arch wiki: ZFS](https://wiki.archlinux.org/title/ZFS)
- [Arch wiki: Swap encryption](https://wiki.archlinux.org/title/Dm-crypt/Swap_encryption)
- [Debian wiki: ZFS](https://wiki.debian.org/ZFS)
- [Gentoo wiki: ZFS](https://wiki.gentoo.org/wiki/ZFS)

## Boot a live image

Download a live CD image from
<https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/>. The Xfce
image has a nice balance of size, features, and usability.

Copy it to an external drive:

```sh
sudo dd bs=1M status=progress if=debian-live-⟪...⟫.iso of=/dev/disk/by-id/⟪...⟫
```

Boot into it. Note that the username is `user` and password is `live`, which
you may need if the screensaver kicks in.

## Shell from another computer

Connect to the internet. Start an SSH server on the live image:

```sh
sudo apt update
sudo apt install openssh-server
mkdir -m 700 .ssh
curl https://github.com/⟪USER⟫.keys | tee .ssh/authorized_keys
```

Note the IP address:

```sh
hostname -I
```

From another computer that has an authorized SSH key:

```sh
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null user@⟪IP⟫
sudo -i
```

## Install `debootstrap`, ZFS, etc

Use ZFS from backports because it has updates and bug fixes.

```sh
cat > /etc/apt/sources.list <<'END'
deb [trusted=yes] file:/run/live/medium bookworm main non-free-firmware

deb https://deb.debian.org/debian bookworm main contrib non-free-firmware
deb-src https://deb.debian.org/debian bookworm main contrib non-free-firmware

deb https://deb.debian.org/debian bookworm-updates main contrib non-free-firmware
deb-src https://deb.debian.org/debian bookworm-updates main contrib non-free-firmware

deb https://deb.debian.org/debian bookworm-backports main contrib non-free-firmware
deb-src https://deb.debian.org/debian bookworm-backports main contrib non-free-firmware
END
apt update
apt upgrade
apt install debootstrap tree vim
apt install -t bookworm-backports zfsutils-linux
```

## Partition the disk

Set `$DISK` to the target disk where you want to install to (the entire thing,
not a partition):

```sh
ls -l /dev/disk/by-id/
DISK=/dev/disk/by-id/⟪...⟫
readlink -f $DISK
```

This is probably `/dev/nvme0n1` on most modern systems.

Unmount and clear the disk first. These instructions assume a modern NVMe
drive. See the OpenZFS instructions if you're dealing with something else.

```sh
swapoff --all
blkdiscard --force $DISK
```

You might try `--secure` with `blkdiscard`, but it wasn't supported for my
system.

We'll create the following partitions:

| # | Mountpoint | Filesystem    | Size      |
|---|------------|---------------|-----------|
| 1 | /boot/EFI  | fat32         |   512 MiB |
| 2 | /boot      | ext4          |   512 MiB |
| 3 | swap       | dm-crypt swap |    32 GiB |
| 4 | /          | ZFS           | remaining |

Modern systems don't strictly need GRUB and `/boot`, but I still prefer it. It
provides a nice menu (even if the system firmware doesn't), and Debian still
sort of assumes there's a bootloader. I use `ext4` for `/boot` because it's
a bit simpler than using ZFS and ZFS provides no significant advantage there.

Swap can be a good idea, even on systems with a lot of RAM. Everyone links to
this
[article (2018) by Chris Down](https://chrisdown.name/2018/01/02/in-defence-of-swap.html),
which makes some good points. Without swap, I've found that Linux's OOM killer
doesn't kick in until it's a bit too late, resulting in lockups that can last
many minutes. The swap can be sized equally to the system RAM to allow for
hibernation, or it can be smaller otherwise. Putting swap on ZFS can result in
a lockup ([issue #7734](https://github.com/zfsonlinux/zfs/issues/7734)), so
avoid that. If you don't want hibernation, you may be able to use an ephemeral
key to encrypt the swap; these instructions use dm-crypt and LUKS instead.

These instructions use ZFS native encryption. I think that provides some
authentication for the data, so it may be better than layering ZFS atop
dm-crypt.

Unfortunately, this setup will require typing a password to unlock swap and
then (if you're not resuming from hibernation), typing a password to unlock
ZFS. In theory, you should be able to unlock both partitions by entering a
single password and running it through a single KDF. For example, you could
create another dm-crypt partition to hold two key files, one for swap and one
for ZFS. However, I couldn't get that to work, even after a surprisingly large
pile of hacks, as I was fighting too many assumptions in the initramfs-tools
scripts.

```sh
sgdisk --zap-all $DISK
sgdisk -n0:0:+512M -t0:EF00 -c0:efi $DISK
sgdisk -n0:0:+512M -t0:8300 -c0:boot $DISK
sgdisk -n0:0:+32G -t0:8309 -c0:swap $DISK
sgdisk -n0:0:0 -t0:BF00 -c0:root $DISK
sgdisk -p $DISK
```

The partition types can be printed with `/sbin/sgdisk --list-types`. Some
common types are also listed on the
[Arch wiki](https://wiki.archlinux.org/title/GPT_fdisk).

## Create the filesystems

Create the EFI and `/boot` filesystems:

```sh
mkfs.fat -F 32 -s 1 -n EFI $DISK-part1
mkfs.ext4 $DISK-part2
```

The OpenZFS guide explains `-s 1`:

> The `-s 1` for `mkdosfs` is only necessary for drives which present 4 KiB
logical sectors ("4Kn" drives) to meet the minimum cluster size (given the
partition size of 512 MiB) for FAT32. It also works fine on drives which
present 512 B sectors.

Initialize the encrypted swap:

```sh
cryptsetup luksFormat $DISK-part3 # enter a passphrase (twice)
cryptsetup open $DISK-part3 swap # enter it again
mkswap /dev/mapper/swap
```

Create the encrypted ZFS pool:

```sh
zpool create \
    -o ashift=12 \
    -o autotrim=on \
    -O encryption=aes-256-gcm -O keyformat=passphrase -O pbkdf2iters=4001001 \
    -O acltype=posix -O xattr=sa -O dnodesize=auto \
    -O atime=off \
    -O canmount=off -O mountpoint=/ -R /mnt \
    rpool $DISK-part4
zpool status rpool
```

This uses PBKDF2 because ZFS does not yet support Argon2. One of these
conflicting PRs may add it soon: <https://github.com/openzfs/zfs/pull/15682/>
and <https://github.com/openzfs/zfs/pull/14836/>.

There are many possible settings, documented in
[man zpoolprops](https://openzfs.github.io/openzfs-docs/man/v2.2/7/zpoolprops.7.html)
and
[man zfsprops](https://openzfs.github.io/openzfs-docs/man/v2.2/7/zfsprops.7.html).

Create and mount the ZFS datasets (filesystems):

```sh
zfs create -o canmount=off -o mountpoint=none rpool/ROOT
zfs create -o canmount=noauto -o mountpoint=/ rpool/ROOT/debian
zfs mount rpool/ROOT/debian
zfs create rpool/home
zfs create -o mountpoint=/root rpool/home/root
chmod 700 /mnt/root
zfs create rpool/var
zfs create -o canmount=off rpool/var/lib
zfs create -o com.sun:auto-snapshot=false rpool/var/lib/docker
zfs create rpool/tmp
chmod 1777 /mnt/tmp
tree /mnt
zfs list
```

The idea is to create datasets for things you might want to snapshot or
(re-)configure independently. They're easy and cheap to create later, but
existing data will occupy space in existing snapshots. The `canmount=off`
setting just makes a pass-through container for other datasets.

Warning: you probably don't want to create a separete dataset for `/etc`. While
this can work, it needs to be mounted before leaving the initramfs, which adds
extra complications. (Otherwise, the early boot process won't have access to
`/etc` and many things go wrong.)

Create `/mnt/run` and mount a `tmpfs` in it:

```sh
mkdir /mnt/run
mount -t tmpfs tmpfs /mnt/run
```

## Run `debootstrap` and chroot in

```sh
debootstrap \
    --extra-suites=bookworm-updates \
    --include=bsdextrautils \
    bookworm \
    /mnt \
    'https://deb.debian.org/debian'
cp -a /etc/hostid /mnt/etc/hostid
mount --make-private --rbind /dev /mnt/dev
mount --make-private --rbind /proc /mnt/proc
mount --make-private --rbind /sys /mnt/sys
LANG=C.UTF-8 chroot /mnt /usr/bin/env DISK=$DISK bash --login
```

The `hostid` is how ZFS tracks which machine last imported a pool. If you don't
copy it into the chroot, ZFS may be unable to cleanly export the pool later
(which is a minor nuisance).

## Set up partitions

```sh
column -t << END | tee /etc/crypttab
#name device keyfile options
swap /dev/disk/by-uuid/$(blkid -s UUID -o value $DISK-part3) none luks,discard
END
column -t << END | tee /etc/fstab
#device mountpoint type options dump pass
/dev/mapper/swap none swap defaults 0 0
/dev/disk/by-uuid/$(blkid -s UUID -o value $DISK-part1) /boot/efi vfat defaults 0 0
/dev/disk/by-uuid/$(blkid -s UUID -o value $DISK-part2) /boot ext4 defaults 0 0
END
swapon -a
swapon
mount /boot
mkdir -p /boot/efi
mount /boot/efi
```

## Configure the system

```sh
echo ⟪NAME⟫ > /etc/hostname
echo 127.0.1.1 $(cat /etc/hostname) >> /etc/hosts

rm /etc/apt/sources.list

cat > /etc/apt/sources.list.d/debian.sources <<'END'
Types: deb deb-src
URIs: https://deb.debian.org/debian
Suites: bookworm bookworm-updates bookworm-backports
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb deb-src
URIs: https://deb.debian.org/debian-security
Suites: bookworm-security
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
END

cat > /etc/apt/preferences.d/20zfs <<'END'
# These come from
# https://packages.debian.org/source/bookworm-backports/zfs-linux. Backports is
# preferred to get ZFS bug fixes.
Package: libnvpair3linux libpam-zfs libuutil3linux libzfs* libzpool* python3-pyzfs pyzfs-doc zfs*
Pin: origin *.debian.org
Pin: release n=bookworm-backports
Pin-Priority: 570
END

apt update
apt upgrade
apt install \
    bsdextrautils \
    console-setup \
    cryptsetup \
    cryptsetup-initramfs \
    curl \
    dpkg-dev \
    firmware-iwlwifi \
    firmware-linux-nonfree \
    firmware-realtek \
    gdisk \
    git \
    grub-efi-amd64 \
    linux-headers-generic \
    linux-image-generic \
    locales \
    man \
    openssh-client \
    parted \
    rsync \
    systemd-timesyncd \
    tree \
    vim \
    zfs-initramfs
dpkg-reconfigure locales keyboard-configuration tzdata
```

These messages are normal:

```
cryptsetup: ERROR: Couldn't resolve device rpool/ROOT/debian
cryptsetup: WARNING: Couldn't determine root device
```

Note: You might need additional `firmware-*` packages, depending on your
hardware.

I don't know whether this step is necessary, but skipping it could plausibly
cause significant pain later:

```sh
echo REMAKE_INITRD=yes > /etc/dkms/zfs.conf
```

## Set up zfs-mount-generator

The initramfs aims to mount the root filesystem and pivot to it. The other
filesystems are mounted later in the boot process. However, other parts of the
boot process may require those filesystems, for example to access `/var`.

One simple approach to addressing this would be to mount more filesystems from
the initramfs. You could do this by listing filesystems in
`ZFS_INITRD_ADDITIONAL_DATASETS` in `/etc/init-ramfs-tools/conf.d/zfs` (or a
nearby file), then running `update-initramfs -u -k all`. However, as of ZFS
2.2.2 (in 2024), I'm unable to access snapshots for those filesystems due to
<https://github.com/openzfs/zfs/issues/11563> or
<https://github.com/openzfs/zfs/issues/9461>:

```console
$ ls /home/.zfs/snapshot/install
ls: cannot open directory '/home/.zfs/snapshot/install': Too many levels of symbolic links
```

Instead, you can use `zfs-mount-generator` to inform `systemd` of the
filesystem dependencies, so that units wait until the filesystems are mounted.
Most of this happens automatically, but you need a cache file that lists the
mounts.

```sh
mkdir -p /etc/zfs/zfs-list.cache
touch /etc/zfs/zfs-list.cache/rpool
zed -F &
cat /etc/zfs/zfs-list.cache/rpool
```

If the file is empty/stale, you can generate an event:
```sh
zfs set canmount=noauto rpool/ROOT/debian
cat /etc/zfs/zfs-list.cache/rpool
```

Then finish up and review:
```sh
fg # kill zed
sed -Ei 's|\t/mnt/?|\t/|' /etc/zfs/zfs-list.cache/rpool
cat /etc/zfs/zfs-list.cache/rpool
```

## Set up the bootloader (GRUB 2)

```sh
mv /etc/default/grub /etc/default/grub.orig
{
    sed -E '/^GRUB_CMDLINE_LINUX=""$/ s@""@"root=ZFS=rpool/ROOT/debian"@' < /etc/default/grub.orig
    echo
    echo '# Disables hook in /etc/grub.d/10_linux that assumes ZFS / implies ZFS /boot'
    echo 'GRUB_FS="not-entirely-zfs"'
} > /etc/default/grub
! diff -u /etc/default/grub.orig /etc/default/grub
update-grub
sed -n '/^menuentry/,/^}/p' /boot/grub/grub.cfg
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=debian --recheck
```

The GRUB entry should look like this:

```grub
menuentry 'Debian GNU/Linux' --class debian --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-/dev/nvme0n1p4' {
	load_video
	insmod gzio
	if [ x$grub_platform = xxen ]; then insmod xzio; insmod lzopio; fi
	insmod part_gpt
	insmod ext2
	search --no-floppy --fs-uuid --set=root 6fb441ef-c9ed-4df8-8f94-51a61b314603
	echo	'Loading Linux 6.1.0-17-amd64 ...'
	linux	/vmlinuz-6.1.0-17-amd64 root=PARTUUID=30baf6d7-faec-460b-a642-fda89ff852d4 ro root=ZFS=rpool/ROOT/debian quiet
	echo	'Loading initial ramdisk ...'
	initrd	/initrd.img-6.1.0-17-amd64
}
```

Note that the `linux` line sets `root=` twice. The first one is
[ignored, hopefully](https://unix.stackexchange.com/questions/544224/evaluation-order-of-duplicated-kernel-parameters).


## Set a root password

```sh
passwd
```

If you don't do this, you will be unable to log in when the machine reboots.

## Install more packages

If that machine isn't wired on Ethernet, install whatever you'll need to access
the network once you reboot.

You may want:

```sh
apt install network-manager
```

## Take a snapshot (optional)

```sh
apt clean
zfs snapshot -r rpool@install
```

## Reboot into the new system

Exit the chroot.

Next, you want to unmount everything. I haven't gotten ZFS to export the pool
cleanly. One option is:

```sh
umount -R /mnt
```

Try:

```sh
umount -l /mnt/dev
```

if that's busy.

Another option is:
```sh
findmnt --submounts /mnt --list --output target,fstype --noheadings | \
    grep -v ' zfs$' | awk '{print $1}' | tac | \
    xargs umount
```

Then run:

```sh
zpool export rpool
```

That will proably fail to export cleanly with the message:

```
cannot export 'rpool': pool is busy
```

If so, don't worry about it too much. It just adds a step below.

```sh
systemctl poweroff
```

Remove the external drive and power the machine on.

If you were unable to export the pool cleanly, you might need to import it in
the initramfs shell when prompted:
```sh
zpool import rpool -f
exit
```

## Rescue instructions (if needed)

Boot the live image and install ZFS as before.

```sh
sudo -i
zpool import -N -R /mnt rpool
zfs load-key rpool
zfs mount rpool/ROOT/debian
zfs mount -a
cp -a /etc/hostid /mnt/etc/hostid
mount --make-private --rbind /dev /mnt/dev
mount --make-private --rbind /proc /mnt/proc
mount --make-private --rbind /sys /mnt/sys
mount -t tmpfs tmpfs /mnt/run
chroot /mnt /bin/bash --login
swapon -a
mount /boot
mount /boot/efi
```

Note that `zfs mount -a` may succeed, yet complain with:
```
failed to lock /etc/exports.d/zfs.exports.lock: No such file or directory
```
I think that's OK.

Now do whatever you think you need to do. Good luck.

## Test hibernation

Once you're booted into the target machine, you may want to update the
initramfs one more time:

```sh
update-initramfs -u -k all
```

It should inform you that it'll try to resume from `/dev/mapper/swap`.

Then test if you can resume from the swap device:

```sh
systemctl hibernate
```
