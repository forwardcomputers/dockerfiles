#!/bin/bash
set -xe
#
cd "${HOME}"
git clone --recursive https://github.com/forwardcomputers/dfiles.git tmp
mv tmp/.git .
rm -rf tmp
rm -rf tmp/ .profile
git reset --hard
git remote set-url origin ssh://git@github.com/forwardcomputers/dfiles.git
#
sudo cp /etc/hosts ~/hosts.new && sed "s/^127.0.0.1.*/127.0.0.1\tlocalshost "$(cat /etc/hostname)"/" -i ~/hosts.new && cp -f ~/hosts.new /etc/hosts
sudo /usr/sbin/sshd -D
