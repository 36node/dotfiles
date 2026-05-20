#!/bin/bash
#
# Claude Code（Anthropic 终端 AI 编码助手）安装

## Claude Code CLI（通过 cask 分发，本质是 CLI 工具）
## 安装后命令为 `claude`，token 等敏感配置通过 .env 注入（见仓库根 README）
## 官方文档：https://docs.claude.com/en/docs/claude-code/overview
brew_cask_install claude-code

## 全局 settings.json：模型、权限模式、deny 列表（屏蔽 .env / .secrets）
## 敏感字段（ANTHROPIC_AUTH_TOKEN / BASE_URL / API_TIMEOUT_MS）走 .env，不写在这
mkdir -p "$HOME/.claude"
link_file "$PWD/packages/claude/settings.json" "$HOME/.claude/settings.json"
