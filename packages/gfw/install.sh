#!/bin/sh
#
# 翻墙

brew_install proxychains-ng
brew_install shadowsocksx-ng
brew_install clashx

## 从 private 数据恢复 配置
sync_file "$PRIVATE/com.qiuyuzhou.ShadowsocksX-NG.plist" "$HOME/Library/Preferences/com.qiuyuzhou.ShadowsocksX-NG.plist"

## create links
link_file "./ShadowsocksX-NG.symlink" "~/.ShadowsocksX-NG"
link_file "./proxychains.symlink" "~/.proxychains"
