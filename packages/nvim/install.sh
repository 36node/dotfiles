#!/bin/sh
#
# nvim 相关安装

## neovim
brew_install neovim

## LazyVim 依赖
brew_install ripgrep
brew_install fd

## LazyVim starter（如果 ~/.config/nvim 已存在则跳过，避免覆盖用户自定义）
if [ ! -d "$HOME/.config/nvim" ]; then
  message "克隆 LazyVim starter ..."
  git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
  rm -rf "$HOME/.config/nvim/.git"
  success "LazyVim starter 已就绪"
  echo ""
fi
