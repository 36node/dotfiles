#!/bin/sh
#
# 自动化安装

cd "$(dirname "$0")"

set -e

source $PWD/lib/echo.sh
source $PWD/lib/append.sh
source $PWD/lib/link.sh
source $PWD/lib/mac_version.sh
source $PWD/lib/brew.sh
source $PWD/help.sh

overwrite_all=false backup_all=false skip_all=false

while test $# -gt 0; do
	case "$1" in
		"-h"|"--help")
			displayUsage
			exit
			;;
		"-o"|"--overwrite")
			overwrite_all=true
			;;
		"-b"|"--backup")
			backup_all=true
			;;
		"-s"|"--skip")
			skip_all=true
			;;
		*)
			echo "Invalid option: $1"
			displayUsage
      exit
			;;
	esac
	shift
done

cat $PWD/assets/ascii.txt

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
export WORKSPACE=${WORKSPACE:-$HOME/Workspace}
export COMPUTER_NAME=${COMPUTER_NAME:-$USER}

###############################################################################
# 系统
# 0. xcode-tools
# 1. homebrew
# 2. zsh && oh-my-zsh
###############################################################################

# 预先循问管理员密码
sudo -v

# 保持活跃状态，直到完成
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

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
. zsh.sh

###############################################################################
# 安装其他无需配置的软件
###############################################################################

brew_install git
brew_install mas
brew_install kubernetes-cli

brew_cask_install cheatsheet
brew_cask_install docker
brew_cask_install github
brew_cask_install go2shell
brew_cask_install google-chrome
brew_cask_install mos
brew_cask_install secure-pipes
brew_cask_install spectacle
brew_cask_install visual-studio-code
brew_cask_install wechatwebdevtools

mas install 836500024     # 微信
mas install 1189898970    # 企业微信
mas install 409201541     # Pages
mas install 409203825     # Numbers
mas install 409183694     # Keynote


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
# 其他
###############################################################################

. extra.sh
warn "成功安装 dotfiles，请重启电脑！"




