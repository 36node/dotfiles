#!/bin/sh
#
# 翻墙

brew_install proxychains-ng
brew_cask_install shadowsocksx-ng

## 从 private 数据恢复 配置
sync_file "$PRIVATE/com.qiuyuzhou.ShadowsocksX-NG.plist" "$HOME/Library/Preferences/com.qiuyuzhou.ShadowsocksX-NG.plist"