#!/bin/sh
#
# brew

brew_install() {
  message "安装 ${1} ..."
  brew list $1 &>/dev/null || brew install $1
  success "安装成功 ${1}"
  echo ""
}

brew_cask_install() {
  message "安装 ${1} ..."
  brew list --cask $1 &>/dev/null || brew install --cask $1
  success "安装成功 ${1}"
  echo ""
}