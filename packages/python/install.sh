#!/bin/sh
#
# python 相关安装

## pyenv
brew_install pyenv
[ -d "$(pyenv root)/versions/3.8.5" ]
pyenv global 3.8.5
