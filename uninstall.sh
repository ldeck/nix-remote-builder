#!/usr/bin/env bash

SSHHOME="${HOME}/.ssh"
SSHCONFIG="${SSHHOME}/config"

SAMPLE_CONFIG="./files/ssh-config"

set -x

NIX_CONTAINER=$(docker ps | grep nix-docker | awk '{print $1}')
if ! [ -z "$NIX_CONTAINER" ]; then
    docker stop $NIX_CONTAINER && docker rm $_
fi

rm -f ~/.ssh/docker_rsa

if [ -f $SSHCONFIG ]; then
    LINE=$(grep -n -m 1 nix-docker ~/.ssh/config | sed  's/\([0-9]*\).*/\1/')
    if ! [ -z "$LINE" ]; then
        COUNT=$(cat $SAMPLE_CONFIG | wc -l)
        MAX=$((LINE + COUNT))
        sed -i '.bak' -e "${LINE},${MAX}d" $SSHCONFIG
    fi
fi

rm -f ~/.nix/remote-build-env
rm -f ~/.nix/remote-systems.conf
rm -rf ~/.nix/keys/
