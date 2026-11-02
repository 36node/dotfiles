#!/bin/bash

# 只同步 Vault 密码，Ansible 缓存和插件保留在本机。
sync_ansible_vault_password() {
  local password_file="$HOME/.ansible/.vault_pass"
  local vault_file="$DOTFILES_VAULT/.ansible/.vault_pass"

  # 不生成新密码，也不在两端都缺失时创建悬空链接。
  if [ ! -e "$password_file" ] && [ ! -e "$vault_file" ]; then
    warn "未找到 Ansible Vault 密码，跳过同步"
    return 0
  fi

  # 密码冲突不能交给通用覆盖选项处理。
  if [ -L "$password_file" ] && [ "$(readlink "$password_file")" != "$vault_file" ]; then
    warn "Ansible Vault 密码已有其他软链接，跳过同步"
    return 1
  fi
  if [ -e "$password_file" ] && [ -e "$vault_file" ] && [ ! -L "$password_file" ]; then
    warn "本机和 vault 都有 Ansible Vault 密码，请先处理冲突"
    return 1
  fi
  vault_ready || { warn "vault 不可用，跳过 Ansible Vault 密码同步"; return 1; }
  mkdir -p "$HOME/.ansible" "$DOTFILES_VAULT/.ansible"
  chmod 700 "$HOME/.ansible" "$DOTFILES_VAULT/.ansible"
  # 迁移前即收紧权限。
  [ ! -e "$password_file" ] || chmod 600 "$password_file"
  [ ! -e "$vault_file" ] || chmod 600 "$vault_file"
  vault_sync_home .ansible/.vault_pass || return 1
  chmod 600 "$password_file"
}

sync_ansible_vault_password
