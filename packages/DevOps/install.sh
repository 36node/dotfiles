#!/bin/bash
#
# DevOps 相关软件安装

###############################################################################
# 安装一些必备软件
###############################################################################

brew_install aliyun-cli       # 阿里云
brew_install ansible
brew_install helm
brew_install k3sup
brew_install k9s              # Kubernetes TUI 管理工具
brew_install kubectx
brew_install kubernetes-cli
brew_install hidetatz/tap/kubecolor

## docker formula 提供独立的 docker / docker-compose CLI
## 注意：OrbStack 自带 docker CLI 和 compose 插件（启动时会 symlink 到 PATH），
##       两者并存有 PATH 优先级冲突。如果你只用 OrbStack，可以 brew uninstall docker
##       docker-compose 让本仓库脚本去掉这两行。如果你用 colima/podman 等替代 daemon，
##       则保留它们。
brew_install docker
brew_install docker-compose
brew_install lazydocker  # Docker TUI（lazygit 同作者，UX 一致）

## OrbStack：Docker Desktop 的轻量替代（更快启动、更省内存、原生 Apple Silicon）
## 同时也能跑 Linux 虚拟机
brew_cask_install orbstack