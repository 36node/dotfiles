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
. dotenv.sh

error "failed!!!!!!!!!!"
