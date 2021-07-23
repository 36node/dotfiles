#!/bin/sh
#
# node 相关安装

## nvm
brew_install nvm
mkdir ~/.nvm

## node && yarn
nvm install 15
npm install --global yarn

## create links
link_file "$PWD/node/npmrc.symlink" "$HOME/.npmrc"
