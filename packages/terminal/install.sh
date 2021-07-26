#!/bin/sh
#
# terminal 相关安装

## 树形目录
brew_install tree

## 简写跳转
brew_install autojump

## 安装 tmux
brew_install tmux

## 安装 fzf https://github.com/junegunn/fzf
brew_install fzf

# 这个命令自动化不太好，需要手动执行
# $(brew --prefix)/opt/fzf/install

## 主题
brew tap homebrew/cask-fonts
brew_install font-hack-nerd-font

open "$PWD/packages/terminal/Solarized Light.terminal"
open "$PWD/packages/terminal/Solarized Dark.terminal"
