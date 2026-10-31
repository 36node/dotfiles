#!/bin/bash
#
# python 相关安装

## pyenv 由同目录 Brewfile 安装
## 下载 Python 源码走国内镜像（见同目录 mirror.sh）
. "$PWD/packages/python/mirror.sh"
[ ! -d "$(pyenv root)/versions/3.14.0" ] && pyenv install 3.14.0
pyenv global 3.14.0
echo ""
