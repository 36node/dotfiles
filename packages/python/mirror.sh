#!/bin/bash
#
# pyenv 下载 Python 源码的镜像：npmmirror（https://registry.npmmirror.com/binary.html?path=python/）
#
# install.sh（bash）和 source.zsh（zsh）都 source 本文件，镜像地址只写这一处
# 国内直连 www.python.org 实测十几 KB/s，一个源码包二十多 MB 要下二十多分钟
#
# python-build 的规则：
#   - 设了 PYTHON_BUILD_MIRROR_URL_SKIP_CHECKSUM，就把官方地址里的 www.python.org/ftp/python
#     换成 PYTHON_BUILD_MIRROR_URL，即 <mirror>/3.14.0/Python-3.14.0.tar.xz
#   - 下载后仍按 pyenv 内置的 sha256 校验，镜像给的文件不对会直接报错
#
# 不需要镜像（如海外）：把下面两行注释掉即可

export PYTHON_BUILD_MIRROR_URL="https://registry.npmmirror.com/-/binary/python"
export PYTHON_BUILD_MIRROR_URL_SKIP_CHECKSUM=1
