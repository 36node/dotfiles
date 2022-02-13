#!/bin/sh
#
# node 相关安装

## nvm
brew_install nvm
mkdir -p ~/.nvm

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm" ] && \. "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

## node && yarn
nvm install 16
npm install --global yarn
npm install --global pnpm
