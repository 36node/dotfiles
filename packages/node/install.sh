#!/bin/sh
#
# node 相关安装

## nvm
brew_install nvm
mkdir -p ~/.nvm

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"

## node && yarn
nvm install 15
npm install --global yarn

## create links
link_file "$PWD/packages/node/npmrc.symlink" "$HOME/.npmrc"
