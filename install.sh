#!/bin/sh
#
# 自动化安装

cd "$(dirname "$0")"

set -e

source $PWD/lib/echo.sh
source $PWD/lib/link.sh
source $PWD/lib/mac_version.sh

cat $PWD/assets/ascii.txt

## 采用 dotenv 加载环境变量 https://github.com/madcoda/dotenv-shell
. dotenv.sh

## 安装过程用到的环境变量
export ZSHRC=${ZSHRC:-$HOME/.zshrc}


## TODO: 可以通过参数控制 -O
overwrite_all=true backup_all=false skip_all=false


###############################################################################
# 系统必要文件
# 1. zsh
# 2. brew & brew cask & mas
###############################################################################
link_file "$PWD/.zshrc" "$ZSHRC"


###############################################################################
# packages 安装
###############################################################################
info '安装 packages/**/install.sh'

find ./packages -name install.sh | while read installer ; do sh -c "${installer}" ; done


###############################################################################
# packages 链接
###############################################################################
info '建立链接 packages/**/symlink.*'

for src in $(find "$PWD/packages" -maxdepth 2 -name 'symlink.*')
do
  dst="$HOME/.${src##*.}"
  link_file "$src" "$dst"
done

###############################################################################
# 善后
###############################################################################
info ''

