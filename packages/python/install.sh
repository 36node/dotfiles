#!/bin/sh
#
# python 相关安装

## pyenv
brew_install pyenv
[ ! -d "$(pyenv root)/versions/3.10.1" ] && pyenv install 3.10.1
pyenv global 3.10.1
