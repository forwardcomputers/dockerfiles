#!/bin/bash
set -xe
#
if [[ ! -d "${HOME}"/.git ]]; then
    cd "${HOME}"
    git clone --recursive https://github.com/forwardcomputers/dfiles.git tmp
    mv tmp/.git .
    rm -rf tmp
    rm -rf tmp/ .profile
    git reset --hard
    git remote set-url origin ssh://git@github.com/forwardcomputers/dfiles.git
fi
#
sudo bash -c '/usr/sbin/sshd -Ded'
