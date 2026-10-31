#!/bin/bash
#
# Codex（OpenAI 终端 AI 编码助手）安装

## Codex CLI 由同目录 Brewfile 安装，命令为 `codex`
## 官方仓库：https://github.com/openai/codex

## ~/.codex/config.toml 真身放 vault（默认 iCloud Drive）跨机同步，不进 git
## 原因：codex 会持续回写 [projects."<绝对路径>"]、perPath、notice 等本机信息，
##       放进公开仓库会泄露本机路径和项目名
## 仓库只保留 config.example.toml，作为本机和 vault 都没有配置时的初始模板
codex_config="$HOME/.codex/config.toml"
mkdir -p "$HOME/.codex"

## 不是指向 vault 的软链（典型是旧方案：直接软链到仓库内 packages/codex/config.toml；
## 也可能是仓库搬过家后的旧路径或别的手工链接），先处理掉，否则 vault 同步会把软链本身挪进 vault：
##   - 链接目标还在 → 转成实体文件，下面 vault 同步会把它挪进 vault
##   - 悬空链接（例如另一台机器 pull 之后仓库文件已删）→ 删掉，直接链到 vault 或用模板初始化
vault_config="$DOTFILES_VAULT/.codex/config.toml"
if [ -L "$codex_config" ] && [ "$(readlink "$codex_config")" != "$vault_config" ]; then
  if [ -f "$codex_config" ]; then
    cp -L "$codex_config" "$codex_config.tmp" && mv -f "$codex_config.tmp" "$codex_config"
  else
    rm -f "$codex_config"
  fi
fi

## 本机和 vault 都没有时，用模板初始化（悬空的 vault 链接也先删掉，免得 cp 写穿到不存在的目录）
if [ ! -e "$codex_config" ] && [ ! -e "$vault_config" ]; then
  rm -f "$codex_config"
  cp "$PWD/packages/codex/config.example.toml" "$codex_config"
  success "用 config.example.toml 初始化 $codex_config"
fi

vault_sync_home .codex/config.toml \
  || warn "$codex_config 没有链接到 vault，按上面的提示处理后重跑 ./install.sh codex"

## 登录走 ChatGPT 官网账号（`codex login`），不要用 OPENAI_API_KEY
## 首次使用或换账号：在终端跑 `codex login`，桌面版在应用内 Sign in
