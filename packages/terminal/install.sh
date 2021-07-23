#!/bin/sh
#
# terminal 相关安装

## 树形目录
brew_install tree

## 简写跳转
brew_install autojump

## 安装 tmux
brew_install tmux

## 主题
brew tap homebrew/cask-fonts
brew_install font-hack-nerd-font

open "$PWD/packages/terminal/Solarized Light.terminal"
open "$PWD/packages/terminal/Solarized Dark.terminal"
