#!/bin/bash
#
# iCloud Drive 同步辅助
#
# 把"不进 git 但需要跨机器同步"的文件/目录通过 iCloud Drive 同步：
# 真身放 iCloud，使用方处建立软链。
#
# 用法：
#   icloud_sync_file .env       # 仓库 .env       ←→ iCloud Drive/.dotfiles/.env
#   icloud_sync_home .ssh       # 用户 home .ssh  ←→ iCloud Drive/.dotfiles/.ssh

# iCloud Drive 在 macOS 上的固定本地路径（自 Sierra 起稳定）
ICLOUD_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs"

# 本仓库专用的子目录（点开头，在 Finder 中默认隐藏）
ICLOUD_DOTFILES_DIR="$ICLOUD_DIR/.dotfiles"

# 检查 iCloud Drive 是否就绪：目录存在且可写
icloud_ready() {
  [ -d "$ICLOUD_DIR" ] || return 1
  local probe="$ICLOUD_DIR/.dotfiles_probe_$$"
  touch "$probe" 2>/dev/null || return 1
  rm -f "$probe"
  return 0
}

# 内部 helper：把指定本地路径与 iCloud Drive 真身建立软链
# 行为：
#   - 本地有实体、iCloud 没有  → mv 本地实体到 iCloud，再建软链（首次迁移）
#   - 本地没有、iCloud 有       → 直接建软链（新机器）
#   - 已经是正确软链           → 跳过（幂等）
#   - iCloud 不可用            → warn 后跳过，不影响安装继续
# 参数：
#   $1: rel            iCloud 里的相对路径（如 ".env" 或 ".ssh"）
#   $2: local_path     本地预期路径（如 "$PWD/.env" 或 "$HOME/.ssh"）
_icloud_sync() {
  local rel=$1
  local local_path=$2
  local icloud_path="$ICLOUD_DOTFILES_DIR/$rel"

  if ! icloud_ready; then
    warn "iCloud Drive 未启用或不可写，跳过 $rel 同步"
    return 1
  fi

  mkdir -p "$(dirname "$icloud_path")"

  # 触发 dataless 文件 materialize（从 iCloud 云端拉回到本地）。
  #
  # 现代 macOS（Sequoia/Tahoe）的 brctl 已经没有 pin/download 子命令，
  # Apple 把 pin 操作只保留在 Finder GUI（右键 → 始终保留本地副本）里。
  # 命令行只能"读触发" —— 任何对 dataless 文件的 read syscall 都会让 APFS
  # 自动把它从 iCloud 拉回到本地。
  #
  # 这对 ~/.ssh 尤其关键：ssh 进程因 macOS TCC 沙盒无法触发 iCloud 拉回，
  # 一旦 known_hosts / 私钥被 evict 到云端，git push / ssh 等会报
  # "Operation not permitted"。我们在 install 时主动读一遍把它们拉下来。
  #
  # 局限：这只是"当下下载一次"，不能阻止 macOS 之后再 evict 回云端。
  # 持久解决方案是在 Finder 里给真身目录设置「始终保留本地副本」，
  # 或在系统设置 → iCloud Drive 关闭「优化 Mac 存储」。详见 README。
  if [ -e "$icloud_path" ]; then
    find "$icloud_path" -type f -exec cat {} \; >/dev/null 2>&1 || true
  fi

  sync_file "$icloud_path" "$local_path"
}

# 把仓库内某个相对路径与 iCloud 同步（适合放仓库内"不进 git 的文件"）
# 例：icloud_sync_file .env  →  $PWD/.env  ←→  iCloud Drive/.dotfiles/.env
icloud_sync_file() {
  local rel=$1
  _icloud_sync "$rel" "$PWD/$rel"
}

# 把用户 home 下某个相对路径与 iCloud 同步（适合放跨机器共享的 home 配置）
# 例：icloud_sync_home .ssh  →  $HOME/.ssh  ←→  iCloud Drive/.dotfiles/.ssh
icloud_sync_home() {
  local rel=$1
  _icloud_sync "$rel" "$HOME/$rel"
}

# 修复 SSH 文件权限：dir 700、私钥 600、公钥 644
# iCloud 同步后权限位有时会被破坏，sshd 严格检查权限会拒绝使用 key
fix_ssh_permissions() {
  local ssh_dir="${1:-$HOME/.ssh}"
  [ -d "$ssh_dir" ] || return 0

  chmod 700 "$ssh_dir" 2>/dev/null || true
  # 公钥（*.pub）644
  find "$ssh_dir" -maxdepth 1 -type f -name "*.pub" \
    -exec chmod 644 {} \; 2>/dev/null || true
  # 其余顶层文件（私钥、known_hosts、config 等）600
  find "$ssh_dir" -maxdepth 1 -type f ! -name "*.pub" \
    -exec chmod 600 {} \; 2>/dev/null || true
}
