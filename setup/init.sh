#!/bin/bash

# exit script if return code != 0
set -e

# update packages ignoring filesystem (docker limitation)
pacman -Syu --ignore filesystem --noconfirm

# set locale
echo en_US.UTF-8 UTF-8 > /etc/locale.gen
locale-gen
echo LANG="en_US.UTF-8" > /etc/locale.conf

# add user "nobody" to primary group "users" (will remove any other group membership)
usermod -g users nobody

# add user "nobody" to secondary group "nobody" (will retain primary membership)
usermod -a -G nobody nobody

# setup env for user nobody
mkdir -p /home/nobody
chown -R nobody:users /home/nobody
chmod -R 775 /home/nobody
 
# set shell for user nobody
chsh -s /bin/bash nobody
 
# upgrade pacman db
pacman-db-upgrade

# delete any local keys
rm -rf /root/.gnupg

# force re-creation of /root/.gnupg and start dirmgr
dirmngr </dev/null

# refresh keys for pacman
pacman-key --refresh-keys

# force re-install of ncurses 6.x with 5.x backwards compatibility (can be removed onced all apps have switched over to ncurses 6.x)
curl -o /tmp/ncurses5-compat-libs-6.0-2-x86_64.pkg.tar.xz -L https://github.com/binhex/arch-packages/raw/master/compiled/ncurses5-compat-libs-6.0-2-x86_64.pkg.tar.xz
pacman -U /tmp/ncurses5-compat-libs-6.0-2-x86_64.pkg.tar.xz --noconfirm

# install additional packages
pacman -S vi --noconfirm

# cleanup
yes|pacman -Scc
#rm -rf /usr/share/locale/*
rm -rf /usr/share/man/*
rm -rf /root/*
rm -rf /tmp/*