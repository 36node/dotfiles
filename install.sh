#!/bin/sh
#
# 自动化安装

cd "$(dirname "$0")/."

set -e

source $PWD/lib/echo.sh
source $PWD/lib/link.sh
source $PWD/lib/mac_version.sh

cat $PWD/assets/ascii.txt

## 采用 dotenv 加载环境变量 https://github.com/madcoda/dotenv-shell
if [ ! -x "/usr/local/bin/dotenv" ]; then
  curl https://raw.githubusercontent.com/madcoda/dotenv-shell/master/dotenv.sh > /usr/local/bin/dotenv
  chmod +x /usr/local/bin/dotenv
fi

. dotenv

error "failed!!!!!!!!!!"
