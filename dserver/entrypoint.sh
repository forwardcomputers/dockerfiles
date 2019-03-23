#!/bin/bash
set -e
#
cd "${HOME}"
git clone --recursive https://github.com/forwardcomputers/dfiles.git tmp
mv tmp/.git .
rm -rf tmp
rm -rf tmp/ .profile
git reset --hard
git remote set-url origin ssh://git@github.com/forwardcomputers/dfiles.git
#
#sudo bash -c 'cp /etc/hosts /tmp/hosts.new && sed "s/^127.0.0.1.*/127.0.0.1\tlocalhost "$(cat /etc/hostname)"/" -i /tmp/hosts.new && cp -f /tmp/hosts.new /etc/hosts'
sudo bash -c '/usr/sbin/sshd -D'
