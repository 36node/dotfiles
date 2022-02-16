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

## 加载环境变量文件 .env
if [ -f .env ]; then
  export $(cat .env | grep -v '#' | sed 's/\r$//' | awk '/=/ {print $1}' )
fi

## 安装过程用到的环境变量
export ZSHRC=${ZSHRC:-$HOME/.zshrc}
export WORKSPACE=${WORKSPACE:-$HOME/Workspace}
export COMPUTER_NAME=${COMPUTER_NAME:-$USER}

###############################################################################
# 装机必备的系统级软件
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
  message "安装 build/install tools ..."
  xcode-select --install &> /dev/null;
  success "安装成功 build/install tools"
fi

## homebrew
if test ! $(which brew); then
  message "安装 homebrew ..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	# for M1
	if [ -s /opt/homebrew/bin/brew ]; then
		echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi
  success "安装成功 homebrew"
fi

###############################################################################
# 安装一些必备软件
###############################################################################

brew_install git
brew_install gh
brew_install jq
brew_install mas
brew_install ruby
brew_install wget

brew_cask_install cheatsheet
brew_cask_install github
brew_cask_install go2shell
brew_cask_install google-chrome
brew_cask_install mos
brew_cask_install postman
brew_cask_install secure-pipes
brew_cask_install visual-studio-code
brew_cask_install feishu # 飞书
brew_cask_install wechat # 微信

###############################################################################
# packages 安装
###############################################################################

message '安装 packages ...'
echo ""

for package in `find packages -mindepth 1 -maxdepth 1 -type d`
do
		echo "***************************************"
		message "安装插件包 $package"
		echo "***************************************"
		echo ""

		if [ -f "$package/install.sh" ]; then
    	. "$package/install.sh"
		else 
			echo "install.sh does not exist."
		fi
done

###############################################################################
# 其他
###############################################################################

## 加载额外的 extra.sh
if [ -f extra.sh ]; then
	ask "Do you want to install extra apps?\n\
	[y]yes, [n]no"
	read -n 1 action

	case "$action" in
		y )
			. extra.sh;;
		* )
			;;
	esac
fi

## 添加 source
append "# source dotfiles" "$ZSHRC"
append "source $PWD/source.zsh" "$ZSHRC"

warn "成功安装 dotfiles，请重启电脑！"
