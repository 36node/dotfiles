#!/bin/bash
#
# Vault（私有文件保险柜）跨机同步辅助
#
# 用一个"vault 目录"承载"不进 git 但需要跨机器同步"的文件/目录。真身放 vault，
# 使用方处建立软链。
#
# vault 后端不限定 —— 凡是"会自动跨机器同步的目录"都行。常见选择：
#   iCloud Drive（默认）
#   Dropbox
#   Syncthing
#   OneDrive
#   Google Drive
#   一台机器自己的目录 + 自己写脚本 rsync 到 NAS / 服务器
#
# 用法：
#   vault_sync_file .env       # 仓库 .env       ←→ $DOTFILES_VAULT/.env
#   vault_sync_home .ssh       # 用户 home .ssh  ←→ $DOTFILES_VAULT/.ssh
#
# 自定义 vault 位置：
#   在执行 install.sh 之前 export 即可，例如：
#     export DOTFILES_VAULT="$HOME/Dropbox/.dotfiles"
#     export DOTFILES_VAULT="$HOME/Sync/.dotfiles"        # Syncthing
#     export DOTFILES_VAULT="$HOME/.dotfiles-vault"       # 纯本地（不同步）
#   不设置时，默认使用 macOS iCloud Drive。

# 默认 vault 路径：iCloud Drive 下的 .dotfiles 子目录（点开头，Finder 默认隐藏）
DEFAULT_VAULT="$HOME/Library/Mobile Documents/com~apple~CloudDocs/.dotfiles"
DOTFILES_VAULT="${DOTFILES_VAULT:-$DEFAULT_VAULT}"

# 检查 vault 目录是否就绪：父目录存在且可写
vault_ready() {
  local parent
  parent=$(dirname "$DOTFILES_VAULT")
  [ -d "$parent" ] || return 1
  local probe="$parent/.dotfiles_probe_$$"
  touch "$probe" 2>/dev/null || return 1
  rm -f "$probe"
  return 0
}

# 内部 helper：把指定本地路径与 vault 真身建立软链
# 行为：
#   - 本地有实体、vault 没有  → mv 本地实体到 vault，再建软链（首次迁移）
#   - 本地没有、vault 有       → 直接建软链（新机器）
#   - 已经是正确软链          → 跳过（幂等）
#   - vault 不可用            → warn 后跳过，不影响安装继续
# 参数：
#   $1: rel            vault 里的相对路径（如 ".env" 或 ".ssh"）
#   $2: local_path     本地预期路径（如 "$PWD/.env" 或 "$HOME/.ssh"）
_vault_sync() {
  local rel=$1
  local local_path=$2
  local vault_path="$DOTFILES_VAULT/$rel"

  if ! vault_ready; then
    warn "vault 目录不可用（$DOTFILES_VAULT），跳过 $rel 同步"
    return 1
  fi

  mkdir -p "$(dirname "$vault_path")"

  # 当 vault 是 iCloud Drive 时，文件可能被 macOS「优化 Mac 存储」evict 到云端，
  # 本地变成 dataless 占位符。任何 read syscall 都会让 APFS 自动从云端拉回，
  # 所以这里 cat 一遍触发 materialize。
  #
  # 对非 iCloud 的 vault（Dropbox / Syncthing / 本地等）这一步无害，只是多读了一遍文件。
  #
  # 局限：iCloud 下这只是"当下下载一次"，不能阻止之后再被 evict。
  # 持久方案：Finder → iCloud Drive → 找到 .dotfiles 目录 → 右键 → 「保留下载」。
  #          只钉这一个目录，不影响其他 iCloud 文件的优化策略。详见 README。
  if [ -e "$vault_path" ]; then
    find "$vault_path" -type f -exec cat {} \; >/dev/null 2>&1 || true
  fi

  sync_file "$vault_path" "$local_path"
}

# 把仓库内某个相对路径与 vault 同步（适合放仓库内"不进 git 的文件"）
# 例：vault_sync_file .env  →  $PWD/.env  ←→  $DOTFILES_VAULT/.env
vault_sync_file() {
  local rel=$1
  _vault_sync "$rel" "$PWD/$rel"
}

# 把用户 home 下某个相对路径与 vault 同步（适合放跨机器共享的 home 配置）
# 例：vault_sync_home .ssh  →  $HOME/.ssh  ←→  $DOTFILES_VAULT/.ssh
vault_sync_home() {
  local rel=$1
  _vault_sync "$rel" "$HOME/$rel"
}

# 修复 SSH 文件权限：dir 700、私钥 600、公钥 644
# 跨机同步（特别是 iCloud）有时会破坏 Unix 权限位，sshd 严格检查权限会拒绝使用 key
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
