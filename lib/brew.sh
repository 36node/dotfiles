brew_install() {
  info "安装 ${1} ..."
  brew list $1 &>/dev/null || brew install $1
  success "安装成功 ${1}"
}

brew_cask_install() {
  info "安装 ${1} ..."
  brew cask list $1 &>/dev/null || brew cask install $1
  success "安装成功 ${1}"
}