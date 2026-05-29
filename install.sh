#!/bin/bash
#
# 自动化安装

cd "$(dirname "$0")"

set -e

source $PWD/lib/echo.sh
source $PWD/lib/append.sh
source $PWD/lib/link.sh
source $PWD/lib/brew.sh
source $PWD/lib/vault.sh
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

## 通过 vault 同步 .env（真身放 $DOTFILES_VAULT，仓库内是软链）
## vault 默认是 iCloud Drive，可通过 export DOTFILES_VAULT=... 改成 Dropbox/Syncthing 等
## 详见 README 「跨机同步：vault 设计」
vault_sync_file .env

## 通过 vault 同步 ~/.ssh 目录（含私钥）
## 安全提示：iCloud Drive / Dropbox 等都不是端到端加密，详见 README 「.ssh 跨机同步」
vault_sync_home .ssh
fix_ssh_permissions

## 加载共享环境变量 .env（跨机器共享，通过 vault 同步）
if [ -f .env ]; then
  export $(cat .env | grep -v '#' | sed 's/\r$//' | awk '/=/ {print $1}' )
fi

## 加载本机覆盖 .env.local（机器特定，不进 git、不进 vault）
## 后于 .env 加载，同名变量会覆盖前者
if [ -f .env.local ]; then
  export $(cat .env.local | grep -v '#' | sed 's/\r$//' | awk '/=/ {print $1}' )
fi

## 安装过程用到的环境变量
export ZSHRC=${ZSHRC:-$HOME/.zshrc}
export WORKSPACE=${WORKSPACE:-$HOME/Workspace}
export COMPUTER_NAME=${COMPUTER_NAME:-$USER}

###############################################################################
# 装机必备的系统级软件
# 0. xcode-tools
# 1. homebrew
# 2. zsh
###############################################################################

# ---------------------------------------------------------------------------
# 一次性获取 sudo 权限，整个脚本期间所有 sudo 命令免密
# ---------------------------------------------------------------------------
# 策略：临时写一条 NOPASSWD 的 sudoers 规则到 /etc/sudoers.d/，脚本结束自动清理。
# 收益：脚本里所有 sudo 命令（scutil、dscl 等）零密码；只在第一次 sudo tee 时输一次。
# 安全：trap EXIT/INT/TERM 保证正常退出、Ctrl+C、异常崩溃都会清理 sudoers 文件。
# 局限：brew 装某些 cask（orbstack 等）会通过 macOS GUI 弹原生密码框
#       要管理员权限去装系统 helper，那是 osascript 路径，绕不开。
SUDOERS_TMP="/etc/sudoers.d/dotfiles-install-$$"
cleanup_sudoers() {
  if [ -f "$SUDOERS_TMP" ]; then
    sudo -n rm -f "$SUDOERS_TMP" 2>/dev/null \
      || warn "无法自动清理 $SUDOERS_TMP，请手动 sudo rm 它"
  fi
}
trap cleanup_sudoers EXIT INT TERM

message "请输入管理员密码（接下来整个安装过程仅此一次）"
echo "$USER ALL=(ALL) NOPASSWD: ALL" \
  | sudo tee "$SUDOERS_TMP" > /dev/null
sudo chmod 440 "$SUDOERS_TMP"

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
brew_install autossh  # SSH 隧道断线自动重连，配合 ~/.ssh/config 的 LocalForward 用（替代已下架的 secure-pipes）
brew_install gemini-cli  # Google Gemini CLI

## 媒体/压缩通用工具（yazi 的预览功能也依赖这几个）
brew_install ffmpeg
brew_install imagemagick
brew_install poppler  # 提供 pdftotext / pdftoppm，PDF 处理 + yazi PDF 预览
brew_install sevenzip  # 7z 压缩工具

## 编辑器 / AI 开发工具
## 注：claude-code / codex 已移到 packages/<name>/install.sh
brew_cask_install visual-studio-code

## 浏览器 / Git / API
brew_cask_install github
brew_cask_install google-chrome
brew_cask_install postman

## macOS 体验增强
brew_cask_install keyclu          # 长按 Cmd 显示快捷键（替代已下架的 cheatsheet）
brew_cask_install monitorcontrol  # 用键盘控制外接显示器亮度/音量（macOS 自身不支持非 Apple 屏）
brew_cask_install mos             # 鼠标平滑滚动 + 反向

## 通讯
brew_cask_install feishu          # 飞书
brew_cask_install wechat          # 微信

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
    warn "$package 没有 install.sh，跳过"
    echo ""
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
