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


###############################################################################
# packages 链接
###############################################################################
info '建立链接 packages/**/symlink.*'

overwrite_all=false backup_all=false skip_all=false
for src in $(find "$PWD/packages" -maxdepth 2 -name 'symlink.*')
do
  dst="$HOME/.${src##*.}"
  link_file "$src" "$dst"
done

###############################################################################
# packages 安装
###############################################################################
info '安装 packages/**/install.sh'

find ./packages -name install.sh | while read installer ; do sh -c "${installer}" ; done


###############################################################################
# 善后
###############################################################################
info '防止配置文件被 installer 修改'

git checkout head -- .
