#!/bin/sh
#
# source everything here

# 当前 script 所在目录
realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

DOTFILES_DIR="$(dirname $(realpath "$0"))"
HOMEBREW_PREFIX=$(brew --prefix)

## 加载共享环境变量 .env（跨机器共享，通过 iCloud 同步）
ENV="$DOTFILES_DIR/.env"
if [ -f "$ENV" -o -L "$ENV" ]; then
  export $(cat $ENV | grep -v '#' | sed 's/\r$//' | awk '/=/ {print $1}' )
fi

## 加载本机覆盖 .env.local（机器特定，不进 git、不进 iCloud）
## 后于 .env 加载，同名变量会覆盖前者
ENV_LOCAL="$DOTFILES_DIR/.env.local"
if [ -f "$ENV_LOCAL" -o -L "$ENV_LOCAL" ]; then
  export $(cat $ENV_LOCAL | grep -v '#' | sed 's/\r$//' | awk '/=/ {print $1}' )
fi

## ruby
if [ -d "${HOMEBREW_PREFIX}/opt/ruby/bin" ]; then
  export PATH=${HOMEBREW_PREFIX}/opt/ruby/bin:$PATH
  export PATH=`gem environment gemdir`/bin:$PATH
fi

###############################################################################
# packages
###############################################################################

for package in `find $DOTFILES_DIR/packages -mindepth 1 -maxdepth 1 -type d`
do
  if [ -f "$package/source.zsh" ]; then
    . "$package/source.zsh"
  fi
done