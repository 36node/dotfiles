#!/bin/bash
#
# node 相关安装

## fnm (Fast Node Manager)
brew_install fnm

## 让本次安装会话内 fnm 可用，以便后续 fnm install/use 命令生效
eval "$(fnm env --shell bash)"

## node 24（设为 default，新 shell 自动使用）
## 用 fnm list 判断是否已装，避免每次跑都跳出 "Version already installed" warning
fnm list 2>/dev/null | grep -q 'v24\.' || fnm install 24
fnm default 24
fnm use 24

## yarn / pnpm 通过 corepack 管理（Node 自带）
corepack enable
corepack prepare pnpm@latest --activate
corepack prepare yarn@stable --activate
echo ""
