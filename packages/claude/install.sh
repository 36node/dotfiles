#!/bin/bash
#
# Claude Code（Anthropic 终端 AI 编码助手）安装

## Claude Code CLI 由同目录 Brewfile 安装，命令为 `claude`
## token 等敏感配置通过 .env 注入（见仓库根 README）
## 官方文档：https://docs.claude.com/en/docs/claude-code/overview

## 全局 ~/.claude/settings.json 真身放 vault（默认 iCloud Drive）跨机同步，不进 git
## 原因：Claude Code 会持续回写这个文件（/model、/config、通知开关、插件、权限放行等），
##       直接软链到公开仓库会不断产生回写提交，放行规则里还可能带上本机路径
## 仓库只保留 settings.example.json（模型、权限模式、deny 列表），作为本机和 vault 都没有配置时的初始模板
## 旧方案的软链（直接链到仓库内 packages/claude/settings.json）由 vault_sync_home_template 迁移
## 敏感字段（ANTHROPIC_AUTH_TOKEN / BASE_URL / API_TIMEOUT_MS）走 .env，不写在这
vault_sync_home_template .claude/settings.json "$PWD/packages/claude/settings.example.json" \
  || warn "$HOME/.claude/settings.json 没有链接到 vault，按上面的提示处理后重跑 ./install.sh claude"
