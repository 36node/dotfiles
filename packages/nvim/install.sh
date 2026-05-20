#!/bin/bash
#
# nvim 相关安装

## neovim
brew_install neovim

## LazyVim 依赖
brew_install ripgrep
brew_install fd

## 链接 nvim 配置（基于 LazyVim，自定义内容在 packages/nvim/config/）
mkdir -p "$HOME/.config"
link_file "$PWD/packages/nvim/config" "$HOME/.config/nvim"
