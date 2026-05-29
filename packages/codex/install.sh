#!/bin/bash
#
# Codex（OpenAI 终端 AI 编码助手）安装

## Codex CLI（通过 cask 分发，本质是 CLI 工具）
## 安装后命令为 `codex`
## 官方仓库：https://github.com/openai/codex
brew_cask_install codex

## 全量 symlink ~/.codex/config.toml：model / provider / 行为开关进 git
## 副作用：codex 会把以下内容自动写回 config.toml，产生 diff
##   - [projects."<path>"]    项目信任级别，绝对路径强机器相关
##   - [notice.*]             codex 已展示过的迁移/通知记录
## 处理方式：定期 commit 这些回写，或跨机时手动合并 projects 段
mkdir -p "$HOME/.codex"
sync_file "$PWD/packages/codex/config.toml" "$HOME/.codex/config.toml"

## 用 .env 里的 OPENAI_API_KEY 写入 ~/.codex/auth.json
## auth.json 是机器本地凭据（不进 git、不进 vault），但 key 本身走 .env（vault 同步）
## 已登录则跳过；要重登用 `codex logout && ./install.sh` 或手动 `codex login`
if [ -n "$OPENAI_API_KEY" ] && [ ! -s "$HOME/.codex/auth.json" ]; then
  message "用 .env 里的 OPENAI_API_KEY 登录 codex ..."
  printenv OPENAI_API_KEY | codex login --with-api-key \
    && success "codex 已登录" \
    || warn "codex login 失败，可手动 \`codex login\` 排查"
  echo ""
fi
