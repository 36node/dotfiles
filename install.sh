#!/bin/sh
#
# 自动化安装

cd "$(dirname "$0")"

set -e

source $PWD/lib/echo.sh
source $PWD/lib/link.sh
source $PWD/lib/mac_version.sh
source $PWD/lib/brew.sh

cat $PWD/assets/ascii.txt

## TODO: 可以通过参数控制 -O
overwrite_all=true backup_all=false skip_all=false

###############################################################################
# 环境变量
###############################################################################

## icloud
export iCloud="$HOME/Library/Mobile Documents/com~apple~CloudDocs"

## TODO: 后面允许自行输入 private 数据存放地址
export PRIVATE="$iCloud/.dotfiles"

if [ ! -d "$PRIVATE" ]; then
  mkdir -p "$PRIVATE"
fi

## 从 private 恢复 env 文件
sync_file "$PRIVATE/.env" "$PWD/.env"

## 从 private 恢复 ssh 文件
sync_file "$PRIVATE/.ssh" "$PWD/packages/.ssh"
sync_file "$PRIVATE/.ssh" "$HOME/.ssh"

## 加载环境变量 .env
if [ -f ".env" -o -L ".env" ]; then
  source ".env"
fi

## 安装过程用到的环境变量
export ZSHRC=${ZSHRC:-$HOME/.zshrc}

###############################################################################
# 系统
#
# 1. homebrew
# 2. zsh && oh-my-zsh
# 3. brew & brew cask & mas
###############################################################################

## Xcode
if ! xcode-select --print-path &> /dev/null; then
  info "安装 build/install tools ..."
  xcode-select --install &> /dev/null;
  success "安装成功 build/install tools"

fi

## homebrew
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

## zsh
if [[ $SHELL != $(which zsh) ]]; then
  chsh -s $(which zsh)
  export SHELL=$(which zsh)
fi

## oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

## 第三方插件
brew_install zsh-completions # 补全
brew_install zsh-autosuggestions # 提示
brew_install zsh-syntax-highlighting # 高亮

## https://github.com/Powerlevel9k/powerlevel9k
brew tap sambadevi/powerlevel9k
brew_install powerlevel9k

## https://github.com/ryanoasis/nerd-fonts
brew tap homebrew/cask-fonts
brew_cask_install font-hack-nerd-font

## zshrc
link_file "$PWD/.zshrc" "$ZSHRC"

###############################################################################
# packages 安装
###############################################################################
info '安装 packages/**/install.sh'

for installer in $(find "$PWD/packages" -maxdepth 2 -name 'install.sh')
do
  . "$installer"
done


###############################################################################
# packages 链接
###############################################################################
info '建立链接 packages/**/*.symlink'

for src in $(find "$PWD/packages" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
do
  dst="$HOME/.$(basename "${src%.*}")"
  link_file "$src" "$dst"
done

###############################################################################
# 安装其他无需配置的系统软件
###############################################################################

brew_install mas
brew_install kubernetes-cli

brew_cask_install mos
brew_cask_install docker

###############################################################################
# 当前 shell 就起作用
###############################################################################

source ~/.zshrc