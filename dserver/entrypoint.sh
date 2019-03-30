#!/bin/bash
set -e
#
if [[ ! -d "${HOME}"/.git ]]; then
    cd "${HOME}"
    git clone --recursive https://github.com/forwardcomputers/dfiles.git tmp > /dev/null 2>&1
    mv tmp/.git .
    rm -rf tmp/ .profile
    git reset --hard  > /dev/null 2>&1
    git remote set-url origin ssh://git@github.com/forwardcomputers/dfiles.git > /dev/null 2>&1
fi
#
sudo bash -c '/usr/sbin/sshd -De'
