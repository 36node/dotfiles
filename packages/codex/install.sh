#!/bin/bash
#
# Codex（OpenAI 终端 AI 编码助手）安装

## Codex CLI 由同目录 Brewfile 安装，命令为 `codex`
## 官方仓库：https://github.com/openai/codex

## ~/.codex/config.toml 真身放 vault（默认 iCloud Drive）跨机同步，不进 git
## 原因：codex 会持续回写 [projects."<绝对路径>"]、perPath、notice 等本机信息，
##       放进公开仓库会泄露本机路径和项目名
## 仓库只保留 config.example.toml，作为本机和 vault 都没有配置时的初始模板
## 旧方案的软链（直接链到仓库内 packages/codex/config.toml）由 vault_sync_home_template 迁移
vault_sync_home_template .codex/config.toml "$PWD/packages/codex/config.example.toml" \
  || warn "$HOME/.codex/config.toml 没有链接到 vault，按上面的提示处理后重跑 ./install.sh codex"

## 登录走 ChatGPT 官网账号（`codex login`），不要用 OPENAI_API_KEY
## 首次使用或换账号：在终端跑 `codex login`，桌面版在应用内 Sign in
