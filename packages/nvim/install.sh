#!/bin/bash
#
# nvim 相关安装

## neovim / ripgrep / fd / macism 由同目录 Brewfile 安装

## 链接 nvim 配置（基于 LazyVim，自定义内容在 packages/nvim/config/）
mkdir -p "$HOME/.config"
link_file "$PWD/packages/nvim/config" "$HOME/.config/nvim"
