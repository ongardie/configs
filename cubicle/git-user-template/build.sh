#!/bin/sh
set -eu

mkdir -p ~/.config/git
cp -a user.conf ~/.config/git
tar -C ~ -cf ~/provides.tar .config/git/user.conf
