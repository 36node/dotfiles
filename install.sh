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
source $PWD/lib/env.sh
source $PWD/help.sh

overwrite_all=false backup_all=false skip_all=false
single_package=""

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
		-*)
			echo "Invalid option: $1"
			displayUsage
      exit
			;;
		*)
			if [ -n "$single_package" ]; then
				error "目前只支持单个 package 参数（已收到 '$single_package'，又来 '$1'）"
			fi
			single_package="$1"
			;;
	esac
	shift
done

###############################################################################
# 单 package 快速模式
#   ./install.sh <package>
#   仅装该 package（它的 Brewfile + install.sh），跳过系统引导（sudo/xcode/brew bootstrap）与根 Brewfile
#   仍加载 .env / .env.local，因为 package 内部可能用到 token（如 codex）
###############################################################################

if [ -n "$single_package" ]; then
  pkg_dir="packages/$single_package"
  [ -d "$pkg_dir" ]            || error "未知 package: ${single_package}（packages/ 下找不到）"
  [ -f "$pkg_dir/Brewfile" ] || [ -f "$pkg_dir/install.sh" ] \
    || error "${pkg_dir} 既没有 Brewfile 也没有 install.sh"

  load_env .env
  load_env .env.local
  export ZSHRC=${ZSHRC:-$HOME/.zshrc}
  export WORKSPACE=${WORKSPACE:-$HOME/Workspace}
  export COMPUTER_NAME=${COMPUTER_NAME:-$USER}

  echo "***************************************"
  message "单独安装 $pkg_dir"
  echo "***************************************"
  echo ""
  [ -f "$pkg_dir/Brewfile" ] && brew_bundle "$pkg_dir/Brewfile"
  [ -f "$pkg_dir/install.sh" ] && . "$pkg_dir/install.sh"
  success "完成 $single_package"
  exit 0
fi

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
load_env .env

## 加载本机覆盖 .env.local（机器特定，不进 git、不进 vault）
## 后于 .env 加载，同名变量会覆盖前者
load_env .env.local

## 安装过程用到的环境变量
export ZSHRC=${ZSHRC:-$HOME/.zshrc}
export WORKSPACE=${WORKSPACE:-$HOME/Workspace}
export COMPUTER_NAME=${COMPUTER_NAME:-$USER}

###############################################################################
# 加载 install.conf（可选）
#   - 文件缺失：装全部 packages + 询问 extra（原行为）
#   - 文件存在但没定义 PACKAGES：装全部 packages（容错）
#   - PACKAGES=(a b)：只装这些
#   - PACKAGES=()  ：装零个（尊重显式空数组）
#   - INSTALL_EXTRA=true|false：跳过询问；留空保持原交互
# 模板见 install.conf.example，本文件不进 git
###############################################################################

if [ -f install.conf ]; then
  message "加载 install.conf"
  . ./install.conf
  echo ""
fi

# 用户没在 conf 里定义 PACKAGES 时，默认装全部
if ! declare -p PACKAGES &>/dev/null; then
  PACKAGES=()
  while IFS= read -r dir; do
    PACKAGES+=("$(basename "$dir")")
  done < <(find packages -mindepth 1 -maxdepth 1 -type d | sort)
fi

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
      || warn "无法自动清理 ${SUDOERS_TMP}，请手动 sudo rm 它"
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

## 软件清单见根目录 Brewfile（各 package 的在 packages/<name>/Brewfile）
brew_bundle Brewfile

###############################################################################
# packages 安装
###############################################################################

message "安装 packages（共 ${#PACKAGES[@]} 个）..."
echo ""

for pkg in "${PACKAGES[@]}"; do
  pkg_dir="packages/$pkg"
  echo "***************************************"
  message "安装插件包 $pkg_dir"
  echo "***************************************"
  echo ""

  if [ ! -d "$pkg_dir" ]; then
    warn "$pkg_dir 不存在，跳过（检查 install.conf 里的 PACKAGES 拼写）"
    echo ""
    continue
  fi

  ## 先装软件（Brewfile），再做配置（install.sh），后者可能依赖前者装好的命令
  [ -f "$pkg_dir/Brewfile" ] && brew_bundle "$pkg_dir/Brewfile"
  [ -f "$pkg_dir/install.sh" ] && . "$pkg_dir/install.sh"
  if [ ! -f "$pkg_dir/Brewfile" ] && [ ! -f "$pkg_dir/install.sh" ]; then
    warn "$pkg_dir 既没有 Brewfile 也没有 install.sh，跳过"
    echo ""
  fi
done

###############################################################################
# 其他
###############################################################################

## 选装软件 Brewfile.extra
## INSTALL_EXTRA 由 install.conf 控制：true/false 跳过询问，留空保持原交互
if [ -f Brewfile.extra ]; then
	case "${INSTALL_EXTRA:-}" in
		true|TRUE|yes|YES|y|Y|1)
			message "安装 extra apps（由 install.conf 指定）..."
			echo ""
			brew_bundle Brewfile.extra
			;;
		false|FALSE|no|NO|n|N|0)
			message "跳过 extra apps（由 install.conf 指定）"
			echo ""
			;;
		"")
			ask "Do you want to install extra apps?\n\
			[y]yes, [n]no"
			read -n 1 action

			case "$action" in
				y )
					brew_bundle Brewfile.extra;;
				* )
					;;
			esac
			;;
		*)
			warn "INSTALL_EXTRA 值无效（'$INSTALL_EXTRA'），按未设置处理"
			ask "Do you want to install extra apps?\n\
			[y]yes, [n]no"
			read -n 1 action
			case "$action" in
				y ) brew_bundle Brewfile.extra ;;
				* ) ;;
			esac
			;;
	esac
fi

## 添加 source
append_block "$ZSHRC" "# source dotfiles" "source $PWD/source.zsh"

warn "成功安装 dotfiles，请重启电脑！"
