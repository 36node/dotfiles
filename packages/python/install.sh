#!/bin/bash
#
# python 相关安装

## pyenv
brew_install pyenv
[ ! -d "$(pyenv root)/versions/3.14.0" ] && pyenv install 3.14.0
pyenv global 3.14.0
echo ""
